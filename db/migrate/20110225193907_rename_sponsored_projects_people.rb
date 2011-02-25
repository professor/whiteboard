class RenameSponsoredProjectsPeople < ActiveRecord::Migration
  def self.up
    drop_table :sponsored_projects_peoples
    create_table :sponsored_project_allocation do |t|
      t.integer :sponsored_project_id
      t.integer :person_id
      t.integer :current_allocation

      t.timestamps
    end
    add_index(:sponsored_project_efforts, :sponsored_projects_people_id)
    add_index(:sponsored_project_efforts, :year)
    add_index(:sponsored_project_efforts, :month)
    add_index(:sponsored_projects, :name)
    add_index(:sponsored_projects, :sponsor_id)
    add_index(:sponsored_project_sponsors, :name)
    add_index(:sponsored_project_allocation, :sponsored_project_id)
    add_index(:sponsored_project_allocation, :person_id)

    rename_column(:sponsored_project_efforts, :sponsored_projects_people_id, :sponsored_project_allocation_id)
  end

  def self.down
    rename_column(:sponsored_project_efforts, :sponsored_project_allocation_id, :sponsored_projects_people_id)

    remove_index(:sponsored_project_efforts, :sponsored_projects_people_id)
    remove_index(:sponsored_project_efforts, :year)
    remove_index(:sponsored_project_efforts, :month)
    remove_index(:sponsored_projects, :name)
    remove_index(:sponsored_projects, :sponsor_id)
    remove_index(:sponsored_project_sponsors, :name)
    remove_index(:sponsored_project_allocation, :sponsored_project_id)
    remove_index(:sponsored_project_allocation, :person_id)

    drop_table :sponsored_project_allocation
    create_table :sponsored_projects_peoples do |t|
      t.integer :sponsored_project_id
      t.integer :person_id
      t.integer :current_allocation

      t.timestamps
    end

  end

end
