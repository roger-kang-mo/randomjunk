class Comment < ActiveRecord::Base

	attr_accessible :author,
					:content,
					:created_at,
					:passcode,
					:thought_id

	belongs_to :thought

end