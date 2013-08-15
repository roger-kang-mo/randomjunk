require 'rspec'
require 'spec_helper'


describe MinesweeperRecord do
	context 'initialized' do
		subject { MinesweeperRecord.new }

		it { should_not be_nil }

		specify { expect(subject.time).to be_nil }
	end
end