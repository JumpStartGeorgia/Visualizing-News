class CopyIdeaData < ActiveRecord::Migration
  def up
=begin # can skip all of this since doing it again later.
    puts "***************************************"
    puts "***************************************"
    puts "this migration assumes that if you are on prod or dev, the news ideas db name is news-ideas, "
    puts "or if you are on staging the db name is news-ideas-staging"
    puts "***************************************"
    puts "***************************************"

    IdeaCategory.delete_all
    IdeaInappropriateReport.delete_all
    IdeaProgress.delete_all
    Idea.delete_all
    Notification.where(:notification_type => [1,2]).delete_all

    connection = ActiveRecord::Base.connection()
    news_db_name = '`news-ideas`'
    if Rails.env.staging?
      news_db_name = '`news-ideas-staging`'
    end
    puts "using ideas db: #{news_db_name}"

    # first have to match up users and if not exist, copy them over
    puts 'moving users, if needed'
    sql = "select id, email, encrypted_password, role, provider, uid, nickname, avatar, wants_notifications from #{news_db_name}.users"
    old_users = connection.execute(sql)
    new_users = User.all
    dummy_password = 'asdfasdfasdfasdfasdfadfwer'

    user_id_match = []
    old_users.each do |old_user|
      puts "looking at old user: #{old_user[1]}"
      # if user is not in new users, add them
      index = new_users.index{|x| x.email == old_user[1]}
      if index.nil?
        puts "- old user not in visual db, adding"
        u = User.create(
          :email => old_user[1],
          :password => dummy_password, 
          :password_confirmation => dummy_password,
          :role => old_user[3], 
          :provider => old_user[4], 
          :uid => old_user[5], 
          :nickname => old_user[6], 
          :avatar => old_user[7], 
          :wants_notifications => old_user[8],
          :db_migrate => true # don't send notification
        )

        # have to manualy move the encrypted password
        sql = "update users set encrypted_password = '#{old_user[2]}' where id = #{u.id}"
        ActiveRecord::Base.connection.execute(sql)

        # create match from old user id to new
        user_id_match << [old_user[0], u.id]
      else
        puts "- old user already in visual db"
        # found match
        user_id_match << [old_user[0], new_users[index].id]
      end
    end
    puts "user_id_match: #{user_id_match}"

    # add ideas
    puts "adding ideas"
    idea_id_match = []
    sql = "select id, user_id, explaination, individual_votes, overall_votes, is_inappropriate, is_duplicate, created_at, updated_at, is_private, current_status_id from #{news_db_name}.ideas"
    old_ideas = connection.execute(sql)
    old_ideas.each do |old_idea|
      i = Idea.create(
          :user_id => user_id_match.select{|x| x[0] == old_idea[1]}.first[1], 
          :explaination => old_idea[2], 
          :individual_votes => old_idea[3], 
          :overall_votes => old_idea[4], 
          :is_inappropriate => old_idea[5], 
          :is_duplicate => old_idea[6], 
          :created_at => old_idea[7], 
          :updated_at => old_idea[8], 
          :is_private => old_idea[9], 
          :current_status_id => old_idea[10],
          :db_migrate => true # don't send notification
      )

      # create match from old idea id to new
      idea_id_match << [old_idea[0], i.id]
    end


    # add categories
    puts "adding categories"
    sql = "select idea_id, category_id from #{news_db_name}.idea_categories"
    old_cats = connection.execute(sql)
    old_cats.each do |old_cat|
      IdeaCategory.create(
        :idea_id => idea_id_match.select{|x| x[0] == old_cat[0]}.first[1], 
        :category_id => old_cat[1]
      )
    end

    # add progress
    puts "adding progress"
    sql = "select idea_id, organization_id, progress_date, explaination, is_completed, url, created_at, updated_at, idea_status_id, is_private from #{news_db_name}.idea_progresses"
    old_progs = connection.execute(sql)
    old_progs.each do |old_prog|
      IdeaProgress.create(
        :idea_id => idea_id_match.select{|x| x[0] == old_prog[0]}.first[1], 
        :organization_id => old_prog[1],
        :progress_date => old_prog[2], 
        :explaination => old_prog[3], 
        :is_completed => old_prog[4], 
        :url => old_prog[5], 
        :created_at => old_prog[6], 
        :updated_at => old_prog[7], 
        :idea_status_id => old_prog[8], 
        :is_private => old_prog[9],
        :db_migrate => true # don't send notification
      )
    end

    # add inappropriate reports
    puts "adding reports"
    sql = "select idea_id, user_id, reason created_at, updated_at from #{news_db_name}.idea_inappropriate_reports"
    old_rpts = connection.execute(sql)
    old_rpts.each do |old_rpt|
      IdeaInappropriateReport.create(
        :idea_id => idea_id_match.select{|x| x[0] == old_rpt[0]}.first[1], 
        :user_id => user_id_match.select{|x| x[0] == old_rpt[1]}.first[1], 
        :reason => old_rpt[2],
        :created_at => old_rpt[3], 
        :updated_at => old_rpt[4]
      )
    end

    # add idea notifications
    puts "adding notifications"
    sql = "select user_id, notification_type, identifier from #{news_db_name}.notifications"
    old_nots = connection.execute(sql)
    old_nots.each do |old_not|
      Notification.create(
        :user_id => user_id_match.select{|x| x[0] == old_not[0]}.first[1], 
        :notification_type => old_not[1],
        :identifier => old_not[2]
      )
    end
=end
  end

  def down
    IdeaCategory.delete_all
    IdeaInappropriateReport.delete_all
    IdeaProgress.delete_all
    Idea.delete_all
    Notification.where(:notification_type => [1,2]).delete_all
  end
end
