
# TextLayoutManager
# Text layout for Cocoa(Mac OS X) mode

# text_string_array
# text_atts_array

# atts_array is Array of attribute Hash.
# Each run is represented as hash of attributes and string

# def markup2atts_array
#  # convert markedup string to atts_array
#  "this is _itatic_ string" to [{string: "this is ", style: PLAIN}, {string: 'itatic', style: ITALIC}, {sting:' string', style:PLAIN}]
# end

# def atts_array2markup:
#  # convert atts_array to markedup string, opposite of markup2atts_array
# end


# Apple implemetation of  NSAttributtedString,
# Apple Text implemetation keeps whole string in one chunk, and each attribute has range.
# But, It makes it difficult to edit content manually, since editing party has to update ranges of every attribute runs.
# It forces you to use additional tool to reconstuct the string, not ideal for editing with a text editor.
# I want to keep attributes and string together in a single hash(atts), making it much easier to edit string by hand.

# Using CoreText (I went back to using NSTextSystem. I am getting strange errors, (context invalid error), that I can't figure out why!! Some blogs says it is bug, I don't want to pull my hair out anymore.)
# XXXXXX no more!!!!! I am using CoreText functions rather than NSText, XXXXXX no more!!!!!
# CTFrame, CTLine, CTRun, CTToken,
# For vertical text, and finer controll
# 1. layout_lines:
#       lays out out lines with att_string and given width
#       it returns height for the layed out pargaph
# 2. Split:
#       using lines, and lines_range
#       lines keep: line_fragments that were layed out
#       lines_range: indicated the range of lines that belongs to the paragaph
#                     when paragraph is splitted, this will indicated where lines belong
# 3. Drawing:
#       draw lines in lines_range
#       line cordinate are reversed in CoreText, so I have to draw from the top to bottom.
#
#   things I should implement
#   1. Dropcap,
#   2. overlapping area with float, illegular shaped but continuous lines.
#   3. inserting image paragraphs that flows along other paragraphs,
#   4. drawing frames around paragraps,
#   5. widow/orphan rule and last character sqeese options
#   6. foot note and indexing support, I need to know colum position of the paragraph
#   7. paragraph based editing support, where text needs to be prosented per paragraph base, and so on...
#   8. Squeeze text to fit

# There two of ways of saving Text data.
# 1. When entire Text has uniform attrbutes, use atts hash.
# 2. When Text has mixed attrbutes, use atts_array

# Text Fit Mode
# Three are two text fitting mode
# one is fiiting text inside of the box, changing font size to fit
# and the other way is to layout text by keeping font size, expanding container size or overflow
# for Text class, default fit mode is       TEXT_FIT_TO_BOX = 0  (chnage font size)
# for Pargaraph class, default fit mode is  TEXT_FIT_TO_FONT = 1  (chnage container size)

# dropcap_lines = 2-3
# dropcap_char  = 1
# for dropcap:
# get first Droped Char rect
# 1. create path with dropcap_area
# 2. layout text with range 1, 0
# 3. Draw Droped Char
# dropcap_area


FIT_FONT_SIZE   = 0   # keep given font size
FIT_TO_BOX      = 1   # change font size to fit text into box

# 'fit_text_to_box'
# 'adjust_box_height'

#overflow or vertical adjustment

# TODO
FIT_EACH_LINE   = 2   # adjust font size for each line to fit text into lines.
                      # So, fewer the text, larger the font size becomes in for each line
                      # And reduce the size of the lines propotionally to fit the entire lines in text box.

#TODO
# text_vertical_alignment

