class Reviewbeer < ActiveRecord::Base
  attr_accessible :photo, :beer_name, :brewery_name, :content, :feel, :grade, :look, :personal_brew, :smell, :taste, :beer_type
belongs_to :profile
has_many :comments, :as => :commentable
has_and_belongs_to_many :beers

	has_attached_file :photo, :styles => { :medium => "300x300>", large: "500x500", thumb: "100x100>" }, default_url: "/assets/dasbootresize2.jpg"
	validates :beer_name, presence: true
	validates :beer_name, presence: true	
	validates :profile_id, presence: true

	default_scope order: 'reviewbeers.created_at DESC'

end
