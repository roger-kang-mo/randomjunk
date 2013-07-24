class CommentsController < ApplicationController


	def index

	end

	def create
		@new_comment = Comment.create(params[:comment])
		@new_comment.save

		respond_to do |format|
			format.json { render :json => @new_comment }
		end
	end

	def update
		@to_update = Comment.find(params[:id])
		@to_update.update_attributes(params[:thought])
		@to_update.save

		respond_to do |format|
			format.json { render :json => @to_update }
		end
	end

	def destroy
		to_delete = Comment.find(params[:id])

		@status = to_delete.delete()

		respond_to do |format|
			format.json { render :json => @status }
		end
	end

	def get_comments_for
		@comments = Comment.where(:thought_id => params[:id])

		respond_to do |format|
			format.json { render :json => { comments: @comments } }
		end
	end

end