require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'should process image_caption' do
  before do
    @image_path = "/Users/mskim/test_data/images/1.jpg"
    @image = Image.new(:image_path=> @image_path)
    @pdf_path = "/Users/mskim/test_data/image/output.pdf"

  end

  it 'should create Image object' do
    assert_equal Image, @image.class 
  end

  it 'should save pdf image' do
    @image.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end

__END__
describe 'image_drawing test' do
  before do
    @image_path = "/Users/Shared/rlayout/image/1.jpg"
    @image = Image.new(:image_path=> @image_path)
    @path = "/Users/Shared/rlayout/output/image_drawing_test.svg"
  end

  it 'should create Image object' do
    @image.must_be_kind_of Image
  end

  it 'shuld have attribute of image_path' do
    @image.image_path.must_equal @image_path
  end

  it 'should draw image' do
    @image.save_svg(@path)
  end

end

describe 'should update image as frame changes' do
  before do
    @image_path = "/Users/Shared/rlayout/image/1.jpg"
    @image = Image.new(:image_path=> @image_path, width: 300)
    @path = "/Users/Shared/rlayout/output/image_fitting_test.svg"
  end
  it 'should wet image_path' do
    @image.image_record.image_path.must_equal @image_path
  end

  it 'should set frame' do
    @image.width.must_equal 300
    @image.height.must_equal 100
  end

  it 'should update frame change ' do
    @path = "/Users/Shared/rlayout/output/image_set_frame_test.svg"
    @image.set_frame([0,0,50,200])
    @image.width.must_equal 50
    @image.height.must_equal 200
    @image.save_svg(@path)
  end


end
