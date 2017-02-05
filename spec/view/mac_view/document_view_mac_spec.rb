require File.dirname(File.expand_path(__FILE__)) + "/../../spec_helper"

if  RUBY_ENGINE == "macruby"
describe 'document_view_mac' do
  before do
    @doc = Document.new(:tite=>"my_test") do
      page do
        random_graphics(20)
      end
      page do
        random_graphics(20)
      end
      page do
        random_graphics(20)
      end
    end
    @pdf_path = "/Users/Shared/rlayout/output/document_test.pdf"
    @doc_view = DocumentViewMac.new(@doc.to_data)
  end
  it 'document should create document ' do
    @doc.must_be_kind_of Document
    @doc.pages.length.must_equal 3
    @doc.pages.first.graphics.length.must_equal 20
  end

  it 'should create DocumentViewMac' do
    @doc_view.must_be_kind_of DocumentViewMac
  end

  it 'should save DocumentViewMac' do
    @doc_view.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
  end
end
end
