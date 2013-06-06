class ProfilesController < ApplicationController
	helper :friendships	

	before_filter :signed_in_user 
	before_filter :correct_user,   only: [:edit, :update]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js
	
	def index
		@profiles = Profile.paginate(page: params[:page])
	end

	def show
		
		@profile= Profile.find(params[:id])
		@account_id= @profile.account_id
		@account = Account.find(@account_id)

		#variables for activities partial
		@activity_present = @profile.activity
		@activity = @profile.build_activity if !Activity.exists?(profile_id: @profile.id)

		#variables for interests partial
		@interest_present = @profile.interest
		@interest = @profile.build_interest if !Interest.exists?(profile_id: @profile.id)

		#variables for favbrewery partial
		@favbrewery_present = @profile.favbrewery
		@favbrewery = @profile.build_favbrewery if !Favbrewery.exists?(profile_id: @profile.id)

		#variables for favbeer partial
		@favbeer_present = @profile.favbeer
		@favbeer = @profile.build_favbeer if !Favbeer.exists?(profile_id: @profile.id)

		#variables for honorablebeer partial
		@honorablebeer_present = @profile.honorablebeer
		@honorablebeer = @profile.build_honorablebeer if !Honorablebeer.exists?(profile_id: @profile.id)

		#variables for misc partial
		@misc_present = @profile.misc
		@misc = @profile.build_misc if !Misc.exists?(profile_id: @profile.id)

		#variables for about partial
		@about_present = @profile.about
		@about = @profile.build_about if !About.exists?(profile_id: @profile.id)

		#variables for location partial
		@location_present = @profile.location
		@location = @profile.build_location if !Location.exists?(profile_id: @profile.id)
		
		#variables for service partial
		@service_present = @profile.service
		@service = @profile.build_service if !Service.exists?(profile_id: @profile.id)

		#variables for beers partial
		@beers = @profile.beer.paginate(page: params[:page], per_page: 5)
		@beer = @profile.beer.build
		
		#variables for reviewbeers partial
		@reviewbeers = @profile.reviewbeer.paginate(page: params[:page], per_page: 5)
		@reviewbeer = @profile.reviewbeer.build

		#variables for blogs created
		@blogs = @profile.blog.paginate(page: params[:page], per_page: 5)

		#variables for news articles created
		@articles = @profile.article.paginate(page: params[:page], per_page: 5)
		
		#variables for news events created
		@events = @profile.event.paginate(page: params[:page], per_page: 5)


	end

	def create

		@profile = current_user.build_profile(params[:profile])
		if @profile.save
			flash[:success] = "Micropost created!"
			redirect_to current_user
		else
			render 'home/new'
		end
	end

	def edit
		@profile= Profile.find(params[:id])
	end

	def new
	end

	def update
		@profile= Profile.find(params[:id])
		if @profile.update_attributes(params[:profile])
			flash[:success] = "Profile updated"
			respond_with @profile

		else
			render 'edit'
		end
	end

	def info
	end

	private

	def correct_user
		@profile= Profile.find(params[:id])
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end

end
