class ChangeUserRoleType < ActiveRecord::Migration
  def up
    # change values first
    # author/user = 0
    # organization/org_admin = 50
    # admin = 99
    User.where(:role => 'author').update_all(:role => 0)
    User.where(:role => 'user').update_all(:role => 0)
    User.where(:role => 'organization').update_all(:role => 50)
    User.where(:role => 'org_admin').update_all(:role => 50)
    User.where(:role => 'admin').update_all(:role => 99)

    # chagne column
    change_column :users, :role, :integer, :default => 0, :null => false
  end

  def down
    # change column
    change_column :users, :role, :string, :default => "", :null => false
    
    # change values
    User.where(:role => 0).update_all(:role => 'user')
    User.where(:role => 50).update_all(:role => 'org_admin')
    User.where(:role => 99).update_all(:role => 'admin')
  end
end
