module RLayout
  # LeaderCell
  # LeaderCell is used for TOC, Jubo and Menu to fill up leader characters.
  # ex 
  # chapter1  ....................................       12
  # sermon    ............ loving others ......... Rev. Kim
  # hym       ................. 450 .............. everybody
  # stake     ....................................       $45
  # pasta     .....................................      $15


  # LeaderCell is a text token that draws leader characters, such as ...... 
  # It grows horizontally


  class LeaderCell < Graphic
    attr_reader :leader_char , :string
    def initialize(options={})
      @leader_char  = options[:leader_char] || '.'
      @string       = options[:string] || @leader_char*3
      @width        = options[:width]
      self
    end
  
    def draw_text(canvas)
      if @string.length > 0 && @para_style
        font_name = @para_style[:font] 
        size = @para_style[:font_size]
        text_color = @para_style[:text_color]
        text_color = "CMYK=0,0,0,100" unless text_color
        text_color = RLayout::color_from_string(text_color)
        canvas.fill_color(text_color) if text_color
        if canvas.font
          canvase_font_name = canvas.font.wrapped_font.font_name
          canvas_font_size  = canvas.font_size
          canvas_fill_color = canvas.fill_color
          if font_name == canvase_font_name && size == canvas_font_size
          elsif font_name != canvase_font_name
            font_foleder  = "/Users/Shared/SoftwareLab/font_width"
            font_file     = font_foleder + "/#{font_name}.ttf"
            doc           = canvas.context.document
            font_wapper   = doc.fonts.add(font_file)
            canvas.font(font_wapper, size: size)
          elsif size != canvas_font_size
            canvas.font(canvas.font, size: size)
          else
            font_foleder  = "/Users/Shared/SoftwareLab/font_width"
            font_file     = font_foleder + "/#{font_name}.ttf"
            doc           = canvas.context.document
            font_wapper   = doc.fonts.add(font_file)
            canvas.font(font_wapper, size: size)
          end
        else
          size = @para_style[:font_size] || 16
          font_foleder  = "/Users/Shared/SoftwareLab/font_width"
          font_file     = font_foleder + "/Shinmoon.ttf"
          font_file     = font_foleder + "/#{font_name}.ttf" if font_name
          doc           = canvas.context.document
          font_wapper   = doc.fonts.add(font_file)
          canvas.font(font_wapper, size: size)
        end

        f = flipped_origin
        x_offset = f[0]
        y_offset = f[1]
        canvas.text(@string, at: [x_offset, y_offset - size])
      end
    end
  
  end
end



  # fills the box with leader_character at run time
  # class LeaderCell < Text
  #   attr_accessor :leader_character, :is_leader
    
  #   def initialize(options={})
  #     options[:font_size] = parent.height - 4
  #     options[:height] = parent.height - 2
  #     @is_leader = options.fetch(:is_leader, false)
      
  #     @leader_character = options.fetch(:leader_character, ".")
  #     if @is_leader
  #       options[:text_string] = @leader_character
  #     end
  #     super
  #     self
  #   end
    
  #   def set_leader_char(width)
  #     puts __method__
  #     if RUBY_ENGINE == 'rubymotion'
  #       puts "@text_layout_manager.att_string.string.length:#{@text_layout_manager.att_string.string.length}"
  #       string_width = @text_layout_manager.att_string.size.width
  #       if string_width < width
  #         puts "sting is short"
  #       else
  #         puts "sting is long"
  #         puts "width:#{width}"
  #         puts "string_width:#{string_width}"
  #         count = string_width/width
  #         new_string = @leader_character*count
  #         @text_layout_manager.replace_string_with(new_string)
  #       end
  #       # leader_string = "."
  #       # while width > leader_string/2.0
  #       #   leader_string += "."
  #       # end
  #       # puts "leader_string.length:#{leader_string.length}"
        
  #     else
  #       leader_string = "."
  #       while width > leader_string/2.0
  #         leader_string += "."
  #       end
  #       puts "leader_string.length:#{leader_string.length}"
  #       # set 
  #     end
  #   end
    
  #   def is_leader?
  #     @is_leader
  #   end
    
  #   # adjust_cell_size by adjusting text font size and width according to given cell_height
  #   def adjust_cell_size(cell_height)
  #     # puts __method__
  #   end
  # end
  