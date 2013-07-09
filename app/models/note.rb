class Note < ActiveRecord::Base
	attr_accessible :content,
				:author,
				:created_at,
				:x,
				:y,
				:size,
				:z

	attr_default :x, 20
	attr_default :y, 71
	attr_default :z, 500

	validates :content,	presence: true
	validates :author, presence: true, length: { maximum: 20 }
end