class BlogsController < ApplicationController

	before_filter :signed_in_user
	before_filter :correct_user,   only: [:edit, :update, :destroy]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js

	def index
		@blogs = Blog.paginate(page: params[:page])
		#@profile_id= @blogs.profile_id
		#@profile= Profile.find(@profile_id)
	end

	def show
		@blog= Blog.find(params[:id])
		@blog_album = Album.find_by_blog_id(@blog)
		@profile_id= @blog.profile_id
		@profile= Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		@album = @blog.album.build

	end

	def create
		@profile= current_user.profile
		@blog = @profile.blog.build(params[:blog])
		if @blog.save
			flash[:success] = "Blog created!"
			redirect_to @blog
		else
			render new_blog_path
		end
	end

	def edit
		@profile= current_profile
		@blog = Blog.find(params[:id])
	end

	def destroy
		@profile = current_profile
		@blog = Blog.find(params[:id])
		if @blog.present?
			@blog.destroy
		end
		respond_with @profile
	end

	def new
		#@event = Event.find(params[:event_id])
		@profile = current_profile
		@blog = @profile.blog.build
	end

	def update
		@blog= Blog.find(params[:id])
		if @blog.update_attributes(params[:blog])
			flash[:success] = "Beers updated"
			respond_with @blog
		else
			render @blog
		end
	end

	def info
	end

	private

	def correct_user

		#finds blog then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@blog_id= Blog.find(params[:id])
		@profile_id = @blog_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end


end
