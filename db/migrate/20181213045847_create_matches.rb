class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.boolean :finished, default: false

      t.timestamps
    end

    create_join_table :users, :matches
  end
end
