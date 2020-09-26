require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create db_chapter' do
  before do
  end
  
  it 'should create DBChapter' do
    @db_item.must_be_kind_of DbItem
    @db_ch.pages.length.must_equal 15
  end
end