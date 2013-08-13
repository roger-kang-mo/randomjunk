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
		let!(:unapproved_thought) { Thought.create({ content: 'temp', approved: false}) }


		it 'should assign approved and unapproved thoughts to @thoughts' do
			
			get :get_all

			expect(assigns(:thoughts)).to eq([approved_thought, unapproved_thought])
		end

	end
end