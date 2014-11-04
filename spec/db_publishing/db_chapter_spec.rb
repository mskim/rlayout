require File.dirname(__FILE__) + "/../spec_helper"

describe 'create db_chapter' do
  before do
    @db_ch    = DBChapter.new(title: 'my first db publishing sample')
    @pdf_path = File.dirname(__FILE__) + "/../output/db_chapter_sample.pdf"
  end
  
  it 'should create DBChapter' do
    @db_ch.must_be_kind_of DBChapter
    @db_ch.pages.length.must_equal 2
  end
  
  it 'should save pdf' do
    @db_ch.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
  end
end 