require 'rspec'
require 'spec_helper'
# require 'thoughts_controller'

describe ThoughtsController do

	describe 'get index' do
		subject { get :index }

		it 'should assigns @thoughts' do
			thought = Thought.create({ content: 'temp', approved: true})
			get :index
			expect(assigns(:thoughts)).to eq([thought])
		end

		it 'should render the index view' do
			get :index
			expect(response).to render_template('index')
		end

		it 'should not assign @thoughts with an unapproved thought' do
			thought = Thought.create({ content: 'temp', approved: false})
			get :index
			expect(assigns(:thoughts)).to eq([])
		end
	end

	describe 'get get_all' do
		subject { get :get_all }

		let!(:approved_thought) { Thought.create({ content: 'temp', approved: true}) }
		let!(:unapproved_thought) { Thought.create({ content: 'poppycock', approved: false}) }


		it 'should assign approved and unapproved thoughts to @thoughts' do

			get :get_all

			expect(assigns(:thoughts)).to eq([approved_thought, unapproved_thought])
		end

		it 'should respond with a json including both thoughts' do

			get :get_all, :format => :json

			expect(response).to be_success

			response_data = JSON.parse(JSON.parse(response.body)['thoughts'])[0]

			expect(response_data.length).to eq(2)
			
			expect(response_data[0].to_json).to eq(approved_thought.to_json)
			expect(response_data[1].to_json).to eq(unapproved_thought.to_json)
		end
	end

	describe 'post destroy' do

		subject { post :destroy }

		let!(:thought_to_delete) { Thought.create({ content: 'temp' }) }
		let(:to_delete_id) { thought_to_delete.id }

		it 'should delete a thought in activerecord' do
			
			expect(Thought.find(to_delete_id)).not_to be_nil

			post :destroy, :format => :json, :id => to_delete_id

			expect{ Thought.find(to_delete_id) }.to raise_error
		end

	end

	describe 'post approve_thought' do
		let!(:thought_to_approve) { Thought.create({ content: 'temp', approved: false }) }
		let(:to_approve_id) { thought_to_approve.id }

		it 'should set the approved flag to true' do
			expect(Thought.find(thought_to_approve).approved).to eq(false)
			post :approve_thought, :format => :json, :id => to_approve_id
			expect(Thought.find(thought_to_approve).approved).to eq(true)
		end
	end
end
