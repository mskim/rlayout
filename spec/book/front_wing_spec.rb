require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create FrontWing' do
  before do
    @project_path  = "#{ENV["HOME"]}/test_data/book_cover/front_wing"
    @pdf_path = "#{ENV["HOME"]}/test_data/book_cover/front_wing/output.pdf"
    @wing = FrontWing.new(document_path: @project_path)
    FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
  end

  it 'should create FrontWing' do
    assert_equal RLayout::FrontWing, @wing.class 
  end

  it 'should create FrontWing' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
