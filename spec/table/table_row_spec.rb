require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create TableRow' do
  before do
    # @row_data         = %w[company name div title phone cell email]
    @row_data         = %w[Softlab 전세영 기획부 부사장 02-578-3402 010-258-5633 sychun@dong-a_furniture.com]
    @pdf_path         = "/Users/mskim/demo/demo_rjob/table/page_with_table/table_row_demo.pdf"
    @csv_path         = "/Users/mskim/demo/demo_rjob/table/page_with_table/category_demo.csv"
    @table_style_path = "/Users/mskim/demo/demo_rjob/table/page_with_table/table_style.rb"
    @column_width_array     = [1,1,1,1,2,2,4]
    @tr1              = TableRow.new(width:500, height:700, row_data: @row_data, column_width_array:@column_width_array, table_style_path: @table_style_path)
  end

  it 'should create TableRow ' do
    assert TableRow, @tr1.class
  end

  it 'should create TableRow ' do
    @tr1.save_pdf_with_ruby(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"  
  end
end
