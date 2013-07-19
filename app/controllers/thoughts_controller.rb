class ThoughtsController < ApplicationController


def index

	@thoughts = Thought.all

	respond_to do |format|
		format.html
	end
end

def show
	@thought = Thought.find(params[:id])

	respond_to do |format|
		format.json { render :json =>  { thought: @thought }}
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

def destroy
	to_delete = Thought.find(params[:id])

	@status = to_delete.delete()

	respond_to do |format|
		format.json { render :json => { status: @status }}
	end
end	

end