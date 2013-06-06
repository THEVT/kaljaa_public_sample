class MicropostsController < ApplicationController
	before_filter :signed_in_user, only: [:create, :destroy]
	before_filter :correct_user,   only: :destroy

	def create
		@account = current_user
		@micropost = current_user.microposts.build(params[:micropost])
		if @micropost.save
			UserMailer.welcome_email(@account).deliver
			flash[:success] = "Micropost created!"
			redirect_to m_home_path
		else
			@feed_items = []
			render 'accounts/m_home'
		end
	end

	def destroy
		@micropost.destroy
		redirect_to m_home_path
	end

	def index
	end

	private

	def correct_user
		@micropost = current_user.microposts.find_by_id(params[:id])
		redirect_to m_home_path if @micropost.nil?
	end

end
