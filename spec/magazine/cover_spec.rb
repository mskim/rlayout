require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create Cover' do
  before do
    @document_path  = "#{ENV["HOME"]}/test_data/toc"
    @pdf_path       = "#{ENV["HOME"]}/test_data/toc/toc.pdf"
    @toc            = Cover.new(document_path: @document_path )
    @document       = @toc.document
  end

  it 'should create Cover' do
    assert_equal RLayout::Cover, @toc.class 
  end

  it 'should create Cover' do
    assert File.exist?(@pdf_path)
  end

  it 'should have document' do
    assert_equal RDocument, @document.class
  end

  it 'document should have one TocPage' do
    first_page = @document.pages.first
    assert_equal TocPage, first_page.class
    assert_equal 50, first_page.left_margin
    assert_equal 50, first_page.top_margin
    assert_equal 50, first_page.right_margin
    assert_equal 50, first_page.bottom_margin
  end  

  it 'document should have one RLeaderTable' do
    first_page = @document.pages.first
    table = first_page.toc_table
    assert_equal RLeaderTable, table.class
    assert_equal 50, table.x
  end  

  it 'document should have one RHeading' do
    first_page = @document.pages.first
    heading = first_page.heading
    assert_equal RHeading, heading.class
  end  
end