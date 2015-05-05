require File.dirname(__FILE__) + "/../spec_helper"

describe 'color struct' do
  before do
    @c= ColorStruct.new('blue')
  end
  it 'should crete color' do
    assert @c['name'] == 'blue'
  end
  it 'should create random color' do
    assert COLOR_NAMES.include?(@c.sample) ==true
  end
end

describe 'cmyk color struct' do
  before do
    @cmyk = CMYKStruct.new(100,100,0,0)
  end
  
  it 'should test cmyk' do
    assert @cmyk[:c] == 100
  end
  
  it 'should have alpha of nil' do
    assert @cmyk[:a] == nil
  end
end

describe 'rgb color struct' do
  before do
    @rgb = RGBStruct.new(50,50,0,30)
  end
  
  it 'should test grb red' do
    assert @rgb[:r] == 50
  end
  
  it 'test test grb alpha' do
    assert @rgb[:a] == 30
  end
end

describe 'fill struct' do
  before do
    @fill = FillStruct.new('black')
  end
  
  it 'should test LinearGradient starting_color' do
    assert @fill[:color] == 'black'
  end
end

describe 'LinearGradient struct' do
  before do
    @lg = LinearGradient.new('black', 'white', 0, 10)
  end
  
  it 'should test LinearGradient starting_color' do
    assert @lg[:starting_color] == 'black'
  end
  
  it 'test LinearGradient ending_color' do
    assert @lg[:ending_color] == 'white'
  end
  
  it 'test LinearGradient steps' do
    assert @lg[:steps] == 10
  end
end

describe 'RadialGradient struct' do
  before do
    @lg = RadialGradient.new('black', 'white', 'center', 5)
  end
  it 'should test RadialGradient starting_color' do
    assert @lg[:starting_color] == 'black'
  end
  it 'test RadialGradient ending_color' do
    assert @lg[:ending_color] == 'white'
  end
  it 'test RadialGradient center' do
    assert @lg[:center] == 'center'
  end
  it 'test RadialGradient center' do
    assert @lg[:steps] == 5
  end
end

describe 'StrokeStruct struct' do
  before do
    @s= StrokeStruct.new('black', 2, [2,1,3,4])
  end
  it 'test StrokeStruct color' do
    assert @s[:color] == 'black'
  end
  it 'test StrokeStruct thickness' do
    assert @s[:thickness] == 2
  end
  it 'test StrokeStruct dash' do
    assert @s[:dash] == [2,1,3,4]
  end
  it 'test StrokeStruct type' do
    assert @s[:type] == nil
  end
end

describe 'CornersStruct struct' do
  before do
    @s= CornersStruct.new(0, 1, 0, 1)
  end
  it 'test CornersStruct top_left' do
    assert @s[:top_left] == 0
  end
  it 'test CornersStruct top_right' do
    assert @s[:top_right] == 1
  end
  it 'test CornersStruct bottom_right' do
    assert @s[:bottom_right] == 0
  end
  it 'test CornersStruct type' do
    assert @s[:type] == nil
  end
end

describe 'SidesStruct struct' do
  before do
    @s= SidesStruct.new(0, 1, 0, 1)
  end
  it 'test SidesStruct left' do
    assert @s[:left] == 0
  end
  it 'test SidesStruct top' do
    assert @s[:top] == 1
  end
  it 'test SidesStruct right' do
    assert @s[:right] == 0
  end
  it 'test SidesStruct bottom' do
    assert @s[:bottom] == 1
  end
  it 'test SidesStruct type' do
    assert @s[:type] == nil
  end
end

describe 'RectStruct struct' do
  before do
    @s= RectStruct.new(0, 1, 300, 400)
  end
  it 'test RectStruct x' do
    assert @s[:x] == 0
  end
  it 'test RectStruct top' do
    assert @s[:y] == 1
  end
  it 'test RectStruct right' do
    assert @s[:width] == 300
  end
  it 'test RectStruct bottom' do
    assert @s[:height] == 400
  end
  
end

describe 'RoundRectStruct struct' do
  before do
    @s= RoundRectStruct.new(0, 1, 300, 400, 10,10)
  end
  it 'test RoundRectStruct x' do
    assert @s[:x] == 0
  end
  it 'test RoundRectStruct top' do
    assert @s[:y] == 1
  end
  it 'test RoundRectStruct width' do
    assert @s[:width] == 300
  end
  it 'test RoundRectStruct height' do
    assert @s[:height] == 400
  end
  it 'test RoundRectStruct cx' do
    assert @s[:rx] == 10
  end
  it 'test RoundRectStruct cy' do
    assert @s[:ry] == 10
  end
end


describe 'CircleStruct struct' do
  before do
    @s= CircleStruct.new(20, 20, 300)
  end
  it 'test CircleStruct cx' do
    assert @s[:cx] == 20
  end
  it 'test CircleStruct cy' do
    assert @s[:cy] == 20
  end
  it 'test CircleStruct cy' do
    assert @s[:r] == 300
  end
end


describe 'EllipseStruct struct' do
  before do
    @s= EllipseStruct.new(500, 200, 300,200)
  end
  it 'test EllipseStruct cx' do
    assert @s[:cx] == 500
  end
  it 'test EllipseStruct cy' do
    assert @s[:cy] == 200
  end
  it 'test EllipseStruct rx' do
    assert @s[:rx] == 300
  end
  it 'test EllipseStruct ry' do
    assert @s[:ry] == 200
  end
end

describe 'LineStruct struct' do
  before do
    @s= LineStruct.new(500, 200, 300,200)
  end
  it 'test LineStruct cx' do
    assert @s[:x1] == 500
  end
  it 'test LineStruct cy' do
    assert @s[:y1] == 200
  end
  it 'test LineStruct rx' do
    assert @s[:x2] == 300
  end
  it 'test LineStruct ry' do
    assert @s[:y2] == 200
  end
end

describe 'PoligonStruct struct' do
  before do
    @s= PoligonStruct.new([500, 200, 300,200])
  end
  it 'test PoligonStruct points' do
    assert @s[:points] == [500, 200, 300,200]
  end
  it 'test PoligonStruct style' do
    assert @s[:style] == nil
  end
end

describe 'TextStruct struct' do
  before do
    @t= TextStruct.new('This is a string')
  end
  it 'should crete TextStruct' do
    assert @t['string'] == 'This is a string'
    assert @t['color'] == nil
    assert @t.members.first == :string
  end

end

describe 'ImageStruct struct' do
  before do
    @i= ImageStruct.new('my/image/path.jpg')
  end
  it 'should crete ImageStruct' do
    assert @i['image_path'] == 'my/image/path.jpg'
    assert @i['fit_type'] == nil
  end

end



