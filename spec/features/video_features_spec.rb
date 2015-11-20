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

  it 'can be created through form', js: true do
    login_as user, scope: :user
    user.organizations << organization

    visit new_organization_visualization_path(organization.reload.permalink)
    expect(page).to have_content('New Visualization')

    within '#fields-panel' do
      # select languages
      find(:css, '#visualization_languages_internal_en').set(true)
      find(:css, '#visualization_languages_internal_hy').set(false)
      find(:css, '#visualization_languages_internal_ka').set(false)

      # Choosing video after selecting languages to give JavaScript time to
      # load (otherwise the fields Video URL and Embed don't always appear)
      choose 'Video'
    end

    within '#form-en' do
      attach_file 'visualization_visualization_translations_attributes_0_image_file_attributes_file',
                  Rails.root.join('spec', 'example_files', 'how-dependent-is-georgia-on-russia-economically_en_medium.jpg')

      fill_in 'Video URL',
              with: 'https://www.youtube.com/watch?v=KN56RvmK5_Y'

      fill_in 'Title', with: 'Test Video Visualization'

    end

    click_on 'Create Visualization'
    expect(page).to have_content 'Visualization was successfully created.'

    video = Visualization.first

    expect(video.title).to eq('Test Video Visualization')
    expect(video.video_url).to eq('https://www.youtube.com/watch?v=KN56RvmK5_Y')
    expect(video.video_embed).to eq('<iframe width="560" height="315" src="http://www.youtube.com/embed/KN56RvmK5_Y" frameborder="0" allowfullscreen=""></iframe>')

    click_on 'Update Visualization'

    expect(page).to have_content('Edit Visualization')
    expect(page).to have_content('Visualization was successfully updated.')

    expect(page).to have_content('Video URL https://www.youtube.com/watch?v=KN56RvmK5_Y')
  end
end
