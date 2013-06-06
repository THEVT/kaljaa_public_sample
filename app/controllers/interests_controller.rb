class InterestsController < ApplicationController

	before_filter :signed_in_user 
	before_filter :correct_user,   only: [:edit, :update]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js
	
	def index
	end

	def show
		
		@interest= Interest.find(params[:id])
		@account_id= @interest.account_id
		@account = Account.find(@account_id)

	end

	def create
		@profile= current_user.profile
		@interest = @profile.build_interest(params[:interest])
		if @interest.save
			flash[:success] = "Interests Updated!"
			redirect_to @profile
		else
			render 'profiles/show'
		end
	end

	def edit
		@interest= Interest.find(params[:id])
	end

	def update
		@interest= Interest.find(params[:id])
		if @interest.update_attributes(params[:interest])
			flash[:success] = "Interests updated"
			respond_with @profile

		else
			render @profile
		end
	end

	def info
	end

	private

	def correct_user

		#finds interest then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@interest_id= Interest.find(params[:id])
		@profile_id = @interest_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end


end
