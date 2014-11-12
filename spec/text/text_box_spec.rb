require File.dirname(__FILE__) + "/../spec_helper"

describe 'TextBox creation' do
  before do
    @tb = TextBox.new(nil, column_count: 1)
    # @tb = TextBox.new(nil)
  end
  it 'should create TextBox' do
    @tb.must_be_kind_of TextBox
  end
end