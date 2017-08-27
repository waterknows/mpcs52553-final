class Document < ApplicationRecord
	belongs_to :user
	has_many :tags
	accepts_nested_attributes_for :tags, allow_destroy: true


	validates :name, presence: true, length: {maximum: 1000}
	validates :description, presence: true, length: {maximum: 10000}
	validates :user_id, presence: true

	#Attribution: http://www.rymcmahon.com/articles/2
	def self.search(search)
	end

end
