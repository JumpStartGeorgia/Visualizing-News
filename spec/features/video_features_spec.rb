require 'rails_helper'

RSpec.describe 'Video', type: :feature do
  let(:video_visualization) do
    FactoryGirl.create(:video_visualization)
  end

  it 'embed code is visible on show page' do
    visit visualization_path(video_visualization)

    expect(page).to have_content('VIDEO EMBED CODE RUNS HERE')
  end
end
