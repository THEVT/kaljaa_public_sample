class Blog < ActiveRecord::Base
	attr_accessible :content, :profile_id, :title, :event_id, :group_id
	belongs_to :profile
	belongs_to :event
	belongs_to :group
	has_many :album

	validates :title, presence: true	
	validates :content, presence: true
	validates :profile_id, presence: true

	default_scope order: 'blogs.created_at DESC'


end
