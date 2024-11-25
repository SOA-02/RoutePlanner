# frozen_string_literal: true

module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    RoutePlanner::App.db.run('PRAGMA foreign_keys = OFF')
    RoutePlanner::Database::OnlineOrm.map(&:destroy)
    RoutePlanner::Database::PhysicalOrm.map(&:destroy)
    RoutePlanner::App.db.run('PRAGMA foreign_keys = ON')
  end
end
