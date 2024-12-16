# frozen_string_literal: true

require_relative '../../helpers/spec_helper'

describe 'Unit test of RoutePlanner API gateway' do
  it 'must report alive status' do
    alive = RoutePlanner::Gateway::Api.new(RoutePlanner::App.config).alive?
    _(alive).must_equal true
  end

  it 'must add the map and skills' do
    res = RoutePlanner::Gateway::Api.new(RoutePlanner::App.config).add_map(TITLE, SYLLABUS)

    _(res.success?).must_equal true
    _(res.parse.keys.count).must_be :>=, 2
  end

  it 'must return a list of projects' do
    # GIVEN a list of skills
    res = RoutePlanner::Gateway::Api.new(RoutePlanner::App.config)
      .fetch_anaylze_result(SKILL)

    # THEN we should see a single project in the list
    _(res.success?).must_equal true
    data = res.parse
    # Check that the necessary keys exist in the response
    _(data).must_include 'map'
    _(data).must_include 'user_ability_value'
    _(data).must_include 'require_ability_value'
    _(data).must_include 'time'
    _(data).must_include 'stress_index'
    _(data).must_include 'online_resources'
    _(data).must_include 'physical_resources'

    # Check that map data is not nil and contains relevant information
    _(data['map']).wont_be_nil
    _(data['map']).must_be_kind_of String

    # Ensure user_ability_value and require_ability_value are Hashes
    _(data['user_ability_value']).must_be_kind_of Hash
    _(data['require_ability_value']).must_be_kind_of Hash

    # Check that stress_index is a Hash and contains expected keys
    _(data['stress_index']).must_be_kind_of Hash
    _(data['stress_index']['pressure_index']).must_be_kind_of Integer
    _(data['stress_index']['stress_level']).must_be_kind_of String

    # Ensure online_resources is an Array and has at least one resource
    _(data['online_resources']).must_be_kind_of Array
    _(data['online_resources'].count).must_be :>=, 1

    # Access the first online resource and verify its structure
    first_resource = data['online_resources'].first
    _(first_resource).must_include 'topic'
    _(first_resource).must_include 'url'
    _(first_resource).must_include 'platform'
    _(first_resource).must_include 'video_duration'

    # Check that the topic is a string and not nil
    _(first_resource['topic']).wont_be_nil
    _(first_resource['topic']).must_be_kind_of String

    # Ensure physical_resources is an Array and has at least one resource
    _(data['physical_resources']).must_be_kind_of Array
    _(data['physical_resources'].count).must_be :>=, 1

    # Access the first physical resource and verify its structure using hash syntax
    first_physical_resource = data['physical_resources'].first
    _(first_physical_resource).must_include 'course_id'
    _(first_physical_resource).must_include 'course_name'
    _(first_physical_resource).must_include 'credit'
    _(first_physical_resource).must_include 'language'
    _(first_physical_resource).must_include 'provider'
    _(first_physical_resource).must_include 'timeloc'

    # Check that the course_id is a string and not nil
    _(first_physical_resource['course_id']).wont_be_nil
    _(first_physical_resource['course_id']).must_be_kind_of String

    # Check that the course_name is a string and not nil
    _(first_physical_resource['course_name']).wont_be_nil
    _(first_physical_resource['course_name']).must_be_kind_of String
  end
end
