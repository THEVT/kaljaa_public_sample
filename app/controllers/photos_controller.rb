class PhotosController < ApplicationController

	before_filter :signed_in_user
	before_filter :correct_user,   only: [:edit, :update, :destroy]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js

	def index
		@photos = Photo.paginate(page: params[:page])
		#@profile_id= @photos.profile_id
		#@profile= Profile.find(@profile_id)
	end

	def show
		@photo= Photo.find(params[:id])
		@album_id = @photo.album_id
		@album = Album.find(@album_id)
		@profile_id= @album.profile_id
		@profile= Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)

	end

	def create
		@album = Album.find(params[:photo][:album_id])
		@photo = @album.photo.build(params[:photo])
		if @photo.save
			flash[:success] = "Photo created!"
			redirect_to @album
		else
			flash[:success] = "You must attach a photo"
			redirect_to @album
		end
	end

	def edit
		@profile= current_profile
		@photo = Photo.find(params[:id])
	end

	def destroy
		@profile = current_profile
		@photo = Photo.find(params[:id])
		@album = @photo.album
		if @photo.present?
			@photo.destroy
		end
		respond_with @album
	end

	def new
		#@event = Event.find(params[:event_id])
		@profile = current_profile
		@album = Album.find(params[:id])
		@photo = @album.photo.build
	end

	def update
		@photo= Photo.find(params[:id])
		if @photo.update_attributes(params[:photo])
			flash[:success] = "Beers updated"
			respond_with @photo
		else
			render @photo
		end
	end

	def info
	end

	private

	def correct_user

		#finds photo then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@photo= Photo.find(params[:id])
		@album = @photo.album
		@profile_id = @album.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end


end
