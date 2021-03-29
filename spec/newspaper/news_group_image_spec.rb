require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

# testing
describe 'test NewsGroupImage' do
  before do
    @image_items = %w[1.jpg 2.jpg 3.jpg 4.jpg]
    @output_path = "/Users/mskim/test_data/group_image/output.pdf"
    @images_folder = "/Users/mskim/test_data/images"
    @g_image = NewsGroupImage.new(:width=>800, :height=>200, images_folder: @images_folder, :image_items=>@image_items, output_path: @ouput_path)
    @svg_path = "/Users/mskim/test_data/group_image/output.svg"
    @pdf_path = "/Users/mskim/test_data/group_image/output.pdf"
  end

  it 'should create NewsGroupImage' do
    assert @g_image.class , NewsGroupImage
    assert @g_image.height , @height
    assert @g_image.width , @width
  end

  # it 'should create MemberImages' do
  #   assert @first_member.class , Image
  # end

  # it 'should create 3 MemberImages' do
  #   assert @g_image.graphics.length , 3
  # end

  it 'should save pdf' do
    @g_image.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end

end
