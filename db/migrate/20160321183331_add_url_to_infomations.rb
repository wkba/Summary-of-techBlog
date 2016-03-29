class AddUrlToInfomations < ActiveRecord::Migration
  def change
    add_column :infomations, :url, :string
  end
end
