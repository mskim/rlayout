require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create LeaderRow' do
  before do
    @row_data           = %w[찬송가 450장 다같이]
    @pdf_path           = "/Users/mskim/demo/demo_rjob/jubo/leader_row_demo.pdf"
    @tr1                = LeaderRow.new(width:500, height:700, row_data: @row_data, column_width_array:@column_width_array, table_style_path: @table_style_path)
  end

  it 'should create LeaderRow ' do
    assert LeaderRow, @tr1.class
  end

  it 'should generate pdf ' do
    @tr1.save_pdf_with_ruby(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"  
  end
end
