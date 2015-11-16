require 'rails_helper'

RSpec.describe 'Video', type: :feature, js: true do
  let(:category) { FactoryGirl.create(:category) }
  let(:video_visualization) do
    FactoryGirl.create(:video_visualization_published,
                       categories: [category])
  end

  it 'video url is visible on show page' do
    # Register the visualization translations to enable calling permalink
    video_visualization.reload

    visit visualization_path(video_visualization.permalink)

    expect(page).to have_content(video_visualization.video_embed)
  end
end
