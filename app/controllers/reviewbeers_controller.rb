class ReviewbeersController < ApplicationController

	before_filter :signed_in_user
	before_filter :correct_user,   only: [:edit, :update, :destroy]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js
	
	def index
	end

	def show
		#@profile= Profile.find(params[:id])
		#@reviewbeers = @profile.reviewbeers.paginate(page: params[:page])
		@reviewbeer= Reviewbeer.find(params[:id])
		@profile_id= @reviewbeer.profile_id
		@profile= Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)

	#variables for reviewbeers partial
		#@reviewbeers = @profile.reviewbeer.paginate(page: params[:page], per_page: 5)
		#@reviewbeer = @profile.reviewbeer.build

		@current_profile= current_user.profile
		@current_profile_id = @current_profile.id
		@commentable = find_commentable
		@testcom = find_test_com
		#@comments = @commentable.comments

	end

	def create
		@profile= current_user.profile
		@reviewbeer = @profile.reviewbeer.build(params[:reviewbeer])
		if @reviewbeer.save
			flash[:success] = "Beer review created!"
			redirect_to @profile
		else
			render 'profiles/show'
		end
	end

	def edit
		@reviewbeer = Reviewbeer.find(params[:id])
	end

	def destroy
		@reviewbeer = Reviewbeer.find(params[:id])
		if @reviewbeer.present?
			@reviewbeer.destroy
		end
		respond_with @profile
	end

	def new
		@profile= current_user.profile
		@reviewbeer = @profile.reviewbeer.build
	end

	def update
		@reviewbeer= Reviewbeer.find(params[:id])
		if @reviewbeer.update_attributes(params[:reviewbeer])
			flash[:success] = "Reviewbeers updated"
			respond_with @profile

		else
			render @profile
		end
	end

	def info
	end

	private

	def correct_user

		#finds reviewbeer then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@reviewbeer_id= Reviewbeer.find(params[:id])
		@profile_id = @reviewbeer_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end

	def find_test_com
		params.each do |name, value|
			if name =~ /(.+)_id$/
				return $1
				#return $1.classify.constantize.find(value)
			else
				return "test"
			end
		end	
		nil
	end

	def find_commentable
		params.each do |name, value|
			if name =~ /(.+)_id$/
				return $1
				#return $1.classify.constantize.find(value)
			else
				return "hello"
			end
		end	
		nil
	end

	def items_on_hold
		#[['A+', 12], ['A', 11], ['A-', 10], ['B+', 9], ['B', 8], ['B-', 7], ['C+', 6], ['C', 5], ['C-', 4], ['D+', 3], ['D', 2], ['D-', 1], ['F', 0]]
	end

end
