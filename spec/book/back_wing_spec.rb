require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create BackWing' do
  before do
    @document_path  = "#{ENV["HOME"]}/test_data/book_cover/back_wing"
    @pdf_path = "#{ENV["HOME"]}/test_data/book_cover/back_wing/output.pdf"
    @back_bing = BackWing.new(document_path: @document_path)
  end

  it 'should create BackWing' do
    assert_equal RLayout::BackWing, @back_bing.class 
  end

  it 'should create BackWing' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
