require File.dirname(__FILE__) + "/../spec_helper"

describe 'create PhotoBook' do
  before do
    @source_path  = "/Users/mskim/Dropbox/photo_book/mskim"
    @source_path  = "/Users/mskim/Dropbox/photo_book/Burack_Obama"
    @pb           = PhotoBook.new(@source_path)
  end
  
  it 'should create PhotoBook' do
    assert @pb.class == PhotoBook
  end
end