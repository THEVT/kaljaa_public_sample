class EventsController < ApplicationController

	before_filter :signed_in_user
	before_filter :public_private, except: [:index, :new, :create]
	before_filter :correct_event_user,   only: [:edit, :update, :destroy]
	#before_filter :correct_user,   only: [:edit, :update, :destroy]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js

	def index
		@events = Event.paginate(page: params[:page])
		#@profile_id= @events.profile_id
		#@profile= Profile.find(@profile_id)
	end

	def show
		#@profiles= Profile.all
		
		@profiles = Profile.paginate(page: params[:page])
		@event= Event.find(params[:id])
		@invited= @event.invite
		@profile_id= @event.profile_id
		@profile= Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		@invite = @event.invite.build
		@profile_current = current_profile
		@attendee= Invite.find_by_profile_id_and_event_id(@profile_current, @event)
		#blogs & articles
		@blogs = @event.blog.paginate(page: params[:page], per_page: 5)
		@articles = @event.article.paginate(page: params[:page], per_page: 5)
		#attendance
		@attending= Invite.where(event_id: @event.id, status: 'attending').limit(5)
		@maybe= Invite.where(event_id: @event.id, status: 'maybe').limit(5)
		@not_attending= Invite.where(event_id: @event.id, status: 'not attending').limit(5)
		@not_responded= Invite.where(event_id: @event.id, status: 'not responded').limit(5)
		@attending_total= Invite.where(event_id: @event.id, status: 'attending')
		@maybe_total= Invite.where(event_id: @event.id, status: 'maybe')
		@not_attending_total= Invite.where(event_id: @event.id, status: 'not attending')
		@not_responded_total= Invite.where(event_id: @event.id, status: 'not responded')

	end

	def create
		@profile= current_user.profile
		@event = @profile.event.build(params[:event])
		if @event.save
			flash[:success] = "Event created!"
			redirect_to @event
		else
			render new_event_path
		end
	end

	def edit
		@profile= current_profile
		@event = Event.find(params[:id])
	end

	def destroy
		@profile = current_profile
		@event = Event.find(params[:id])
		if @event.present?
			@event.destroy
			respond_with @event
		end
		#respond_with @event
	end

	def invite
		@profiles = Profile.paginate(page: params[:page])
		@event= Event.find(params[:id])
		@profile_id= @event.profile_id
		@profile= Profile.find(@profile_id)
		@invited= @event.invite
		@attendee = Invite.find_by_profile_id_and_event_id(current_profile, @event)
		@attending= Invite.where(event_id: @event.id, status: 'attending')
		@maybe= Invite.where(event_id: @event.id, status: 'maybe')
		@not_attending= Invite.where(event_id: @event.id, status: 'not attending')
		@not_responded= Invite.where(event_id: @event.id, status: 'not responded')
		#@attendees= Profile.where(id: @attending.profile_id)
		@invite = @event.invite.build
		
	end

	def new
		@profile = current_profile
		@event = @profile.event.build
		#@event.private = "0"
	end

	def update
		@event= Event.find(params[:id])
		if @event.update_attributes(params[:event])
			flash[:success] = "Beers updated"
			respond_with @event
		else
			render @event
		end
	end

	def invited?(other_user)
		invites.find_by_profile_id(other_user.id)
	end

	def invite!(other_user)
		invites.create!(profile_id: other_user.id)
	end

	def uninvite!(other_user)
		invites.find_by_profile_id(other_user.id).destroy
	end


	private

	def correct_user

		#finds event then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@event_id= Event.find(params[:id])
		@profile_id = @event_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def correct_event_user
		@profile_id = current_profile.id
		@event= Event.find(params[:id])
		@invite = Invite.find_by_profile_id_and_event_id(current_profile, @event)
		redirect_to(@event) unless (@profile_id == @event.profile_id) || (@invite.admin == 1) || @invite
	end

	def public_private
		@profile_id = current_profile.id
		@event= Event.find(params[:id])
		@invite = Invite.find_by_profile_id_and_event_id(current_profile, @event)
		if @event.exclusive == 1 
			flash[:success] = "This Event is Private. You have to be invited to see this event"
			redirect_to(events_path) unless (@profile_id == @event.profile_id) || @invite
		end
		
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end


end
