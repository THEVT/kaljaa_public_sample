class Album < ActiveRecord::Base
  attr_accessible :article_id, :blog_id, :description, :event_id, :group_id, :profile_id, :title

	belongs_to :article
	belongs_to :blog
	belongs_to :event
	belongs_to :group
	belongs_to :profile
	has_many :photo

end
