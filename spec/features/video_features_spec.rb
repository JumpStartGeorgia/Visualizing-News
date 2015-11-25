require 'rails_helper'

RSpec.describe 'Video', type: :feature, js: true do
  let(:organization) { FactoryGirl.create(:organization) }

  let(:user) { FactoryGirl.create(:user) }

  let(:category) { FactoryGirl.create(:category) }

  let(:video_visualization) do
    FactoryGirl.create(:video_visualization_published,
                       categories: [category])
  end

  it 'can be created through form', js: true do
    login_as user, scope: :user
    category # load category
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

    # Allow page to load to avoid 'stale element reference' error
    sleep 1

    # Goes to 2nd visualization form page

    expect(page).to have_content 'Visualization was successfully created.'

    video = Visualization.first

    expect(video.title).to eq('Test Video Visualization')
    expect(video.video_url).to eq('https://www.youtube.com/watch?v=KN56RvmK5_Y')
    expect(video.video_embed).to eq('<iframe width="560" height="315" src="http://www.youtube.com/embed/KN56RvmK5_Y" frameborder="0" allowfullscreen=""></iframe>')

    click_on 'Update Visualization'

    expect(page).to have_content('Edit Visualization')

    # Goes to 3rd visualization form page

    expect(page).to have_content('Visualization was successfully updated.')
    expect(page).to have_content('Video URL https://www.youtube.com/watch?v=KN56RvmK5_Y')

    # check that video embed code is displayed in browser
    embedded_video_html = page.evaluate_script(
      "document.getElementById('embedded-video-#{video.translations[0].locale}').innerHTML"
    ).strip

    expect(video.video_embed).to eq(embedded_video_html)

    explanation_value = "Hello!!\n\nThis is an explanation of the video"
    fill_in 'Explanation',
            with: explanation_value

    researcher_value = 'Test Researcher Name 1, Test Organization 1'
    fill_in 'Researcher (Name, Organization)',
            with: researcher_value

    narrator_value = 'Test Narrator Name 1, Test Organization 1'
    fill_in 'Narrator (Name, Organization)',
            with: narrator_value

    researcher_value = 'Test Researcher Name 1, Test Organization 1'
    fill_in 'Researcher (Name, Organization)',
            with: researcher_value

    producer_value = 'Test Producer Name 1, Test Organization 1'
    fill_in 'Producer (Name, Organization)',
            with: producer_value

    director_value = 'Test Director Name 1, Test Organization 1'
    fill_in 'Director (Name, Organization)',
            with: director_value

    writer_value = 'Test Writer Name 1, Test Organization 1'
    fill_in 'Writer (Name, Organization)',
            with: writer_value

    designer_animator_value = 'Test Designer Animator Name 1, Test Organization 1'
    fill_in 'Designer / Animator (Name, Organization)',
            with: designer_animator_value

    sound_music_value = 'Test Sound Music Name 1, Test Organization 1'
    fill_in 'Sound / Music Designer (Name, Organization)',
            with: sound_music_value

    # Add visualization to category
    find(:css, "#visualization_category_ids_#{category.id}").set(true)

    within '#visualization_published_input' do
      choose 'Yes'
    end

    fill_in 'Publication Date', with: Time.now.strftime('%d/%m/%Y')

    click_on 'Update Visualization'

    # Goes to video show page

    expect(page).to have_content('Visualization was successfully updated.')

    # get html content of #visual div
    visual_html = page.evaluate_script(
      "document.getElementById('visual').innerHTML"
    ).strip

    # Check that the html is the video embed code
    expect(visual_html).to eq(video.video_embed)

    expect(page).to have_content(explanation_value)
    expect(page).to have_content("Researcher: #{researcher_value}")
    expect(page).to have_content("Narrator: #{narrator_value}")
    expect(page).to have_content("Producer: #{producer_value}")
    expect(page).to have_content("Director: #{director_value}")
    expect(page).to have_content("Writer: #{writer_value}")

    expect(page).to have_content(
      "Designer / Animator: #{designer_animator_value}"
    )

    expect(page).to have_content("Sound / Music Designer: #{sound_music_value}")
  end
end
