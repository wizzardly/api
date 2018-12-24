class AddStatusToMatch < ActiveRecord::Migration[5.2]
  def change
    remove_column :matches, :finished
    add_column :matches, :status, :integer, default: 0
  end
end
