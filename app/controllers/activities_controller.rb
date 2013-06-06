class ActivitiesController < ApplicationController

	before_filter :signed_in_user 
	before_filter :correct_user,   only: [:edit, :update]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js
	
	def index
	end

	def show
		
		@activity= Activity.find(params[:id])
		@account_id= @activity.account_id
		@account = Account.find(@account_id)

	end

	def create
		@profile= current_user.profile
		@activity = @profile.build_activity(params[:activity])
		if @activity.save
			flash[:success] = "Activities Updated!"
			redirect_to @profile
		else
			render 'profiles/show'
		end
	end

	def edit
		@activity= Activity.find(params[:id])
	end

	def update
		@activity= Activity.find(params[:id])
		if @activity.update_attributes(params[:activity])
			flash[:success] = "Activities updated"
			respond_with @profile

		else
			render @profile
		end
	end

	def info
	end

	private

	def correct_user
		#@profile= Profile.find(params[:id])
		#@account_id= @profile.account_id
		#@account = Account.find(@account_id)
		#redirect_to(@profile) unless current_user?(@account)
		#repititive (should be improved) code to determine correct user
		#finds activity then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@activity_id= Activity.find(params[:id])
		@profile_id = @activity_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end

end
