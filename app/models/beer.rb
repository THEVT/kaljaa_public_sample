class Beer < ActiveRecord::Base
  attr_accessible :beer_name, :content, :brewery_name, :photo
	belongs_to :profile
	has_many :comments, :as => :commentable
	has_and_belongs_to_many :reviewbeers

	has_attached_file :photo, :styles => { :medium => "300x300>", large: "500x500", thumb: "100x100>" }, default_url: "/assets/dasbootresize2.jpg"
	validates :beer_name, presence: true	
	validates :profile_id, presence: true

	default_scope order: 'beers.created_at DESC'

	
end
