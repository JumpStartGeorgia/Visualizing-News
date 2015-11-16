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

    # get html content of #visual div
    visual_html = page.evaluate_script(
      "document.getElementById('visual').innerHTML"
    ).strip

    # Check that the html is the video embed code
    expect(visual_html).to eq(video_visualization.video_embed)
  end
end
