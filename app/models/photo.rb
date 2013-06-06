class Photo < ActiveRecord::Base
  attr_accessible :album_id, :description, :profile_pic, :title, :photo

	belongs_to :album

	has_attached_file :photo, :styles => { :medium => "300x300>", large: "500x500", thumb: "100x100>" }	
	validates :album_id, presence: true
	validates :photo, presence: true	

	default_scope order: 'photos.created_at DESC'

end
