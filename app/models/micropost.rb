class Micropost < ActiveRecord::Base
	attr_accessible :content
	belongs_to :account

	validates :content, presence: true, length: { maximum: 140 }	
	validates :account_id, presence: true

	default_scope order: 'microposts.created_at DESC'

	def self.from_accounts_followed_by(account)
		followed_account_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :account_id"
		where("account_id IN (#{followed_account_ids}) OR account_id = :account_id", 
          account_id: account.id)
	end

end
