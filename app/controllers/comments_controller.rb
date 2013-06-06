class CommentsController < ApplicationController

	before_filter :signed_in_user
	before_filter :correct_user,   only: [:edit, :update, :destroy]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js

	def create
		@profile= current_user.profile
		@commentable = find_commentable
		@comment = @commentable.comments.build(params[:comment])
		if @comment.save
			flash[:notice] = "Successfully saved comment."
			redirect_to :id => nil
		else
			render :action => 'new'
		end
	end	

	def index

		#@reviewbeer= Reviewbeer.find(params[:id])
		#@profile_id= @reviewbeer.profile_id
		#@profile= Profile.find(@profile_id)
		#@account_id= @profile.account_id
		#@account = Account.find(@account_id)

		@current_profile= current_user.profile
		@current_profile_id = @current_profile.id
		@profile = find_profile
		@commentable = find_commentable
		@comments = @commentable.comments
	end

	def show
		@comment = Comment.find(params[:id])
	end


	private

	def find_profile
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
				return $1.classify.constantize.find(value)
			end
		end	
		nil
	end

	def correct_user

		#finds comment then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@comment_id= Comment.find(params[:id])
		@profile_id = @comment_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end


end
