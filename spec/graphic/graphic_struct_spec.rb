require 'minitest/autorun'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../..', 'lib')
require 'rlayout/graphic'
include RLayout

describe 'color struct' do
  before do
    @c= ColorStruct.new('blue')
  end
  it 'should crete color' do
    @c['name'].must_equal 'blue'
  end
  it 'should create random color' do
    COLOR_NAMES.include?(@c.sample).must_equal true
  end
end

describe 'cmyk color struct' do
  before do
    @cmyk = CMYKStruct.new(100,100,0,0)
  end
  
  it 'should test cmyk' do
    @cmyk[:c].must_equal 100
  end
  
  it 'should have alpha of nil' do
    @cmyk[:a].must_equal nil
  end
end

describe 'rgb color struct' do
  before do
    @rgb = RGBStruct.new(50,50,0,30)
  end
  
  it 'should test grb red' do
    @rgb[:r].must_equal 50
  end
  
  it 'test test grb alpha' do
    @rgb[:a].must_equal 30
  end
end

describe 'fill struct' do
  before do
    @fill = FillStruct.new('black')
  end
  
  it 'should test LinearGradient starting_color' do
    @fill[:color].must_equal 'black'
  end
end

describe 'LinearGradient struct' do
  before do
    @lg = LinearGradient.new('black', 'white', 0, 10)
  end
  
  it 'should test LinearGradient starting_color' do
    @lg[:starting_color].must_equal 'black'
  end
  
  it 'test LinearGradient ending_color' do
    @lg[:ending_color].must_equal 'white'
  end
  
  it 'test LinearGradient steps' do
    @lg[:steps].must_equal 10
  end
end

describe 'RadialGradient struct' do
  before do
    @lg = RadialGradient.new('black', 'white', 'center', 5)
  end
  it 'should test RadialGradient starting_color' do
    @lg[:starting_color].must_equal 'black'
  end
  it 'test RadialGradient ending_color' do
    @lg[:ending_color].must_equal 'white'
  end
  it 'test RadialGradient center' do
    @lg[:center].must_equal 'center'
  end
  it 'test RadialGradient center' do
    @lg[:steps].must_equal 5
  end
end

describe 'StrokeStruct struct' do
  before do
    @s= StrokeStruct.new('black', 2, [2,1,3,4])
  end
  it 'test StrokeStruct color' do
    @s[:color].must_equal 'black'
  end
  it 'test StrokeStruct thickness' do
    @s[:thickness].must_equal 2
  end
  it 'test StrokeStruct dash' do
    @s[:dash].must_equal [2,1,3,4]
  end
  it 'test StrokeStruct type' do
    @s[:type].must_equal nil
  end
end


describe 'RectStruct struct' do
  before do
    @s= RectStruct.new(0, 1, 300, 400)
  end
  it 'test RectStruct x' do
    @s[:x].must_equal 0
  end
  it 'test RectStruct top' do
    @s[:y].must_equal 1
  end
  it 'test RectStruct right' do
    @s[:width].must_equal 300
  end
  it 'test RectStruct bottom' do
    @s[:height].must_equal 400
  end
  
end

describe 'RoundRectStruct struct' do
  before do
    @s= RoundRectStruct.new(0, 1, 300, 400, 10,10)
  end
  it 'test RoundRectStruct x' do
    @s[:x].must_equal 0
  end
  it 'test RoundRectStruct top' do
    @s[:y].must_equal 1
  end
  it 'test RoundRectStruct width' do
    @s[:width].must_equal 300
  end
  it 'test RoundRectStruct height' do
    @s[:height].must_equal 400
  end
  it 'test RoundRectStruct cx' do
    @s[:rx].must_equal 10
  end
  it 'test RoundRectStruct cy' do
    @s[:ry].must_equal 10
  end
end


describe 'CircleStruct struct' do
  before do
    @s= CircleStruct.new(20, 20, 300)
  end
  it 'test CircleStruct cx' do
    @s[:cx].must_equal 20
  end
  it 'test CircleStruct cy' do
    @s[:cy].must_equal 20
  end
  it 'test CircleStruct cy' do
    @s[:r].must_equal 300
  end
end


describe 'EllipseStruct struct' do
  before do
    @s= EllipseStruct.new(500, 200, 300,200)
  end
  it 'test EllipseStruct cx' do
    @s[:cx].must_equal 500
  end
  it 'test EllipseStruct cy' do
    @s[:cy].must_equal 200
  end
  it 'test EllipseStruct rx' do
    @s[:rx].must_equal 300
  end
  it 'test EllipseStruct ry' do
    @s[:ry].must_equal 200
  end
end

describe 'LineStruct struct' do
  before do
    @s= LineStruct.new(500, 200, 300,200)
  end
  it 'test LineStruct cx' do
    @s[:x1].must_equal 500
  end
  it 'test LineStruct cy' do
    @s[:y1].must_equal 200
  end
  it 'test LineStruct rx' do
    @s[:x2].must_equal 300
  end
  it 'test LineStruct ry' do
    @s[:y2].must_equal 200
  end
end

describe 'PoligonStruct struct' do
  before do
    @s= PoligonStruct.new([500, 200, 300,200])
  end
  it 'test PoligonStruct points' do
    @s[:points].must_equal [500, 200, 300,200]
  end
  it 'test PoligonStruct style' do
    @s[:style].must_equal nil
  end
end

describe 'TextStruct struct' do
  before do
    @t= TextStruct.new('This is a string')
  end
  it 'should crete TextStruct' do
    @t['string'].must_equal 'This is a string'
    @t['color'].must_equal nil
    @t.members.first.must_equal :string
  end

end

describe 'ImageStruct struct' do
  before do
    @i= ImageStruct.new('my/image/path.jpg')
  end
  it 'should crete ImageStruct' do
    @i['image_path'].must_equal 'my/image/path.jpg'
    @i['fit_type'].must_equal nil
  end

end



