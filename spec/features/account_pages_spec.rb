#rspec spec/features/account_pages_spec.rb

require 'spec_helper'

describe "AccountPages" do
   
	subject { page }

	describe "signup page" do
		#let(:account) { FactoryGirl.create(:account) }
		before { visit signup_path }

		#it { should have_selector('h1',    text: 'hello world') }
		#it { should have_selector('title', text: 'Sign up') }
	end

	describe "signup" do

		before { visit signup_path }

		let(:submit) { "Create my account" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(Account, :count)
			end
		end

		describe "with valid information" do
			before do
				fill_in "Email",        with: "user@example.com"
				fill_in "Password",     with: "foobar"
				fill_in "Confirmation", with: "foobar"
				find(:css, "#account_authorization_1[value='1']").set(true)
				find(:xpath, "//input[@id='account_ty']").set "brewery"
			end

			it "should create a user" do
				expect { click_button submit }.to change(Account, :count).by(1)
			end
		end

	end

	describe "edit" do
		let(:account) { FactoryGirl.create(:account) }
		before { visit edit_account_path(account) }

		describe "page" do
			it { should have_selector('h1',    text: "Update your Settings") }

		end

		describe "with invalid information" do
			before { click_button "Save changes" }

			it { should have_content('error') }
		end
	end

end
