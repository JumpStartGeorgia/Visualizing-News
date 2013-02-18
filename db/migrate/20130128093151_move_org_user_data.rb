class MoveOrgUserData < ActiveRecord::Migration
  def up
=begin # can skip all of this since doing it again later.
    puts "***************************************"
    puts "***************************************"
    puts "this migration assumes that if you are on prod or dev, the news ideas db name is news-ideas, "
    puts "or if you are on staging the db name is news-ideas-staging"
    puts "***************************************"
    puts "***************************************"

    connection = ActiveRecord::Base.connection()
    news_db_name = '`news-ideas`'
    if Rails.env.staging?
      news_db_name = '`news-ideas-staging`'
    end
    puts "using ideas db: #{news_db_name}"

    new_users = User.all

    # get users from old system
    puts 'getting old users'
    sql = "select id, email, encrypted_password, role, provider, uid, nickname, avatar, wants_notifications from #{news_db_name}.users"
    old_users = connection.execute(sql)

    puts 'matching old user id to new user'
    user_id_match = []
    old_users.each do |old_user|
      puts "looking at old user: #{old_user[1]}"
      # if user is not in new users, add them
      index = new_users.index{|x| x.email == old_user[1]}
      if !index.nil?
        puts "- old user already in visual db"
        # found match
        user_id_match << [old_user[0], new_users[index].id]
      end
    end
    puts "user_id_match: #{user_id_match}"

    puts 'getting old org users'
    sql = "select user_id, organization_id from #{news_db_name}.organization_users"
    old_org_users = connection.execute(sql).to_a

    puts 'looking for missing org assignments'
    old_users.each do |old_user|
      puts "looking at old user: #{old_user[1]}"
      index = old_org_users.index{|x| x[0] == old_user[0]}
      if !index.nil?
        puts "- found org match: #{old_org_users[1]}"

        # if org match not in current db, add it
        if
          index_user = new_users.index{|x| x.email == old_user[1]}
          if new_users[index_user].organization_users.blank? ||
            new_users[index_user].organization_users.index{|y| y.organization_id == old_org_users[index][1]}.nil?

            puts "-- adding org for user"
            new_users[index_user].organization_users.create(:organization_id => old_org_users[index][1])
          end
        end
      end
    end
=end
  end

  def down
    # do nothing
  end
end
