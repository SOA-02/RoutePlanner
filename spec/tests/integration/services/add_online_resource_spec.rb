# frozen_string_literal: false

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'RoutePlanner Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_youtube
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store online resource' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to find and save remote project to database' do
      # GIVEN: a valid request for an existing remote project:
      videos = RoutePlanner::Youtube::VideoRecommendMapper.new(API_KEY).find(KEY_WORD)

      # WHEN: the service is called with the request form object
      videos_made = RoutePlanner::Service::AddOnlineResource.new.call(KEY_WORD)
      # THEN: the result should report success..
      _(videos_made.success?).must_equal true

      # ..and provide a video entity with the right details
      rebuilt_videos = videos_made.value!
      rebuilt_videos.zip(videos).each do |rebuilt, original|
        _(rebuilt.original_id.class).must_equal(original.original_id.class)
        _(rebuilt.topic.class).must_equal(original.topic.class)
        _(rebuilt.url.class).must_equal(original.url.class)
        _(rebuilt.platform.class).must_equal(original.platform.class)
        _(rebuilt.for_skill.class).must_equal(original.for_skill.class)
      end
    end
  end
end