module RLayout
  class TextLayoutManager
    attr_accessor :owner_graphic
    attr_accessor :text_direction, :text_markup
    attr_accessor :line_count, :text_size, :linked, :text_line_spacing
    attr_accessor :text_alignment, :text_vertical_alignment, :text_vertical_offset
    attr_accessor :drop_lines, :drop_char, :drop_char_width, :drop_char_height
    attr_accessor :text_fit_type, :text_overflow, :overflow_line_count, :text_underflow
    attr_accessor :text_atts_array, :text_string_array
    attr_reader   :att_string, :layout_manager, :text_container

    def initialize(owner_graphic, options={})
      @owner_graphic  = owner_graphic
      @text_fit_type  = @owner_graphic.text_fit_type if @owner_graphic
      @text_direction = options.fetch(:text_direction, 'left_to_right') # top_to_bottom for Japanese
      @text_vertical_alignment = options.fetch(:text_vertical_alignment, "center")
      @text_size      = options[:text_size] || 16
      @text_line_spacing = options[:text_line_spacing] || 0 #@text_size*0.5
      @att_string     = NSTextStorage.alloc.initWithAttributedString(make_att_string_from_option(options))
      @layout_manager = NSLayoutManager.alloc.init
      @att_string.addLayoutManager @layout_manager
      @text_container = NSTextContainer.alloc.initWithContainerSize(NSMakeSize(@owner_graphic.width, @owner_graphic.height))
      @layout_manager.addTextContainer @text_container
      layout_lines(options) unless options[:no_layout]
      self
    end

    # line layout using NSText System
    def layout_lines(options={})
      return 0 unless @att_string
      @text_overflow  = false
      @overflow_line_count = 0
      width           = @owner_graphic.width
      width           = options[:proposed_width] if options[:proposed_width]
      if options[:proposed_height]
        @text_container.setContainerSize(NSMakeSize(width, options[:proposed_height]))
      else
        @text_container.setContainerSize(NSMakeSize(width, @owner_graphic.height))
      end
      range     = @layout_manager.glyphRangeForTextContainer @text_container
      # @layout_manager.glyphRangeForTextContainer @text_container
      used_rect = @layout_manager.usedRectForTextContainer @text_container
      if options[:proposed_height]
        if used_rect.size.height <= options[:proposed_height]
          # text fits into given room, and we also have enough room for text_line_spacing
          if used_rect.size.height + @text_line_spacing  <= options[:proposed_height]
            @owner_graphic.height = used_rect.size.height + @text_line_spacing
          else
            @owner_graphic.height = options[:proposed_height]
          end
          @text_overflow = false
        else
          # text doesn't fit into proposed height, raise text_overflow
          @owner_graphic.height = used_rect.size.height #+ @text_line_spacing
          @text_overflow = true
        end
      elsif options[:text_fit_type] == 'adjust_box_height'
        @owner_graphic.height = @owner_graphic.top_margin + @owner_graphic.top_inset + @owner_graphic.bottom_margin + @owner_graphic.bottom_inset
        if @owner_graphic.text_height_in_lines
          if used_rect.size.height > @owner_graphic.text_height_in_lines
            # this is when text has more than one line
            # We want to keeep it as multple of body_line_height
            multiples = used_rect.size.height/(@owner_graphic.text_height_in_lines*@owner_graphic.body_line_height)
            @owner_graphic.height += @owner_graphic.body_line_height*(multiples + 1)
          else
            @owner_graphic.height += (@owner_graphic.text_height_in_lines*@owner_graphic.body_line_height)
          end
        else
          @owner_graphic.height += used_rect.size.height
        end
      else
        # if range.length is less than @att_string.string.length
        # there is a overflow
        @text_overflow = true if range.length < @att_string.string.length
        if @text_overflow
          fit_text_to_box if @text_fit_type =="fit_text_to_box"
          # @text_overflow == false
          range     = @layout_manager.glyphRangeForTextContainer @text_container
          if range.length < @att_string.string.length
            # puts "Still overflowing"
          end
          used_rect = @layout_manager.usedRectForTextContainer @text_container
        end
      end
      # vertically align text
      top_space     = @owner_graphic.top_margin + @owner_graphic.top_inset
      bottom_space  = @owner_graphic.bottom_margin + @owner_graphic.bottom_inset
      graphic_space = @owner_graphic.height - top_space - bottom_space
      @text_vertical_offset = top_space
      case @text_vertical_alignment
      when 'top'
        @text_vertical_offset = top_space
      when 'bottom'
        @text_vertical_offset = graphic_space - used_rect.size.height
      else
        @text_vertical_offset = (graphic_space - used_rect.size.height)/2
      end
    end

    def set_frame
      # ???
      # layout_lines
      layout_lines()
    end

    # TODO
    def set_text_string(string)
      range = NSMakeRange(0, @att_string.length)
      @att_string.replaceCharactersInRange(range, withString: string)
    end

    def replace_string_with(string)
      range = NSMakeRange(0, @att_string.length)
      @att_string.replaceCharactersInRange(range, withString: string)
    end

    #TODO
    def att_string_to_hash(att_string)
      Hash.new
    end

    def to_hash
      h = {}
      h[:text_markup]   = @text_markup
      h[:text_direction]= @text_direction
      h[:text_string]   = @att_string.string
      h[:text_size]     = @text_size
      h[:text_line_spacing] = @text_line_spacing
      h[:text_fit_type] = @text_fit_type
      h[:att_string]    = att_string_to_hash(@att_string)
      h[:line_direction] = @line_direction if @line_direction == "vertical"
      h
    end

    def make_atts
      @text_color = RLayout::convert_to_nscolor(@text_color)    unless @text_color.class == NSColor
      atts={}
      atts[NSFontAttributeName]             = NSFont.fontWithName(@font, size:@text_size)
      atts[NSForegroundColorAttributeName]  = @text_color
      if @guguri_width && @guguri_width < 0
        atts[NSStrokeWidthAttributeName] = atts_hash[:guguri_width] #0, -2,-5,-10
        atts[NSStrokeColorAttributeName]=color_from_string(attributes[:guguri_color])
        #atts[NSStrokeColorAttributeName]=Graphic.color_from_string(attributes[:guguri_color])
      end
      if @text_tracking
        atts[NSKernAttributeName] = @text_tracking
      end
      left_align        = NSMutableParagraphStyle.alloc.init.setAlignment(NSLeftTextAlignment)
      right_align       = NSMutableParagraphStyle.alloc.init.setAlignment(NSRightTextAlignment)
      center_align      = NSMutableParagraphStyle.alloc.init.setAlignment(NSCenterTextAlignment)
      justified_align   = NSMutableParagraphStyle.alloc.init.setAlignment(NSJustifiedTextAlignment)
      newParagraphStyle = NSMutableParagraphStyle.alloc.init # default is left align

      case @text_alignment
      when "left"
        newParagraphStyle = left_align
      when "right"
        newParagraphStyle = right_align
      when "center"
        newParagraphStyle = center_align
      when 'justified'
        newParagraphStyle = justified_align
      else
        newParagraphStyle = left_align
      end
      newParagraphStyle.setLineSpacing(@text_line_spacing) if @text_line_spacing
      newParagraphStyle.setFirstLineHeadIndent(@text_first_line_head_indent) if @text_first_line_head_indent
      newParagraphStyle.setHeadIndent(@text_head_indent) if @text_head_indent
      newParagraphStyle.setTailIndent(@text_tail_indent) if @text_tail_indent
      atts[NSParagraphStyleAttributeName] = newParagraphStyle
      atts
    end

    def make_att_string_from_option(options)
      if options[:text_string_array] && options[:text_atts_array]
        make_att_string_with_string_and_atts_array(options[:text_string_array], options[:text_atts_array])
      # if we are give pre-make NSAttributedString, use it
      elsif options[:ns_attributed_string]
        options[:ns_attributed_string]
      # elsif has_inline_elements?(options[:text_string])
      #TODO implement inline element, italic, bold, underline, sub, super, emphasis(color)
      # if it exists, make it into text_string_array, and text_atts_array
      else
        make_att_string(options)
      end
    end

    #TODO
    # def has_inline_elements?(text_string)
    #   style_char = nil
    #   if text_string =~ /_.*_/
    #     style_char = "_"
    #   elsif text_string =~ /\*.*\*/
    #     style_char += "*"
    #   end
    # end

    # make att_string by merging segments of diffrent attributed strings
    # given in text_strings and text atts
    def make_att_string_with_string_and_atts_array(text_string_array, text_atts_array)
      att_string = NSMutableAttributedString.alloc.init
      #TODO make sure text_atts_array.length > 0
      default_atts = {}
      default_atts = text_atts_array[0]  if text_atts_array.length > 0
      text_string_array.each_with_index do |string, i|
        atts = default_atts
        if text_atts_array.length > i
          atts = text_atts_array[i]
        end
        atts[:text_string] = string
        att_string.appendAttributedString(make_att_string(atts))
      end
      att_string
    end

    def make_att_string(options={})
      #TODO
      # atts[NSKernAttributeName] = @text_track           if @text_track
      if options[:text_markup]
        @text_markup = options[:text_markup]
      elsif options[:markup]
        @text_markup = options[:markup]
      else
        @text_markup = 'p'
      end
      @text_string                   = options.fetch(:text_string, "")
      @font                          = options.fetch(:font, "Times")
      @text_size                     = options.fetch(:text_size, 16)
      @text_color                    = options.fetch(:text_color, "black")
      @text_line_spacing             = options.fetch(:text_line_spacing, 0)
      @text_fit_type                 = options.fetch(:text_fit_type, 0)
      @text_alignment                = options.fetch(:text_alignment, "left")
      @text_tracking                 = options.fetch(:text_tracking, 0)  if options[:text_tracking ]
      @text_first_line_head_indent   = options.fetch(:text_first_line_head_indent, 0)
      @text_head_indent              = options.fetch(:text_head_indent, 0)
      @text_tail_indent              = options.fetch(:text_tail_indent, 0)
      @text_paragraph_spacing_before = options[:text_paragraph_spacing_before] if options[:text_paragraph_spacing_before]
      @text_paragraph_spacing        = options[:text_paragraph_spacing]        if options[:text_paragraph_spacing]
      atts = make_atts
      att_string                     = NSMutableAttributedString.alloc.initWithString(@text_string, attributes: atts)
      att_string
    end

     #
     # def body_line_height_multiple(head_para_height)
     #   body_height = @owner_graphic.body_height
     #   # puts "body_height:#{body_height}"
     #   # body_multiple = ((head_para_height/body_height).to_i + 1)*body_height
     # end

    # do not break paragraph that is less than 4 lines
    # apply widow/orphan rule and last_line_small_char_set rule.
    def is_breakable?
      @line_count >= 4
    end

    def fontSizedForAreaSize
      text_size       = @att_string.size
      # container_size  = NSMakeSize(@owner_graphic.text_rect[2], @owner_graphic.text_rect[3])
      container_size  = @text_container.containerSize
      ptr = Pointer.new(NSRange.type)
      ptr[0]= NSMakeRange(0,0)
      current_font    = @att_string.attributesAtIndex(0, effectiveRange:ptr)[NSFontAttributeName]
      scale           = scaleToAspectFit(text_size, container_size)
      NSFont.fontWithDescriptor(current_font.fontDescriptor, size:scale * current_font.pointSize)
    end

    def scaleToAspectFit(source, box)
      # Todo  10 should be the inset and including in the margin
      h_margin = @text_container.lineFragmentPadding
      h_margin += @owner_graphic.left_margin + @owner_graphic.right_margin
      v_margin = @text_container.lineFragmentPadding
      h_margin += @owner_graphic.top_margin + @owner_graphic.bottom_margin
      w=(box.width-h_margin)/(source.width + 4.0)
      h=(box.height-v_margin)/source.height
      [w,h].min - 0.1 #TODO Why do I need this???
    end

    def fit_text_to_box
      fitting_font=fontSizedForAreaSize
      atts={NSFontAttributeName=>fitting_font}
      range=NSMakeRange(0,@att_string.length)
      @att_string.addAttributes(atts, range:range)
    end

    # layout layout_drop_cap_lines
    # @drop_ct_line: CTLine with drop char
    # @drop_frame:   CTFrame with side lines
    # @dropped_att_string
    # @att_string: att_string without dropped char
    # @frame:        CTFrame with rest of lines
    def layout_drop_cap_lines(options)
      @drop_char_height      = @drop_lines*(@text_size + @text_line_spacing)
      proposed_width    = @owner_graphic.width
      proposed_width    = options[:proposed_width] if options[:proposed_width]
      drop_font    = options.fetch(:drop_font, 'Helvetica')
      drop_text_color   = options.fetch(:drop_text_color, @text_color)
      drop_text_color   = RLayout::convert_to_nscolor(drop_text_color)    unless drop_text_color.class == NSColor
      atts={}
      @drop_char_text_size                  = @drop_char_height
      atts[NSFontAttributeName]             = NSFont.fontWithName(drop_font, size:@drop_char_text_size)
      atts[NSForegroundColorAttributeName]  = drop_text_color
      drop_char_att_string                  = NSMutableAttributedString.alloc.initWithString(@drop_char, attributes:atts)
      @drop_ct_line       = CTLineCreateWithAttributedString(drop_char_att_string)
      @drop_char_width    = CTLineGetTypographicBounds(@drop_ct_line, nil, nil,nil)
      @right_side_width   = proposed_width - @drop_char_width
      @proposed_path       = CGPathCreateMutable()
      bounds              = CGRectMake(@drop_char_width, 0, @right_side_width, @drop_char_height)
      CGPathAddRect(@proposed_path, nil, bounds)
      @right_size_frame   = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(0, 0), @proposed_path, nil)
      range               = CTFrameGetVisibleStringRange(@right_size_frame)
      last_char_position=range.location + range.length
      if last_char_position < @att_string.length
        # still left over string after right_side_frame
        @proposed_path    = CGPathCreateMutable()
        bounds            = CGRectMake(0, @drop_char_height, proposed_width, 1000)
        CGPathAddRect(@proposed_path, nil, bounds)
        @frame            = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(0, 0), @proposed_path, nil)
        @line_count       = CTFrameGetLines(@frame).count
        used_size_height  = @line_count*(@text_size + @text_line_spacing) + @drop_char_height
        # set text_overflow and under flow
        @owner_graphic.adjust_size_with_text_height_change(proposed_width, used_size_height)
      else
        @owner_graphic.adjust_size_with_text_height_change(proposed_width, @drop_char_height)
      end
    end

    def text_height
      @line_count*(@text_size + @text_line_spacing)
    end

    def text_line_height
      @text_size + @text_line_spacing
    end

    # split att_string into two at overflowing position
    def split_overflowing_lines
      @lines_array            = CTFrameGetLines(@frame)
      glyphCount              = CTLineGetGlyphCount(@lines_array.last)
      last_line_range         = CTLineGetStringRange(@lines_array.last)
      second_half_position    = last_line_range.location + glyphCount
      first_half_range        = NSMakeRange(0, second_half_position)
      second_half_range       = NSMakeRange(second_half_position, @att_string.length - second_half_position)
      first_half_string       = @att_string.attributedSubstringFromRange(first_half_range).copy
      second_half_stirng      = @att_string.attributedSubstringFromRange(second_half_range).copy
      @att_string             = first_half_string
      second_half_options     = to_hash
      second_half_options[:att_string]  = second_half_stirng
      second_half_options[:linked]      = true
      second_paragraph        = Paragraph.new(second_half_options)
      return second_paragraph
    end

    def text_rect
      @owner_graphic.text_rect
    end

  end

