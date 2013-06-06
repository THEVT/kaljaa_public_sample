class MiscsController < ApplicationController

	before_filter :signed_in_user 
	before_filter :correct_user,   only: [:edit, :update]
	#before_filter :admin_user,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js
	
	def index
	end

	def show
		
		@misc= Misc.find(params[:id])
		@account_id= @misc.account_id
		@account = Account.find(@account_id)

	end

	def create
		@profile= current_user.profile
		@misc = @profile.build_misc(params[:misc])
		if @misc.save
				flash[:success] = "Miscellaneous Updated!"
				redirect_to @profile
		else
			render 'profiles/show'
		end
	end

	def edit
		@misc= Misc.find(params[:id])
	end

	def update
		@misc= Misc.find(params[:id])
		if @misc.update_attributes(params[:misc])
			flash[:success] = "Miscs updated"
			respond_with @profile

		else
			render @profile
		end
	end

	def info
	end

	private

	def correct_user

		#finds misc then matches profile_id to Profile then matches matches account_id to Account then asks if its current user 
		@misc_id= Misc.find(params[:id])
		@profile_id = @misc_id.profile_id
		@profile = Profile.find(@profile_id)
		@account_id= @profile.account_id
		@account = Account.find(@account_id)
		redirect_to(@profile) unless current_user?(@account)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end


end
