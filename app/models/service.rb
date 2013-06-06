class Service < ActiveRecord::Base
  attr_accessible :content, :profile_id
	belongs_to :profile

	validates :profile_id, presence: true

end
