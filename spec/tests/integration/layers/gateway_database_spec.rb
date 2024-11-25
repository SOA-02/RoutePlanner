# frozen_string_literal: false

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'Integration Tests of Youtube API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_youtube
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store videos' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: save yt api to database' do
      videos = RoutePlanner::Youtube::VideoRecommendMapper.new(API_KEY).find(KEY_WORD)
      _(videos).wont_be_empty
      _(videos).must_be_kind_of Array
      videos.each do |video|
        RoutePlanner::Repository::For.entity(video).build_online_resource(video) if video.id.nil?

        rebuilt = RoutePlanner::Repository::For.entity(video).find_online(video)
        _(rebuilt).wont_be_nil

        _(rebuilt.topic).wont_be_nil
        _(rebuilt.url).wont_be_nil
        _(rebuilt.platform).wont_be_nil
      end
    end
  end
end

describe 'Integration Tests of NTHUSA API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_nthusa
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store courses' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: save nthusa api to database' do
      courses = RoutePlanner::Nthusa::PhysicalRecommendMapper.new.find(PRE_REQ)
      _(courses).wont_be_empty
      _(courses).must_be_kind_of Array
      courses.each do |course|
        RoutePlanner::Repository::For.entity(course).build_physical_resource(course) if course.id.nil?

        rebuilt = RoutePlanner::Repository::For.entity(course).physicals_find(course)
        _(rebuilt).wont_be_nil

        _(rebuilt.course_id).wont_be_nil
        _(rebuilt.course_name).wont_be_nil
        _(rebuilt.credit).wont_be_nil
      end
    end

    it 'HAPPY: fetch summary response from openai' do
      summary = RoutePlanner::OpenAPI::MapMapper
        .new(SYLLABUS, OPENAI_KEY)
        .call

      _(summary).must_be_kind_of RoutePlanner::Entity::Map
      rebuilt = RoutePlanner::Repository::For.entity(summary).build_map(summary)
      _(rebuilt.map_name).must_be_kind_of String
      _(rebuilt.map_description).must_be_kind_of String
      _(rebuilt.map_evaluation).must_be_kind_of String
      _(rebuilt.map_ai).must_be_kind_of String

    end
  end
end
