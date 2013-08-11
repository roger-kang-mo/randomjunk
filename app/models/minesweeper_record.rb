class MinesweeperRecord < ActiveRecord::Base

	attr_accessible :time, :name, :width, :height, :mines

end