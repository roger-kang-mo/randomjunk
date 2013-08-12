class MinesweeperRecordsController < ApplicationController


	def index
		
	end

	def create
		@new_record = MinesweeperRecord.create(params[:minesweeper_record])
		@new_record.save

		respond_to do |format|
			format.json { render :json => @new_record }
		end
	end

	def update
		@to_update = MinesweeperRecord.find(params[:id])
		@to_update.update_attributes(params[:record])

		@to_update.save

		respond_to do |format|
			format.json { render :json => @to_update }
		end
	end

	def delete
		id_to_delete = params[:id]

		@status = MinesweeperRecord.find(id_to_delete).delete

		respond_to do |format|
			format.json { render :json => @status}
		end
	end

	def query_records
		start_index = params[:data][:start] or 0
		limit = params[:data][:limit] or 10
		high_low = params[:data][:high_low] or 'high'
		high_low = high_low == 'high' ? 'id asc' : 'id desc'

		# MinesweeperRecord.find(:all, :order => high_low, :limit => limit)
		@records = MinesweeperRecord.find(:all, :order => high_low)
		# MinesweeperRecord.select("records.*").having("")

		respond_to do |format|
			format.json { render :json => @records}
		end

	end
end
