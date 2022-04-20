require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

SAMPLE_CSV_DATA = <<EOF
company, name, title, phone, email
SoftwareLab, Min, CEO, 010-234-5588, mskim@gmail.com
SoftwareLab, Yong, VP Sales, 010-234-5588, mskim@gmail.com
SoftwareLab, Tae, VP Marketing, 010-234-5588, mskim@gmail.com
SoftwareLab, Tae, VP Marketing, 010-234-5588, mskim@gmail.com
Apple, Tae1, VP Marketing, 010-234-5588, mskim@gmail.com
Apple, Tae2, VP Marketing, 010-234-5588, mskim@gmail.com
Apple, Tae3, VP Marketing, 010-234-5588, mskim@gmail.com

EOF

describe 'create ParaTable' do
  before do
    @row_data           = %w[찬송가 450장 다같이]
    @output_path           = "/Users/mskim/demo/demo_rjob/jubo/leader_row_demo.pdf"
    @tr1                = ParaTable.new(csv_data: SAMPLE_CSV_DATA)
  end

  it 'should create TableRow ' do
    assert_equal ParaTable, @tr1.class
  end

  # it 'should generate pdf ' do
  #   @tr1.save_pdf(@pdf_path)
  #   assert File.exist?(@pdf_path)
  #   system "open #{@pdf_path}"  
  # end
end
