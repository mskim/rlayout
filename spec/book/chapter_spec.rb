require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
describe "create Chapter with page_floats" do
  before do
    @document_path = "#{ENV["HOME"]}/test_data/chapter_1"
    @chapter      = RLayout::Chapter.new(document_path: @document_path, custom_style: true)
    @doc          = @chapter.document
  end

  it 'should create Chapter' do
    assert_equal Chapter, @chapter.class 
  end

  it 'should save PDF' do
    @pdf_path = "#{ENV["HOME"]}/test_data/chapter_1/chapter.pdf"
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end

__END__
describe "create Chapter with images" do
  before do
    @document_path = "#{ENV["HOME"]}/test_data/chapter"
    # @pdf_path     = "#{ENV["HOME"]}/test_data/chapter_1/chapter.pdf"
    # @document_path = "#{ENV["HOME"]}/test_data/chapter_1"
    # @pdf_path     = "#{ENV["HOME"]}/test_data/chapter_1/chapter.pdf"
    @document_path  = "#{ENV["HOME"]}/test_data/chapter_with_images"
    @chapter      = RLayout::Chapter.new(document_path: @document_path, page_pdf:true, svg:true)
    @doc          = @chapter.document
  end

  it 'should create Chapter' do
    assert_equal Chapter, @chapter.class 
  end

end

describe "create Chapter" do
  before do
    @document_path = "#{ENV["HOME"]}/test_data/chapter"
    # @pdf_path     = "#{ENV["HOME"]}/test_data/chapter_1/chapter.pdf"
    # @document_path = "#{ENV["HOME"]}/test_data/chapter_1"
    # @pdf_path     = "#{ENV["HOME"]}/test_data/chapter_1/chapter.pdf"
    @chapter      = RLayout::Chapter.new(document_path: @document_path)
    @doc          = @chapter.document
  end

  it 'should create Chapter' do
    assert_equal Chapter, @chapter.class 
  end

end
