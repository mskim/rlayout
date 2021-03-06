require File.dirname(File.expand_path(__FILE__)) + "/../../spec_helper"

describe 'create Graphic svg ' do
  before do
    @g = Graphic.new(:x=>200, :y=>400, :width=>500, :height=>200, :fill_color=>"yellow", stroke_thickness: 3, stroke_color: 'black')
    @svg_path = "#{ENV["HOME"]}/test_data/svg/graphic_test.svg"
  end

  it 'should save svg' do
    @g.save_svg(@svg_path)
    assert File.exist?(@svg_path) == true
    system "open #{@svg_path}"
  end
end

describe 'create Circle svg ' do
  before do
    @g = Circle.new(:x=>400, :y=>400, :fill_color=>"red")
    @svg_path = "#{ENV["HOME"]}/test_data/svg/circle_test.svg"
  end

  it 'should save svg' do
    @g.save_svg(@svg_path)
    assert File.exist?(@svg_path) == true
    system "open #{@svg_path}"
  end
end

describe 'create RoundRect svg ' do
  before do
    @g = RoundRect.new(:x=>400, :y=>400, :fill_color=>"yellow")
    @svg_path = "#{ENV["HOME"]}/test_data/svg/round_rect_test.svg"
  end
  it 'should save svg' do
    @g.save_svg(@svg_path)
    assert File.exist?(@svg_path) == true
    system "open #{@svg_path}"
  end
end

describe 'create Ellipse svg ' do
  before do
    @g = Ellipse.new(:x=>500, :y=>200, :width=>500, :height=>200, :fill_color=>"gray")
    @svg_path = "#{ENV["HOME"]}/test_data/svg/ellipse_test.svg"
  end
  it 'should save svg' do
    @g.save_svg(@svg_path)
    assert File.exist?(@svg_path) == true
    system "open #{@svg_path}"
  end
end

describe 'create Line svg ' do
  before do
    @g = Line.new(:x=>20, :y=>30, :x2=>500, :y2=>200, :line_color=>"orange")
    @svg_path = "#{ENV["HOME"]}/test_data/svg/line_test.svg"

  end
  it 'should save svg' do
    @g.save_svg(@svg_path)
    assert File.exist?(@svg_path) == true
    system "open #{@svg_path}"
  end
end

describe 'create Image svg ' do
  before do
    @image_path = "#{ENV["HOME"]}/test_data/images/1.jpg"
    @g = Image.new(:image_path=> @image_path)
    @svg_path = "#{ENV["HOME"]}/test_data/svg/image_test.svg"

  end 
  it 'should save svg' do
    @g.save_svg(@svg_path)
    assert File.exist?(@svg_path) == true
    system "open #{@svg_path}"
  end
end

describe 'create Text svg ' do
  before do
    @g = Text.new(text_string: "This is a text test.")
    @svg_path = "#{ENV["HOME"]}/test_data/svg/text_test.svg"

  end
  it 'should save svg' do
    @g.save_svg(@svg_path)
    assert File.exist?(@svg_path) == true
    system "open #{@svg_path}"
  end
end

__END__
describe 'parse SVG text ' do
  before do
    @svg_text =<<SVG
<svg height="210" width="500">
  <polygon points="200,10 250,190 160,210" style="fill:lime;stroke:purple;stroke-width:1" />
</svg>
SVG
    @h  = Graphic.from_svg(@svg_text)
    puts @h
    # @svg_path = "/Users/Shared/rlayout/output/graphic_test.svg"
  end

  it 'parse svg text' do
    @h.must_be_kind_of Graphic
  end
end
