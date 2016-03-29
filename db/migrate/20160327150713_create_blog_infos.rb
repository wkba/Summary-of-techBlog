class CreateBlogInfos < ActiveRecord::Migration
  def change
    create_table :blog_infos do |t|
      t.string :user_id
      t.integer :entry_id
      t.boolean :like
      t.boolean :later
      t.boolean :read
      t.string :url
      t.string :title
      t.string :siteName
      t.string :date

      t.timestamps null: false
    end
  end
end
