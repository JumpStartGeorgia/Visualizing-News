class CreateOrgPermalinks < ActiveRecord::Migration
  def up
    OrganizationTranslation.all.each do |trans|
      trans.generate_permalink!
      trans.save
    end
  end

  def down
    OrganizationTranslation.update_all(:permalink => nil)
  end
end
