if Rails::VERSION::MAJOR < 3

    ActionController::Routing::Routes.draw do |map|
        map.connect('project_aliases', :controller => 'project_aliases', :action => 'index')
        map.connect('project_aliases/new', :controller => 'project_aliases', :action => 'new')
        map.connect('project_aliases/create', :controller => 'project_aliases', :action => 'create')
        map.connect('project_aliases/:id/destroy', :controller => 'project_aliases', :action => 'destroy')
        map.connect('project_aliases/:id/rename', :controller => 'project_aliases', :action => 'rename')
    end

else

    get    'project_aliases',             :to => 'project_aliases#index'
    get    'project_aliases/new',         :to => 'project_aliases#new'
    post   'project_aliases/create',      :to => 'project_aliases#create'
    delete 'project_aliases/:id/destroy', :to => 'project_aliases#destroy'
    put    'project_aliases/:id/rename',  :to => 'project_aliases#rename'

end
