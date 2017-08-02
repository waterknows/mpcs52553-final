class User < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
	has_secure_password

	has_many :dashboards
	has_many :reviews

end
