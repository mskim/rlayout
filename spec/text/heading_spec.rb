require File.dirname(__FILE__) + "/../spec_helper"

describe 'testing heading creation' do
  before do
    @doc = RLayout::Document.new(:initial_page=>false) do
      page(layout_space: 10) do
        heading(fill_color: "orange", title: "This is title") 
        main_text(column_count: 3) do
          float_image(:local_image=> "1.jpg", :grid_frame=> [0,0,1,1])
          float_image(:local_image=> "2.jpg", :grid_frame=> [0,1,1,1])
        end
        relayout!
      end
    end
    
    @first_page = @doc.pages.first
    @heading = @first_page.graphics.first
    @heading.puts_frame
  end
  
  it 'should create Heading' do
    assert @heading.class == Heading
  end

end

__END__
describe 'testing heading creation' do
  before do
    @heading = Heading.new(nil)
  end
  
  it 'should create heading' do
    @heading.must_be_kind_of Heading
  end
  
  it 'should have default values' do
    @heading.x.must_equal 0
    # @heading.y.must_equal 0
    @heading.width.must_equal 600
    # @heading.height.must_equal 100
  end
end

describe 'testing heading block' do
  before do
    @h = Heading.new(nil) do
      title "This title looks great."
      subtitle "This is subtitle."
      leading "This is the leading"
      author "- Min Soo Kim"
    end
  end
    
  it 'should create heading' do
    @h.must_be_kind_of Heading
  end
  
  it 'should have default types' do
    @h.title_object.must_be_kind_of Text
    @h.subtitle_object.must_be_kind_of Text
    @h.leading_object.must_be_kind_of Text
    @h.author_object.must_be_kind_of Text
  end
  
  it 'should save heading' do
    @svg_path = "/Users/Shared/rlayout/output/heading_test.svg"
    # @pdf_path = "/Users/Shared/rlayout/output/heading_test.pdf"
    @h.save_svg(@svg_path)
    File.exists?(@svg_path).must_equal true
    system "open #{@svg_path}"
    # @h.save_pdf(@pdf_path)
    # File.exists?(@pdf_path).must_equal true
  end
  
end
