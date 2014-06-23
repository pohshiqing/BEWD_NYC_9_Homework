class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  

  	devise :database_authenticatable, :registerable,
        	:recoverable, :rememberable, :trackable, :validatable
	has_many :products
	has_attached_file :avatar, styles: { thumb: "100x100>" }, default_url:"/images/missing.png"
	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
	has_many :likes
	has_many :messages

#geocoded_by :full_street_address   # can also be an IP address
geocoded_by :IPAddress   # can also be an IP address

after_validation :geocode          # auto-fetch coordinates


#acts_as_messageable


end


