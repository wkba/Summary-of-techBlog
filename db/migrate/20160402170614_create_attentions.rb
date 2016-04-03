class CreateAttentions < ActiveRecord::Migration
  def change
    create_table :attentions do |t|
      t.string :user_id
      t.integer :entry_id
      t.string :url
      t.string :title
      t.string :siteName
      t.string :date

      t.timestamps null: false
    end
  end
end
