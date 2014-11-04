require File.dirname(__FILE__) + "/../spec_helper"

describe 'create db_chapter' do
  before do
    @db_ch    = ObjectChapter.new(title: 'my first db publishing sample')
    @pdf_path = File.dirname(__FILE__) + "/../output/db_chapter_sample.pdf"
  end
  
  it 'should create ObjectChapter' do
    @db_ch.must_be_kind_of ObjectChapter
    @db_ch.pages.length.must_equal 10
  end
  
  it 'should save pdf' do
    @db_ch.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
  end
  
  it 'should save yml' do
    @yml_path = File.dirname(__FILE__) + "/../output/db_chapter_sample.yml"
    @db_ch.save_yml(@yml_path)
    File.exists?(@yml_path).must_equal true
  end
end 