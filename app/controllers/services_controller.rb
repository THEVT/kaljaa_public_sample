class ServicesController < ApplicationController

	before_filter :signed_in_user 
	before_filter :correct_user,   only: [:edit, :update]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js
	
	def index
	end

	def show
		
		@service= Service.find(params[:id])
		@account_id= @service.account_id
		@account = Account.find(@account_id)

	end

	def create
		@profile= current_user.profile
		@service = @profile.build_service(params[:service])
		if @service.save
			flash[:success] = "Services Updated!"
			redirect_to @profile
		else
			render 'profiles/show'
		end
	end

	def edit
		@service= Service.find(params[:id])
	end

	def update
		@service= Service.find(params[:id])
		if @service.update_attributes(params[:service])
			flash[:success] = "Services updated"
			respond_with @profile

		else
			render @profile
		end
	end

	def info
	end

	private

	def correct_user

		#finds service then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@service_id= Service.find(params[:id])
		@profile_id = @service_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end

end
