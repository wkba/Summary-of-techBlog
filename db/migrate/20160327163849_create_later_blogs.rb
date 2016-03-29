class CreateLaterBlogs < ActiveRecord::Migration
  def change
    create_table :later_blogs do |t|
      t.string :user_id
      t.integer :entry_id
      t.boolean :later
      t.string :url
      t.string :title
      t.string :siteName
      t.string :date

      t.timestamps null: false
    end
  end
end
