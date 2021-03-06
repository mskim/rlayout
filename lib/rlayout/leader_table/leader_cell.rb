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


  class LeaderCell < Text
    attr_reader :leader_char 
    attr_accessor :column_index, :row_index
    attr_accessor :column_index, :row_index
    attr_accessor :style_object
    def initialize(options={})
      # options[:stroke_width] = 1.0
      options[:text_alignment] = 'center'
      options[:v_alignment] = 'center'
      super
      # @height = @parent.height if @parent
      # @text_alignment = 'center'
      # @v_alignment    = 'center'
      # @stroke[:thickness] = 1
      # @stroke[:color] = 'red'
      # @fill[:color] = 'blue'
      # @layout_expand = nil
      # @layout_expand = :width
      @has_text = true
      fillup_with_leader
      self
    end
    
    def fillup_with_leader
      # if parent.leader_style_object
      #   @style_object = parent.leader_style_object
      # else
        @current_style_service = RLayout::StyleService.shared_style_service
        @style_object = @current_style_service.style_object_from_para_style(para_style) 
      # end
      @font_wrapper = @style_object.font
      @font_size = @style_object.font_size
      @string_width = @font_size/4.0
      # @string_width = glyphs.map{|g| @style_object.scaled_item_width(g)}.reduce(:+)
      if @string_width < @width
        room = @width - @string_width
        multiples = (room/@string_width).round
        @text_string = @text_string*multiples if multiples > 0
        set_string_width
      end
    end

    def para_style
      h = {}
      h[:font]                = @font       || 'KoPubDotumPL'
      h[:font_size]           = @font_size  || 12
      h[:tracking]            = @tracking   || 0     
      h[:scale]               = @scale      || 100  
      h
    end

  end
end

