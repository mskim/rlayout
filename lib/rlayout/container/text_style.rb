module RLayout

  class Container < Graphic
    # return para_style
    def gt_L(font_size, color, text_alignment)
      h = {}
      h[:font] = 'KoPubDotumPL'
      h[:font_size] = font_size || 12
      h[:font_color] = color || 'black'
      h[:text_alignment] = text_alignment || 'left'
      h
    end

    def gt_M(font_size, color, text_alignment)
      h = {}
      h[:font] = 'KoPubDotumPM'
      h[:font_size] = font_size || 12
      h[:font_color] = color || 'black'
      h[:text_alignment] = text_alignment || 'left'
      h
    end

    def gt_B(font_size, color, text_text_alignment)
      h = {}
      h[:font] = 'KoPubDotumPB'
      h[:font_size] = font_size || 12
      h[:font_color] = color || 'black'
      h[:text_text_alignment] = text_alignment || 'left'
      h
    end

    # KoPubDotumPL
    # KoPubDotumPM
    # KoPubDotumPB

    # KoPubBatangPB
    # KoPubBatangPM
    # KoPubBatangPB

    def gothic_light(font_size, color, text_alignment)
      h = {}
      h[:font] = 'KoPubDotumPL' 
      h[:font_size] = font_size || 12
      h[:font_color] = color || 'black'
      h[:text_alignment] = text_alignment || 'left'
      h
    end

    def mj_M(font_size, color, text_alignment)
      h = {}
      h[:font] = 'KoPubBatangPM'
      h[:font_size] = font_size || 12
      h[:font_color] = color || 'black'
      h[:text_alignment] = text_alignment || 'left'
      h
    end

    def mj_B(font_size, color, text_alignment)
      h = {}
      h[:font] = 'KoPubBatangPB'
      h[:font_size] = font_size || 12
      h[:font_color] = color || 'black'
      h[:text_alignment] = text_alignment || 'left'
      h
    end
  end
end