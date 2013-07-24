class CommentsController < ApplicationController


	def index

	end

	def create
		@new_comment = Comment.create(params[:comment])
		# @new_thought.save

		respond_to do |format|
			format.json { render :json => { status: @new_comment.save }}
		end
	end

	def update

	end

	def destroy

	end

	def get_comments_for
		@comments = Comment.where(:thought_id => params[:id])

		respond_to do |format|
			format.json { render :json => { comments: @comments } }
		end
	end

end