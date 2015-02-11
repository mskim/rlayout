require File.dirname(__FILE__) + "/../spec_helper"

describe 'PhotoSpread' do
  before do
    @left = "/Users/mskim/Development/photo_layout/photos/1881.jpg"
    @right = "/Users/mskim/Development/photo_layout/photos/1916.jpg"
    options = {
      width: 1500,
      height: 600,
      left: @left, 
      right: @right,
    }    
    @ps = PhotoSpread.new(nil, options)
    @pdf_path = "/Users/mskim/Development/photo_layout/photos/spread.pdf"
  end
  
  it 'should save PhotoSpread' do
    @ps.save_pdf(@pdf_path)
  end
end

__END__
describe 'create PhotoSpread' do
  before do
    @path = "/Users/mskim/Development/photo_layout/photos"
    @photo_book = PhotoBook.new(path: @path)
  end
  
  # it 'should create PhotoBook' do
  #   @photo_book.must_be_kind_of PhotoBook
  # end
  # 
  # it 'should layout layout spreads' do
  #   @photo_book.pages.must_be_kind_of Array
  # end
  # 
  # it 'should create spreads' do
  #   @photo_book.pages.first.must_be_kind_of PhotoSpread
  # end
  
  it 'should save document' do
    @pdf_path = "/Users/mskim/Development/photo_layout/photos/photobook.pdf"
    File.exists?(@pdf_path).must_equal true
    # system("open #{@pdf_path}")
  end
end

