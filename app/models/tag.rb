class Tag < ApplicationRecord
	belongs_to :document
	validates :topic, presence: true, length: {maximum: 100}

end