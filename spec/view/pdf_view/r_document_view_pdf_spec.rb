require File.dirname(File.expand_path(__FILE__)) + "/../../spec_helper"

describe 'create DocumentViewPdf' do
  before do
    @pdf_path = "/Users/Shared/rlayout/output/document_view_pdf_test.pdf"
    @doc = RDocument.new
    @doc.save_pdf(@pdf_path)
  end

  it 'should create DocumentViewPdf' do
    assert_equal @doc.document_view_pdf.class, DocumentViewPdf
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end