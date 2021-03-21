require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe ' save_pdf of Graphic' do
  before do
    @g = Graphic.new(width:400, height: 400)
  end
  it 'should create Container' do
    assert Graphic, @g.class
  end

  # it 'should save Container' do
  #   path = File.dirname(__FILE__) + "/saving_from_hexa.pdf"
  #   @g.save_pdf(path)
  #   assert File.exist?(path), true
  # end
end

describe ' create Graphic with from_right and from_bottom' do
  before do
    @c = Container.new(width:400, height: 400) do
      rectangle(from_right:10, from_bottom: 100)
    end
    @r = @c.graphics.first
  end
  it 'should create Container' do
    assert Container, @c.class
  end

  it 'should create Container' do
    assert Rectangle, @r.class
  end

  it 'should have right x and y value' do
    assert 290, @r.x
    assert 100, @r.width
    assert 200, @r.y
    assert 100, @r.height
  end
end


describe ' create Graphic from yaml' do
  before do

yml =<<-EOF
{
  doc_type: "NAMECARD",
  page_front: {
    image_logo: {
      grid: [0,0,1,1],
      image: '1.jpg'
    },
    stack_personal: {
      grid: [0,0,1,1],
      name: 'Min Soo Kim',
      email: 'mskimsid@gmail.com'
    },
    stack_company: {
      grid: [0,0,1,1],
      address1: '10 Some Stree',
      address2: 'Seoul, Korea'
    }
  },

  page_back: {
    image_logo: {
      grid: [0,0,1,1],
      image: '1.jpg'
    },

    stack_personal: {
      grid: [0,0,1,1],
      name: 'Min Soo Kim',
      email: 'mskimsid@gmail.com'
    },

    stack_company: {
      grid: [0,0,1,1],
      address1: '10 Some Stree',
      address2: 'Seoul, Korea'
    }
  }
}

    EOF
    @g = RLayout::Graphic.new(json: YAML::load(yml))
  end

  it 'shuld create object from data' do
    assert_equal Graphic, @g.class 
  end
end

describe ' convert string to color' do
  before do
    color_string = "FF0000"
    @color = RLayout::color_from_hex(color_string)
  end
  it 'shuld convert hex color' do
    assert_equal "rgb(255,0,0)", @color
  end
end

describe 'create Graphic ' do
  before do
    @g = Graphic.new(parent:nil, :fill_color=>"blue")
  end

  it 'should not have fill' do
    assert_equal FillStruct, @g.fill.class 
    assert_equal 'blue', @g.fill.color 
  end

  it 'should create rect shape' do
    assert_equal RectStruct, @g.shape.class 
  end

  it 'should have stroke' do
    assert_equal StrokeStruct, @g.stroke.class 
    assert_equal @g.stroke.color,  'CMYK=0,0,0,100'
    assert_equal @g.stroke.thickness, 0
  end

  it 'should not have image_record' do
    assert_nil @g.image_record
  end

  it 'should not have text_record' do
    assert_nil @g.text_record
  end
end

describe 'LinearFill ' do
  before do
    @g = Graphic.new(:fill_type=>'gradiation', :fill_color=>"blue")
  end

  it 'should create LinearFill' do
    assert_equal LinearGradient, @g.fill.class
  end
end

describe 'RadialFill ' do
  before do
    @g = Graphic.new(:starting_color=>"blue", :ending_color=>'red', :fill_type=>"radial")
  end

  it 'should create LinearFill' do
    assert_equal RadialGradient, @g.fill.class
  end
end

describe 'create Circle' do
  before do
    @c = Circle.new(:width=>200, :height=>200)
  end

  it 'should create Circle' do
    assert_equal Circle, @c.class
  end

  it 'should create CircleStruct shape' do
    assert_equal 100, @c.shape.r
    assert_equal 100, @c.shape.cx
    assert_equal 100, @c.shape.cy
  end

  it 'should have fill' do
    assert_equal FillStruct, @c.fill.class
    assert_equal "CMYK=0,0,0,0", @c.fill.color
  end

  it 'should have stroke' do
    assert_equal StrokeStruct, @c.stroke.class
    assert_equal 'CMYK=0,0,0,100', @c.stroke.color
    assert_equal 0, @c.stroke.thickness
  end
