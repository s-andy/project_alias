class AddProjectAliasesUndeletable < Rails::VERSION::MAJOR < 5 ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]

    def self.up
        add_column :project_aliases, :undeletable, :boolean, :default => false, :null => false
    end

    def self.down
        remove_column :project_aliases, :undeletable
    end

end
