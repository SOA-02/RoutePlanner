require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'

describe 'Tests OpenAI library' do
  before do
    VcrHelper.configure_vcr_for_skill
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Fetch OpenAI successfully' do
    it 'HAPPY: fetches syllabus and analyze prerequisite successfully' do
      # skill_prompt = RoutePlanner::Entity::SkillSet.new.skill_prompt
      mapper = RoutePlanner::OpenAPI::SkillSetMapper.new(
        SYLLABUS,
        OPENAI_KEY
      )

      result = mapper.call
      puts "\nParsed skill result:"
      puts result.inspect

      parsed = result.gsub(/^```yaml\n|```$/m, '')
      puts parsed
      # puts "\nPrerequisite format:"
      # puts result['prerequisites']
    end
  end
end
