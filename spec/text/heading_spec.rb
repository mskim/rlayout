require File.dirname(__FILE__) + "/../spec_helper"

# describe 'testing heading creation' do
#   before do
#     @heading = Heading.new(nil)
#   end
#   
#   it 'should create heading' do
#     @heading.must_be_kind_of Heading
#   end
#   
#   it 'should have default values' do
#     @heading.x.must_equal 0
#     # @heading.y.must_equal 0
#     @heading.width.must_equal 100
#     # @heading.height.must_equal 100
#   end
# end

describe 'testing heading block' do
  before do
    @h = Heading.new(nil) do
      title("This is a title.")
      subtitle("This is subtitle.")
      leading("This is the leading")
      author("This is the author")
    end
  end
  
  it 'should have height heading' do
    @h.height.must_equal  50
  end
  
  it 'should create heading' do
    @h.must_be_kind_of Heading
  end
  
  it 'should have default types' do
    @h.title_text.must_be_kind_of Text
    @h.subtitle_text.must_be_kind_of Text
    @h.leading_text.must_be_kind_of Text
    @h.author_text.must_be_kind_of Text
  end
  
  it 'should save heading' do
    @svg_path = File.dirname(__FILE__) + "/../output/heading_test.svg"
    @pdf_path = File.dirname(__FILE__) + "/../output/heading_test.pdf"
    @h.save_svg(@svg_path)
    File.exists?(@svg_path).must_equal true
    @h.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    
  end
  
end
