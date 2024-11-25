# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:prerequisites) do
      primary_key :id

      String :skill
      Integer :value

      DateTime :created_at
      DateTime :updated_at
      index :id
    end
  end
end
