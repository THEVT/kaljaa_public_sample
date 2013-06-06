class Favbrewery < ActiveRecord::Base
  attr_accessible :b1, :b10, :b2, :b3, :b4, :b5, :b6, :b7, :b8, :b9

	belongs_to :profile

	validates :profile_id, presence: true

end
