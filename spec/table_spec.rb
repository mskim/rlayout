require File.dirname(__FILE__) + "/../spec_helper"

describe 'table row' do
  before do
    @csv_path = "/Users/mskim/flier/demo.csv"
    @csv_data = File.open(@csv_path, 'r'){|f| f.read}
    @tbl      = Table.new(nil, csv_data: @csv_data, has_head_row: true)
    @row      = @tbl.graphics.first
    @body_row = @tbl.graphics[0]
    puts @body_row.row_type
  end
  
  it 'should create TableRow' do
    puts "@row.graphics.length:#{@row.graphics.length}"
    assert @row.class == RLayout::TableRow
  end
  
  it 'should have stroke_sides as [0,1,0,1]' do
    assert @row.stroke[:sides] == [0,1,0,1]
  end
  
  it 'should have head_row' do
    assert @row.row_type == 'head_row'
    puts "@body_row.row_type:#{@body_row.row_type}"
    assert @body_row.row_type == 'body_row'
  end
end

__END__

describe 'table with csv' do
  before do
    @csv_path = "/Users/mskim/idcard/CardDemo.csv"
    @csv_data = File.open(@csv_path, 'r'){|f| f.read}
    @tbl      = Table.new(nil, csv_data: @csv_data, head_row: true)
  end
  
  it 'should create table with csv_data' do
    assert @tbl.class == RLayout::Table
  end
  
  it 'should have table with csv_data' do
    assert @tbl.has_head_row? == true
  end
  
end



PDSCRIPT = <<-EOF
RLayout::Page.new(nil) do
  table(csv_path:  "/Users/mskim/flier/demo.csv")
end

EOF

describe 'table with pgscript' do
  before do
    @tbl      = eval(PDSCRIPT)
  end
  
  it 'should create table' do
    puts "@tbl.class:#{@tbl.class}"
    assert @tbl.class == RLayout::Page
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
	