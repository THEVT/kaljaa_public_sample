class MembersController < ApplicationController

	before_filter :signed_in_user
	before_filter :correct_group_user,   only: [:edit, :update, :destroy]
	#before_filter :correct_user,   only: [:edit, :update, :destroy]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js

	def admin		
		@invitee = Member.find(params[:id])
		@group = Group.find(@invitee.group_id)
		if @invitee.admin == 0
			@invitee.update_attributes(admin: true)
			redirect_to members_group_path(@group)
		else
			@invitee.update_attributes(admin: false)
			redirect_to members_group_path(@group)
		end
	end

	def index
		@members = Member.paginate(page: params[:page])
		#@profile_id= @members.profile_id
		#@profile= Profile.find(@profile_id)
	end

	def show
		@member= Member.find(params[:id])
		@profile_id= @member.profile_id
		@profile= Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)

	end

	def create
		@profile_ids = params[:profile_ids]
		@group_id = params[:member][:group_id]
		@group = Group.find(@group_id)
		@profile_ids.each do |id|
			@group.member.create(:profile_id => id, :status => 'not responded', admin: "0")
		end
		respond_with @group
	end

	def destroy
		@profile = current_profile
		@member = Member.find(params[:id])
		@group = Group.find(@member.group_id)
		if @member.present?
			@member.destroy
			redirect_to members_group_path(@group)
		end
		#redirect_to root_url
	end

	def edit
		@profile= current_profile
		@member = Member.find(params[:id])
	end

	def update
		@member= Member.find(params[:id])
		@group= @member.group
		if @member.update_attributes(params[:member])
			flash[:success] = "Group Membership Updated"
			respond_with @group	
		else
			respond_with @group
		end
	end

	def info
	end

	private

	def correct_user

		#finds member then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@member_id= Member.find(params[:id])
		@profile_id = @member_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def correct_group_user
		@profile_id = current_profile.id
		@member= Member.find(params[:id])
		@group = Group.find(@member.group_id)
		redirect_to(@group) unless (@profile_id == @group.profile_id) || (@member.admin == 1) || @member
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end

end
