class AddValuelowToProduct < ActiveRecord::Migration
  def change
    add_column :products, :value_low, :integer
  end
end
