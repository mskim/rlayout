require File.dirname(__FILE__) + "/../spec_helper"

describe 'create Graphic svg ' do
  before do
    @g = Graphic.new(:x=>200, :y=>400, :fill_color=>"blue")
    @svg_path = "/Users/Shared/rlayout/output/graphic_test.svg"
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
    @svg_path = "/Users/Shared/rlayout/output/circle_test.svg"
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
    @svg_path = "/Users/Shared/rlayout/output/round_rect_test.svg"
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
    @svg_path = "/Users/Shared/rlayout/output/ellipse_test.svg"
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
    @svg_path = "/Users/Shared/rlayout/output/line_test.svg"
  end
  it 'should save svg' do
    @g.save_svg(@svg_path)
    assert File.exist?(@svg_path) == true
    system "open #{@svg_path}"
  end
end

describe 'create Image svg ' do
  before do
    @image_path = "/Users/Shared/rlayout/image/1.jpg"
    @g = Image.new(nil,:image_path=> @image_path)
    @svg_path = "/Users/Shared/rlayout/output/image_test.svg"
  end
  it 'should save svg' do
    @g.save_svg(@svg_path)
    assert File.exist?(@svg_path) == true
    system "open #{@svg_path}"
  end
end

describe 'create Text svg ' do
  before do
    @g = Text.new(nil,:text_string=> "This is a text test.")
    @svg_path = "/Users/Shared/rlayout/output/text_test.svg"
  end
  it 'should save svg' do
    @g.save_svg(@svg_path)
    assert File.exist?(@svg_path) == true
    system "open #{@svg_path}"
  end
end

