require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'should save yaml' do
  before do
    @project_path = "#{ENV["HOME"]}/test_data/circle"
    @pdf_path = @project_path + "/output.pdf"
    @c = Circle.new(:project_path=> @project_path,  fill_color:'red', stroke_color:'black', stroke_width: 1)
  end

  it 'should create Circle object' do
    assert_equal Circle, @c.class 
    assert_equal @project_path, @c.project_path 
  end

  it 'should create Graphic object' do
    assert_equal 'red', @c.fill.color 
  end

  it 'should save yaml' do
    @c.save_pdf(@pdf_path)
    assert File.exist? @pdf_path
    system "open #{@pdf_path}"
  end
end