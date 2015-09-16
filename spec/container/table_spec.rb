require File.dirname(__FILE__) + "/../spec_helper"

describe 'table with csv' do
  before do
    @csv_path = "/Users/mskim/idcard/CardDemo.csv"
    @csv_data = File.open(@csv_path, 'r'){|f| f.read}
    @tbl      = Table.new(nil, csv: @csv_data, head_row: true)
  end
  
  it 'should create table with csv_data' do
    assert @tbl.class == RLayout::Table
  end
  
  it 'should have table with csv_data' do
    assert @tbl.head_row == true
  end
  
end

describe 'table' do
   before do
    @tbl = Table.new(nil) do
      th do
        td "heading cell 1", align: "right"
        td "heading cell 2"
        td "this is third column"
      end
      tr  do
        td "row1 is body cell", align: "left"
        td "row1 is second column"
        td "row1 is third column"
      end
      tr  do
        td "row2 cell 1", align: "left"
        td "row2 cell 2"
        td "row2 cell 3"
      end
    end
    
  end
  
  it 'shuld create table' do
    assert @tbl.class == RLayout::Table
  end
  
  it 'shuld create two rows' do
    assert @tbl.graphics.length == 3
  end
  
end
	