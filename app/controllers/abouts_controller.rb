class AboutsController < ApplicationController

	before_filter :signed_in_user 
	before_filter :correct_user,   only: [:edit, :update]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js
	
	def index
	end

	def show
		
		@about= About.find(params[:id])
		@account_id= @about.account_id
		@account = Account.find(@account_id)

	end

	def create
		@profile= current_user.profile
		@about = @profile.build_about(params[:about])
		if @about.save
			flash[:success] = "Abouts Updated!"
			redirect_to @profile
		else
			render 'profiles/show'
		end
	end

	def edit
		@about= About.find(params[:id])
	end

	def update
		@about= About.find(params[:id])
		if @about.update_attributes(params[:about])
			flash[:success] = "Abouts updated"
			respond_with @profile

		else
			render @profile
		end
	end

	def info
	end

	private

	def correct_user

		#finds about then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@about_id= About.find(params[:id])
		@profile_id = @about_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end

end
