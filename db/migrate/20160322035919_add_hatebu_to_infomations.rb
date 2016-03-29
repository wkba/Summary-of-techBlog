class AddHatebuToInfomations < ActiveRecord::Migration
  def change
    add_column :infomations, :hatebu, :integer
  end
end
