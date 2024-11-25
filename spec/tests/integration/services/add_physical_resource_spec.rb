# frozen_string_literal: false

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'RoutePlanner Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_nthusa
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store physical resource' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to find and save remote course to database' do
      # GIVEN: a valid request for an existing remote course:
      courses = RoutePlanner::Nthusa::PhysicalRecommendMapper.new.find(PRE_REQ)

      # WHEN: the service is called with the request form object
      courses_made = RoutePlanner::Service::AddPhysicalResource.new.call(PRE_REQ)
      # THEN: the result should report success..
      _(courses_made.success?).must_equal true

      # ..and provide a course entity with the right details
      rebuilt_videos = courses_made.value!
      rebuilt_videos.zip(courses).each do |rebuilt, course|
        _(rebuilt.course_id).must_equal(course.course_id)
        _(rebuilt.course_name).must_equal(course.course_name)
        _(rebuilt.language).must_equal(course.language)
        _(rebuilt.provider).must_equal(course.provider)
        _(rebuilt.timeloc).must_equal(course.timeloc)
        _(rebuilt.for_skill).must_equal(course.for_skill)
      end
    end
  end
end
