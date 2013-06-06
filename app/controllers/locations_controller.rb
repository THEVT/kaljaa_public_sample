class LocationsController < ApplicationController

	before_filter :signed_in_user 
	before_filter :correct_user,   only: [:edit, :update]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js
	
	def index
	end

	def show
		
		@location= Location.find(params[:id])
		@account_id= @location.account_id
		@account = Account.find(@account_id)

	end

	def create
		@profile= current_user.profile
		@location = @profile.build_location(params[:location])
		if @location.save
			flash[:success] = "Locations Updated!"
			redirect_to @profile
		else
			render 'profiles/show'
		end
	end

	def edit
		@location= Location.find(params[:id])
	end

	def update
		@location= Location.find(params[:id])
		if @location.update_attributes(params[:location])
			flash[:success] = "Locations updated"
			respond_with @profile

		else
			render @profile
		end
	end

	def info
	end

	private

	def correct_user

		#finds location then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@location_id= Location.find(params[:id])
		@profile_id = @location_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end

end
