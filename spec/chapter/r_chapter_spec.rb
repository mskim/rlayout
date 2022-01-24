require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
describe "create RChapter with page_floats" do
  before do
    # @document_path = "/Users/mskim/test_data/chapter"
    # @pdf_path     = "/Users/mskim/test_data/chapter_1/chapter.pdf"
    # @pdf_path     = "/Users/mskim/test_data/chapter_1/chapter.pdf"
    # @document_path  = "/Users/mskim/test_data/chapter_with_page_floats"
    @document_path = "/Users/mskim/test_data/chapter_1"
    @chapter      = RLayout::RChapter.new(document_path: @document_path, page_pdf:true, svg:true)
    @doc          = @chapter.document
  end

  it 'should create RChapter' do
    assert_equal RChapter, @chapter.class 
  end

  it 'should save PDF' do
    @pdf_path = "/Users/mskim/test_data/chapter_1/chapter.pdf"
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end

__END__
describe "create RChapter with images" do
  before do
    @document_path = "/Users/mskim/test_data/chapter"
    # @pdf_path     = "/Users/mskim/test_data/chapter_1/chapter.pdf"
    # @document_path = "/Users/mskim/test_data/chapter_1"
    # @pdf_path     = "/Users/mskim/test_data/chapter_1/chapter.pdf"
    @document_path  = "/Users/mskim/test_data/chapter_with_images"
    @chapter      = RLayout::RChapter.new(document_path: @document_path, page_pdf:true, svg:true)
    @doc          = @chapter.document
  end

  it 'should create RChapter' do
    assert_equal RChapter, @chapter.class 
  end

end

describe "create RChapter" do
  before do
    @document_path = "/Users/mskim/test_data/chapter"
    # @pdf_path     = "/Users/mskim/test_data/chapter_1/chapter.pdf"
    # @document_path = "/Users/mskim/test_data/chapter_1"
    # @pdf_path     = "/Users/mskim/test_data/chapter_1/chapter.pdf"
    @chapter      = RLayout::RChapter.new(document_path: @document_path)
    @doc          = @chapter.document
  end

  it 'should create RChapter' do
    assert_equal RChapter, @chapter.class 
  end

end
