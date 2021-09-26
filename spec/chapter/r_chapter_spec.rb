require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "create RChapter" do
  before do
    @document_path = "/Users/mskim/test_data/chapter_1"
    @pdf_path     = "/Users/mskim/test_data/chapter_1/chapter.pdf"
    @document_path = "/Users/mskim/test_data/chapter_1"
    @pdf_path     = "/Users/mskim/test_data/chapter_1/chapter.pdf"
    @chapter      = RLayout::RChapter.new(document_path: @document_path)
    @doc          = @chapter.document
  end

  it 'should create RChapter' do
    assert_equal RChapter, @chapter.class 
  end

  # it 'shoud have RDocument' do
  #   @doc.must_be_kind_of RDocument
  # end

  # it 'shoud create RDocument with page_size' do
  #   @doc.page_size.must_equal 'A5'
  # end

  # it 'should save chapter pdf' do
  #   assert File.exist?(@pdf_path)
  #   system "open #{@pdf_path}"
  # end
end
