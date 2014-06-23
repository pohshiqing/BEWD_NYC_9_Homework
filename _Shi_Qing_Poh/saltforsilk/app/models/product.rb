class Product < ActiveRecord::Base

	belongs_to :user
	has_attached_file :image, styles: { thumb: "100x100>" }, default_url:"/images/missing.png"
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	has_many :likes
	has_and_belongs_to_many :matches, class_name: "Product", join_table: "likes", association_foreign_key: "userproduct_id"

end

