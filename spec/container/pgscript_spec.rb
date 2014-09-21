require File.dirname(__FILE__) + "/../spec_helper"

describe 'testing container split-v' do
  before do
    @container = Container.new(nil) do
      split_v(2, :fill_color=>"blue")
    end
  end
  
  it 'should create container' do
    @container.must_be_kind_of Container
  end
  
  it 'should have two graphics' do
    @container.graphics.length.must_equal 2
  end
  
  it 'should have layout_direction' do
    @container.layout_direction.must_equal 'vertical'
  end
  
  it 'should apply option values' do
    @container.graphics.first.fill_color.must_equal 'blue'
    @container.graphics.first.height.must_equal 50
    @container.graphics[1].height.must_equal 50
    @container.graphics[1].fill_color.must_equal 'blue'
  end
  
  it 'should save' do
    svg_path = File.dirname(__FILE__) + "/../output/container_pgscript_split-v.svg"
    pdf_path = File.dirname(__FILE__) + "/../output/container_pgscript_split-v.pdf"
    @container.save_svg(svg_path)
    @container.save_pdf(pdf_path)
  end
end

# describe 'testing container split-h' do
#   before do
#     @container = Container.new(nil) do
#       split_h(2, :fill_color=>"gray")
#     end
#   end
#   
#   it 'should create container' do
#     @container.must_be_kind_of Container
#   end
#   
#   it 'should have two graphics' do
#     @container.graphics.length.must_equal 2
#   end
#   
#   it 'should have layout_direction' do
#     @container.layout_direction.must_equal 'horizontal'
#   end
#   
#   it 'should save' do
#     svg_path = File.dirname(__FILE__) + "/../output/container_pgscript_split-h.svg"
#     pdf_path = File.dirname(__FILE__) + "/../output/container_pgscript_split-h.pdf"
#     @container.save_svg(svg_path)
#     @container.save_pdf(pdf_path)
#   end
# end
