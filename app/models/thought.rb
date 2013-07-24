class Thought < ActiveRecord::Base
	attr_accessible :content,
					:created_at,
					:comments,
					:thumbs,
					:approved



	attr_default :thumbs, 0

	has_many :comments

	validates :content, presence: true

end