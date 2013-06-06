class RelationshipsController < ApplicationController

before_filter :signed_in_user

	def create
		@account = Account.find(params[:relationship][:followed_id])
		current_user.follow!(@account)
		respond_to do |format|
			format.html { redirect_to @account }
			format.js
		end
	end

	def destroy
		@account = Relationship.find(params[:id]).followed
		current_user.unfollow!(@account)
		respond_to do |format|
			format.html { redirect_to @account }
			format.js
		end
	end

end
