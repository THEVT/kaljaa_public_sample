namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		make_accounts
		make_microposts
		make_relationships
	end
end

def make_accounts
  admin = Account.create!(email: "social@kaljaa.org",
                 password: "foobar",
                 password_confirmation: "foobar",
				authorization: "1",
				ty: "social")
  admin.toggle!(:admin)
  20.times do |n|
    name  = Faker::Name.name
    email = "social-#{n+1}@kaljaa.org"
    password  = "password"
    Account.create!(email: email,
                   password: password,
                   password_confirmation: password,
				authorization: "1",
				ty: "social")
  end
	20.times do |n|
    name  = Faker::Name.name
    email = "brewery-#{n+1}@kaljaa.org"
    password  = "password"
    Account.create!(email: email,
                   password: password,
                   password_confirmation: password,
				authorization: "1",
				ty: "brewery")
  end
	20.times do |n|
    name  = Faker::Name.name
    email = "media-#{n+1}@kaljaa.org"
    password  = "password"
    Account.create!(email: email,
                   password: password,
                   password_confirmation: password,
				authorization: "1",
				ty: "media")
  end
	20.times do |n|
    name  = Faker::Name.name
    email = "industry-#{n+1}@kaljaa.org"
    password  = "password"
    Account.create!(email: email,
                   password: password,
                   password_confirmation: password,
				authorization: "1",
				ty: "industry")
  end
	20.times do |n|
    name  = Faker::Name.name
    email = "vendor-#{n+1}@kaljaa.org"
    password  = "password"
    Account.create!(email: email,
                   password: password,
                   password_confirmation: password,
				authorization: "1",
				ty: "vendor")
  end
end

def make_microposts
	accounts = Account.all(limit: 6)
	50.times do
		content = Faker::Lorem.sentence(5)
		accounts.each { |account| account.microposts.create!(content: content) }
	end
end

def make_relationships
	accounts = Account.all
	account  = accounts.first
	followed_users = accounts[2..50]
	followers      = accounts[3..40]
	followed_users.each { |followed| account.follow!(followed) }
	followers.each      { |follower| follower.follow!(account) }
end

