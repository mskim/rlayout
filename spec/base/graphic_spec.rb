require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe ' save_pdf of Graphic' do
  before do
    @g = Graphic.new(width:400, height: 400)
  end
  it 'should create Container' do
    assert Graphic, @g.class
  end

  it 'should save Container' do
    path = File.dirname(__FILE__) + "/saving_from_hexa.pdf"
    @g.save_pdf(path)
    assert File.exist?(path), true
  end
end

__END__


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
    @g.class.must_equal Graphic
  end
end

describe ' convert string to color' do
  before do
    color_string = "FF0000"
    @color = RLayout::color_from_hex(color_string)
  end
  it 'shuld convert hex color' do
    @color.must_equal "rgba(1.0,0.0,0.0,1)"
  end
end

describe 'create Graphic ' do
  before do
    @g = Graphic.new(parent:nil, :fill_color=>"blue")
  end

  it 'should create Graphic' do
    @g.class.must_equal Graphic
  end

  it 'should not have fill' do
    @g.fill.class.must_equal FillStruct
    @g.fill.color.must_equal 'blue'
  end

  it 'should create rect shape' do
    @g.shape.class.must_equal RectStruct
  end

  it 'should have stroke' do
    @g.stroke.class.must_equal StrokeStruct
    @g.stroke.color.must_equal 'black'
    @g.stroke.thickness.must_equal 0
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
    @g.fill.class.must_equal LinearGradient
  end
end

describe 'RadialFill ' do
  before do
    @g = Graphic.new(:starting_color=>"blue", :ending_color=>'red', :fill_type=>"radial")
  end
  it 'should create LinearFill' do
    @g.fill.class.must_equal RadialGradient
  end
end

describe 'create Circle' do
  before do
    @c = Circle.new(:width=>200, :height=>200)
  end
  it 'should create Circle' do
    @c.class.must_equal Circle
  end
  it 'should create CircleStruct shape' do
    @c.shape.class.must_equal CircleStruct
    @c.shape.r.must_equal 100
    @c.shape.cx.must_equal 100
    @c.shape.cy.must_equal 100
  end
  it 'should have fill' do
    @c.fill.class.must_equal FillStruct
    @c.fill.color.must_equal 'white'
  end
  it 'should have stroke' do
    @c.stroke.class.must_equal StrokeStruct
    @c.stroke.color.must_equal 'black'
    @c.stroke.thickness.must_equal 0
  end
end

describe 'create Ellipse' do
  before do
    @c = Ellipse.new(:width=>100, :height=>200, :fill_color=>"orange")
  end
  it 'should create Ellipse' do
    @c.class.must_equal Ellipse
  end

  it 'should create EllipseStruct shape' do
    @c.shape.class.must_equal EllipseStruct
    @c.shape.rx.must_equal 50
    @c.shape.ry.must_equal 100
  end

  it 'should have fill' do
    @c.fill.class.must_equal FillStruct
    @c.fill.color.must_equal 'orange'
  end

  it 'should have stroke' do
    @c.stroke.class.must_equal StrokeStruct
    @c.stroke.color.must_equal 'black'
    @c.stroke.thickness.must_equal 0
  end

  it 'should have stroke' do
    @c.stroke.class.must_equal StrokeStruct
    @c.stroke.color.must_equal 'black'
    @c.stroke.thickness.must_equal 0
  end

  it 'should save' do
    @path = "/Users/Shared/rlayout/output/graphic_color_test.svg"
    @c.save_svg(@path)
    # system "open #{@path}"
  end

end

describe 'create RoundRect' do
  before do
    @c = RoundRect.new(:width=>100, :height=>200)
  end
  it 'should create RoundRect' do
    @c.class.must_equal RoundRect
  end

  it 'should create RoundRectStruct shape' do
    @c.shape.class.must_equal RoundRectStruct
    @c.shape.rx.must_equal 10.0
    @c.shape.ry.must_equal 10.0
  end
  it 'should have fill' do
    @c.fill.class.must_equal FillStruct
    @c.fill.color.must_equal 'white'
  end
  it 'should have stroke' do
    @c.stroke.class.must_equal StrokeStruct
    @c.stroke.color.must_equal 'black'
    @c.stroke.thickness.must_equal 0
  end
end

describe 'create Image' do
  before do
    @c = Image.new(:image_path=> "my_image_path.jpg", :width=>100, :height=>200)
  end
  it 'should create Image' do
    @c.class.must_equal Image
    @c.image_path.must_equal "my_image_path.jpg"
  end

  it 'should create Image shape' do
    @c.shape.class.must_equal RectStruct
    @c.shape.width.must_equal 100
    @c.shape.height.must_equal 200
  end
  it 'should have fill' do
    @c.fill.class.must_equal FillStruct
    @c.fill.color.must_equal 'white'
  end
  it 'should have stroke' do
    @c.stroke.class.must_equal StrokeStruct
    @c.stroke.color.must_equal 'black'
    @c.stroke.thickness.must_equal 0
  end
end

describe 'create Text' do
  before do
    @c = Text.new(:text_string=> "This is my text string.", :width=>100, :height=>200)
  end
  it 'should create Text' do
    @c.class.must_equal Text
  end
  it 'should create text_record' do

    @c.text_record.string.must_equal "This is my text string."
  end

  it 'should create Text shape' do
    @c.shape.class.must_equal RectStruct
    @c.shape.width.must_equal 100
    @c.shape.height.must_equal 200
  end
  it 'should have fill' do
    @c.fill.class.must_equal FillStruct
    @c.fill.color.must_equal 'white'
  end
  it 'should have stroke' do
    @c.stroke.class.must_equal StrokeStruct
    @c.stroke.color.must_equal 'black'
    @c.stroke.thickness.must_equal 0
  end
end

describe 'generate random graphics' do
  before do
    @g = Graphic.random_graphics(200)
    @path = "/Users/Shared/rlayout/output/graphic_random_test.svg"
  end

  it 'should create Graphic' do
    @g.must_be_kind_of Array
  end
end


describe 'testing Text ' do
  before do
    @t = Text.new(width: 400,  text_string: "This is text string and I like it very much. Wouldn't you? "*4, font_size: 24, text_alignment: 'right')
  end

  it 'should create heading' do
    @t.must_be_kind_of Text
    @t.text_record.size.must_equal 24
  end

  it 'should save Text' do
    @svg_path = "/Users/Shared/rlayout/output/text_test.svg"
    @t.save_svg(@svg_path)
    File.exists?(@svg_path).must_equal true
  end

end
