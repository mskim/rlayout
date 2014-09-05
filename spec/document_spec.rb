require File.dirname(__FILE__) + "/spec_helper"

describe "document" do
  before do
    @doc = Document.new(:tite=>"my_test") do
      page do
        rect fill_color: "green"
        rect fill_color: "red", x:200, y:200
        rect fill_color: "black" , x:300, y:300
        rect fill_color: "blue", x:500, y:500
      end
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
    @doc.pages.length.must_equal 1
  end
  
  it 'should have pages' do
    @doc.pages.length.must_equal 1
  end
  
  it 'should save svg' do
    @svg_path = File.dirname(__FILE__) + "/output/document_test.svg"
    @doc.save_svg(@svg_path)
    File.exists?(@svg_path).must_equal true
    
  end
end
