class CreateInfomations < ActiveRecord::Migration
  def change
    create_table :infomations do |t|
      t.string :siteName
      t.string :siteURL
      t.string :title
      t.string :description
      t.integer :stocked
      t.integer :liked

      t.timestamps null: false
    end
  end
end
