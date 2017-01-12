require 'minitest/autorun'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../..', 'lib')
require 'rlayout/graphic'
include RLayout

describe 'should process image_caption' do
  before do
    @image_path = "/Users/Shared/rlayout/image/1.jpg"
    @image = Image.new(:image_path=> @image_path)
  end

  it 'should create Image object' do
    @image.must_be_kind_of Image
  end

  it 'should have image_caption' do
    assert @image.image_caption
  end

  it 'should set caption' do
    image = Image.new(:image_path=> @image_path, :image_caption=> "This is a image caption")
    image.image_caption.must_equal "This is a image caption"
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
