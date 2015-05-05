require File.dirname(__FILE__) + "/spec_helper"

describe 'testing container with graphics' do
  before do
    @container = Container.new(nil, :x=>200, :y=>50, :width=>300, :height=>500)
    @g5 = Container.new(@container, :tag=> 'g2', :layout_direction=>'horizontal')
      RoundRect.new(@g5, :fill_color=> 'yellow', :thickness=> 5)
      Circle.new(@g5, :fill_color=> 'lightGray', :thickness=> 5)
      RoundRect.new(@g5, :fill_color=> 'blue', :thickness=> 5)
      Circle.new(@g5, :fill_color=> 'red', :thickness=> 5)
    @g1 = Rectangle.new(@container, :fill_color=> 'red')
    @g2 = Circle.new(@container, :fill_color=> 'yellow', :thickness=> 20)
    @g3 = RoundRect.new(@container, :fill_color=> 'blue')
    @container.relayout!
  end
    
  it 'should save svg' do
    @svg_path = File.dirname(__FILE__) + "/output/container_test.svg"
    @container.save_svg(@svg_path)
    system("open #{@svg_path}")
  end

end

describe 'testing container with line' do
  before do
    @container = Container.new(nil, :x=>200, :y=>50, :width=>300, :height=>500)
    @g1 = Line.new(@container, :line_color=> 'red', :line_width=> 20)
    @g2 = Line.new(@container, :line_color=> 'yellow', :line_width=> 10)
    @g3 = Line.new(@container, :line_color=> 'black', :line_width=> 5)
    @g4 = Line.new(@container, :line_color=> 'green', :line_width=> 1)
    @container.relayout!
  end
    
  it 'should save svg' do
    @svg_path = File.dirname(__FILE__) + "/output/container_with_line_test.svg"
    @container.save_svg(@svg_path)
    system("open #{@svg_path}")
  end

end

__END__

describe 'testing container with graphics' do
  before do
    @container = Container.new(nil)
    @g1 = Container.new(@container, :fill_color=> 'red')
      @g3= Graphic.new(@g1, :fill_color=> 'yellow')
      @g4= Graphic.new(@g1, :fill_color=> 'black')
    @g2 = Container.new(@container, :fill_color=> 'blue', :tag=> 'g2')
      @g5= Graphic.new(@g2, :fill_color=> 'yellow', :tag=> 'g5')
      @g6= Graphic.new(@g2, :fill_color=> 'blue', :tag=> 'g6')
    @container.relayout!
     
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
    @pdf_path = File.dirname(__FILE__) + "/output/container_test.pdf"
    @container.save_pdf(@pdf_path)
    system("open #{@pdf_path}")
  end
end

describe 'testing container creation' do
  before do
    @container = Container.new(nil)
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
    @container = Container.new(nil)
    @c1 = Container.new(@container, fill_color: 'red')
    @c3 = Container.new(@c1, fill_color: 'orange')
    @c4 = Container.new(@c1, fill_color: 'green')
    @c2 = Container.new(@container, tag: "c2", fill_color: 'gray')
    @c5 = Container.new(@c2, tag: "c5", fill_color: 'blue')
    @c6 = Container.new(@c2, fill_color: 'brown')
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
    @pdf_path = File.dirname(__FILE__) + "/output/container_nested_test.pdf"
    @container.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
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