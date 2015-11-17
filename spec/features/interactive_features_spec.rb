require 'rails_helper'

RSpec.describe 'Interactive', type: :feature, js: true do
  let(:organization) { FactoryGirl.create(:organization) }
  let(:user) { FactoryGirl.create(:user) }

  it 'can be created through form', js: true do
    login_as user, scope: :user
    user.organizations << organization

    visit new_organization_visualization_path(organization.reload.permalink)
    expect(page).to have_content('New Visualization')

    within '#fields-panel' do
      choose 'Interactive'

      # select languages
      find(:css, '#visualization_languages_internal_en').set(true)
      find(:css, '#visualization_languages_internal_hy').set(false)
      find(:css, '#visualization_languages_internal_ka').set(false)
    end

    within '#form-en' do
      fill_in 'Title', with: 'test-video-vis'

      fill_in 'URL to Interactive Visualization',
              with: 'https://www.youtube.com/watch?v=KN56RvmK5_Y'
    end

    click_on 'Create Visualization'
    expect(page).to have_content 'Visualization was successfully created.'
  end
end
