# rubocop:disable Layout/EmptyLines
# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of Youtube API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_youtube
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Video Information' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: save yt api to database' do
      video = Outline::Youtube::VideoMapper.new(API_KEY).find(VIDEO_ID)
      _(video).must_be_kind_of Outline::Entity::Video

      rebuilt = Outline::Repository::For.entity(video).create(video)
      _(rebuilt.video_id).must_equal(video.video_id)
      _(rebuilt.video_title).must_equal(video.video_title)
      _(rebuilt.video_description).must_equal(video.video_description)
      _(rebuilt.video_published_at).must_equal(video.video_published_at)
      _(rebuilt.video_thumbnail_url).must_equal(video.video_thumbnail_url)
      _(rebuilt.video_tags).must_equal(video.video_tags)
    end
  end
end
