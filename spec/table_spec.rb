require File.dirname(__FILE__) + "/spec_helper"

describe 'table style' do
  before do
    @csv_path = "/Users/mskim/flier/category_demo.csv"
    @table_style_path = "/Users/mskim/flier/table_style.rb"
    @csv_data = File.open(@csv_path, 'r'){|f| f.read}
    @tbl      = Table.new(nil, width: 595.28, height: 841.89, category_level: 1, csv_data: @csv_data, has_head_row: true, table_style_path: @table_style_path )
  end
  
  it 'should have table with csv_data' do
    assert @tbl.has_head_row? == true
  end
  
  it 'should have cell with stroke_sides' do
    body_row = @tbl.graphics[1]
    puts body_row.fill.color
    body_row_last_cell = body_row.graphics.last
    assert body_row_last_cell.stroke.sides == [1,0,0,0]
  end
      
end

__END__
csv = <<EOF

company, name, title, phone, email
SoftwareLab, Min, CEO, 010-234-5588, mskim@gmail.com
SoftwareLab, Yong, VP Sales, 010-234-5588, mskim@gmail.com
SoftwareLab, Tae, VP Marketing, 010-234-5588, mskim@gmail.com
SoftwareLab, Tae, VP Marketing, 010-234-5588, mskim@gmail.com
Apple, Tae1, VP Marketing, 010-234-5588, mskim@gmail.com
Apple, Tae2, VP Marketing, 010-234-5588, mskim@gmail.com
Apple, Tae3, VP Marketing, 010-234-5588, mskim@gmail.com

EOF

describe 'table style' do
  before do
    @table_style_path = "/Users/mskim/flier/table_style.rb"
    @tbl      = Table.new(nil, csv_data: csv, table_style_path: @table_style_path, category_level: 1 )
  end
  
  it 'should have cell with stroke_sides' do
    assert @tbl.graphics.length == 8
  end

  it 'should have floating category cells' do
    assert @tbl.floats.length == 2
  end
  
  it 'should have floating category cells with vertically stacked' do
    assert @tbl.floats[0].y <  @tbl.floats[1].y
  end
  
  it 'should have floating category cells with category text' do
    assert @tbl.floats[0].y <  @tbl.floats[1].y
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
	