module ProjectAliasesHelper

    # Modified #project_tree_options_for_select
    def project_alias_project_options_for_select(projects, options = {})
        s = ''.html_safe
        if blank_text = options[:include_blank]
            blank_text = '&nbsp;'.html_safe if blank_text == true
            s << content_tag('option', blank_text, :value => '')
        end
        project_tree(projects) do |project, level|
            name_prefix = (level > 0 ? '&nbsp;' * 2 * level + '&#187; ' : '').html_safe
            tag_options = { :value => project.id }
            if project == options[:selected] || (options[:selected].respond_to?(:include?) && options[:selected].include?(project))
                tag_options[:selected] = 'selected'
            else
                tag_options[:selected] = nil
            end
            s << content_tag('option', name_prefix + h(project) + ' (' + project.identifier + ')', tag_options)
        end
        s.html_safe
    end

end
