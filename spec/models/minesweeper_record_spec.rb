require 'spec_helper'


describe MinesweeperRecord do
	context 'initialized' do
		subject { MinesweeperRecord.new }

		it { should_not be_nil }

		specify { subject.time.should == 0 }
	end
end