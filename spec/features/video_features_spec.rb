require 'rails_helper'

RSpec.describe 'Video', type: :feature do
  let(:video_visualization) do
    FactoryGirl.create(:video_visualization)
  end

  it 'embed code is visible on show page' do
    video_visualization.update_column(:published, true)
    video_visualization.update_column(:published_date, Time.now)
    video_visualization.categories << FactoryGirl.create(:category)

    ot = video_visualization.organization.reload.translations.first
    ot.permalink = Utf8Converter.convert_ka_to_en(ot.name).to_ascii.downcase.gsub(' ', '-')
    ot.save!

    video_visualization.reload

    visit visualization_path(video_visualization.permalink)

    expect(page).to have_content('VIDEO EMBED CODE RUNS HERE')
  end
end
