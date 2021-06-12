require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"



describe 'testing GroupImage creation' do
  before do
    # @container = Container.new(:width=>600, :height=>800, :layout_space=>20, :layout_direction=>"horizontal") do
    # @image_items = %w[1.jpg 2.jpg]
    @pdf_path = "/Users/mskim/test_data/yearbook/sample_class/B/output.pdf"
    @images_folder = "/Users/mskim/test_data/yearbook/sample_class/B/output.pdf"
    @images_folder = "/Users/mskim/test_data/yearbook/sample_class/B"
    @image_items = Dir.glob("#{@images_folder}/*.jpg").map{|f| File.basename(f)}
    @image_item_captions = @image_items.map{|f| File.basename(f, ".jpg").unicode_normalize}
    @g = GroupImage.new(:width=>400, :height=>400,  images_folder: @images_folder, :image_items=>@image_items, image_item_captions: @image_item_captions, output_path: @pdf_path)

  end

  it 'should save pdf GroupImage' do
    @g.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path) == true
    system "open #{@pdf_path}"
  end
end

__END__
describe 'testing GroupImage creation' do
  before do
    # @container = Container.new(:width=>600, :height=>800, :layout_space=>20, :layout_direction=>"horizontal") do
    @image_items = %w[1.jpg 2.jpg 3.jpg 4.jpg]
    # @image_items = %w[1.jpg 2.jpg]
    @output_path = "/Users/mskim/test_data/group_image/output.pdf"
    @images_folder = "/Users/mskim/test_data/images"
    @g = GroupImage.new(:width=>400, :height=>400,  images_folder: @images_folder, :image_items=>@image_items, output_path: @ouput_path)
    @svg_path = "/Users/mskim/test_data/group_image/output.svg"
    @pdf_path = "/Users/mskim/test_data/group_image/output.pdf"
  end

  # it 'should create GroupImage' do
  #   assert_equal GroupImage, @g.class
  #   assert_equal 400, @g.width
  #   assert_equal 400, @g.height
  # end

  # it 'should create member images' do
  #   assert_equal 4, @g.graphics.length
  # end

  # it 'width of member images ' do
  #   # assert 200 > @g.graphics.first.width
  #   assert_equal 0, @g.graphics.first.x
  #   assert_equal 0, @g.graphics.first.y
  # end

  it 'should save pdf GroupImage' do
    @g.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path) == true
    system "open #{@pdf_path}"
  end
end

