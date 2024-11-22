require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'

describe 'Tests OpenAI library' do
  before do
    VcrHelper.configure_vcr_for_summary
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Fetch OpenAI successfully' do
    it 'HAPPY: fetches syllabus and summarize successfully' do
      prompt = RoutePlanner::Entity::SkillSet.new.summarize_prompt
      summary = RoutePlanner::OpenAPI::ChatService
        .new(input: SYLLABUS, prompt: prompt, api_key: OPENAI_KEY)
        .call

      puts "\nSyllabus result:"
      puts summary.inspect

      _(summary).must_be_kind_of String
    end

    # it 'HAPPY: fetches syllabus and analyze prerequisite successfully' do
    #   skill_prompt = RoutePlanner::Entity::SkillSet.new.skill_prompt
    #   mapper = RoutePlanner::OpenAPI::SkillSetMapper.new(
    #     SYLLABUS,
    #     skill_prompt,
    #     OPENAI_KEY
    #   )

    #   result = mapper.call
    #   puts "\nParsed skill result:"
    #   puts result.inspect

    #   # puts "\nPrerequisite format:"
    #   # puts result['prerequisites']
    # end
  end
end
