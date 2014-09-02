require File.dirname(__FILE__) + "/spec_helper"

describe "document" do
  before do
    @doc = Document.new(:tite=>"my_test") do
      page
      page
      page
    end
  end
  
  it 'document should create document ' do
    @doc.must_be_kind_of Document
  end
  
  it 'document should have default values' do
    @doc.title.must_equal "untitled"
    @doc.paper_size.must_equal "A4"
    @doc.path.must_equal nil
    @doc.width.must_equal 600
    @doc.height.must_equal 800
    @doc.margin.must_equal 50
    @doc.portrait.must_equal true
    @doc.pages.length.must_equal 3
  end
  
  it 'should have pages' do
    @doc.pages.length.must_equal 3
  end
end
