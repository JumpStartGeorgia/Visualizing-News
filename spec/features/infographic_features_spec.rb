require 'rails_helper'

RSpec.describe 'Infographic', type: :feature, js: true do
  let(:organization) { FactoryGirl.create(:organization) }
  let(:user) { FactoryGirl.create(:user) }

  it 'can be created through form', js: true do
    login_as user, scope: :user
    user.organizations << organization

    visit new_organization_visualization_path(organization.reload.permalink)
    expect(page).to have_content('New Visualization')

    within '#fields-panel' do
      choose 'Infographic'

      # select languages
      find(:css, '#visualization_languages_internal_en').set(true)
      find(:css, '#visualization_languages_internal_hy').set(false)
      find(:css, '#visualization_languages_internal_ka').set(false)
    end

    within '#form-en' do
      fill_in 'Title', with: 'test-video-vis'

      attach_file 'visualization_visualization_translations_attributes_0_image_file_attributes_file',
                  Rails.root.join('spec', 'example_files', 'how-dependent-is-georgia-on-russia-economically_en_medium.jpg')
    end

    click_on 'Create Visualization'
    expect(page).to have_content 'Visualization was successfully created.'
  end
end
