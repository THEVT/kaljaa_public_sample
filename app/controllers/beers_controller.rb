class BeersController < ApplicationController

	before_filter :signed_in_user
	before_filter :correct_user,   only: [:edit, :update, :destroy]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js
	
	def index
	end

	def show
		@profile= Profile.find(params[:id])
		@beers = @profile.beers.paginate(page: params[:page])
		@beer= Beer.find(params[:id])
		@profile_id= @beer.profile_id
		@account = Account.find(@account_id)

	end

	def create
		@profile= current_user.profile
		@beer = @profile.beer.build(params[:beer])
		if @beer.save
			flash[:success] = "Beers Updated!"
			redirect_to @profile
		else
			render 'profiles/show'
		end
	end

	def edit
		@profile= current_user.profile
		@beer = Beer.find(params[:id])
	end

	def destroy
		@beer = Beer.find(params[:id])
		if @beer.present?
			@beer.destroy
		end
		respond_with @profile
	end

	def new
		
	end

	def update
		@beer= Beer.find(params[:id])
		if @beer.update_attributes(params[:beer])
			flash[:success] = "Beers updated"
			respond_with @profile

		else
			render @profile
		end
	end

	def info
	end

	private

	def correct_user

		#finds beer then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@beer_id= Beer.find(params[:id])
		@profile_id = @beer_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end

end
