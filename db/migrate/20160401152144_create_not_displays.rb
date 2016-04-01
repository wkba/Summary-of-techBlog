class CreateNotDisplays < ActiveRecord::Migration
  def change
    create_table :not_displays do |t|
      t.integer :user_id
      t.integer :entry_id

      t.timestamps null: false
    end
  end
end
