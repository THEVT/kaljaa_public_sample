module GroupsHelper

	def invited(f)
		@invited= Member.find_by_profile_id_and_group_id(f, @group)
		if @invited == nil
			return true
		else
			return false
		end 
	end	

	def group_admin
		if @attendee != nil
			if @attendee.admin == 1
				return true
			else
				return false
			end
		else
			return false
		end
	end

end
