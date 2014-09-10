require File.dirname(__FILE__) + "/spec_helper"

describe ' ObjectBox creation' do
  before do
    @ob = ObjectBox.new(nil, :width=>600, :height=>800)
    @flowomg_text =Paragraph.generate(3)
    @svg_path = File.dirname(__FILE__) + "/output/object_box_test.svg"
  end
  
  # it 'should create container' do
  #   @ob.must_be_kind_of ObjectBox
  #   @ob.graphics.length.must_equal 3
  #   @ob.graphics[0].must_be_kind_of Container
  #   @ob.graphics[0].x.must_equal 0
  # end
  # 
  # it 'should save' do
  #   @ob.save_svg(@svg_path)
  #   File.exists?(@svg_path).must_equal true
  #   # system("open #{@svg_path}") if File.exists?(@svg_path)
  # end
  
  it 'should layout_items' do
     puts result = @ob.layout_items(@flowomg_text, 0)
     @flowing_path = File.dirname(__FILE__) + "/output/object_box_flowingtest.svg"
     @ob.save_svg(@flowing_path)
     File.exists?(@flowing_path).must_equal true
   end
   
  it 'should save pdf' do
    puts result = @ob.layout_items(@flowomg_text, 0)
    @flowing_path = File.dirname(__FILE__) + "/output/object_box_flowingtest.pdf"
    @ob.save_pdf(@flowing_path)
    File.exists?(@flowing_path).must_equal true
  end
end

# describe 'Paragraph test' do
#   before do
#     @fo =Paragraph.new(nil)
#     @flowomg_text =Paragraph.generate(30)
#   end
#   
#   it 'should create FlowingObject' do
#     @fo.must_be_kind_of Paragraph
#   end
#   
#   it 'should create 30 Paragraphs' do
#     @flowomg_text.length.must_equal 30
#   end
# end