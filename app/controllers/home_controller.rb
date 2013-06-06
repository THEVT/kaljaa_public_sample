class HomeController < ApplicationController
	def index
		@title = "Kaljaa"
		#@account = Account.new
		#@account.remember_me =  !cookies[:remember].nil?
	end

	def copyright
	end

	def faq
	end

	def learn
	end

	def privacy
	end

	def support
	end

	def terms
	end
	
private
	def collect_static
		
	end

	def redirect_to_forwarding_url
	
	end
 
end
