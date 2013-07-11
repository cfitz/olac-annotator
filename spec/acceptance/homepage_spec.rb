require 'acceptance/acceptance_helper'

feature "Homepage", %q{
  In order to run the demo for processing
  a visitor
  should be able to go to the homepage
} do



  scenario "A visitor goes to the homdpage" do
    visit '/'
    page.driver.status_code.should == 200
    page.should have_link("Process MARC Record",  :href => "/nlps/new")
  end

end