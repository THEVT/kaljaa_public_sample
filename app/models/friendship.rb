class Friendship < ActiveRecord::Base
  attr_accessible :friend_id, :profile_id, :status, :profile, :friend

	belongs_to :profile
	belongs_to :friend, :class_name => "Profile", foreign_key: "friend_id"

	validates_presence_of :profile_id, :friend_id

	# Return true if the profiles are (possibly pending) friends.
	def self.exists?(profile, friend)
		not find_by_profile_id_and_friend_id(profile, friend).nil?
	end

	# Record a pending friend request.
	def self.request(profile, friend)
		unless profile == friend or Friendship.exists?(profile, friend)
			transaction do
				create(:profile => profile, :friend => friend, :status => 'pending')
				create(:profile => friend, :friend => profile, :status => 'requested')
			end
		end
	end

	# Accept a friend request.
	def self.accept(profile, friend)
		transaction do
			accept_one_side(profile, friend)
			accept_one_side(friend, profile)
		end
	end
	# Delete a friendship or cancel a pending request.
	def self.breakup(profile, friend)
		transaction do
			destroy(find_by_profile_id_and_friend_id(profile, friend))
			destroy(find_by_profile_id_and_friend_id(friend, profile))
		end
	end

	private

	# Update the db with one side of an accepted friendship request.
	def self.accept_one_side(profile, friend)
		request = find_by_profile_id_and_friend_id(profile, friend)
		request.status = 'accepted'
		request.save!
	end

end
