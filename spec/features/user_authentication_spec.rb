require 'rails_helper'

feature 'User authentication' do 
	background do
		user = create(:user)
	end

	scenario 'can log in from the home page' do
		visit '/'
		expect(page).to_not have_content('New Scan')

		click_link 'Login'
		fill_in 'Email', with: 'fancyfellows@gmail.com'
		fill_in 'Password', with: 'illbeback'
		click_button 'Log in'

		expect(page).to have_content('Signed in successfully.')
		expect(page).to_not have_content('Register')
		expect(page).to_not have_content('Login')
		expect(page).to have_content('Logout')
	end

	scenario 'can log out once logged in' do
		visit '/'
		expect(page).to_not have_content('New Scan')

		click_link 'Login'
		fill_in 'Email', with: 'fancyfellows@gmail.com'
		fill_in 'Password', with: 'illbeback'
		click_button 'Log in'

		click_link 'Logout'

		expect(page).to have_content('Signed out successfully.')
		expect(page).to have_content('Register')
		expect(page).to have_content('Login')
		expect(page).to_not have_content('Logout')
	end

end