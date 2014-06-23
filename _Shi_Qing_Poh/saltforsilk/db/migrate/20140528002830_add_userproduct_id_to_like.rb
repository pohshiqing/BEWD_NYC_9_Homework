class AddUserproductIdToLike < ActiveRecord::Migration
  def change
    add_column :likes, :userproduct_id, :integer
  end
end
