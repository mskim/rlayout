require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "create LineFragment" do
  before do
    options = {x: 0, y: 0, width: 300, height: 16}
    @line = RLineFragment.new(options)
  end

  it 'should create line' do
    @line.must_be_kind_of RLineFragment
  end

end
