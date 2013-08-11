class StuffsController < ApplicationController

	def index
		respond_to do |format|
			format.html
		end
	end

	def minesweeper
		@minesweeper_records = MinesweeperRecord.find(:all, :order => 'id desc', :limit => 10)

		respond_to do |format|
			format.html
		end
	end

	def create_minesweeper_board
		@board = []
		respond_to do |format|
			format.js 
		end
	end

	def scattergories
		respond_to do |format|
			format.html
		end
	end

	def whatis
		respond_to do |format|
			format.html
		end
	end


end