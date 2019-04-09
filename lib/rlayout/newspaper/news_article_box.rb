
# NewsArticleBox
# grid_frame is passed to detemine the width, height, and column_number of text_box
# Used when creating newspaper article, called from NewsBoxMaker

# show_overflow_lines
#
# 1. create NewsArticleBox
# 1. generate columns
#   1. create_lines
# 1. generate floats and layout floats
#   1. mark lines that over lapping floats
# 4.5*28.34646 = 12.755907
# 15*28.34646 = 425.1969

QUOTE_BOX_SPACE_BEFORE = 2

module RLayout
  class NewsArticleBox < NewsBox
    attr_accessor :heading_columns, :fill_up_enpty_lines
    attr_accessor :current_column, :current_column_index, :overflow, :underflow, :empty_lines
    attr_accessor :heading, :subtitle_box, :subtitle_in_head, :personal_image, :news_image
    attr_accessor :quote_box, :quote_box_size, :quote_position, :quote_x_grid, :quote_x_grid, :quote_v_extra_space, :quote_alignment, :quote_line_type 
    attr_accessor :starting_column_x, :gutter, :column_bottom
    attr_accessor :overflow_column, :page_number, :char_count, :has_profile_image
    attr_reader :announcement_column, :announcement_color, :boxed_subtitle_type, :subtitle_type
    attr_reader :overlap, :overlap_rect, :embedded, :has_left_side_bar
    attr_reader :stroke_x, :stroke_y, :stroke_width
    attr_reader :svg_content

    def initialize(options={}, &block)
      super
      @overflow           = false
      @page_number        = options[:page_number]
      @has_profile_image  = options[:has_profile_image]
      if @kind == '사설' || @kind == 'editorial'
        if @page_number && @page_number == 22
          @stroke.sides = [1,1,1,1]
          @left_margin  = @gutter
          @left_inset   = @gutter
        else
          @stroke.sides = [1,3,1,1]
          @left_inset   = @gutter
          @right_inset  = @gutter
        end
      elsif @kind == '기고' || @kind == 'opinion'
        @stroke.sides = [0,1,0,1] 
        @stroke.thickness = 0.3
      elsif @kind == '박스기고' || @kind == 'box_opinion'
        # @stroke.sides = [0,1,0,1]
        # if @top_position
        #   @top_margin += @body_line_height
        # end
        @top_margin   = @body_line_height
        if @on_right_edge
          @left_margin  = @body_line_height
          @left_inset   = @body_line_height
          @right_margin = @body_line_height
        else
          @right_margin = @body_line_height
          @right_inset  = @body_line_height
          @left_margin   = @body_line_height
        end
        # @stroke.sides = [0,1,0,1] 
        @stroke.thickness = 0.3
      elsif @kind == '책소개' || @kind == 'book_review'
        @has_left_side_bar = true
      elsif @kind == '특집' || @kind == 'special'
        @has_left_side_bar = true
        @stroke.sides = [1,2,1,1]
      elsif @kind == '부고-인사' || @kind == 'obitualry'

      else
        @stroke.sides = [0,0,0,1]
        @stroke.thickness = 0.3
      end
      @subtitle_type          = options[:subtitle_type] || '1단'
      @overlap                = options[:overlap]
      @embedded               = options[:embedded]
      @current_column_index   = 0
      @heading_columns        = @column_count      
      @heading_columns        = options[:heading_columns] if options[:heading_columns]
      @fill_up_enpty_lines    = options[:fill_up_enpty_lines] || false
      @boxed_subtitle_type    = options[:boxed_subtitle_type]
      @announcement_column    = options[:announcement_column]
      @announcement_color     = options[:announcement_color] || 'red'
      @quote_box_size         = options[:quote_box_size] || 0
      @quote_position         = options[:quote_position] || 3
      @quote_x_grid           = options[:quote_x_grid] || 1
      @quote_v_extra_space    = options[:quote_v_extra_space] || 0
      @quote_alignment        = options[:quote_alignment] || 'left'
      @quote_line_type        = options[:quote_line_type] || '상하' #'박스'
      @quote_box_column       = options[:quote_box_column] || 1

      create_columns
      if block
        instance_eval(&block)
      end
      make_overlap(@overlap) if @overlap
      if @floats.length > 0
        layout_floats!
      end
      self
    end

    def stroke_rect
      if @has_profile_image && (@page_number && @page_number == 22)
        [@x + @gutter, @y, @width - @left_margin, @height]
      elsif @on_left_edge && (@kind == '박스기고' || @kind == 'box_opinion')
        [@x + @left_margin, @y + top_margin ,@width - @left_margin - @right_margin - @gutter, @height - @top_margin - @bottom_margin]
      else
        [@x + @left_margin, @y + top_margin ,@width - @left_margin - @right_margin ,@height - @top_margin - @bottom_margin]
      end
    end
    # create news_columns
    #  news_columns are different from text_column
    def create_columns
      current_x = @starting_column_x
      if @kind == '사설' || @kind == 'editorial'
        editorial_column_width = @column_width*2 + @gutter - @left_margin - @left_inset - @right_inset
        if @heading_columns == 6
          editorial_column_width = @column_width
          @column_count.times do
            g= RColumn.new(:parent=>nil, x: current_x, y: 0, width: @column_width, height: @height, column_line_count: @column_line_count, body_line_height: @body_line_height, article_bottom_spaces_in_lines: @article_bottom_spaces_in_lines)
            g.parent = self
            @graphics << g
            current_x += @column_width + @gutter
            @column_type  = "editorial"
          end
        else
          @left_inset   = @gutter
          @stroke_sides = [1,1,0,1]
          # @right_inset  = 0
          if @has_profile_image || (@page_number && @page_number == 22)
            puts "we are at @page_number == 22 @has_profile_image"
            @column_type = "editorial_with_profile_image"
            editorial_column_width = @column_width*2 - @gutter # - @left_margin - @left_inset #- @right_inset
            current_x += @left_margin + @left_inset
            @starting_column_x = current_x
          else
            @column_type = "editorial"
            editorial_column_width = @column_width*2 + @gutter - @left_inset - @right_inset
            current_x += @gutter
            @starting_column_x = current_x
          end
          g= RColumn.new(:parent=>nil, column_type: @column_type, x: current_x, y: 0, width: editorial_column_width, height: @height, stroke_sides: @stroke_sides, column_line_count: @column_line_count, body_line_height: @body_line_height, article_bottom_spaces_in_lines: @article_bottom_spaces_in_lines)
          g.parent = self
          @graphics << g
        end
        # current_y += @top_margin + @top_inset
        @overflow_column = RColumn.new(:parent=>nil, column_type: "overflow_column", x: current_x, y: 0, width: @column_width, height: @height*20, column_line_count: @column_line_count*20, body_line_height: @body_line_height, article_bottom_spaces_in_lines: @article_bottom_spaces_in_lines)
        @overflow_column.parent = self
      elsif @kind == '박스기고' || @kind == 'box_opinion'
        @column_width = (@width - @gutter*3 - (@column_count - 1)*@gutter)/@column_count
        @stroke_x = current_x
        @stroke_y = @body_line_height
        current_x += @gutter
        @starting_column_x = current_x
        @column_count.times do
          g= RColumn.new(:parent=>nil, x: current_x, y: @body_line_height, width: @column_width, height: @height - @body_line_height, column_line_count: @column_line_count - 1, body_line_height: @body_line_height, article_bottom_spaces_in_lines: @article_bottom_spaces_in_lines)
          g.parent = self
          @graphics << g
          current_x += @column_width + @gutter
          @column_type  = "box_opinion"
        end

        @overflow_column = RColumn.new(:parent=>nil, column_type: "overflow_column", x: current_x, y: 0, width: @column_width, height: @height*20, column_line_count: @column_line_count*20, body_line_height: @body_line_height, article_bottom_spaces_in_lines: @article_bottom_spaces_in_lines)
        @overflow_column.parent = self
      else
        @column_count.times do
          g= RColumn.new(:parent=>nil, x: current_x, y: 0, width: @column_width, height: @height, column_line_count: @column_line_count, body_line_height: @body_line_height, article_bottom_spaces_in_lines: @article_bottom_spaces_in_lines)
          g.parent = self
          @graphics << g
          current_x += @column_width + @gutter
        end
        @overflow_column = RColumn.new(:parent=>nil, column_type: "overflow_column", x: current_x, y: 0, width: @column_width, height: @height*20, column_line_count: @column_line_count*20, body_line_height: @body_line_height, article_bottom_spaces_in_lines: @article_bottom_spaces_in_lines)
        @overflow_column.parent = self
      end
      @column_bottom = max_y(@graphics.first.frame_rect)
      link_column_lines
    end

    def link_column_lines
      previous_column_last_line = nil
      @graphics.each do |column|
        first_line                          = column.graphics.first
        last_line                           = column.graphics.last
        previous_column_last_line.next_line = first_line if previous_column_last_line
        previous_column_last_line           = last_line
      end
      previous_column_last_line.next_line   = @overflow_column.graphics.first
    end

    def is_top_story?
      @top_story
    end

    # # create lines that are adjusted for overflapping floats
    # # This is called after floats are layoued out.
    # def create_column_lines
    def overlapping_floats_with_column(column)
      overlapping_floats = []# IDEA: ndi
      @floats.each do |float|
        overlapping_floats << float if intersects_rect(column.frame_rect, float.frame_rect)
      end
      overlapping_floats
    end

    # adjust overlapping line_fragment text area
    # this method is called when float positions have changed
    def adjust_overlapping_columns
      @graphics.each_with_index do |column, i|
        overlapping_floats = overlapping_floats_with_column(column)
        column.adjust_overlapping_lines(overlapping_floats)
      end
    end

    def average_characters_per_line
      @graphics.first.average_characters_per_line
    end

    def suggested_number_of_characters
      #TODO
      article_box_lines_count*average_characters_per_line
    end

    def article_box_character_count
      character_count = 0
      @graphics.each_with_index do |column, i|
        character_count += column.char_count
      end
      character_count
    end

    def article_box_unoccupied_lines_count
      if @kind == '사설' || @kind == 'editorial'
        return @graphics[0].unoccupied_lines_count
      end
      unoccupied_lines_count = 0
      @graphics.reverse.each do |column_from_last|
        break if column_from_last.graphics.last.layed_out_line?
        unoccupied_lines_count += column_from_last.unoccupied_lines_count
      end
      unoccupied_lines_count
    end

    def article_box_lines_count
      available_lines = 0
      @graphics.each_with_index do |column, i|
        lines = column.available_lines_count
        available_lines += lines
      end
      available_lines
    end

    def save_article_info
      article_info                      = {}
      article_info[:column]             = @column_count
      article_info[:row]                = @row_count
      article_info[:is_front_page]      = @is_front_page
      article_info[:top_story]          = @top_story
      article_info[:top_position]       = @top_position
      article_info[:extended_line_count]= @extended_line_count if @extended_line_count
      article_info[:pushed_line_count]  = @pushed_line_count if @pushed_line_count
      article_info[:quote_box_size]     = @quote_box_size

      if @underflow
        # if we have author image at the bottom from layout
        @empty_lines -= 6 if @news_image
        article_info[:empty_lines]            = @empty_lines
      elsif @overflow
        # article_info[:overflow]              = true
        article_info[:overflow_line_count]    = @overflow_column.layed_out_line_count
        article_info[:overflow_text]          = overflow_text
      else
        # article_info[:lines_count]            = article_box_lines_count
        # article_info[:current_characters]     = article_box_character_count
        # article_info[:suggested_characters]   = suggested_number_of_characters
        # article_info[:needed_chars]           = suggested_number_of_characters - article_box_character_count
      end
      info_path = "#{$ProjectPath}/article_info.yml"
      File.open(info_path, 'w'){|f| f.write article_info.to_yaml}
    end

    def count_chars
      #code
    end

    def overflow_text
      return @overflow_column.overflow_text #if @over_flow
      ""
    end

    def first_text_line
      line = nil
      @graphics.each_with_index do |column, i|
        next if @has_left_side_bar && i == 0
        line = column.first_text_line_in_column
        return line if line
      end
      @overflow_column.graphics.first
    end

    def save_appened_story
      #code
    end

    def last_line_of_box
      overlap_array = @overlap
      overlap_array = eval(@overlap) if @overlap.class == String
      if @overlap && intersects_rect(overlap_array, @graphics.last.column_grid_rect)
        overlap_rect_height_in_lines = @overlap_rect.height/@body_line_height.to_i - 1
        @graphics.last.graphics[-overlap_rect_height_in_lines] 
      elsif @announcement_box
        @graphics.last.graphics[-4]
      else
        @graphics.last.graphics.last
      end
    end

    def layout_items(flowing_items, options={})
      current_line = first_text_line

      while @item = flowing_items.shift do
        current_line = @item.layout_lines(current_line)
      end
      if  current_line
        @current_column  = current_line.column
      end
      @overflow  = true if @overflow_column.graphics.first.layed_out_line?
      if @overflow
        last_line_of_box.fill.color = 'red'
      else
        @empty_lines    = article_box_unoccupied_lines_count
        @underflow      = true if @empty_lines > 0
      end
      unless @fill_up_enpty_lines
        save_article_info
      end
    end
    
    def second_column_x
      @graphics[1].x
    end
    
    def has_left_side_bar_heading_width
      @graphics.last.x_max - second_column_x
    end

    # make heading as float
    def make_article_heading(options={})
      @is_front_page            = options['is_front_page'] || options[:is_front_page]
      @top_story                = options['top_story'] || options[:top_story]
      @top_position             = options['top_position'] || options[:top_position]
      @subtitle_in_head         = false
      @subtitle_in_head         = true if @subtitle_type == '제목밑 가로'
      h_options = options.dup
      h_options[:is_float]      = true
      h_options[:parent]        = self
      h_options[:column_count]  = @column_count
      h_options[:x]             = @starting_column_x
      h_options[:y]             = 0
      h_options[:width]         = @width - 2
      h_options[:width]         = @width - @gutter unless @on_left_edge
      h_options[:width]         = @width - @gutter unless @on_right_edge
      h_options[:width]         = @heading_columns*@column_width if @heading_columns != @column_count
      h_options[:subtitle_type] = @subtitle_type
      @stroke.thickness = 0.3
      case @kind
      when 'editorial', "사설"
        @stroke.sides = [1,1,1,1]
        if @has_profile_image
          h_options[:width] -= @gutter
        else
          h_options[:width] -= @left_inset  + @right_inset
        end
        @heading = NewsHeadingForEditorial.new(h_options)
      when 'opinion', "기고"
        @stroke.sides = [0,1,0,1]
        h_options[:x]     += @left_margin + @column_width + @gutter
        h_options[:y]     = 2
        if @column_count == 2 
          h_options[:x]     = @left_margin
          h_options[:width] -= @left_margin +  @gutter
        else
          h_options[:width] -= (h_options[:x] + @right_inset + @right_margin )
        end
        @heading = NewsHeadingForOpinion.new(h_options)
      when 'box_opinion', '박스기고'
        @stroke.sides     = [1,2,1,1]
        h_options[:y]     = @body_line_height  # if @top_position
        if @on_right_edge
          h_options[:x]     = @gutter*2
          h_options[:width] -=@gutter*2
        elsif @on_left_edge
          h_options[:x]     = @gutter
          h_options[:width] -=@gutter*2
        end
        @heading = NewsHeadingForArticle.new(h_options)
      when 'obituary_promotion', '부고-인사'
        @heading = NewsHeadingForObituary.new(h_options)
      when '특집', '책소개'
        @heading          = NewsHeadingForArticle.new(h_options)
      else
        @stroke.sides = [0,0,0,1]
        @stroke.thickness = 0.3
        @heading = NewsHeadingForArticle.new(h_options)
        if  @column_count != @heading_columns
          # make top margin at the right side of shortened heading
          place_holder_options               = {}   
          place_holder_options[:is_float]    = true
          place_holder_options[:parent]      = self
          place_holder_options[:x]           = @column_width*4 + @gutter*4
          place_holder_options[:y]           = 0
          place_holder_options[:width]       = @column_width*(@column_count - @heading_columns) + @gutter*(@column_count - @heading_columns - 1)
          place_holder_options[:height]      = @body_line_height
          @heading_right_side_one_line_space = Rectangle.new(place_holder_options)
        end
      end
      # check if we have 2 단 기고
      # put heading after personal image
      if @kind == "기고" && @column_count == 2
        unless @heading == @floats[1]
          # make heading as second one in floats
          @heading = @floats.pop
          @floats.insert(1,@heading)
        end
      else
        if @floats.first.class == NewsImage && @floats.first.position.to_i == 0
          # puts "++++++++++ we have NewsImage at position == 0"
          # position 0 image is at first, so leave it.
        elsif @heading != @floats.first
          # make heading as first one in floats
          @heading = @floats.pop
          @floats.unshift(@heading)
        end
      end
    end

    # does current text_box include Heading in floats
    def has_heading?
      @floats.each do |float|
        return true if float.class == RLayout::Heading
      end
      false
    end

    def get_heading
      @floats.each do |float|
        return float if float.class == RLayout::NewsHeadingForArticle || float.class == RLayout::NewsHeadingForOpinion || float.class == RLayout::NewsHeadingForEditorial
      end
      nil
    end

    def get_image
      @floats.each do |float|
        return float if float.class == RLayout::Image
      end
      nil
    end

    def has_leading_box?
      @floats.each do |float|
        return true if float.tag == "leading"
      end
      false
    end

    def has_quote_box?
      @floats.each do |float|
        return true if float.tag == "quote"
      end
      false
    end

    def make_floats(heading_hash)
      if @boxed_subtitle_type
        float_boxed_subtitle(heading_hash)
      end
      # don't create another subtitle, if it is top_story, It is created by heading
      # if !@top_story && heading_hash['subtitle'] && heading_hash['subtitle'] != ""
      if @subtitle_type != '제목밑 가로'
        float_subtitle(heading_hash['subtitle']) if heading_hash['subtitle'] && heading_hash['subtitle'] != ""
      end

      # if heading_hash['personal_image']
      #   float_personal_image(heading_hash)
      # end

      if heading_hash['quote']
        float_quote(heading_hash)
      end

      if heading_hash['announcement']
        float_announcement(heading_hash)
      end

      layout_floats!
    end

    def make_overlap(rect)
      rect = eval(rect) if rect.class == String
      space_above = @body_line_height*2
      o_x       = rect[0]*grid_width
      o_y       = rect[1]*grid_height - @page_heading_margin_in_lines*@body_line_height
      o_y      += @extended_line_count * @body_line_height if @extended_line_count 
      o_y      -= space_above
      o_width   = rect[2]*grid_width
      o_width  -= @gutter if on_left_edge
      o_width  -= @gutter if on_right_edge
      o_height  = rect[3]*grid_height
      o_height += space_above
      @overlap_rect = Rectangle.new(parent:self, is_float: true, x:o_x, y:o_y, width:o_width, height:o_height, layout_expand: nil, top_margin:space_above, stroke_sides:[0,1,0,2], stroke_width: 0.3)
    end

    # text_height_in_lines should be calculated dynamically
    def float_boxed_subtitle(heading_hash)
      boxed_subtitle_text     = heading_hash['boxed_subtitle_text']
      options = {}
      options[:style_name] = 'subtitle_s_gothic'
      options[:text_string]   = boxed_subtitle_text
      options[:text_fit_type] = 'adjust_box_height'
      options[:x]             = @starting_column_x
      options[:x]             += @column_width + @gutter if @has_left_side_bar
      options[:y]             = 0
      options[:top_inset]     = 0 if options[:space_before_in_lines] == 0
      options[:width]         = @column_width
      options[:layout_expand] = nil
      options[:is_float]      = true
      options[:line_after]    = 1
      options[:parent]        = self
      if @boxed_subtitle_type == 1 #'고딕_회색바탕'
        options[:fill_color]  = 'CMYK=0,0,0,10'
      elsif @boxed_subtitle_type == 2 #'고딕_테두리'
        options[:stroke_sides]        = [1,1,1,1]
        options[:stroke_width] = 0.3
      end
      # have one extra line after the box
      options[:bottom_margin]  = @body_line_height
      TitleText.new(options)
    end

    # text_height_in_lines should be calculated dynamically
    def float_subtitle(subtitle_string)
      options = {}
      options[:style_name] = 'subtitle_S'
      if @column_count > 3
        options[:style_name] = 'subtitle_M'
      end
      options[:text_string]   = subtitle_string
      options[:text_fit_type] = 'adjust_box_height'
      options[:x]             = @starting_column_x
      options[:x]             += @column_width + @gutter if @subtitle_type == "2단-2단시작"
      options[:x]             += @column_width + @gutter if @has_left_side_bar
      options[:y]             = 0
      options[:top_inset]     = 0 if options[:space_before_in_lines] == 0
      options[:width]         = @column_width
      options[:width]         += @column_width + @gutter      if @subtitle_type == "2단" || @subtitle_type == "2단-2단시작"
      options[:width]         += @column_width*2 + @gutter*2  if @subtitle_type == "3단"
      options[:layout_expand] = nil
      options[:is_float]      = true
      options[:parent]        = self
      # options[:stroke_width]  = 1
      options[:stroke_color]  = "CMYK=0,0,0,100"
      if @floats.last.class == NewsImage && floats.last.image_kind =~/^인물/
        personal_image = floats.pop
      end
      TitleText.new(options)
      @floats << personal_image if personal_image
    end

    def float_quote(options={})
      return if @quote_box_size == '0'
      if @kind == '기고' || @kind == 'opinion'
        box_height                      = (@quote_box_size.to_i + QUOTE_BOX_SPACE_BEFORE)*@body_line_height
        text_options                    = {}
        text_options[:x]                = @left_margin
        text_options[:height]           = box_height
        text_options[:y]                = @height - box_height - @article_bottom_spaces_in_lines*@body_line_height
        text_options[:width]            = @grid_width*2 - @gutter
        text_options[:left_margin]      = 3
        text_options[:right_margin]     = 3
        text_options[:quote_text_lines] = text_height_in_lines
        text_options[:layout_expand]    = nil
        text_options[:is_float]         = true
        text_options[:text_string]      = options['quote']
        text_options[:style_name]       = 'quote'
        text_options[:parent]           = self
        text_options[:v_alignment]      = 'bottom'
        text_options[:height]           = box_height
        @quote_box = QuoteText.new(text_options)
        @quote_box.y = @height - @quote_box.height - @article_bottom_spaces_in_lines*@body_line_height
      else
        quote_options                     = {}
        quote_options[:column]            = @quote_box_column
        quote_options[:row]               = 1
        quote_options[:layout_expand]     = nil
        quote_options[:is_float]          = true
        quote_options[:text_string]       = options['quote']
        quote_options[:parent]            = self
        quote_options[:quote_positon]     = @quote_positon || 5
        quote_options[:quote]             = options['quote']
        quote_options[:quote_position]    = @quote_position || 1
        quote_options[:quote_box_size]    = @quote_box_size || 4
        quote_options[:quote_x_grid]      = @quote_x_grid || 1
        quote_options[:quote_v_extra_space] = @quote_v_extra_space || 0
        quote_options[:quote_alignment]   = @quote_alignment || 'left'
        quote_options[:quote_line_type]   = @quote_line_type || '상하' #'박스'
        quote_options[:quote_x_grid]      = @quote_x_grid 
        @quote_box = NewsQuote.new(quote_options)
      end
    end


    def float_announcement(options={})
      box_height                    = 3*@body_line_height 
      text_options                  = {}
      text_options[:height]         = box_height
      text_options[:y]              = @height - box_height - @article_bottom_spaces_in_lines*@body_line_height
      text_options[:top_margin]     = @body_line_height
      text_options[:bottom_margin]  = 4 #TODO body_leading
      text_options[:x]              = @graphics.last.x
      text_options[:width]          = @graphics.last.width
      text_options[:style_name]     = 'announcement_1'
      text_options[:left_margin]    = 0
      text_options[:right_margin]   = 0
      text_options[:layout_expand]  = nil
      text_options[:is_float]       = true
      text_options[:text_string]    = options['announcement']
      text_options[:announcement_color]  = @announcement_color
      text_options[:announcement_column] = @announcement_column
      if @announcement_column == 2 
        text_options[:width]        = @graphics.last.width*2 + @gutter
        text_options[:x]            = @graphics[-2].x
        text_options[:style_name]   = 'announcement_2'
      end
      text_options[:parent]         = self
      text_options[:v_alignment]    = 'bottom'
      text_options[:height]         = box_height
      @announcement_box             = AnnouncementText.new(text_options)
    end

    def float_personal_image(options={})
      options = options.dup
      frame_rect = grid_frame_to_rect(options[:grid_frame]) if options[:grid_frame]
      options[:x]       = frame_rect[0]
      options[:y]       = frame_rect[1]
      options[:width]   = frame_rect[2]
      options[:height]  = frame_rect[3]
      options[:layout_expand]   = nil
      options[:is_float]        = true
      options[:parent]          = self
      Quote.new(options)
    end

    # Use news_image instead of float_image
    def news_image(options={})
      options[:parent]    = self
      options[:is_float]  = true
      @news_image         = NewsImage.new(options)
      if options[:position] == 0
        # make iit the first item in floats
        if @floats.length > 1
          @floats.pop
          @floats.unshift(@news_image)
        end
      end
    end

    def news_column_image(options={})
      options[:parent]    = self
      options[:is_float]  = true
      @news_image         = NewsColumnImage.new(options)
    end

    def grid_frame_to_rect(grid_frame, options={})
      return [0,0,100,100]    unless @graphics
      return [0,0,100,100]    if grid_frame.nil?
      return [0,0,100,100]    if grid_frame == ""
      return [0,0,100,100]    if grid_frame == []
      grid_frame          = eval(grid_frame) if grid_frame.class == String
      column_frame        = @graphics.first.frame_rect
      # when grid_frame[0] is greater than columns
      frame_x             = column_frame[0]
      if grid_frame[0] >= @graphics.length
        frame_x           = @graphics.last.x_max
      else
        frame_x           = @graphics[grid_frame[0]].x
      end
      frame_y             = @grid_size[1]*grid_frame[1]
      column_index = (grid_frame[0] + grid_frame[2] - 1).to_i
      if @graphics[column_index]
        frame_width         = @graphics[column_index].x_max - frame_x
      else
        frame_width         = @graphics[0].x_max - frame_x
      end
      frame_height          = @grid_size[1]*grid_frame[3]
      # if image is on bottom, move up by @article_bottom_spaces_in_lines*@body_line_height
      # height_in_lines = @row_count*7
      # height_in_lines += @extended_line_count if  @extended_line_count
      # height_in_lines -= @pushed_line_count if  @pushed_line_count
      # bottom   = (grid_frame[1] + grid_frame[3])*7
      if options[:bottom_position] == true
        frame_y  = @height - frame_height - @article_bottom_spaces_in_lines*@body_line_height
      end
      [frame_x, frame_y, frame_width, frame_height]
    end

    # layout_floats!
    # Floats are Heading, Image, Quotes, SideBox ...
    # Floats should have frame_rect, float_position, and flaot_bleeding.
    # Height value is in grid_rect units, but this could vary with content.
    # Default frame_rect for float is [0,0,1,1], grid_rect in cordinates
    # For Images, default height is natural height proportional to image width/height ratio.
    # For Text, default height is natural height proportional to thw content of text, unless specified otherwise.

    # Floats are grouped in three categories
    # 1. top to bottom:         default image layout
    # 2. middle moving across:  used for leading, Quotes, and Image
    # 3. bottom to up:          sidebox, bleeding image
    # Floats are layed out in order of @floats array from top to bottom.
    # If starting location is occupies, following float is placed below the position of pre-occupied one.
    # Floats can also move up from the bottom, it moves up with top down.
    # Floats string at the bottom of the TextBox, should pass float_bottom:true
    # If float_bleed:true, it bleeds at the location, top, bottom and side
    # TODO centered floats
    # For Leading, Quotes or Image, should implement cented float
    # It is common for Centered floats to have width slightly larger than column width on each side.
    # float_paistion: "center"
    # for article_box with bottom space,
    def layout_floats!
      return unless @floats
      # reset heading width
      @occupied_rects =[]
      if has_heading? && (@heading_columns != @column_count)
        heading = get_heading
        heading.width = @column_width
        heading.x     = @starting_column_x
      end
      #TODO position bottom bottom_occupied_rects
      # middle occupied rect shoul
      @middle_occupied_rects = []
      @bottom_occupied_rects = []
      @floats.each_with_index do |float, i|
        @float_rect = float.frame_rect
        if i==0
          @occupied_rects << float.frame_rect
        elsif @column_count == 2 && float.class == RLayout::NewsHeadingForOpinion
          # when we have 2 column opinion, width gets too small for title
          # so we are overlapping title on top of the image
          next
        elsif intersects_with_occupied_rects?(@occupied_rects, @float_rect)
          # move to some place
          move_float_to_unoccupied_area(@occupied_rects, float)
          @occupied_rects << float.frame_rect
        else
          @occupied_rects << @float_rect
        end
      end
      true
    end

    def intersects_with_occupied_rects?(occupied_arry, new_rect)
      occupied_arry.each do |occupied_rect|
        return true if intersects_rect(occupied_rect, new_rect)
      end
      false
    end

    # if float is overlapping, move float to unoccupied area
    # by moving float to the bottom of the overlapping float.
    def move_float_to_unoccupied_area(occupied_arry, float)
      occupied_arry.each do |occupied_rect|
        if intersects_rect(occupied_rect, float.frame_rect)
          float.y = max_y(occupied_rect) + 0
          if max_y(float.frame_rect) > @column_bottom
            float.height = @column_bottom - float.y
            float.adjust_image_height if float.respond_to?(:adjust_image_height)
          end
        end
      end
    end

    def non_overlapping_area(column_rect, float_rect, min_gap =10)
      if contains_rect(float_rect, column_rect)
        #  "float_rect covers the entire column_rect"
        return [0,0,0,0]
      elsif min_y(float_rect) <= min_y(column_rect) && max_y(float_rect) >= max_y(column_rect)
        #  "hole or block in the middle"
        rects_array = []
        upper_rect = column_rect.dup
        upper_rect.size.height = min_y(float_rect)
        # return only if rect height is larger than minimun
        rects_array << upper_rect if  upper_rect.size.height > min_gap
        lower_rect = column_rect.dup
        lower_rect.origin.y = max_y(float_rect)
        lower_rect.size.height -= max_y(float_rect)
        # return only if rect height is larger than minimun
        rects_array << lower_rect if  lower_rect.size.height > min_gap
        # return [0,0,0,0] if none of them are big enough
        return [0,0,0,0] if rects_array.length == 0
        # return single rect rather than the Array, if one of them is big enough
        return rects_array[0] if rects_array.length == 1
        # return both rects in array, if both are big enough
        return rects_array
      elsif min_y(float_rect) <= min_y(column_rect)
        #  "overlapping at the top "
        new_rect = column_rect.dup
        new_rect[1] = max_y(float_rect)
        new_rect[HEIGHT_VAL] -= float_rect[HEIGHT_VAL]
        return new_rect
      elsif max_y(float_rect) >= max_y(column_rect)
        #  "overlapping at the bottom "
        new_rect = column_rect.dup
        new_rect[HEIGHT_VAL] = min_y(float_rect)
        return new_rect
      end
    end

    def border_x
      if @kind == '박스기고'
        @x + @gutter*2
      else
        return @x  if @on_left_edge
        @x + @gutter
      end
    end

    def border_y
      @top_margin
    end

    def border_width
      if @kind == '박스기고'
        @width
      else
        b_width = @width
        b_width -=@gutter unless @on_left_edge
        b_width -=@gutter unless @on_right_edge
        b_width
      end
    end

    def columns_in_svg
      columns_svg = ""
      @graphics.each do |col|
        columns_svg += col.to_svg
      end
      columns_svg
    end

    def floats_in_svg
      floats_svg = ""
      @floats.each do |float|
        floats_svg += float.to_svg
      end
      floats_svg
    end

    def save_svg(path)
      File.open(path, 'w'){|f| f.write to_svg}
    end
    
    def to_svg
      svg_template=<<~EOF
      <svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 #{@width} #{@height}' >
        <rect fill='white' x='0' y='0' width='#{@width}' height='#{@height}' />
        #{columns_in_svg}
        #{floats_in_svg}
      </svg>
      EOF
      erb = ERB.new(svg_template)
      @svg_content = erb.result(binding)
    end

    def to_pdf

    end

  end

end
