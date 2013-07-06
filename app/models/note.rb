class Note < ActiveRecord::Base
	attr_accessible :content,
				:author,
				:created_at,
				:x,
				:y,
				:size,
				:z

	attr_default :x, 0
	attr_default :y, 0

	validates :content,	presence: true, length: { maximum: 200 }
	validates :author, presence: true, length: { maximum: 20 }
end