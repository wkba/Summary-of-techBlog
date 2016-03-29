class AddDateToInfomations < ActiveRecord::Migration
  def change
    add_column :infomations, :date, :string
  end
end
