class HonorablebeersController < ApplicationController

	before_filter :signed_in_user 
	before_filter :correct_user,   only: [:edit, :update]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js
	
	def index
	end

	def show
		
		@honorablebeer= Honorablebeer.find(params[:id])
		@account_id= @honorablebeer.account_id
		@account = Account.find(@account_id)

	end

	def create
		@profile= current_user.profile
		@honorablebeer = @profile.build_honorablebeer(params[:honorablebeer])
		if @honorablebeer.save
			flash[:success] = "Honorable Mentions Updated!"
			redirect_to @profile
		else
			render 'profiles/show'
		end
	end

	def edit
		@honorablebeer= Honorablebeer.find(params[:id])
	end

	def update
		@honorablebeer= Honorablebeer.find(params[:id])
		if @honorablebeer.update_attributes(params[:honorablebeer])
			flash[:success] = "Honorablebeers updated"
			respond_with @profile

		else
			render @profile
		end
	end

	def info
	end

	private

	def correct_user

		#finds honorablebeer then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@honorablebeer_id= Honorablebeer.find(params[:id])
		@profile_id = @honorablebeer_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end


end
