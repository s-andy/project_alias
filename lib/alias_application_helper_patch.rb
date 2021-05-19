require_dependency 'application_helper'

module AliasApplicationHelperPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            alias_method :parse_redmine_links_without_project_alias, :parse_redmine_links
            alias_method :parse_redmine_links, :parse_redmine_links_with_project_alias
        end
    end

    module ClassMethods
    end

    module InstanceMethods

        def parse_redmine_links_with_project_alias(text, project, obj, attr, only_path, options)
            text.gsub!(%r{([\s\(,\-\[\>]|\A)(!)?(([a-z0-9\-_]+):)?project:([^"\s<>][^\s<>]*?|"[^"]+?")(?=(?=[[:punct:]]\W)|,|\s|\]|<|\z)}) do |m|
                leading, esc, project_prefix, project_identifier, identifier = $1, $2, $3, $4, $5, $6
                link = nil
                if esc.nil?
                    name = identifier.gsub(%r{\A"(.*)"\z}, "\\1")
                    if p = ProjectAlias.find_by_alias(name.downcase)
                        link = link_to_project(p.project, { :only_path => only_path }, :class => 'project')
                    elsif p = Project.visible.where([ "identifier = :s OR LOWER(name) = :s", { :s => name.downcase } ]).first
                        link = link_to_project(p, { :only_path => only_path }, :class => 'project')
                    end
                end
                (leading + (link || "#{project_prefix}project:#{identifier}")).html_safe
            end

            parse_redmine_links_without_project_alias(text, project, obj, attr, only_path, options)
        end

    end

end
