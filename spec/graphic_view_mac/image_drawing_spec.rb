require File.dirname(__FILE__) + "/../spec_helper"

describe 'image_drawing test' do
  before do
    @image_path = File.dirname(__FILE__) + "/../image/1.jpg"
    @image = Image.new(nil, :image_path=> @image_path)
    @path = File.dirname(__FILE__) + "/../output/image_drawing_test.pdf"
  end
  
  it 'should create Image object' do
    @image.must_be_kind_of Image
  end
  
  it 'shuld have attribute of text_string' do
    @image.image_path.must_equal @image_path
  end
  
  it 'should draw text' do
    @image.save_pdf(@path)
  end
end