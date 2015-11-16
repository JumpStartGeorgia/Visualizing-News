require 'rails_helper'

RSpec.describe 'Video', type: :feature do
  let(:video_visualization) do
    FactoryGirl.create(:video_visualization)
  end

  it 'embed code is visible on show page' do
    video_visualization.update_column(:published, true)
    video_visualization.update_column(:published_date, Time.now)
    video_visualization.categories << FactoryGirl.create(:category)

    video_visualization.reload

    visit visualization_path(video_visualization.permalink)

    expect(page).to have_content('VIDEO EMBED CODE RUNS HERE')
  end
end
