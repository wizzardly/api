class AddTimestampsToMatches < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :started_at, :timestamp
    add_column :matches, :paused_at, :timestamp
  end
end
