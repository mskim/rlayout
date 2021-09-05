require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create FrontWing' do
  before do
    @project_path  = "/Users/mskim/test_data/book_cover/front_wing"
    @pdf_path = "/Users/mskim/test_data/book_cover/front_wing/output.pdf"
    @back_bing = FrontWing.new(project_path: @project_path)
  end

  it 'should create FrontWing' do
    assert_equal RLayout::FrontWing, @back_bing.class 
  end

  it 'should create FrontWing' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
