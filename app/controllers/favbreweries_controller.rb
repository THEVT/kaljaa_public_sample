class FavbreweriesController < ApplicationController

	before_filter :signed_in_user 
	before_filter :correct_user,   only: [:edit, :update]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js
	
	def index
	end

	def show
		
		@favbrewery= Favbrewery.find(params[:id])
		@account_id= @favbrewery.account_id
		@account = Account.find(@account_id)

	end

	def create
		@profile= current_user.profile
		@favbrewery = @profile.build_favbrewery(params[:favbrewery])
		if @favbrewery.save
			flash[:success] = "Favorite Breweries Updated!"
			redirect_to @profile
		else
			render 'profiles/show'
		end
	end

	def edit
		@favbrewery= Favbrewery.find(params[:id])
	end

	def update
		@favbrewery= Favbrewery.find(params[:id])
		if @favbrewery.update_attributes(params[:favbrewery])
			flash[:success] = "Favorite Breweries updated"
			respond_with @profile

		else
			render @profile
		end
	end

	def info
	end

	private

	def correct_user

		#finds favbrewery then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@favbrewery_id= Favbrewery.find(params[:id])
		@profile_id = @favbrewery_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end

end
