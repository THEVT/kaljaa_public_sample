class InvitesController < ApplicationController

	before_filter :signed_in_user
	before_filter :correct_event_user,   only: [:edit, :update, :destroy]
	#before_filter :correct_user,   only: [:edit, :update, :destroy]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js

	def admin		
		@invitee = Invite.find(params[:id])
		@event = Event.find(@invitee.event_id)
		if @invitee.admin == 0
			@invitee.update_attributes(admin: true)
			redirect_to invite_event_path(@event)
		else
			@invitee.update_attributes(admin: false)
			redirect_to invite_event_path(@event)
		end
	end

	def index
		@invites = Invite.paginate(page: params[:page])
		#@profile_id= @invites.profile_id
		#@profile= Profile.find(@profile_id)
	end

	def show
		@invite= Invite.find(params[:id])
		@profile_id= @invite.profile_id
		@profile= Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)

	end

	def create
		@profile_ids = params[:profile_ids]
		@event_id = params[:invite][:event_id]
		@event = Event.find(@event_id)
		@profile_ids.each do |id|
			@event.invite.create(:profile_id => id, :status => 'not responded', admin: "0")
		end
		respond_with @event
	end

	def destroy
		@profile = current_profile
		@invite = Invite.find(params[:id])
		@event = Event.find(@invite.event_id)
		if @invite.present?
			@invite.destroy
			redirect_to invite_event_path(@event)
		end
		#redirect_to root_url
	end

	def edit
		@profile= current_profile
		@invite = Invite.find(params[:id])
	end

	def update
		@invite= Invite.find(params[:id])
		@event= @invite.event
		if @invite.update_attributes(params[:invite])
			flash[:success] = "Event Attendance Updated"
			respond_with @event	
		else
			respond_with @event
		end
	end

	def info
	end

	private

	def correct_user

		#finds invite then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@invite_id= Invite.find(params[:id])
		@profile_id = @invite_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def correct_event_user
		@profile_id = current_profile.id
		@invite= Invite.find(params[:id])
		@event = Event.find(@invite.event_id)
		redirect_to(@event) unless (@profile_id == @event.profile_id) || (@invite.admin == 1) || @invite
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end



end
