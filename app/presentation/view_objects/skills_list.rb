# frozen_string_literal: true

require_relative 'skill'

module Views
  # View for a a list of video entities
  class SkillList
    def initialize(skills)
      @skills = skills.map.with_index { |vid, i| Skill.new(vid, i) }
    end

    def each(&show)
      @skills.each do |vid|
        show.call vid
      end
    end

    def any?
      @skills.any?
    end
  end
end
