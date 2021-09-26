require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'should creadte Rectangle' do
  before do
    @project_path = "/Users/mskim/test_data/rectangle"
    @pdf_path = @project_path + "/output.pdf"
    @c = Rectangle.new(:project_path=> @project_path)
  end

  it 'should create Graphic object' do
    assert_equal Rectangle, @c.class 
    assert_equal @project_path, @c.project_path 
  end

  it 'should save yaml' do
    @c.save_pdf_with_ruby(@pdf_path)
    assert File.exist? @pdf_path
    system "open #{@pdf_path}"
  end
end