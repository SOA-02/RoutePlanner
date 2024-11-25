# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:skills) do
      primary_key :id

      String :skill_name
      Integer :challenge_score

      DateTime :created_at
      DateTime :updated_at
      index :id
    end
  end
end
