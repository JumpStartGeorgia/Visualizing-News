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
        
      end
    end

    describe '#video_embed' do
      context 'with blank video url' do
        it 'does not cause error if blank' do

        end
      end
      context 'with present video url' do
        it 'causes error if blank' do

        end
      end
    end
  end
end
