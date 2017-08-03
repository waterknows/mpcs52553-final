class Review < ApplicationRecord
	validates :name, presence: true, length: {maximum: 30}
	validates :description, presence: true, length: {maximum: 500}
	validates :user_id, presence: true

	belongs_to :user

end
