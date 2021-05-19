class ProjectAlias < ActiveRecord::Base
    include Redmine::SafeAttributes

    belongs_to :project

    IDENTIFIER_RE = %r{\A(?!\d+$)[a-z0-9\-_]*\z}

    validates_presence_of :project, :alias
    validates_uniqueness_of :alias
    validates_length_of :alias, :in => Project.const_defined?(:IDENTIFIER_MAX_LENGTH) ? 1..Project::IDENTIFIER_MAX_LENGTH : 1..20, :allow_blank => true
    validates_format_of :alias, :with => IDENTIFIER_RE
    validates_exclusion_of :alias, :in => %w(new)
    validate :validate_alias

    attr_protected :id, :undeletable if Rails::VERSION::MAJOR < 5

    safe_attributes :project_id, :alias

    def rename!
        if Project.connection.update("UPDATE #{Project.table_name} " +
                                     "SET identifier = '#{self.alias}' " +
                                     "WHERE id = #{project.id}") > 0
            if Project.connection.update("UPDATE #{ProjectAlias.table_name} " +
                                         "SET alias = '#{project.identifier}', undeletable = 1 " +
                                         "WHERE id = #{id}") > 0
                true
            else
                Project.connection.update("UPDATE #{Project.table_name} " +
                                          "SET identifier = '#{project.identifier}' " +
                                          "WHERE id = #{project.id}")
                false
            end
        else
            false
        end
    end

private

    def validate_alias
        if self.alias
            if self.project && self.alias == self.project.identifier
                errors.add(:alias, :same_as_identifier)
            elsif Project.find_by_identifier(self.alias)
                errors.add(:alias, :identifier_exists)
            end
        end
    end

end
