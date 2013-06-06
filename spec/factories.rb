
FactoryGirl.define do

	factory :account do
		email    "foobar@example.com"
		password "foobar"
		password_confirmation "foobar"
		authorization "1"
		ty "brewery"
	end

end
