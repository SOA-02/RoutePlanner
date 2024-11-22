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
    it 'HAPPY: fetches side quest skill successfully' do
      prompt = :side_quest
      @skillset = RoutePlanner::OpenAI::ChatService
        .new(message: 'Machine Learning', prompt: prompt, api_key: OPENAI_KEY)
        .call

      _(@skillset).must_be_kind_of String
    end

    it 'HAPPY: fetches main quest skill successfully' do
      prompt = :main_quest
      @skillset = RoutePlanner::OpenAI::ChatService
        .new(message: 'Machine Learning', prompt: prompt, api_key: OPENAI_KEY)
        .call

      _(@skillset).must_be_kind_of String
    end
  end
end
