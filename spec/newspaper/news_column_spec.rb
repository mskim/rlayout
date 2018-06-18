require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create NewsColumn' do
  before do
    @col = NewsColumn.new()
  end

  it 'should create NewsColumn' do
    @col.must_be_kind_of NewsColumn
  end

  it 'should create NewsLineFragment' do
    @col.graphics.first.must_be_kind_of NewsLineFragment
  end

  it 'should create NewsLineFragment' do
    @col.graphics.length.must_equal 33
  end

  it 'lines should have links' do
    @col.graphics.first.next_text_line.must_be_kind_of NewsLineFragment
  end
end
