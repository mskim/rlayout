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
  
  it 'shuld have attribute of image_path' do
    @image.image_path.must_equal @image_path
  end
  
  it 'should draw image' do
    @image.save_pdf(@path)
  end
  
end

describe 'should update image as frame changes' do
  before do
    @image_path = File.dirname(__FILE__) + "/../image/1.jpg"
    @image = Image.new(nil, :image_path=> @image_path, width: 300)
    @path = File.dirname(__FILE__) + "/../output/image_fitting_test.pdf"
  end
  it 'should fit frame' do
    @image.save_pdf(@path)
  end
  
  it 'should update frame change ' do
    @path = File.dirname(__FILE__) + "/../output/image_set_frame_test.pdf"
    @image.set_frame([0,0,50,200])
    puts @image.width
    puts @image.height
    @image.save_pdf(@path)
  end
    
  
end