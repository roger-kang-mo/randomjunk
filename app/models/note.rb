class Note < ActiveRecord::Base
	attr_reader :content,
				:author,
				:created_at


	validates :content,	presense: true, length: { maximum: 200 }
	
end