# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  wall       :integer
#  ts         :integer
#  s1         :string(255)
#  s2         :string(255)
#  s3         :string(255)
#  s4         :string(255)
#  s5         :string(255)
#  s6         :string(255)
#  s7         :string(255)
#  s8         :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Profile < ActiveRecord::Base
  
	attr_accessible :s1, :s2, :s3, :s4, :s5, :s5, :s6, :s7, :s8, :ts, :wall, :city, :account_id

	belongs_to :account
	has_one :activity, foreign_key: "profile_id", dependent: :destroy
	has_one :interest, foreign_key: "profile_id", dependent: :destroy
	has_one :favbrewery, foreign_key: "profile_id", dependent: :destroy
	has_one :favbeer, foreign_key: "profile_id", dependent: :destroy
	has_one :honorablebeer, foreign_key: "profile_id", dependent: :destroy
	has_one :misc, foreign_key: "profile_id", dependent: :destroy
	has_one :about, foreign_key: "profile_id", dependent: :destroy
	has_one :location, foreign_key: "profile_id", dependent: :destroy
	has_one :service, foreign_key: "profile_id", dependent: :destroy
	has_many :album, dependent: :destroy
	has_many :article, dependent: :destroy
	has_many :blog, dependent: :destroy
	has_many :beer
	has_many :comment, dependent: :destroy
	has_many :event
	has_many :group
	has_many :invite, dependent: :destroy
	has_many :member, dependent: :destroy
	has_many :reviewbeer, dependent: :destroy
	has_many :friendships
	 has_many :friends,
		       :through => :friendships,
		       :conditions => "status = 'accepted'",
		       :order => :s1

	  has_many :requested_friends,
		       :through => :friendships,
		       :source => :friend,
		       :conditions => "status = 'requested'",
		       :order => :created_at

	  has_many :pending_friends,
		       :through => :friendships,
		       :source => :friend,
		       :conditions => "status = 'pending'",
		       :order => :created_at

	acts_as_messageable	

	validates :account_id, presence: true

	default_scope order: 'profiles.s1 ASC'

	def name
		s1
	end

	def mailboxer_email(object)
		#Check if an email should be sent for that object
		#if true
		if false 
			return "define_email@on_your.model"
		#if false
		else
			return nil
		#return nil
		end
	end

end
