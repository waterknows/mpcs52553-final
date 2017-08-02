class Review < ApplicationRecord
	belongs_to :dashboard, touch: true
	belongs_to :user
end
