# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'

describe 'Integration test of AddMapandSkill service and API gateway' do
  it 'must add the map and skills' do
    # WHEN we request to add a map and skill
    request = RoutePlanner::Forms::NewSyllabus.new.call(syllabus_title: TITLE, syllabus_text: SYLLABUS)

    res = RoutePlanner::Service::AddMapandSkill.new.call(request)
    # THEN we should see a single success message
    _(res.success?).must_equal true

    payload = res.value!

    _(payload.map.map_name).must_equal TITLE
    _(payload.map.map_description).wont_be_nil
    _(payload.skills).wont_be_empty

    # Additional validation: Ensure all expected skills are included
    expected_skills = ['Data Analytics', 'Statistics', 'Machine Learning', 'Business Intelligence', 'Python Programming']
    _(payload.skills).must_equal expected_skills
  end
end
