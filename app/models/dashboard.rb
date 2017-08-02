class Dashboard < ApplicationRecord
	validates :name, presence: true, length: {maximum: 30}
	validates :description, presence: true, length: {maximum: 140}
	validates :user_id, presence: true

	has_many :reviews
	belongs_to :user
	before_create :random_color

	private
		def random_color
			if self.color.nil?
				srand
				self.color = "rgb(#{192 + rand(64)},#{192 + rand(64)},#{192 + rand(64)})"
			end
		end

end
