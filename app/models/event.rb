class Event < ActiveRecord::Base
  	attr_accessible :photo, :city, :country, :day, :description, :end_time, :major_event, :exclusive, :profile_id, :start_time, :state, :street, :title, :weekly, :zipcode
	belongs_to :profile
	has_many :invite, dependent: :destroy
	has_many :blog
	has_many :article

	has_attached_file :photo, :styles => { :medium => "300x300>", large: "500x500", thumb: "100x100>" }, default_url: "/assets/dasbootresize2.jpg"

	validates :title, presence: true	
	validates :profile_id, presence: true

	default_scope order: 'events.created_at DESC'

end
