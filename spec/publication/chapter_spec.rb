require File.dirname(__FILE__) + "/../spec_helper"
require File.dirname(__FILE__) + '/../../lib/rlayout/publication/chapter'

describe 'create Chapter' do
  before do
    @m = Chapter.new(:title =>"Chapter Title", :starts_left=>false)
  end
  it 'should create Chapter' do
    @m.must_be_kind_of Chapter
  end
  
  it 'should create pages' do
    @m.pages.length.must_equal 2
  end
  
  it 'should save' do
    @pdf_path = File.dirname(__FILE__) + "/../output/chapter_test.pdf"
    @m.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
  end
end
