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

        expect(video.errors.messages.length).to eq(1)
      end
    end
  end
end
