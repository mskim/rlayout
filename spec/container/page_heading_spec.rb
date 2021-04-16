require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe ' test page_heading' do
  before do
    @layout_path = "/Users/mskim/Development/pillar_layout/public/1/issue/2021-01-29/9/heading/layout.rb"
    @pdf_path = "/Users/mskim/Development/pillar_layout/public/1/issue/2021-01-29/9/heading/output.pdf"
    @layout_rb = File.open(@layout_path){|f| f.read}
    @oage_heading = eval(@layout_rb)
  end

  it 'should create Container' do
    assert_equal Container, @oage_heading.class
  end

  it 'should save pdf' do
    @oage_heading.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end