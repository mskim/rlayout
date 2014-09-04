require File.dirname(__FILE__) + "/spec_helper"

describe 'testing heading creation' do
  before do
    @heading = Heading.new(nil)
  end
  
  it 'should create heading' do
    @heading.must_be_kind_of Heading
  end
  
  it 'should have default values' do
    @heading.x.must_equal 0
    @heading.y.must_equal 0
    @heading.width.must_equal 100
    # @heading.height.must_equal 100
  end
end

describe 'testing heading block' do
  before do
    @heading = Heading.new(nil) do
      title("Thisi is a title.")
      subtitle("This is subtitle.")
      author( "This is the leading")
      leading( "This is the leading")
    end
  end
  
  it 'should create heading' do
    @heading.must_be_kind_of Heading
  end
  
  it 'should have default types' do
    @heading.title_text.must_be_kind_of Text
    @heading.subtitle_text.must_be_kind_of Text
    @heading.leading_text.must_be_kind_of Text
    @heading.author_text.must_be_kind_of Text
  end
end

# describe 'testing heading with graphics' do
#   before do
#     @heading = Container.new(nil)
#     @g1 = Graphic.new(self)
#     @heading.place_graphic(@g1)
#     @heading.place_graphic(Graphic.new(nil))
#     
#   end
#   
#   it 'should add graphics' do
#     @heading.graphics.length.must_equal 2
#     @heading.graphics.length.must_equal 2
#   end
#   
#   it 'added graphics should have self as parent' do
#     @heading.graphics[0].parent_graphic.must_equal @heading
#     @heading.graphics[1].parent_graphic.must_equal @heading
#   end
# end
