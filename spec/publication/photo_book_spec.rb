require File.dirname(__FILE__) + "/../spec_helper"

describe 'create PhotoBook' do
  before do
    @path = "/Users/mskim/Dropbox/photo_book/mskim"
    @pb   = PhotoBook.new(@path)
  end
  
  it 'should create PhotoBook' do
    assert @pb.class == PhotoBook
  end
end