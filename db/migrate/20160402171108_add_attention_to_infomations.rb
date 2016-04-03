class AddAttentionToInfomations < ActiveRecord::Migration
  def change
    add_column :infomations, :attention, :integer
  end
end
