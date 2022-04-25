require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create ImagePlus' do
  before do
    # data_path    = "#{ENV["HOME"]}/test_data/demo_table/story.md"
    h = {}
    h[:widht]         = 100
    h[:height]        = 100
    # h[:local_image]   = '1.jpg'
    # h[:project_path]  = "#{ENV["HOME"]}/test_data/box_ad"
    h[:image_path] = "#{ENV["HOME"]}/test_data/images/1.jpg"
    h[:caption]       = "Old Korean Houes"
    @image_p          = RLayout::ImagePlus.new(h)
    @pdf_path   = "#{ENV["HOME"]}/test_data/box_ad/image_plus.pdf"
  end

  it 'should create ImagePlus' do
    assert_equal RLayout::ImagePlus, @image_p.class 
  end  
  
  it 'should save ImagePlus' do
    @image_p.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end