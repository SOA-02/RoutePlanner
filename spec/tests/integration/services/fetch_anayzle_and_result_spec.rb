# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'

describe 'Integration test of FetchAnayzleResult service and API gateway' do
  it 'must add the map and skills' do
    # WHEN we request to fetch and analyze the result

    res = RoutePlanner::Service::FethcAnayzleResult.new.call(SKILL)
    # THEN we should see a single success message
    _(res.success?).must_equal true

    payload = res.value!

    # Ensure the map data is not empty and has the correct type
    _(payload.map).wont_be_nil


    # Ensure user_ability_value and require_ability_value are Hashes
    _(payload.user_ability_value).must_be_kind_of Hash
    _(payload.user_ability_value).wont_be_nil
    _(payload.require_ability_value).must_be_kind_of Hash
    _(payload.require_ability_value).wont_be_nil

    # Ensure stress index is a Hash with expected keys
    _(payload.stress_index).must_be_kind_of Hash
    _(payload.stress_index['pressure_index']).must_be_kind_of Integer
    _(payload.stress_index['stress_level']).wont_be_nil

    # Ensure online resources is an array with at least one item
    _(payload.online_resources).must_be_kind_of Array
    _(payload.online_resources).wont_be_empty
    _(payload.online_resources.first).must_respond_to :topic
    _(payload.online_resources.first).must_respond_to :url

    # Ensure physical resources is an array with at least one item
    _(payload.physical_resources).must_be_kind_of Array
    _(payload.physical_resources).wont_be_empty
    _(payload.physical_resources.first).must_respond_to :course_id
    _(payload.physical_resources.first).must_respond_to :course_name
  end
end
