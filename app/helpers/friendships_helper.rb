module FriendshipsHelper

	# Return an appropriate friendship status message.
	def friendship_status(profile, friend)
		friendship = Friendship.find_by_profile_id_and_friend_id(profile, friend)
		return "#{friend.s1} is not your friend (yet)." if friendship.nil?
		case friendship.status
		when 'requested'
			"#{friend.s1} would like to be your friend."
		when 'pending'
			"You have requested friendship from #{friend.s1}."
		when 'accepted'
			"#{friend.s1} is your friend."
		end
	end

end
