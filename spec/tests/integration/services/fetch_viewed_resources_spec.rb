# frozen_string_literal: true

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

  describe 'RoutePlanner fetch viewed resources' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should return videos that are being watched' do
      # GIVEN: a valid resource exists locally and is being watched
      #
      # watched_list = [SKILL]
      online_resources = RoutePlanner::Youtube::VideoRecommendMapper
        .new(API_KEY)
        .find(SKILL)

      online_resources.each do |physical_resource|
        RoutePlanner::Repository::For.entity(physical_resource).build_online_resource(physical_resource)
      end

      physical_resources = RoutePlanner::Nthusa::PhysicalRecommendMapper.new.find(SKILL)
      physical_resources.each do |physical_resource|
        RoutePlanner::Repository::For.entity(physical_resource).build_physical_resource(physical_resource)
      end

      # WHEN: the service is called with the given skill
      result = RoutePlanner::Service::FetchViewedResources.new.call(SKILL)
      # THEN: it should return both physical and online resources
      _(result.success?).must_equal true
      resources = result.value!

      expected_physical_resources = physical_resources.map { |res| res.to_attr_hash.except(:id) }
      actual_physical_resources = resources[:physical_resources].map do |res|
        res.to_attr_hash.except(:id)
      end

      _(actual_physical_resources).must_equal expected_physical_resources

      expected_online_resources = online_resources.map(&:to_attr_hash)
      actual_online_resources = resources[:online_resources].map(&:to_attr_hash)

      _(actual_online_resources).must_equal expected_online_resources
    end

    it 'HAPPY: should return an empty list if no resources exist for the skill' do
      # GIVEN: no resources exist for the skill
      online_resources = RoutePlanner::Youtube::VideoRecommendMapper
        .new(API_KEY)
        .find(SKILL)

      online_resources.each do |physical_resource|
        RoutePlanner::Repository::For.entity(physical_resource).build_online_resource(physical_resource)
      end

      physical_resources = RoutePlanner::Nthusa::PhysicalRecommendMapper.new.find(SKILL)
      physical_resources.each do |physical_resource|
        RoutePlanner::Repository::For.entity(physical_resource).build_physical_resource(physical_resource)
      end
      watched_list = []

      # WHEN: the service is called with the given skill
      result = RoutePlanner::Service::FetchViewedResources.new.call(watched_list)

      # THEN: it should return a failure with a specific message
      _(result.failure?).must_equal true
      _(result.failure).must_equal 'No resources found'
    end

    it 'SAD: should return failure if an unexpected error occurs' do
      # GIVEN: the repository raises an unexpected error
      skill = 'Java Programming'

      #  Stub the `fetch_physical_resources` method to raise an error
      service = RoutePlanner::Service::FetchViewedResources.new

      service.stub :fetch_physical_resources, ->(_) { raise StandardError, 'Unexpected error' } do
        service.stub :fetch_online_resources, ->(_) { [] } do
          # WHEN: the service is called with the given skill
          result = service.call(skill)

          # THEN: it should return a failure message
          _(result.failure?).must_equal true
          _(result.failure).must_equal RoutePlanner::Service::FetchViewedResources::MSG_SERVER_ERROR
        end
      end
    end
  end
end
