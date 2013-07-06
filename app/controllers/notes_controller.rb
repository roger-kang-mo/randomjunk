class NotesController < ApplicationController

	def index
		@notes = Note.all

		respond_to do |format|
			format.html
		end
	end

	def create
		note_params = params[:note]
		@newNote = Note.create(:author => note_params['author'], :content => note_params['content'])

		result = @newNote.save

		respond_to do |format|
			format.json { render :json => { note: @newNote }}
		end
	end

	def destroy
		id = params[:id]

		note_to_delete = Note.find(id)
		note_to_delete.delete

		respond_to do |format|
			format.json { render :json => { :status => 'deleted' }}
		end
	end

	def update_positions
		notes = params[:notes].to_a
		is_success = true

		# begin
		notes.each do |note|
			current_note = Note.find(note[1]['id'].to_i)
			current_note.x = note[1]['coords']['x'].to_i
			current_note.y = note[1]['coords']['y'].to_i

			temp = current_note.save
			puts temp
		end
		# rescue
		# 	is_success = false
		# end

		respond_to do |format|
			format.json { render :json => { is_success: is_success}}
		end
	end
end