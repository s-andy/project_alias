class ProjectAliasesController < ApplicationController
    layout 'admin'
    self.main_menu = false if self.respond_to?(:main_menu)

    before_action :require_admin

    helper :sort
    include SortHelper

    def index
        sort_init('alias')
        sort_update(
            'alias'      => "#{ProjectAlias.table_name}.alias",
            'identifier' => "#{Project.table_name}.identifier",
            'project'    => "#{Project.table_name}.name"
        )
        @projects = Project.visible.all
        @aliases = ProjectAlias.joins(:project).order(sort_clause)
        render(:layout => !request.xhr?)
    end

    def new
        @alias = ProjectAlias.new
        @projects = Project.visible.order('lft')
    end

    def create
        @alias = ProjectAlias.new
        @alias.safe_attributes = params[:project_alias]
        if @alias.save
            flash[:notice] = l(:notice_successful_create)
            redirect_to(:action => 'index')
        else
            @projects = Project.visible.order('lft')
            render('project_aliases/new')
        end
    end

    def destroy
        @alias = ProjectAlias.find(params[:id])
        if @alias.destroy
            flash[:notice] = l(:notice_successful_delete)
        end
        redirect_to(:action => 'index')
    end

    def rename
        @alias = ProjectAlias.find(params[:id])
        old_identifier = @alias.project.identifier
        new_identifier = @alias.alias
        if @alias.rename!
            flash[:notice] = l(:notice_successful_update)
            call_hook(:controller_project_aliases_rename_after,
                    { :project => @alias.project,
                      :old_identifier => old_identifier,
                      :new_identifier => new_identifier })
        end
        redirect_to(:action => 'index')
    end

end
