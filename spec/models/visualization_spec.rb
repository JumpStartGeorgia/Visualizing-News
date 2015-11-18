require 'rails_helper'

RSpec.describe 'Visualization', type: :model do
  context 'when type is video' do
    it 'is valid with required fields' do
      video = FactoryGirl.create(:video_visualization).reload

      expect(video.valid?).to eq(true)
    end

    describe 'translation #video_url' do
      it 'causes error if blank' do
        video = FactoryGirl.create(:video_visualization).reload
        translation = video.translations[0]
        translation.video_url = nil
        translation.save!

        video.valid?

        video_url_required_error = video.errors.messages[:video_url][0]
        expect(video_url_required_error).to eq('is a required field.')
      end
    end
  end
end
