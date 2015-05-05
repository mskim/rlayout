require File.dirname(__FILE__) + "/spec_helper"

describe 'create Graphic ' do
  before do
    @g = Graphic.new(nil, :fill_color=>"blue")
  end
  it 'should create Graphic' do
    assert @g.klass == "Rectangle"
  end
  
  it 'should not have fill' do    
    assert @g.fill.class == FillStruct
    assert @g.fill.color == 'blue'
  end
  
  it 'should create rect shape' do    
    assert @g.shape.class == RectStruct
  end

  it 'should have stroke' do    
    assert @g.stroke.class == StrokeStruct
    assert @g.stroke.color == 'black'
    assert @g.stroke.thickness == 0
  end
  it 'should not have image_record' do    
    assert @g.image_record == nil
  end
  it 'should not have text_record' do    
    assert @g.text_record == nil
  end
end

describe 'LinearFill ' do
  before do
    @g = Graphic.new(nil, :fill_type=>'gradiation', :fill_color=>"blue")
  end
  it 'should create LinearFill' do
    assert @g.fill.class == LinearGradient
  end
end

describe 'RadialFill ' do
  before do
    @g = Graphic.new(nil, :starting_color=>"blue", :ending_color=>'red', :fill_type=>"radial")
  end
  it 'should create LinearFill' do
    assert @g.fill.class == RadialGradient
  end
end


describe 'create Circle' do
  before do
    @c = Circle.new(nil, :width=>200, :height=>200)
  end
  it 'should create Circle' do
    assert @c.klass == "Circle"
  end
  it 'should create CircleStruct shape' do
    assert @c.shape.class   == CircleStruct
    assert @c.shape.r       == 100
    assert @c.shape.cx      == 100
    assert @c.shape.cy      == 100
  end
  it 'should have fill' do    
    assert @c.fill.class == FillStruct
    assert @c.fill.color == 'white'
  end
  it 'should have stroke' do    
    assert @c.stroke.class == StrokeStruct
    assert @c.stroke.color == 'black'
    assert @c.stroke.thickness == 0
  end
  
end

describe 'create Ellipse' do
  before do
    @c = Ellipse.new(nil, :width=>100, :height=>200, :fill_color=>"orange")
  end
  it 'should create Ellipse' do
    assert @c.klass == "Ellipse"
  end
  
  it 'should create EllipseStruct shape' do
    assert @c.shape.class   == EllipseStruct
    assert @c.shape.rx      == 50
    assert @c.shape.ry      == 100
  end
  it 'should have fill' do    
    assert @c.fill.class == FillStruct
    assert @c.fill.color == 'orange'
  end
  it 'should have stroke' do    
    assert @c.stroke.class == StrokeStruct
    assert @c.stroke.color == 'black'
    assert @c.stroke.thickness == 0
  end
  it 'should have stroke' do    
    assert @c.stroke.class == StrokeStruct
    assert @c.stroke.color == 'black'
    assert @c.stroke.thickness == 0
  end
  
  it 'should save' do
    @path = File.dirname(__FILE__) + "/output/graphic_color_test.svg"
    @c.save_svg(@path)
    system "open #{@path}"
  end
  
end

describe 'create RoundRect' do
  before do
    @c = RoundRect.new(nil, :width=>100, :height=>200)
  end
  it 'should create RoundRect' do
    assert @c.klass == "RoundRect"
  end
  
  it 'should create RoundRectStruct shape' do
    assert @c.shape.class   == RoundRectStruct
    assert @c.shape.rx      == 10.0
    assert @c.shape.ry      == 10.0
  end
  it 'should have fill' do    
    assert @c.fill.class == FillStruct
    assert @c.fill.color == 'white'
  end
  it 'should have stroke' do    
    assert @c.stroke.class == StrokeStruct
    assert @c.stroke.color == 'black'
    assert @c.stroke.thickness == 0
  end
end

describe 'create Image' do
  before do
    @c = Image.new(nil, :image_path=> "my_image_path.jpg", :width=>100, :height=>200)
  end
  it 'should create Image' do
    assert @c.klass       == "Image"
    assert @c.image_path  == "my_image_path.jpg"
  end
  
  it 'should create Image shape' do
    assert @c.shape.class     == RectStruct
    assert @c.shape.width     == 100
    assert @c.shape.height    == 200
  end
  it 'should have fill' do    
    assert @c.fill.class == FillStruct
    assert @c.fill.color == 'white'
  end
  it 'should have stroke' do    
    assert @c.stroke.class == StrokeStruct
    assert @c.stroke.color == 'black'
    assert @c.stroke.thickness == 0
  end
end

describe 'create Text' do
  before do
    @c = Text.new(nil, :text_string=> "This is my text string.", :width=>100, :height=>200)
  end
  it 'should create Text' do
    assert @c.klass       == "Text"
  end
  it 'should create text_record' do
  
    assert @c.text_record.string  == "This is my text string."
  end
  
  it 'should create Text shape' do
    assert @c.shape.class     == RectStruct
    assert @c.shape.width     == 100
    assert @c.shape.height    == 200
  end
  it 'should have fill' do    
    assert @c.fill.class == FillStruct
    assert @c.fill.color == 'white'
  end
  it 'should have stroke' do    
    assert @c.stroke.class == StrokeStruct
    assert @c.stroke.color == 'black'
    assert @c.stroke.thickness == 0
  end
end

describe 'generate random graphics' do
  before do
    @g = Graphic.random_graphics(200)
    @path = File.dirname(__FILE__) + "/output/graphic_random_test.svg"
  end
  
  it 'should create Graphic' do
    @g.must_be_kind_of Array
  end
  
  it 'should save random grapics' do    
    p = Page.new(nil)
    p.add_graphics(@g)
    p.save_svg(@path)
    system "open #{@path}"
  end
end

__END__


describe ' Graphic from Hash ' do
  before do
    h = {
      :klass => "Container",
      :fill_color=> 'red',
      :graphics => [
        {:klass => "Rectangle", :fill_color=> 'blue'},
        {:klass => "Rectangle", :fill_color=> 'green'},
        ]
    }
    @t = Container.new(nil, h)
  end
    
  it 'should save Rectangle from hash' do
    @pdf_path = File.dirname(__FILE__) + "/output/graphic_from_hash.pdf"
    @t.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
end

describe 'testing Text ' do
  before do
    @t = Text.new(nil, width: 400,  text_string: "This is text string and I like it very much. Wouldn't you? "*4, text_size: 24, text_alignment: 'right')
  end
  
  it 'should create heading' do
    @t.must_be_kind_of Text
    @t.text_size.must_equal 24
  end
  
  it 'should save Text' do
    @svg_path = File.dirname(__FILE__) + "/output/text_test.svg"
    @pdf_path = File.dirname(__FILE__) + "/output/texxt_test.pdf"
    # @t.save_svg(@svg_path)
    # File.exists?(@svg_path).must_equal true
    @t.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
  end
  
end


