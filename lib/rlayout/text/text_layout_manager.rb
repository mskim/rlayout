framework 'cocoa'

module RLayout
  class TextLayoutManager
    attr_accessor :att_string, :text_container, :line_fragments, :token_list
    attr_accessor :current_token_index, :text_direction
    attr_accessor :width, :height # TODO remove this use text_container
    def initialize(text_container, options={})
      @att_string     = make_att_string(options)
      @text_container = text_container
      @text_direction = options.fetch(:text_direction, 'left_to_right') # top_to_bottom for Japanese
      @width          = @text_container[2]
      @height         = @text_container[3]
      # line_fragments  = []
      # make_tokens
      # layout_lines_custom
      layout_lines
      self
    end
        
    def make_att_string(options)
      #TODO
      # implement text_fit_type
      # atts[NSKernAttributeName] = @text_track           if @text_track
      # implement inline element, italic, bold, underline, sub, super, emphasis(color)
      if options[:attrs_array]
        @atts_array = options[:attrs_array]
        # layout_lines(:attrs_array=>options[:attrs_array])
      elsif options[:text_string] || options[:text_size] #&& options[:text_string]!=""
        @text_markup    = options.fetch(:text_markup, 'p')
        @text_markup    = options.fetch(:markup, "p")
        @text_string    = options.fetch(:text_string, "")
        @text_color     = options.fetch(:text_color, "black")
        @text_font      = options.fetch(:text_font, "Times")
        @text_size      = options.fetch(:text_size, 16)
        @text_line_spacing= options.fetch(:text_line_spacing, @text_size*1.5)
        @text_fit_type  = options.fetch(:text_fit_type, 0)
        @text_alignment = options.fetch(:text_alignment, "center")
        @text_first_line_head_indent    = options.fetch(:text_first_line_head_indent, nil)
        @text_head_indent               = options.fetch(:text_head_indent, nil)
        @text_tail_indent               = options.fetch(:text_tail_indent, nil)
        @text_paragraph_spacing_before  = options[:text_paragraph_spacing_before] if options[:text_paragraph_spacing_before]
        @text_paragraph_spacing         = options[:text_paragraph_spacing]        if options[:text_paragraph_spacing]
        
      end
      
      atts={}
      
      atts[NSFontAttributeName]             = NSFont.fontWithName(@text_font, size:@text_size)
      atts[NSForegroundColorAttributeName]  = @text_color      

      if @guguri_width && @guguri_width < 0
        atts[NSStrokeWidthAttributeName] = atts_hash[:guguri_width] #0, -2,-5,-10 
        atts[NSStrokeColorAttributeName]=GraphicRecord.color_from_string(attributes[:guguri_color])
      end 
      
      right_align   = NSMutableParagraphStyle.alloc.init.setAlignment(NSRightTextAlignment)          
      center_align  = NSMutableParagraphStyle.alloc.init.setAlignment(NSCenterTextAlignment)          
      justified_align  = NSMutableParagraphStyle.alloc.init.setAlignment(NSJustifiedTextAlignment)          
      newParagraphStyle  = NSMutableParagraphStyle.alloc.init
      case @text_alignment
      when "right"
        newParagraphStyle = right_align
      when "center"
        newParagraphStyle = center_align
      when 'justified'
        newParagraphStyle = justified_align
      end
      newParagraphStyle.setLineSpacing(@text_line_spacing) if @text_line_spacing
      newParagraphStyle.setFirstLineHeadIndent(@text_first_line_head_indent) if @text_first_line_head_indent
      newParagraphStyle.setHeadIndent(@text_head_indent) if @text_head_indent
      newParagraphStyle.setTailIndent(@text_tail_indent) if @text_tail_indent
      atts[NSParagraphStyleAttributeName] = newParagraphStyle         
      att_string=NSMutableAttributedString.alloc.initWithString(@text_string, attributes:atts)
      att_string
    end
    
    
    def make_tokens
      starting = 0
      # def initialize(att_string, start, length, text_direction)
      @token_list = []
      @att_string.string.split(" ").collect do |token_string|
        @token_list << TextToken.new(@att_string, starting, token_string.length, @text_direction, 'text_kind')
        starting += token_string.length
        @token_list << TextToken.new(@att_string, starting, 1, @text_direction, 'space_kind')
        starting += 1
      end
      @token_list.last.token_type = 'end_of_para'
    end
    
    def body_line_height_multiple(head_para_height)
      puts __method__
      puts "head_para_height:#{head_para_height}"
      # TODO
      # @style_service = @style_service ||= StyleService.new
      # body_height = @style_service.body_height
      body_height = 12
      body_multiple = body_height
      while body_multiple <= head_para_height
        body_multiple += body_height
      end
      body_multiple
    end
    
    
    def layout_lines(options={})
      if RUBY_ENGINE =='macruby'        
        text_storage  = NSTextStorage.alloc.init
        
        if options[:attrs_array]
          # text_storage = atts_array_to_att_string(options[:attrs_array])
          text_storage.setAttributedString(@att_string)
        else
          # text_storage  = NSTextStorage.alloc.initWithString(@text_string, attributes:atts)
          text_storage.setAttributedString(@att_string)
          
        end
                
        if @text_direction == 'left_to_right'
          text_container = NSTextContainer.alloc.initWithContainerSize([@width,1000])
          layout_manager = NSLayoutManager.alloc.init
          layout_manager.addTextContainer(text_container)
          text_storage.addLayoutManager(layout_manager)
          text_container.setLineFragmentPadding(0.0)
          layout_manager.glyphRangeForTextContainer(text_container)
          used_size=layout_manager.usedRectForTextContainer(text_container).size
          @height = used_size.height + @text_line_spacing
          
          if @text_markup && @text_markup != 'p' #&& options[:aling_to_grid]
            # puts "Make the head paragraph height as body text multiples"
            # by adjusting @top_margin and @bottom_margin around it
            body_multiple_height = body_line_height_multiple(@height)
            @text_paragraph_spacing_before = (body_multiple_height - @height)/2
            @text_paragraph_spacing        = @text_paragraph_spacing_before
            # @top_margin = (body_multiple_height - @height)/2
            # @bottom_margin = @top_margin
            @height = body_multiple_height
          end
        else
          # for vertival text
          # TODO using NSASTysetter sub class
          #  1. rotate glyphs 90 to left, except English and numbers
          #  1. rotate line 90 to right
          
          # NSLineBreakByCharWrapping
          
          # issues
          #  1. line height control
          #  1. horozontal alignment for non-square English, and commas.
          #  1. English string that rotates
          #  1. Two or more digit Numbers
          #  1. Commas, etc....
           
          v_line_count = @width/(@text_size + @text_line_spacing)
          y = @top_margin + @top_inset
          width = @text_size*0.7
          x = @width - width
          heigth = @height
          @vertical_lines = []
          v_line_count.to_i.times do
            @vertical_lines << NSMakeRect(x,y,width,height)
            x -= @text_size + @text_line_spacing
          end
          layout_manager = NSLayoutManager.alloc.init        
          text_storage.addLayoutManager(@layout_manager)
          @vertical_lines.each do |v_line|
            @text_container = NSTextContainer.alloc.initWithContainerSize(v_line.size)
            @text_container.setLineFragmentPadding(0.0)
            @layout_manager.addTextContainer(@text_container)
            glyphRange=@layout_manager.glyphRangeForTextContainer(@text_container) 
            # if layout is done  
            # @height = body_multiple_height
            # origin = v_line.origin
            # origin.y = origin.y
            # @layout_manager.drawGlyphsForGlyphRange(glyphRange, atPoint:v_line.origin)
          end
          
          
        end
      else
        # TODO
        # for non -macruby env
        # adjust height
        
      end
      
    end
    
    
    def layout_lines_custom
      current_token_index = 0
      y = 0
      height = @token_list[current_token_index].rect[3]
      # def initialize(token_list, starting_token_index,  proposed_rect, text_direction)
      proposed_rect = [0, y, @text_container[2], height]
      line = TextLine.new(@token_list, current_token_index, proposed_rect, @text_direction)
      puts "line:#{line}"
      current_token_index += line.length
      puts "line.last_token_index:#{line.last_token_index}"
      unless line.last_token_index == @token_list.length
        line = TextLine.new(current_token_index, current_token_index, proposed_rect, @text_direction)
        current_token_index += line.length
        y+= line[3]
      end
    end
    
    def shown_text_index
    
    end
    
    def line_height_sum
      
    end
    
    def draw_text(options={})
      
    end
  end
  
  class TextLine
    attr_accessor :text_container, :token_list, :starting_token_index, :length
    attr_accessor :text_direction, :line_rect
    
    def initialize(token_list, starting_token_index,  proposed_rect, text_direction)
      @token_list           = token_list
      @starting_token_index = starting_token_index
      @line_rect            = proposed_rect
      @length               = 0
      layout_line
      self
    end
    
    def last_token_index
      puts __method__
      puts "@starting_token_index:#{@starting_token_index}"
      puts "@length:#{@length}"
      @starting_token_index + @length
    end
    
    def layout_line
      if @text_direction == 'left_to_right'
        current_x = 0
        unless (current_x + @token_list[starting_token_index + @length].width) >= line_rect[2]
          @length +=1
        end
      elsif @text_direction == 'top_to_bottom'
      
      end
      # do alignment of line
      
    end
    
    def draw_line(att_string)
      # @token_line[starting_token..length].each do |token|
      #   token.draw_token(att_string)
      # end
    end
    
  end
  
  class TextToken
    attr_accessor :start, :length, :rect
    attr_accessor :text_direction
    attr_accessor :token_type, :language, :token_type
  
    def initialize(att_string, start, length, text_direction, token_type)
      @text_direction = text_direction
      @start          = start
      @length         = length
      @token_type     = token_type
      layout_token(att_string)
      self
    end
  
    def layout_token(att_string)
      if @text_direction == 'left_to_right'
        token_att_string = att_string
        if @token_type == 'text_kind'
          @rect= [0,0,length*12, 12]
        else
          @rect= [0,0,6,12]
        end
      elsif @text_direction == 'top_to_bottom'
         puts "vertical case"
      end
      
    end
    
    def draw_token(att_string)
      
    end
  end
  
end


require 'minitest/autorun'
include RLayout

describe 'create TextLayoutManager' do
  before do
    # @att_string = {:fill_color=>'lightGray', :text_first_line_head_indent=>10, :text_paragraph_spacing_before=>10, :width=>200, :text_alignment=>'justified', :text_string=>"This is a paragraph test string and it looks good to me.", :markup=>'h6', :text_line_spacing=>10}
    options = {}
    options[:text_string]     = "This is some sample string."
    options[:text_direction]     = "left_to_right"
    @text_container = [0,0,300,200]
    @tlm = TextLayoutManager.new(@text_container, options)
  end
  
  it 'should create TextLayoutManager' do
    @tlm.must_be_kind_of TextLayoutManager
  end
  
  # it 'should create TextTokens' do
  #   @tlm.token_list.must_be_kind_of Array
  #   @tlm.token_list.length.must_equal 10
  #   @tlm.token_list.each do |token|
  #     puts token.inspect
  #   end
  # end
  
end