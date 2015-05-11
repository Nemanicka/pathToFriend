require 'spec_helper'

describe "StaticPages" do
    describe "Home page" do
        it "should have the content of geosearch" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        visit '/static_pages/home'
        expect(page).to have_content('LAL') 
    end
  end
end


