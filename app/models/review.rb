class Review < ApplicationRecord
	belongs_to :user

	validates :name, presence: true, length: {maximum: 1000}
	validates :description, presence: true, length: {maximum: 10000}
	validates :user_id, presence: true

	#Attribution: http://www.rymcmahon.com/articles/2
	def self.search(search)
  		where("name LIKE ? OR description LIKE ?", "%#{search}%", "%#{search}%") 
	end

end
