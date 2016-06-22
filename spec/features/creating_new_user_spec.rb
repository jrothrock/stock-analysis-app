feature 'Creating a new user' do 
	background do
		visit '/'
		click_link 'Register'
	end

	scenario 'can create a new user via the home page' do
		fill_in 'Email', with: 'test@test.com'
		fill_in 'Username', with: 'username'
		fill_in 'Password', with: 'password', match: :first
		fill_in 'Confirm Password', with: 'password'

		click_button 'Sign up'
		expect(page).to have_content('Welcome! You have signed up successfully')
	end

	scenario 'require a username to be more than 4 characters' do
		fill_in 'Email', with: 'test@test.com'
		fill_in 'Username', with: 'u'
		fill_in 'Password', with: 'password', match: :first
		fill_in 'Confirm Password', with: 'password'

		click_button 'Sign up'
		expect(page).to have_content('minimum is 4 characters')
	end

	scenario 'require a username to be less than 12 characters' do
		fill_in 'Email', with: 'test@test.com'
		fill_in 'Username', with: 'u' * 13
		fill_in 'Password', with: 'password', match: :first
		fill_in 'Confirm Password', with: 'password'

		click_button 'Sign up'
		expect(page).to have_content('maximum is 12 characters')
	end
end