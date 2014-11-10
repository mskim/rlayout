require File.dirname(__FILE__) + "/../spec_helper"

describe 'create db_chapter' do
  before do
    @source_path = "/Users/mskim/membership/pdf"
    @source_path = "/Users/mskim/MediaWill/pdf/79x113"
    @db_ch    = DBChapter.new(title: 'my first db publishing sample', source_path: @source_path)
    @pdf_path = File.dirname(__FILE__) + "/../output/db_chapter_sample.pdf"
  end
  
  it 'should create DBChapter' do
    @db_ch.must_be_kind_of DBChapter
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