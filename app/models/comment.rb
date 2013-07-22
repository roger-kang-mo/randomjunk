class Comment < ActiveRecord::Base

	attr_accessible :author,
					:content,
					:created_at,
					:passcode

	belongs_to :thought

end