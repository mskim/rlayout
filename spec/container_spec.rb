require 'minitest/autorun'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'rlayout/graphic'
require 'rlayout/container'
include RLayout

describe 'test profile' do
  before do
    @g5 = Container.new(:tag=> 'g2', :layout_direction=>'horizontal')
      RoundRect.new(parent: @g5, :tag => "RoundRect")
      Circle.new(parent: @g5, :tag => "Circle")
      RoundRect.new(parent: @g5, :tag => "RoundRect2")
      Circle.new(parent: @g5, :tag => "Circle2")
  end

  it 'should return profile' do
    @g5.profile.must_equal "Circle_Circle2_RoundRect_RoundRect2"
  end
end

describe 'testing container with graphics' do
  before do
    @container = Container.new(:x=>200, :y=>50, :width=>300, :height=>500)
    @g5 = Container.new(parent: @container, :tag=> 'g2', :layout_direction=>'horizontal')
      RoundRect.new(parent: @g5, :fill_color=> 'yellow', :thickness=> 5)
      Circle.new(parent: @g5, :fill_color=> 'lightGray', :thickness=> 5)
      RoundRect.new(parent: @g5, :fill_color=> 'blue', :thickness=> 5)
      Circle.new(parent: @g5, :fill_color=> 'red', :thickness=> 5)
    @g1 = Rectangle.new(parent: @container, :fill_color=> 'red')
    @g2 = Circle.new(parent: @container, :fill_color=> 'yellow', :thickness=> 20)
    @g3 = RoundRect.new(parent: @container, :fill_color=> 'blue')
    @container.relayout!
  end
    
  it 'should save svg' do
    @svg_path = "/Users/Shared/rlayout/output/container_test.svg"
    @container.save_svg(@svg_path)
    File.exist?(@svg_path).must_equal true
    # system("open #{@svg_path}")
  end
end

describe 'testing container with line' do
  before do
    @container = Container.new(:x=>200, :y=>50, :width=>300, :height=>500)
    @g1 = Line.new(parent: @container, :line_color=> 'red', :line_width=> 20)
    @g2 = Line.new(parent: @container, :line_color=> 'yellow', :line_width=> 10)
    @g3 = Line.new(parent: @container, :line_color=> 'black', :line_width=> 5)
    @g4 = Line.new(parent: @container, :line_color=> 'green', :line_width=> 1)
    @container.relayout!
  end
    
  it 'should save svg' do
    @svg_path = "/Users/Shared/rlayout/output/container_with_line_test.svg"
    @container.save_svg(@svg_path)
    File.exist?(@svg_path).must_equal true
    # system("open #{@svg_path}")
  end

end


describe 'testing container with graphics' do
  before do
    @container = Container.new()
    @g1 = Container.new(parent: @container, :fill_color=> 'red')
      @g3= Graphic.new(parent: @g1, :fill_color=> 'yellow')
      @g4= Graphic.new(parent: @g1, :fill_color=> 'black')
    @g2 = Container.new(parent: @container, :fill_color=> 'blue', :tag=> 'g2')
      @g5= Graphic.new(parent: @g2, :fill_color=> 'yellow', :tag=> 'g5')
      @g6= Graphic.new(parent: @g2, :fill_color=> 'blue', :tag=> 'g6')
    @container.relayout!
     
  end
  
  it 'should add graphics' do
    @container.graphics.length.must_equal 2
    @container.graphics.length.must_equal 2
  end
  
  it 'added graphics should have self as parent' do
    @container.graphics[0].parent_graphic.must_equal @container
    @container.graphics[1].parent_graphic.must_equal @container
  end
  
  it 'should save pdf' do
    @svg_path = "/Users/Shared/rlayout/output/container_test.svg"
    @container.save_svg(@svg_path)
    # system("open #{@svg_path}")
  end
end

describe 'testing container creation' do
  before do
    @container = Container.new()
  end
  
  it 'should create container' do
    @container.must_be_kind_of Container
  end
  
  it 'should have default values' do
    @container.x.must_equal 0
    # @container.y.must_equal 0   # I think there is MacRuby Bug for setting @y as nil
    @container.width.must_equal 100
    @container.height.must_equal 100
  end
end

describe 'testing container with graphics' do
  before do
    @container = Container.new()
    @c1 = Container.new(parent: @container, fill_color: 'red')
    @c3 = Container.new(parent: @c1, fill_color: 'orange')
    @c4 = Container.new(parent: @c1, fill_color: 'green')
    @c2 = Container.new(parent: @container, tag: "c2", fill_color: 'gray')
    @c5 = Container.new(parent: @c2, tag: "c5", fill_color: 'blue')
    @c6 = Container.new(parent: @c2, fill_color: 'brown')
    @container.relayout!
    # puts "++++++ @c5.text_rect:#{@c5.text_rect}"
    # puts "++++++ @c6.text_rect:#{@c6.text_rect}"
    
  end
  
  # it 'should add graphics' do
  #   @container.graphics.length.must_equal 2
  #   @container.graphics.length.must_equal 2
  # end
  # 
  # it 'added graphics should have self as parent' do
  #   @container.graphics[0].parent_graphic.must_equal @container
  #   @container.graphics[1].parent_graphic.must_equal @container
  # end
  
  it 'should save pdf' do
    @svg_path = "/Users/Shared/rlayout/output/container_nested_test.svg"
    @container.save_svg(@svg_path)
    File.exists?(@svg_path = "/Users/Shared/rlayout/output/container_nested_test.svg"
    ).must_equal true
    # view = @container.ns_view
    # s_views = view.subviews
    # c2 = s_views.last
    # puts "c2.frame.origin.y:#{c2.frame.origin.y}"
    # c5=c2.subviews.first
    # puts "c5.frame.origin.y:#{c5.frame.origin.y}"
    # c6=c2.subviews.last
    # puts c6.frame.origin.x
    # puts "c6.frame.origin.y:#{c6.frame.origin.y}"
  end
end