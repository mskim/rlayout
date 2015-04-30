require File.dirname(__FILE__) + "/../spec_helper"

describe 'test has_too_distored_frame?' do
  before do
    @p = RLayout::GridLayout.find_grid_layout_with(2)
    @g = @p[0]
  end
  it 'should has_too_distored_frame? ' do
    puts @g.frame_rects
    @g.has_too_distored_frame?.must_equal false
  end
  

end

__END__



describe 'test sort_frames_by_y_and_x' do
  before do
    @p = RLayout::GridLayout.find_grid_layout_with(5)
    @g = @p[2]
  end
  it 'should sort_frames_by_y_and_x ' do
    puts "before"
    @g.frames.each{|f| puts "f.frame:#{f.frame}"}
    
    @g.sort_frames_by_y_and_x
    puts "after"
    @g.frames.each{|f| puts "f.frame:#{f.frame}"}
  end


end

describe 'find_grid_layout_with(pattern)' do
  before do
    @p = RLayout::GridLayout.find_grid_layout_with(5)
  end
  
  it 'should find GridLayouts' do
    @p.must_be_kind_of Array
    @p.length.must_equal 4
  end
  
end

describe 'area test' do
  before do
    @p = RLayout::GridLayout.find_grid_layout_with(3)
  end
  
  it 'should calculate the are' do
    @g = @p.first
    @g.total_area.must_equal 9
  end
  
  it 'should sort the area' do
    @g = @p.first
    puts "before"
    @p.each do |gf|
      puts gf.grid_key
      puts gf.total_area
    end
    
    GridLayout.sort_by_area(@p)
    puts "after"
    @p.each do |gf|
      puts gf.grid_key
      puts gf.total_area
    end
    
  end

end

describe 'create GridLayout' do
  before do
    @g = RLayout::GridLayout.new("7x11/5", :frames=>[[0,0,1,1], [1,0,1,1]])
  end
  
  it 'should create GridLayout' do
    @g.must_be_kind_of RLayout::GridLayout
  end
  
  it 'should create @frames' do
    @g.frames.first.must_be_kind_of RLayout::Frame
    @g.frames.length.must_equal 2
  end
  
  it 'should flip horizontally' do
    @g.flip_horizontally
    @g.frames.first.frame.must_equal [6,0,1,1]
  end
  
  it 'should flip vertically' do
    @g.flip_vertically
    @g.frames.first.frame.must_equal [0,10,1,1]
  end
  

end

describe 'should detect for equl frames content' do
  it 'should detect for equal frames' do
    first = [[6,0,1,1],[0,10,1,1], [1,1,1,1]]
    second = [[1,1,1,1], [0,10,1,1], [6,0,1,1]]
    result = RLayout::GridLayout.has_equal_frames?(first, second)
    result.must_equal true
  end
  
end

describe 'should detect for has_heading? frames content' do
  before do
    @g = RLayout::GridLayout.new("7x11/H/5", :frames=>[[0,0,1,1], [1,0,1,1]])
  end
  it 'should detect has_heading?' do
    @g.has_heading?.must_equal true
  end
end