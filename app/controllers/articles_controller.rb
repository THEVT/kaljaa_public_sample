class ArticlesController < ApplicationController

	before_filter :signed_in_user
	before_filter :correct_user,   only: [:edit, :update, :destroy]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js

	def index
		@articles = Article.paginate(page: params[:page])
		#@profile_id= @articles.profile_id
		#@profile= Profile.find(@profile_id)
	end

	def show
		@article= Article.find(params[:id])
		@article_album = Album.find_by_article_id(@article)
		@profile_id= @article.profile_id
		@profile= Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		@album = @article.album.build

	end

	def create
		@profile= current_user.profile
		@article = @profile.article.build(params[:article])
		if @article.save
			flash[:success] = "Article created!"
			redirect_to @article
		else
			render new_article_path
		end
	end

	def edit
		@profile= current_profile
		@article = Article.find(params[:id])
	end

	def destroy
		@profile = current_profile
		@article = Article.find(params[:id])
		if @article.present?
			@article.destroy
		end
		respond_with @profile
	end

	def new
		@profile = current_profile
		@article = @profile.article.build
	end

	def update
		@article= Article.find(params[:id])
		if @article.update_attributes(params[:article])
			flash[:success] = "Beers updated"
			respond_with @article
		else
			render @article
		end
	end

	def info
	end

	private

	def correct_user

		#finds article then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@article_id= Article.find(params[:id])
		@profile_id = @article_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end

end
