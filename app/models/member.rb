class Member < ActiveRecord::Base
	
	attr_accessible :admin, :group_id, :name, :profile_id, :status
	belongs_to :group
	belongs_to :profile

	validates :profile_id, presence: true
	validates :status, presence: true
	validates :group_id, presence: true

	#default_scope order: 'invites.created_at DESC'

end
