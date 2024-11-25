# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'

describe 'Tests NTHUSA API library' do
  before do
    VcrHelper.configure_vcr_for_nthusa
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Search information' do
    before do
      @relevant_result = RoutePlanner::Nthusa::PhysicalRecommendMapper
        .new
        .find(PRE_REQ)
    end

    it 'HAPPY: search relevant gateway captures search relevant results' do
      @search_relevant_data = RoutePlanner::Nthusa::NthusaApi.new.nthusa_search_recommend(PRE_REQ)
      assert_kind_of Array, @search_relevant_data
      refute_empty @search_relevant_data
    end

    it 'HAPPY: recognize search relevant results' do
      assert_kind_of Array, @relevant_result
      refute_empty @relevant_result
      @relevant_result.each do |item|
        assert_kind_of RoutePlanner::Entity::Physical, item
      end
    end

    it 'HAPPY: should get  using try' do
      @relevant_result.each do |item|
        refute_nil item.course_id
        refute_nil item.course_name
        refute_nil item.credit
      end
    end
  end
end
