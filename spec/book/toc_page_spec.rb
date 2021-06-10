require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create TocPage' do
  before do
    @document_path  = "/Users/mskim/test_data/toc"
    @pdf_path       = "/Users/mskim/test_data/toc/toc.pdf"
    @toc_content = [
      ['여기는 제목 1',  '4'],
      ['여기는 제목 2',  '12'],
      ['여기는 제목 3',  '30'],
      ['여기는 제목 4',  '40'],
      ['여기는 제목 5',  '55'],
      ['여기는 제목 7',  '65'],
      ['여기는 제목 8',  '79'],
      ['여기는 제목 9',  '84'],
      ['여기는 제목 10',  '102'],
    ]
    @toc_page       = TocPage.new(document_path: @document_path, toc_data: @toc_content )
  end

  it 'should create Toc' do
    assert_equal RLayout::TocPage, @toc_page.class 
  end

  it 'should create Toc' do
    assert File.exist?(@pdf_path)
  end
end