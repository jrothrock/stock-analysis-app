require 'rails_helper.rb'

feature 'Creating Scans' do
  background do
    user = create :user
    visit new_scan_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end
  
	scenario 'can create a job ' do
		fill_in 'Must enter a ticker symbol', with: 'SPHS'
		click_button 'Create Scan'
		expect(page).to have_content('Your report has been generated!')
	end	

	scenario 'cannot create a new scan without logging in' do
	click_link 'Logout'

    visit new_scan_path
    expect(page).to have_content('Log in')
  end
end