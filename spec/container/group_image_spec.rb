require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'testing GroupImage creation' do
  before do
    # @container = Container.new(:width=>600, :height=>800, :layout_space=>20, :layout_direction=>"horizontal") do
    @image_items = %w[1.jpg 2.jpg 3.jpg 4.jpg]
    @output_path = "/Users/mskim/test_data/group_image/output.pdf"
    @images_path = "/Users/mskim/test_data/images"
    @g = GroupImage.new(:width=>800, :height=>200, images_path: @images_path, :image_items=>@image_items, output_path: @ouput_path)
    @svg_path = "/Users/mskim/test_data/group_image/output.svg"
    @pdf_path = "/Users/mskim/test_data/group_image/output.pdf"
  end

  it 'should create GroupImage' do
    assert_equal GroupImage, @g.class 
  end

  it 'should create member images' do
    assert_equal 4, @g.graphics.length
  end

  it 'width of member images ' do
    assert_equal 200, @g.graphics.first.width
  end

  it 'should save pdf GroupImage' do
    @g.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path) == true
    system "open #{@pdf_path}"
  end
end

