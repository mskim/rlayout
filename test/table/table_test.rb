require File.dirname((File.expand_path __FILE__)) + "/../test_helper"


describe 'create table' do
  before do
    @table = RLayout::Table.new()
  end
  it 'should create Table Ovject' do
     assert @table.class ==  Table
   end
end