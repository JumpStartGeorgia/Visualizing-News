require 'rails_helper'

RSpec.describe 'Visualization Translation', type: :model do
  context 'when type of visualization is video' do
    context 'with valid fields' do
      it 'is valid' do
        vt = FactoryGirl.create(:video_visualization_translation)

        expect(vt.valid?).to eq(true)
      end
    end

    describe '#video_url' do
      it 'causes error if does not contain protocol' do
        vt = FactoryGirl.create(:video_visualization_translation)
        vt.video_url = 'www.youtube.com/watch?v=KN56RvmK5_Y'

        vt.valid?

        video_url_wrong_format_error = vt.errors.messages[:video_url][0]
        expect(video_url_wrong_format_error).to eq('is invalid')
      end
    end

    describe '#video_embed' do
      context 'with blank video url' do
        it 'does not cause error if blank' do
          vt = FactoryGirl.create(:video_visualization_translation)
          vt.video_url = nil
          vt.video_embed = nil

          expect(vt.valid?).to eq(true)
        end
      end
      context 'with present video url' do
        it 'causes error if blank' do
          vt = FactoryGirl.create(:video_visualization_translation)
          vt.video_embed = nil

          vt.valid?

          video_embed_required_error = vt.errors.messages[:video_embed][0]
          expect(video_embed_required_error).to eq("can't be blank")
        end
      end
    end
  end
end
