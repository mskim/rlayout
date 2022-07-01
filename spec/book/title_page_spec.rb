require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create TitlePage' do
  before do
    @document_path  = "#{ENV["HOME"]}/test_data/title_page"
    @pdf_path = "#{ENV["HOME"]}/test_data/title_page/output.pdf"
    h = {}
    h[:title] = '녹색의 정원'
    h[:width] = 354.33075
    h[:height] = 532.913448
    h[:left_margin] = 56.69292
    h[:top_margin] = 39.68504
    h[:right_margin] = 56.69292
    h[:bottom_margin] = 70.86615
    @title_page = TitlePage.new(document_path: @document_path, **h)
  end

  it 'should create TitlePage' do
    assert_equal RLayout::TitlePage, @title_page.class 
  end

  it 'should create TitlePage' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
