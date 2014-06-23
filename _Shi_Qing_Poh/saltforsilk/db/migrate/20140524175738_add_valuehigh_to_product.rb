class AddValuehighToProduct < ActiveRecord::Migration
  def change
    add_column :products, :value_high, :integer
  end
end
