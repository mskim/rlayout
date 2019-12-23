require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "create RChapter" do
  before do
    @project_path = "/Users/mskim/Development/chapter/01_chapter"
    @chapter      = RLayout::RChapter.new(project_path: @project_path)
    @doc          = @chapter.document
  end

  it 'should create RChapter' do
    @chapter.must_be_kind_of RChapter
  end

  # it 'shoud have RDocument' do
  #   @doc.must_be_kind_of RDocument
  # end

  # it 'shoud create RDocument with paper_size' do
  #   @doc.paper_size.must_equal 'A5'
  # end

  # it 'should save chapter pdf' do
  #   @pdf_path = "/Users/Shared/rlayout/pdf_output/r_chapter.pdf"
  #   @doc.save_pdf(@pdf_path)
  #   File.exist?(@pdf_path).must_equal true
  #   system "open #{@pdf_path}"
  # end
end
