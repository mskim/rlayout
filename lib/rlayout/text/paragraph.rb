module RLayout 
  class Paragraph < Container
    attr_accessor :breakable, :part # head, body, tail
    attr_accessor :markup, :para_string, :tokens, :line_height
    def initialize(parent_graphic, options={})
      super
      @klass = "Paragraph"
      @layout_expand = []
      @para_string  = options.fetch(:para_string,"")
      @markup       = options.fetch(:markup,'p')
      @text_font    = options.fetch(:text_font,'Times')
      @text_size    = options.fetch(:text_size,16)
      @text_color   = options.fetch(:text_color, 'black')
      @layout_space = options.fetch(:layout_space, 10)
      @left_inset  = 4
      @right_inset = 4
      @top_margin   = 3
      @line_color = 'red'
      @line_width = 1
      
      self
    end
        
    # create a line 
    def add_line
      t =TextLine.new(self, :x=>@left_inset, :width=>(@width - @left_inset - @right_inset) , :height=>@line_height, :layout_space=>@text_size/4, :layout_expand=>[:width], :line_width=>1, :line_color=>'yellow' )
      puts "+++++++++++ t.x:#{t.x}"
      puts t.width
      t
    end
    
    # This is very similar to layout_items for ObjectBox
    # The difference is we are adding tokens to lines instead of adding flowing items to columns
    # TextLines get added as we need them, where as colums are not add for ObjectBox layout
    # TextLines size are change with token size,  where as colum size is fixed and flowing item size are chamged.

    def layout_lines 
      # create line as we layout tokens
      # clear lines
      @graphics = []
      #TODO I should look this up in the width table, but for now make the widht as 70% of the font size
      # total_with = @text_string.length*@text_size
      # lines = total_with / @width
      @para_string.split("").each_slice(@width/@text_size.to_i) do |a| 
        line_string = a.join("")
        TextLine.new(self, :text_string=>line_string, :x=>@left_inset, :width=>(@width - @left_inset - @right_inset) , :height=>@line_height, :layout_space=>@text_size/4, :layout_expand=>[:width], :line_width=>1, :line_color=>'yellow' )
      end
    end

    def change_width_and_adjust_height(new_width)
      @width = new_width
      layout_lines
      # TODO
      # change height
    end
        
    def to_svg
      if @parent_graphic
        return svg
      else
        svg_string = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n"
        svg_string += svg
        svg_string += "</svg>\n"
        return svg_string
      end
    end
    
    def svg
        s = "<rect x=\"#{@x}\" y=\"#{@y}\" width=\"#{@width}\" height=\"#{@height}\""
        if @fill_color!=nil && @fill_color != ""
          s+= " fill=\"#{@fill_color}\""
        end
        if @line_width!=nil && @line_width > 0
          s+= " stroke=\"#{@line_color}\""
          s+= " stroke-width=\"#{@line_width}\""
        end
        s+= "></rect>\n"
        
        if @text_string !=nil && @text_string != ""
          s += "<text font-size=\"#{@text_size}\" x=\"#{@x}\" y=\"#{@y}\" fill=\"#{@text_color}\">#{@text_string}</text>\n"
        end
        s
    end
    
    def self.generate(number)
      list = []
      text = "One two  three four five six seven eight nine ten eleven twelve thirteen."
      number.times do
        list << Paragraph.new(nil, :para_string=>text)
      end
      list
    end
  end
  
  
end