# frozen_string_literal: true

require 'sequel'

module RoutePlanner
  module Database
    # Object Relational Mapper for Maps
    class SkillOrm < Sequel::Model(:skills)
      one_to_many :map_skills,
                  class: :'RoutePlanner::Database::MapSkillsOrm'
      plugin :timestamps, update_on_create: true
    end
  end
end
