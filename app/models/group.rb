class Group < ActiveRecord::Base
  attr_accessible :photo, :city, :country, :description, :exclusive, :visible, :profile_id, :state, :street, :title, :zipcode
	belongs_to :profile
	has_many :member, dependent: :destroy
	has_many :blog
	has_many :article

	has_attached_file :photo, :styles => { :medium => "300x300>", large: "500x500", thumb: "100x100>" }, default_url: "/assets/dasbootresize2.jpg"

	validates :title, presence: true	
	validates :profile_id, presence: true

	default_scope order: 'groups.created_at DESC'

end
