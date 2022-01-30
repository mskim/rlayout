require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create ColumnTextPage' do
  before do
    @column_text_path  = "/Users/mskim/test_data/column_text_page"
    @pdf_path = "/Users/mskim/test_data/column_text_page/output.pdf"
    FileUtils.mkdir_p(@column_text_path) unless File.exist?(@column_text_path)
    @prologue = Isbn.new(document_path: @column_text_path)
  end

  it 'should create FrontWing' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
