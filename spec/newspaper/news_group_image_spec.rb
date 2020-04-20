require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

# testing
describe 'test NewsGroupImage' do
  before do
    @folder = "/Users/mskim/Development/pillar_layout/public/1/images"
    image1 = @folder + "/1.jpg"
    image2 = @folder + "/2.jpg"
    image3 = @folder + "/3.jpg"
    images = ["#{image1}", "#{image2}", "#{image3}"]
    @width = 600
    @height = 50
    @g_image = RLayout::NewsGroupImage.new(member_images: images, width: @width, height: @height)
    @first_member = @g_image.graphics.first
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
    @pdf_path = @folder + "/group_image.pdf"
    @g_image.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
  end

end
