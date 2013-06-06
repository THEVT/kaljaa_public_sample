class Article < ActiveRecord::Base
  attr_accessible :content, :profile_id, :title, :word_on_the_street, :event_id, :group_id

	belongs_to :profile
	belongs_to :event
	belongs_to :group
	has_many :album

	validates :title, presence: true	
	validates :content, presence: true
	validates :profile_id, presence: true
	validates :word_on_the_street, presence: true

	default_scope order: 'articles.created_at DESC'

end
