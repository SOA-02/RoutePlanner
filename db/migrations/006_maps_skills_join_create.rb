# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:map_skills) do
      primary_key :id
      foreign_key :map_id, :maps
      foreign_key :skill_id, :skills

      DateTime :created_at
      DateTime :updated_at
      index :id
    end
  end
end
