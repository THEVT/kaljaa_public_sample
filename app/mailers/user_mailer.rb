class UserMailer < ActionMailer::Base
  default from: "dew.boms.llc@gmail.com"

	def welcome_email(account)
		@account = account
		@url  = "localhost:3000"
		mail(:to => account.email, :subject => "Welcome to Kaljaa")
	end

end
