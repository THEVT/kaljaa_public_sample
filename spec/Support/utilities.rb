def sign_in(account)
  visit signin_path
  fill_in "Email",    with: account.email
  fill_in "Password", with: account.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = account.remember_token
end
