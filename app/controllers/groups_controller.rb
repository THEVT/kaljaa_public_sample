class GroupsController < ApplicationController

	before_filter :signed_in_user
	before_filter :public_private, except: [:index, :new, :create]
	before_filter :correct_group_user,   only: [:edit, :update, :destroy]
	#before_filter :correct_user,   only: [:edit, :update, :destroy]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js

	def index
		@groups = Group.paginate(page: params[:page])
		#@profile_id= @groups.profile_id
		#@profile= Profile.find(@profile_id)
	end

	def show
		#@profiles= Profile.all
		
		@profiles = Profile.paginate(page: params[:page])
		@group= Group.find(params[:id])
		@invited= @group.member
		@profile_id= @group.profile_id
		@profile= Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		@member = @group.member.build
		@profile_current = current_profile
		@attendee= Member.find_by_profile_id_and_group_id(@profile_current, @group)
		#blogs & articles
		@blogs = @group.blog.paginate(page: params[:page], per_page: 5)
		@articles = @group.article.paginate(page: params[:page], per_page: 5)
		#members
		@members= Member.where(group_id: @group.id, status: 'attending').limit(5)
		@admin= Member.where(group_id: @group.id, admin: 1).limit(5)
		@declined= Member.where(group_id: @group.id, status: 'not attending').limit(5)
		@not_responded= Member.where(group_id: @group.id, status: 'not responded').limit(5)
		@member_total= Member.where(group_id: @group.id, status: 'attending')
		@admin_total= Member.where(group_id: @group.id, status: 'maybe')
		@declined_total= Member.where(group_id: @group.id, status: 'not attending')
		@not_responded_total= Member.where(group_id: @group.id, status: 'not responded')

	end

	def create
		@profile= current_user.profile
		@group = @profile.group.build(params[:group])
		if @group.save
			flash[:success] = "Group created!"
			redirect_to @group
		else
			render new_group_path
		end
	end

	def edit
		@profile= current_profile
		@group = Group.find(params[:id])
	end

	def destroy
		@profile = current_profile
		@group = Group.find(params[:id])
		if @group.present?
			@group.destroy
			respond_with @group
		end
		#respond_with @group
	end

	def members
		@profiles = Profile.paginate(page: params[:page])
		@group= Group.find(params[:id])
		@profile_id= @group.profile_id
		@profile= Profile.find(@profile_id)
		@invited= @group.member
		@attendee = Member.find_by_profile_id_and_group_id(current_profile, @group)
		@members= Member.where(group_id: @group.id, status: 'attending')
		@admin= Member.where(group_id: @group.id, admin: 1)
		@declined= Member.where(group_id: @group.id, status: 'not attending')
		@not_responded= Member.where(group_id: @group.id, status: 'not responded')
		#@attendees= Profile.where(id: @attending.profile_id)
		@invite = @group.member.build
		
	end

	def new
		@profile = current_profile
		@group = @profile.group.build
		#@group.private = "0"
	end

	def update
		@group= Group.find(params[:id])
		if @group.update_attributes(params[:group])
			flash[:success] = "Beers updated"
			respond_with @group
		else
			render @group
		end
	end

	def invited?(other_user)
		invites.find_by_profile_id(other_user.id)
	end

	def member!(other_user)
		invites.create!(profile_id: other_user.id)
	end

	def uninvite!(other_user)
		invites.find_by_profile_id(other_user.id).destroy
	end


	private

	def correct_user

		#finds group then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@group_id= Group.find(params[:id])
		@profile_id = @group_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def correct_group_user
		@profile_id = current_profile.id
		@group= Group.find(params[:id])
		@member = Member.find_by_profile_id_and_group_id(current_profile, @group)
		redirect_to(@group) unless (@profile_id == @group.profile_id) || (@member.admin == 1) || @member
	end

	def public_private
		@profile_id = current_profile.id
		@group= Group.find(params[:id])
		@member = Member.find_by_profile_id_and_group_id(current_profile, @group)
		if @group.exclusive == 1 
			flash[:success] = "This Group is Private. You have to be invited to see this group"
			redirect_to(groups_path) unless (@profile_id == @group.profile_id) || @member
		end
		
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end

end
