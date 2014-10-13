require 'pry'

module RLayout
  
  class MyGraphic
    attr_accessor :fill, :text, :line
    def initialize
      @fill = {color: 'white', type: 0, other_color: 'white'}
      @text = {font: 'Times', size: 12, color: 'black'}
      self
    end    
  end
  
  LayoutRecord  = Struct.new(:direction, :space, :length, :expand) do
    
    
  end
  
  FillRecord    = Struct.new(:color, :type, :other_color) do
    
  end

  LineRecord    = Struct.new(:type, :color, :width, :dash, :edge) do
    
  end
  
  
  ImageRecord   = Struct.new(:path, :fit_mode, :image_rect) do
    
    
  end
  TEXT_RECORD_DEFAUALTS = {
    font: 'Times',
    
  }
  TextRecord    = Struct.new(:font, :size, :color, :alignment, :line_spacing,  :head_indent, :left_indent, :right_indent) do
    
    def to_data
      h={}
      h[:font] =font if font
      h[:size] =size if size
      h[:color] =color if color
      h[:alignment] =alignment if alignment
      h[:line_spacing] =line_spacing if line_spacing
      h[:head_indent] =head_indent if head_indent
      h[:left_indent] =left_indent if left_indent
      h[:right_indent] =right_indent if right_indent
      h
    end
    
    def serialize
      h={}
      h[:font] =font if font
      h[:size] =size if size
      h[:color] =color if color
      h[:alignment] =alignment if alignment
      h[:line_spacing] =line_spacing if line_spacing
      h[:head_indent] =head_indent if head_indent
      h[:left_indent] =left_indent if left_indent
      h[:right_indent] =right_indent if right_indent
      h
    end
    
    def defaults
      
    end
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