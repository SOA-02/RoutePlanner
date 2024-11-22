require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'

describe 'Tests OpenAI library' do
  before do
    VcrHelper.configure_vcr_for_youtube
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Fetch OpenAI successfully' do
    before do
      prompt = :physical_training
      @skillset = RoutePlanner::Mixins::ChatService
        .new(message: 'Machine Learning', prompt: prompt, api_key: OPENAI_KEY)
        .call
    end
    it 'HAPPY: fetches side quest skill successfully' do
      _(@skillset).must_be_kind_of String
    end
  end
end
