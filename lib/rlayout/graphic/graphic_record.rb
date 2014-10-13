require 'pry'

module RLayout
  GRID_DEFAUALTS = {
    cells:        Array.new,
    column_count: 6,
    row_count:    6,
    v_lines:      Array.new,
    h_lines:      Array.new,
    color:        "blue",
    rect:         [0,0,1,1],
    inset:        [0,0,0,0],
    unit_width:   0,
    unit_height:  0,
    show:         true,
  }
  
  def grid_data
    h={}
    h[:cells]        = @cells         if @cells
    h[:column_count] = @column_count  if @column_count
    h[:row_count]    = @row_count     if @row_count
    h[:v_lines]      = @v_lines       if @v_lines
    h[:h_lines]      = @h_lines       if @h_lines
    h[:color]        = @color         if @color
    h[:rect]         = @rect          if @rect
    h[:inset]        = @inset         if @inset
    h[:unit_width]   = @unit_width    if @unit_width
    h[:unit_height]  = @unit_height   if @unit_height
    h[:show]         = @show          if @show
    h
  end
  
  def grid_serialized
    h={}
    h[:cells]        = @cells         if @cells         && @cells         != GRID_DEFAUALTS[:cells]
    h[:column_count] = @column_count  if @column_count  && @column_count  != GRID_DEFAUALTS[:column_count]
    h[:row_count]    = @row_count     if @row_count     && @row_count     != GRID_DEFAUALTS[:row_count]
    h[:v_lines]      = @v_lines       if @v_lines       && @v_lines       != GRID_DEFAUALTS[:v_lines]
    h[:h_lines]      = @h_lines       if @h_lines       && @h_lines       != GRID_DEFAUALTS[:h_lines]
    h[:color]        = @color         if @color         && @color         != GRID_DEFAUALTS[:color]
    h[:rect]         = @rect          if @rect          && @rect          != GRID_DEFAUALTS[:rect]
    h[:inset]        = @inset         if @inset         && @inset         != GRID_DEFAUALTS[:inset]
    h[:unit_width]   = @unit_width    if @unit_width    && @unit_width    != GRID_DEFAUALTS[:unit_width]
    h[:unit_height]  = @unit_height   if @unit_height   && @unit_height   != GRID_DEFAUALTS[:unit_height]
    h[:show]         = @show          if @show          && @show          != GRID_DEFAUALTS[:show]
    h
    
  end
  
  LAYOUT_DEFAUALTS = {
    direction: 'vertical',
    space: 0,
    length: 1,
    expand: [:widht, :height]
  }
  
  def layout_data
    h={}
    h[:direction]        = @direction         if @direction
    h[:space] = @space  if @space
    h[:length]    = @length     if @length
    h[:expand]      = @expand       if @expand
    h
  end
  
  def layout_serialized
    h={}
    h[:direction]   = @direction  if @direction && @direction != LAYOUT_DEFAUALTS[:direction]
    h[:space]       = @space      if @space     && @space   != LAYOUT_DEFAUALTS[:space]
    h[:length]      = @length     if @length    && @length  != LAYOUT_DEFAUALTS[:length]
    h[:expand]      = @expand     if @expand    && @expand  != LAYOUT_DEFAUALTS[:expand]
    h
  end
  
  FILL_DEFAUALTS = {
    color: 'white',
    type: 0,
    other_color: 'gray',
  }
  
  def fill_data
    h={}
    h[:color]   = @color         if @color
    h[:type]   = @type  if @type
    h[:other_color]    = @other_color     if @other_color
    h
  end
  
  def fill_serialized
    h={}
    h[:color]   = @color  if @color && @color != FILL_DEFAUALTS[:color]
    h[:type]       = @type      if @type     && @type   != FILL_DEFAUALTS[:type]
    h[:other_color]      = @other_color     if @other_color    && @other_color  != FILL_DEFAUALTS[:other_color]
    h
  end

  LINE_DEFAUALTS = {
    color: 'black',
    width: '0',
    type: 0,
    dash: [1,0,1,0],
    edge: [1,1,1,1],
  }
  
  def line_data
    h={}
    h[:color]   = @color    if @color
    h[:width]   = @width    if @width
    h[:type]    = @type     if @type
    h[:dash]    = @dash     if @dash
    h[:edge]    = @edge     if @edge
    h
  end
  
  def line_serialized
    h={}
    h[:color]   = @color  if @color && @color != LINE_DEFAUALTS[:color]
    h[:width]   = @width  if @width && @width != LINE_DEFAUALTS[:width]
    h[:type]    = @type   if @type  && @type  != LINE_DEFAUALTS[:type]
    h[:dash]    = @dash   if @dash  && @dash  != LINE_DEFAUALTS[:dash]
    h[:edge]    = @edge   if @edge  && @edge  != LINE_DEFAUALTS[:edge]
    h
  end


  IMAGE_DEFAUALTS = {
    path: nil,
    fit_mode: 0,
    rect: [1,1,1,1],
  }
  
  def image_data
    h={}
    h[:path]          = @path         if @path
    h[:fit_mode]      = @fit_mode     if @fit_mode
    h[:rect]          = @rect         if @rect
    h
  end

  def image_serialized
    h={}
    h[:path]          = @path         if @path          && @path != IMAGE_DEFAUALTS[:path]
    h[:fit_mode]      = @fit_mode     if @fit_mode      && @fit_mode != IMAGE_DEFAUALTS[:fit_mode]
    h[:rect]          = @rect         if @rect          && @rect != IMAGE_DEFAUALTS[:rect]
    h
  end
  
  TEXT_DEFAUALTS = {
    font: 'Times',
    size: 16,
    color: 'black',
    alignment: 'center',
    line_spacing: 6,
    head_indent: 0,
    left_indent: 0,
    right_indent: 0,
  }
  
  def text_data
    h={}
    h[:font]          = @font         if @font
    h[:size]          = @size         if @size
    h[:color]         = @color        if @color
    h[:alignment]     = @alignment    if @alignment
    h[:line_spacing]  = @line_spacing if @line_spacing
    h[:head_indent]   = @head_indent  if @head_indent
    h[:left_indent]   = @left_indent  if @left_indent
    h[:right_indent]  = @right_indent if @right_indent
    h
  end

  def text_serialized
    h={}
    h[:font]          = @font         if @font          != TEXT_DEFAUALTS[:font]
    h[:size]          = @size         if @size          != TEXT_DEFAUALTS[:font]
    h[:color]         = @color        if @color         != TEXT_DEFAUALTS[:font]
    h[:alignment]     = @alignment    if @alignment     != TEXT_DEFAUALTS[:font]
    h[:line_spacing]  = @line_spacing if @line_spacing  != TEXT_DEFAUALTS[:font]
    h[:head_indent]   = @head_indent  if @head_indent   != TEXT_DEFAUALTS[:font]
    h[:left_indent]   = @left_indent  if @left_indent   != TEXT_DEFAUALTS[:font]
    h[:right_indent]  = @right_indent if @right_indent  != TEXT_DEFAUALTS[:font]
    h
  end

  
  
  GridRecord    = Struct.new(:direction, :space, :length, :expand) do
    
    
  end
  
  # attr_accessor :gutter_line_type, :gutter_line_width, :gutter_line_color, :gutter_line_dash
  # GutterRecord = Struct.new(:line_type, :line_width, :)
end

g = RLayout::MyGraphic.new
binding.pry
puts g

__END__
require 'minitest/autorun'
include RLayout

describe 'TextRecord' do
  before do
    @text = TextRecord.new('Times', 12, 'black')
  end
  it 'should have values' do
    @text.must_be_kind_of TextRecord
    @text.font.must_equal 'Times'
  end
  it 'should respond to to_data' do
    @text.to_data.must_be_kind_of Hash
    puts @text.to_data
    puts @text.font
  end
  it 'should set new value' do
    @text.font = "Helvetical"
    @text[:size] = 36
    puts @text.to_data
    @text.font.must_equal "Helvetical"
    @text.size.must_equal 36
  end
end