require 'rails_helper'

RSpec.describe 'Video', type: :feature, js: true do
  let(:organization) { FactoryGirl.create(:organization) }

  let(:user) { FactoryGirl.create(:user) }

  let(:category) { FactoryGirl.create(:category) }

  let(:video_visualization) do
    FactoryGirl.create(:video_visualization_published,
                       categories: [category])
  end

  it 'video url is visible on show page' do
    # Register the visualization translations to enable calling permalink
    video_visualization.reload

    visit visualization_path(video_visualization.permalink)

    # get html content of #visual div
    visual_html = page.evaluate_script(
      "document.getElementById('visual').innerHTML"
    ).strip

    # Check that the html is the video embed code
    expect(visual_html).to eq(video_visualization.video_embed)
  end

  it 'can be created through form' do
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


    # Add video url
    # Upload visual image

    click_on 'Create Visualization'
    expect(page).to have_content 'Visualization was successfully created.'

    # expect video url to be something
    # expect video embed to be something
  end
end
