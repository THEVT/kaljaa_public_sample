class Invite < ActiveRecord::Base
	attr_accessible :event_id, :profile_id, :status, :admin
	belongs_to :event
	belongs_to :profile

	validates :profile_id, presence: true
	validates :status, presence: true
	validates :event_id, presence: true

	#default_scope order: 'invites.created_at DESC'

end
