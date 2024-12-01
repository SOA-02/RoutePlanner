# frozen_string_literal: true

module Views
  # View for a single skill entity
  class Skill
    def initialize(skill, index = nil)
      @skill = skill
      @index = index
    end

    def entity
      @skill
    end

    def skill_name
      @skill.skill_name
    end

  end
end
