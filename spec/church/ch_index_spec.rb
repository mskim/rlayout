require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create ChIndex' do
  before do
    @index_path =  "/Users/mskim/test_data/church/ch_index"
    @pdf_path =  "/Users/mskim/test_data/church/ch_index/output.pdf"
    @y = ChIndex.new(index_path: @index_path)
    @y.save_pdf(@pdf_path)

  end

  it 'should create folders' do
    assert RLayout::ChIndex,  @y.class
  end

  it 'should create section_pdf' do
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end
