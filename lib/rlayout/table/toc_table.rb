
INLINE_TAB_RX = /(\t)/

# make TocTableRow layout_expand: nil
# token layout_expand: nil
module RLayout

  class TocTable < Container
	
	  def initialize(options={})
	    super
	    self
	  end
	  
	  def layout_items(paragraphs)
      if paragraphs.first[:markup] == "h2"
        title_para = paragraphs.shift
        options = {}
        options[:parent]        = self
        options[:text_string]   = title_para[:para_string]
        options[:font_size]     = 20
        options[:text_alignment]= "center"
        options[:layout_expand] = :width
        options[:height]        = 70
        Text.new(options)
      end
      
      paragraphs.each do |row_options|
        row_options[:parent]  = self
        row_options[:height]  = 30
        row_options[:width]   = @width - @left_margin - @right_margin
        row_options[:x]       = @left_margin
        TocTableRow.new(row_options)
      end
      relayout!      
	  end
  end

	
	class TocTableRow < Container
	  attr_accessor :para_string, :markup
	  def initialize(para)
	    super
	    @layout_direction   = "horizontal"
      @layout_expand      = :nil
      @width              = @parent_graphic.width - @left_margin - @right_margin
      @markup             = para[:markup]
      @para_string        = para[:para_string]
      @items              = @para_string.split(INLINE_TAB_RX)
      @column_width_array = [2,4,1]
      column_width_sum    = @column_width_array.reduce(:+)
      @column_width_array.map!{|e| @width*e/column_width_sum}
      @items.each_with_index do |item, i|
        if i == 0
          token = TextToken.new(string: item, atts: para[:atts])
          TocTextCell.new(parent: self, width: @column_width_array[i], token: token, h_alignment: "left", atts: para[:atts], layout_expand: :nil, x: @left_margin)
        elsif item == "\t"
          LeaderToken.new(parent:self, width: @column_width_array[i], layout_expand: :nil , x: @column_width_array[0])            
        elsif i == 2
          token = TextToken.new(string:item, atts: para[:atts], layout_expand: nil)
          x = (@left_margin + @column_width_array[0] + @column_width_array[1])
          TocTextCell.new(parent: self, width: @column_width_array[i], token: token, h_alignment: 'right', layout_expand: :nil, x: x)
        end
      end
	  end
	end
	

  class TocTextCell < Container
    attr_accessor :h_alignment, :v_alignment, :token
    attr_accessor :atts
    def initialize(options={})
      super
      @layout_expand = nil
      @layout_direction = "horizontal"
      @token          = options[:token]
      @atts           = options[:atts]
      @layout_length  = @width
      @h_alignment    = options.fetch(:h_alignment, "left")
      @height         = @token.height
      @token.parent_graphic = self
      @graphics << token
      align_token
      self
    end
    
    def align_token
      @margin = 2
      @space = @width - @token.width - @margin*2
      if @space <= @margin
        @x = 0
        return
      end
      case @h_alignment
      when 'left'
        @token.x = @margin   
      when 'center'
        @token.x = @margin + @space/2 
      when 'right'
        @token.x = @margin + @space      
      else
        @token.x = @margin
      end
      
    end
  end
  
end