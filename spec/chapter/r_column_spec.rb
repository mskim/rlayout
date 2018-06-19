require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create RColumn' do
  before do
    @col = RColumn.new()
  end

  it 'should create RColumn' do
    @col.must_be_kind_of RColumn
  end

  it 'should create RLineFragment' do
    @col.graphics.first.must_be_kind_of RLineFragment
  end

  it 'should create RLineFragment' do
    @col.graphics.length.must_equal 33
  end

  it 'lines should have links' do

    @col.graphics.first.next_text_line.must_be_kind_of RLineFragment
  end
end
