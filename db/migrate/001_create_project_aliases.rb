class CreateProjectAliases < Rails::VERSION::MAJOR < 5 ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]

    def self.up
        create_table :project_aliases do |t|
            t.column :project_id, :integer, :null => false
            t.column :alias,      :string,  :null => false
        end
        add_index :project_aliases, [ :alias ], :unique => true, :name => :project_alias
    end

    def self.down
        drop_table :project_aliases
    end

end
