class FriendshipsController < ApplicationController

	before_filter :signed_in_user
	before_filter :correct_profile,   only: [:edit, :update, :destroy]
	#before_filter :admin_profile,     only: [:edit, :update]
	respond_to :json, :html, :xml, :js


	def create
		@profile = current_profile
		@friendrequest = Profile.find(params[:friend_id])
		Friendship.request(@profile, @friendrequest)
		flash[:notice] = "Friend request sent."
		redirect_to profiles_path
	end

	def accept
		@profile = current_profile
		@friend = Profile.find(params[:id])

		if @profile.requested_friends.include?(@friend)
			Friendship.accept(@profile, @friend)
			flash[:notice] = "Friendship with #{@friend.s1} accepted!"
		else
			flash[:notice] = "No friendship request from #{@friend.s1}."
		end
		redirect_to accounts_path
	end

	def decline
		@profile = current_profile
		@friend = Profile.find(params[:id])

		if @profile.requested_friends.include?(@friend)
			Friendship.breakup(@profile, @friend)
			flash[:notice] = "Friendship with #{@friend.s1} declined"
		else
			flash[:notice] = "No friendship request from #{@friend.s1}."
		end
		redirect_to accounts_path
	end

	def cancel
		@profile = current_profile
		@friend = Profile.find(params[:id])
		
		if @profile.pending_friends.include?(@friend)
			Friendship.breakup(@profile, @friend)
			flash[:notice] = "Friendship request canceled."
		else
			flash[:notice] = "No request for friendship with #{@friend.s1}"
		end
		redirect_to accounts_path
	end

	def delete
		@profile = current_profile
		@friend = Profile.find(params[:id])	
		
		if @profile.friends.include?(@friend)
			Friendship.breakup(@profile, @friend)
			flash[:notice] = "Friendship with #{@friend.s1} deleted!"
		else
			flash[:notice] = "You aren't friends with #{@friend.s1}"
		end
		redirect_to accounts_path
	end


	private

	def setup_friends
		#@profile = current_profile
		#@friend = Profile.find(params[:id])
		#@friend = Profile.find(params[:friend_id])
	end

end
