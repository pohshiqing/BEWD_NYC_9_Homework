class AddIpAddressToUser < ActiveRecord::Migration
  def change
    add_column :users, :IPAddress, :string
    add_column :users, :string, :string
  end
end
