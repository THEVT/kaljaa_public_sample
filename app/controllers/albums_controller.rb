class AlbumsController < ApplicationController

	before_filter :signed_in_user
	before_filter :correct_user,   only: [:edit, :update, :destroy]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js

	def index
		@albums = Album.paginate(page: params[:page])
		#@profile_id= @albums.profile_id
		#@profile= Profile.find(@profile_id)
	end

	def show
		@album= Album.find(params[:id])
		@photos2 = @album.photo.all
		@photos = @album.photo.paginate(page: params[:page], per_page: 30)
		@photo = @album.photo.build
		#user stuff
		@profile_id= @album.profile_id
		@profile= Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)

	end

	def create
		@profile= current_user.profile
		@album = @profile.album.build(params[:album])
		if @album.save
			flash[:success] = "Album created!"
			redirect_to @album
		else
			render new_album_path
		end
	end

	def edit
		@profile= current_profile
		@album = Album.find(params[:id])
	end

	def destroy
		@profile = current_profile
		@album = Album.find(params[:id])
		if @album.present?
			@album.destroy
		end
		respond_with @profile
	end

	def new
		#@event = Event.find(params[:event_id])
		@profile = current_profile
		@album = @profile.album.build
	end

	def update
		@album= Album.find(params[:id])
		if @album.update_attributes(params[:album])
			flash[:success] = "Beers updated"
			respond_with @album
		else
			render @album
		end
	end

	def info
	end

	private

	def find_controller
		params.each do |name, value|
			if name =~ /(.+)_id$/
				return $1.classify.constantize.find(value)
			end
		end	
		nil
	end

	def correct_user

		#finds album then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@album_id= Album.find(params[:id])
		@profile_id = @album_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end


end
