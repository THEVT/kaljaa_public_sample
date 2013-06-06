class FavbeersController < ApplicationController

	before_filter :signed_in_user 
	before_filter :correct_user,   only: [:edit, :update]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js
	
	def index
	end

	def show
		
		@favbeer= Favbeer.find(params[:id])
		@account_id= @favbeer.account_id
		@account = Account.find(@account_id)

	end

	def create
		@profile= current_user.profile
		@favbeer = @profile.build_favbeer(params[:favbeer])
		if @favbeer.save
			flash[:success] = "Favorite Beers Updated!"
			redirect_to @profile
		else
			render 'profiles/show'
		end
	end

	def edit
		@favbeer= Favbeer.find(params[:id])
	end

	def update
		@favbeer= Favbeer.find(params[:id])
		if @favbeer.update_attributes(params[:favbeer])
			flash[:success] = "Favorite Beers updated"
			respond_with @profile

		else
			render @profile
		end
	end

	def info
	end

	private

	def correct_user

		#finds favbeer then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@favbeer_id= Favbeer.find(params[:id])
		@profile_id = @favbeer_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end

end
