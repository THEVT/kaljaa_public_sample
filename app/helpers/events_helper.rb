module EventsHelper

	def invited(f)
		@invited= Invite.find_by_profile_id_and_event_id(f, @event)
		if @invited == nil
			return true
		else
			return false
		end 
	end
	
	def event_admin
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
