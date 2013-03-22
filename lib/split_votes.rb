module SplitVotes

  def self.included (base)
    base.extend ClassMethods
  end


  def votes_up
    return 0 if (self.individual_votes.nil? || self.individual_votes.length < 4)
    self.individual_votes.clone.split('+')[1].split('-')[0]
  end

  def votes_down
    return 0 if (self.individual_votes.nil? || self.individual_votes.length < 4)
    self.individual_votes.clone.split('+')[1].split('-')[1]
  end

  def votes_diff
    return {:number => 0, :color => 'grey'} if (self.individual_votes.nil? || self.individual_votes.length < 4)
    f = self.individual_votes.clone.split('+')[1].split('-')
    number = f[0].to_i - f[1].to_i
    if number > 0
      color = 'green'
    elsif number == 0
      color = 'grey'
    else
      color = 'red'
    end
    {:number => number, :color => color}
  end

  def voted (user, status)
    if user.present? && status.present?
      record = VoterId.where(:user_id => user.id, :votable_type => self.class.name.downcase, :votable_id => self.id, :status => status)
      return !(record.nil? || record.empty?)
    end
    return false
  end

  def process_vote(user, status)
    success = false
    if user.present? && status.present?
      record = VoterId.where(:user_id => user.id, :votable_type => self.class.name.downcase, :votable_id => self.id)

      if record.blank?

        if self.individual_votes.blank? || self.individual_votes.length < 4
          # reset to 0
          self.individual_votes = '+0-0'
        end

        split = self.individual_votes.split('+')[1].split('-')
        ups = split[0].to_i
        downs = split[1].to_i

        if status == 'up'
          ups = ups + 1
        elsif status == 'down'
          downs = downs + 1
        end

        self.individual_votes = "+#{ups}-#{downs}"
			  self.overall_votes = ups - downs + self.fb_likes
        self.save

        VoterId.create(:user_id => user.id, :votable_type => self.class.name.downcase,
                        :votable_id => self.id, :status => status)

        success = true

      elsif record[0].status != status

        split = self.individual_votes.split('+')[1].split('-')
        ups = split[0].to_i
        downs = split[1].to_i

        if status == 'up'
          ups = ups + 1
        elsif status == 'down'
          downs = downs + 1
        end

        self.individual_votes = "+#{ups}-#{downs}"
			  self.overall_votes = ups - downs + self.fb_likes
        self.save

        # update the vote record
        record[0].status = status
        record[0].save

        success = true
      end
    end
    return success
  end

  def process_like
	  self.overall_votes += 1
	  self.fb_likes += 1
    self.save
  end

  module ClassMethods
  end

end
