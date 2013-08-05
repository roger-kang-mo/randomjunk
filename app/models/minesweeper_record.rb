class MinesweeperRecord < ActiveRecord::Base

	attr_accessible :time

	attr_default :time, 0

	def initialize
		super
	end
end