module RLayout
  LayoutRecord  = Struct.new(:direction, :space, :length, :expand) do
    
    
  end
  

  FillRecord    = Struct.new(:color, :type, :other_color) do
    
  end

  LineRecord    = Struct.new(:type, :color, :width, :dash) do
    
  end
  
  
  ImageRecord   = Struct.new(:path, :fit_mode, :image_rect) do
    
    
  end
  
  TextRecord    = Struct.new(:font, :size, :color, :line_spacing, :alignment) do
    def atts
    end
    
    def to_data
      {
        font: font,
        size: size,
        color: color,
        line_spacing: line_spacing,
        alignment: alignment,
        }
    end
    
    def to_hash
      
    end
    
    def defaults
      
    end
  end  
  
  
  GridRecord    = Struct.new(:direction, :space, :length, :expand) do
    
    
  end
  
  # attr_accessor :gutter_line_type, :gutter_line_width, :gutter_line_color, :gutter_line_dash
  # GutterRecord = Struct.new(:line_type, :line_width, :)
end

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
  it 'should respind to to_data' do
    @text.to_data.must_be_kind_of Hash
    puts @text.to_data
    puts @text.font
  end
end