end

describe 'create Ellipse' do
  before do
    @c = Ellipse.new(:width=>100, :height=>200, :fill_color=>"orange")
  end

  it 'should create Ellipse' do
    assert_equal Ellipse, @c.class
  end

  it 'should create EllipseStruct shape' do
    assert_equal EllipseStruct, @c.shape.class
    assert_equal 50, @c.shape.rx
    assert_equal 100, @c.shape.ry 
  end

  it 'should have fill' do
    assert_equal FillStruct, @c.fill.class 
    assert_equal 'orange', @c.fill.color
  end

  it 'should have stroke' do
    assert_equal @c.stroke.class, StrokeStruct
    assert_equal 'CMYK=0,0,0,100', @c.stroke.color
    assert_equal 0, @c.stroke.thickness
  end

  it 'should have stroke' do
    assert_equal StrokeStruct, @c.stroke.class
    assert_equal 'CMYK=0,0,0,100', @c.stroke.color 
    assert_equal 0, @c.stroke.thickness
  end

  # it 'should save' do
  #   @path = "/Users/Shared/rlayout/output/graphic_color_test.svg"
  #   @c.save_svg(@path)
  #   # system "open #{@path}"
  # end

end

describe 'create RoundRect' do
  before do
    @c = RoundRect.new(:width=>100, :height=>200)
  end

  it 'should create RoundRect' do
    assert_equal RoundRect, @c.class 
  end

  it 'should create RoundRectStruct shape' do
    assert_equal RoundRectStruct, @c.shape.class 
    assert_equal 10.0, @c.shape.rx 
    assert_equal 10.0, @c.shape.ry 
  end

  it 'should have fill' do
    assert_equal FillStruct, @c.fill.class 
    assert_equal "CMYK=0,0,0,0", @c.fill.color 
  end

  it 'should have stroke' do
    assert_equal StrokeStruct, @c.stroke.class 
    assert_equal 'CMYK=0,0,0,100', @c.stroke.color 
    assert_equal 0, @c.stroke.thickness
  end
end

describe 'create Image' do
  before do
    @c = Image.new(:image_path=> "my_image_path.jpg", :width=>100, :height=>200)
  end
  it 'should create Image' do
    assert_equal Image, @c.class 
    assert_equal "my_image_path.jpg", @c.image_path 
  end

  it 'should create Image shape' do
    assert_equal RectStruct, @c.shape.class
    assert_equal 100, @c.shape.width
    assert_equal 200, @c.shape.height
  end

  it 'should have fill' do
    assert_equal FillStruct, @c.fill.class 
    assert_equal "CMYK=0,0,0,10", @c.fill.color 
  end

  it 'should have stroke' do
    assert_equal StrokeStruct, @c.stroke.class
    assert_equal 'CMYK=0,0,0,100', @c.stroke.color 
    assert_equal 1, @c.stroke.thickness 
  end
end

describe 'create Text' do
  before do
    @c = Text.new(:text_string=> "This is my text string.", :width=>100, :height=>200)
  end

  it 'should create Text' do
    assert_equal Text, @c.class
  end

  it 'should create text_record' do
    assert_equal "This is my text string.", @c.text_string
  end

  it 'should create Text shape' do
    assert_equal RectStruct, @c.shape.class 
    assert_equal 100, @c.shape.width 
    assert_equal 200, @c.shape.height 
  end

  it 'should have fill' do
    assert_equal FillStruct, @c.fill.class
    assert_equal "CMYK=0,0,0,0", @c.fill.color 
  end

  it 'should have stroke' do
    assert_equal StrokeStruct, @c.stroke.class
    assert_equal 'CMYK=0,0,0,100', @c.stroke.color 
    assert_equal 0, @c.stroke.thickness
  end
end

describe 'generate random graphics' do
  before do
    @g = Graphic.random_graphics(200)
    @path = "/Users/Shared/rlayout/output/graphic_random_test.svg"
  end

  it 'should create Graphic' do
    assert_kind_of Array, @g 
  end
end
