module RLayout

  class NSUtils
    def self.ns_atts_from_style(style)
      atts = {}
      atts[NSFontAttributeName] = NSFont.fontWithName("Times", size:10.0)
      if style[:font] && style[:font_size]
        atts[NSFontAttributeName] = NSFont.fontWithName(style[:font], size: style[:font_size])
      end
      if style[:text_color]
        if style[:text_color] == ""
          atts[NSForegroundColorAttributeName] = NSColor.blackColor
        else
          atts[NSForegroundColorAttributeName] = RLayout.color_from_string(style[:text_color])
        end
      end

      if style[:tracking] && style[:tracking] != 0
        atts[NSKernAttributeName] = style[:tracking]
      end

      if style[:scale] && style[:scale] != "" && style[:scale] != 100
        # NSExpansionAttributeName
        # NSNumber containing floating point value, as log of expansion factor to be applied to glyphs
        # Default 0.0, no expansion
        # Available in Mac OS X v10.3 and later. Declared in NSAttributedString.h
        # # NSExpansionAttributeName
        delta = (style[:scale] - 100)/100
        atts[NSExpansionAttributeName] = delta
      end

      unless style[:space_width]
        atts[:space_width]  = NSAttributedString.alloc.initWithString(" ", attributes: atts).size.width
      else
        atts[:space_width]  = style[:space_width]
      end
      atts
    end


    def self.attributes_of_attributed_string(att_str)
      att_run_array=[]
      range = Pointer.new(NSRange.type)
      i=0
      string = att_str.string
      #  "att_str.string:#{att_str.string}"
      while i < att_str.string.length do
        attrDict = att_str.attributesAtIndex  i, effectiveRange:range
        length=range[0].length
        i += length
        att_hash={}
        starting_index = range[0].location
        ending_index = starting_index + (range[0].length - 1)
        att_hash[:paragraph_style]=attrDict[NSParagraphStyleAttributeName]  if attrDict[NSParagraphStyleAttributeName]
        if attrDict[NSFontAttributeName]
          att_hash[:font]=attrDict[NSFontAttributeName].fontName
          att_hash[:size]= attrDict[NSFontAttributeName].pointSize.round(2)
          # att_hash[:color]= attrDict[NSForegroundColorAttributeName].color
        end
        att_hash[:tracking]       = attrDict[NSKernAttributeName]            if attrDict[NSKernAttributeName]
        att_hash[:strike]         = attrDict[NSStrikethroughStyleAttributeName] if attrDict[NSStrikethroughStyleAttributeName]
        att_hash[:baseline_offset]= attrDict[NSBaselineOffsetAttributeName]       if attrDict[NSBaselineOffsetAttributeName]
        att_hash[:styles]= []
        att_hash[:styles]<<:italic                                    if attrDict[NSObliquenessAttributeName]
        att_hash[:styles]<<:bold                                      if attrDict[NSObliquenessAttributeName]
        att_hash[:styles]<< :underline                                if attrDict[NSUnderlineStyleAttributeName]
        att_hash[:styles]<< :superscript                              if attrDict[NSSuperscriptAttributeName]

        # is there no subscript?
        # att_hash[:styles]<< :suberscript  if attrDict[NSSubscriptAttributeName]
        att_run_array <<  att_hash
      end
      att_run_array
    end
    # NSString *NSFontAttributeName;
    # NSString *NSParagraphStyleAttributeName;
    # NSString *NSForegroundColorAttributeName;
    # NSString *NSUnderlineStyleAttributeName;
    # NSString *NSSuperscriptAttributeName;
    # NSString *NSBackgroundColorAttributeName;
    # NSString *NSAttachmentAttributeName;
    # NSString *NSLigatureAttributeName;
    # NSString *NSBaselineOffsetAttributeName;
    # NSString *NSKernAttributeName;
    # NSString *NSLinkAttributeName;
    # NSString *NSStrokeWidthAttributeName;
    # NSString *NSStrokeColorAttributeName;
    # NSString *NSUnderlineColorAttributeName;
    # NSString *NSStrikethroughStyleAttributeName;
    # NSString *NSStrikethroughColorAttributeName;
    # NSString *NSShadowAttributeName;
    # NSString *NSObliquenessAttributeName;
    # NSString *NSExpansionAttributeName;
    # NSString *NSCursorAttributeName;
    # NSString *NSToolTipAttributeName;
    # NSString *NSMarkedClauseSegmentAttributeName;


  end


end
