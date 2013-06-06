# == Schema Information
#
# Table name: accounts
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  session_id      :string(255)
#  authorization   :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  enabled         :integer          default(1)
#  ty              :string(255)
#  password_digest :string(255)
#

class Account < ActiveRecord::Base
	attr_accessible :email, :password, :password_confirmation, :authorization, :ty
	
	has_secure_password
	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_accounts, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id",
		                         class_name:  "Relationship",
		                         dependent:   :destroy
	has_many :followers, through: :reverse_relationships, source: :follower
	has_one :profile, dependent: :destroy  	

	before_save { |account| account.email = email.downcase }
	before_save :create_remember_token

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 6 }
	validates :password_confirmation, presence: true
	validates :authorization, presence: true
	validates :ty, presence: true

	def feed
		# This is preliminary. See "Following users" for the full implementation.
		Micropost.where("account_id = ?", id)
	end

	def following?(other_account)
		relationships.find_by_followed_id(other_account.id)
	end

	def follow!(other_account)
		relationships.create!(followed_id: other_account.id)
	end

	def unfollow!(other_account)
		relationships.find_by_followed_id(other_account.id).destroy
	end

	private

	def create_remember_token
		self.remember_token = SecureRandom.urlsafe_base64
	end
end
