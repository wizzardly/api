class AddFinishedAtToMatches < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :finished_at, :datetime
  end
end
