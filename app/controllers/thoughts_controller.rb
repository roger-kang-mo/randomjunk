class ThoughtsController < ApplicationController


	def index

		@thoughts = Thought.where(:approved => true)

		respond_to do |format|
			format.html
		end
	end

	def show
		@thought = Thought.find(params[:id])

		respond_to do |format|
			format.json { render :json =>  @thought }
		end
	end



	def get_all
		@thoughts = Thought.all

		respond_to do |format|
			format.json { render :json => { thoughts: [@thoughts].to_json }}
		end
	end

	def create
		@new_thought = Thought.create(params[:thought])
		# @new_thought.save

		respond_to do |format|
			format.json { render :json => { status: @new_thought.save }}
		end
	end

	def update
		@to_update = Thought.find(params[:id])
		@to_update.update_attributes(params[:thought])

		respond_to do |format|
			format.json { render :json => { status: @to_update.save }}
		end
	end

	def destroy
		to_delete = Thought.find(params[:id])
		comments_to_delete = Comment.where(:thought_id => params[:id])

		comments_to_delete.each do |comment|
			comment.delete()
		end

		@status = to_delete.delete()

		respond_to do |format|
			format.json { render :json => { status: @status }}
		end
	end	

	def secret_page

		@unapproved_thoughts = Thought.where(:approved => false)
		@current_thoughts = Thought.where(:approved => true)

		respond_to do |format|
			format.html
		end
	end

	def approve_thought
		to_approve = Thought.find(params[:id])
		to_approve.update_attribute(:approved, true)

		respond_to do |format|
			format.json { render :json => { status: to_approve.save() }}
		end
	end

end