end

# I need a way to find out what the hight of line is,
# given font with size and line spaceing for paragraph
#
# counting lines
# NSLayoutManager *layoutManager = [textView layoutManager];
# unsigned numberOfLines, index, numberOfGlyphs =
#         [layoutManager numberOfGlyphs];
# NSRange lineRange;
# for (numberOfLines = 0, index = 0; index < numberOfGlyphs; numberOfLines++){
#     (void) [layoutManager lineFragmentRectForGlyphAtIndex:index
#             effectiveRange:&lineRange];
#     index = NSMaxRange(lineRange);
# }

# The key methods here are -
# lineFragmentRectForGlyphAtIndex:effectiveRange:, -
# lineFragmentUsedRectForGlyphAtIndex:, -locationOfGlyphAtIndex:, and
# NSTypesetter's -baselineOffsetInLayoutManager:glyphIndex:.  It's a
# little difficult for me to describe all of the relationships between
# these measurements without a diagram, but you should be able to try
# them out and see how they differ in all of the various cases you're
# interested in--paragraph spacing, line spacing, line height multiple,
# etc.  The line fragment rect is the rect within which the line was
# laid out.  The used rect is the rect within that actually taken up by
# the text, including some forms of padding.  The baseline offset is the
# distance from the bottom of the line fragment rect to the baseline for
# a particular glyph.

# Circle View
# lineFragmentRect = @layoutManager.lineFragmentRectForGlyphAtIndex i, effectiveRange:nil
# layoutLocation = @layoutManager.locationForGlyphAtIndex(i)
