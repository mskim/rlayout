#encode :utf-8

module RLayout
  class Styles < XMLDocument
    attr_accessor :character_styles, :paragraph_styles
    attr_accessor :table_styles, :cell_styles, :object_styles
    def initialize(xml, options={})
      super
      @element.root.elements.each do |style_group|
        case style_group.name
        when 'RootCharacterStyleGroup'
          parse_char_styles(style_group)
        when 'RootParagraphStyleGroup'
          parse_paragraph_styles(style_group)
        when 'TOCStyle'
          parse_toc_style(style_group)
        when 'RootCellStyleGroup'
          parse_cell_style(style_group)
        when 'RootTableStyleGroup'
          parse_table_style(style_group)
        when 'RootObjectStyleGroup'
          parse_object_style(style_group)
        when 'TrapPreset'
          puts 'RootTrapPresetGroup'
        else 
          puts style_group
        end
      end
      
      self
    end  
    
    def parse_char_styles(element)
      @character_styles = []
      element.elements.each do |char_style|
        h = {}
        h[:name] = char_style.attributes['Name']
        @character_styles << h
      end      
    end
    
    def parse_paragraph_styles(style_group)
      @paragraph_styles = []
      style_group.elements.each do |para_style|
        h = {}
        h[:name] = para_style.attributes['Name']
        attrs = para_style.attributes 
        if based_on = para_style.elements['Properties'].elements['BasedOn']
          h[:based_on]        = based_on.text
        else
          h[:text_font]       = para_style.elements['Properties'].elements['AppliedFont'].text
          h[:text_size]       = attrs['PointSize']
          h[:text_style]      = attrs['FontStyle']
          h[:text_alignment]  = attrs['Justification']
          h[:text_leading]    = para_style.elements['Properties'].elements['Leading'].text
          h[:text_first_line_head_indent]= attrs['FirstLineIndent'] 
          h[:text_head_indent]= attrs['LeftIndent']
          h[:text_tail_indent]= attrs['RightIndent']
        end
        @paragraph_styles << h
      end   
    end
    
    def parse_cell_style(style_group)
      puts __method__
    end
    
    def parse_table_style(style_group)
      puts style_group
      puts __method__
    end
    
    def parse_toc_style(style_group)
      puts __method__
    end
    
    def parse_object_style(style_group)
      puts __method__
    end
  end

end

__END__

paragraph_styles
{"AllowArbitraryHyphenation"=>"false",
 "AppliedLanguage"=>"$ID/English: USA",
 "AutoLeading"=>"120",
 "AutoTcy"=>"0",
 "AutoTcyIncludeRoman"=>"false",
 "BaselineShift"=>"0",
 "BulletsAlignment"=>"LeftAlign",
 "BulletsAndNumberingListType"=>"NoList",
 "BulletsTextAfter"=>"^t",
 "BunriKinshi"=>"true",
 "Capitalization"=>"Normal",
 "CharacterAlignment"=>"AlignEmCenter",
 "CharacterDirection"=>"DefaultDirection",
 "CharacterRotation"=>"0",
 "CjkGridTracking"=>"false",
 "Composer"=>"HL Composer",
 "DesiredGlyphScaling"=>"100",
 "DesiredLetterSpacing"=>"0",
 "DesiredWordSpacing"=>"100",
 "DiacriticPosition"=>"OpentypePosition",
 "DigitsType"=>"DefaultDigits",
 "DropCapCharacters"=>"0",
 "DropCapLines"=>"0",
 "DropcapDetail"=>"0",
 "EndJoin"=>"MiterEndJoin",
 "FillColor"=>"Color/Black",
 "FillTint"=>"-1",
 "FirstLineIndent"=>"0",
 "FontStyle"=>"Regular",
 "GlyphForm"=>"None",
 "GradientFillAngle"=>"0",
 "GradientFillLength"=>"-1",
 "GradientFillStart"=>"0 0",
 "GradientStrokeAngle"=>"0",
 "GradientStrokeLength"=>"-1",
 "GradientStrokeStart"=>"0 0",
 "GridAlignFirstLineOnly"=>"false",
 "GridAlignment"=>"None",
 "GridGyoudori"=>"0",
 "HorizontalScale"=>"100",
 "HyphenWeight"=>"5",
 "HyphenateAcrossColumns"=>"true",
 "HyphenateAfterFirst"=>"2",
 "HyphenateBeforeLast"=>"2",
 "HyphenateCapitalizedWords"=>"true",
 "HyphenateLadderLimit"=>"3",
 "HyphenateLastWord"=>"true",
 "HyphenateWordsLongerThan"=>"5",
 "Hyphenation"=>"true",
 "HyphenationZone"=>"36",
 "IgnoreEdgeAlignment"=>"false",
 "Imported"=>"false",
 "Jidori"=>"0",
 "Justification"=>"LeftAlign",
 "Kashidas"=>"DefaultKashidas",
 "KeepAllLinesTogether"=>"false",
 "KeepFirstLines"=>"2",
 "KeepLastLines"=>"2",
 "KeepLinesTogether"=>"false",
 "KeepRuleAboveInFrame"=>"false",
 "KeepWithNext"=>"0",
 "KeepWithPrevious"=>"false",
 "KentenAlignment"=>"AlignKentenCenter",
 "KentenCharacterSet"=>"CharacterInput",
 "KentenCustomCharacter"=>"",
 "KentenFontSize"=>"-1",
 "KentenKind"=>"None",
 "KentenOverprintFill"=>"Auto",
 "KentenOverprintStroke"=>"Auto",
 "KentenPlacement"=>"0",
 "KentenPosition"=>"AboveRight",
 "KentenStrokeTint"=>"-1",
 "KentenTint"=>"-1",
 "KentenWeight"=>"-1",
 "KentenXScale"=>"100",
 "KentenYScale"=>"100",
 "KerningMethod"=>"$ID/Metrics",
 "KeyboardDirection"=>"DefaultDirection",
 "KinsokuHangType"=>"None",
 "KinsokuType"=>"KinsokuPushInFirst",
 "LastLineIndent"=>"0",
 "LeadingAki"=>"-1",
 "LeadingModel"=>"LeadingModelAkiBelow",
 "LeftIndent"=>"0",
 "Ligatures"=>"true",
 "MaximumGlyphScaling"=>"100",
 "MaximumLetterSpacing"=>"0",
 "MaximumWordSpacing"=>"133",
 "MinimumGlyphScaling"=>"100",
 "MinimumLetterSpacing"=>"0",
 "MinimumWordSpacing"=>"80",
 "MiterLimit"=>"4",
 "Name"=>"$ID/[No paragraph style]",
 "NoBreak"=>"false",
 "NumberingAlignment"=>"LeftAlign",
 "NumberingApplyRestartPolicy"=>"true",
 "NumberingContinue"=>"true",
 "NumberingExpression"=>"^#.^t",
 "NumberingLevel"=>"1",
 "NumberingStartAt"=>"1",
 "OTFContextualAlternate"=>"true",
 "OTFDiscretionaryLigature"=>"false",
 "OTFFigureStyle"=>"Default",
 "OTFFraction"=>"false",
 "OTFHVKana"=>"false",
 "OTFHistorical"=>"false",
 "OTFJustificationAlternate"=>"false",
 "OTFLocale"=>"true",
 "OTFMark"=>"true",
 "OTFOrdinal"=>"false",
 "OTFOverlapSwash"=>"false",
 "OTFProportionalMetrics"=>"false",
 "OTFRomanItalics"=>"false",
 "OTFSlashedZero"=>"false",
 "OTFStretchedAlternate"=>"false",
 "OTFStylisticAlternate"=>"false",
 "OTFStylisticSets"=>"0",
 "OTFSwash"=>"false",
 "OTFTitling"=>"false",
 "OverprintFill"=>"false",
 "OverprintStroke"=>"false",
 "PageNumberType"=>"AutoPageNumber",
 "ParagraphBreakType"=>"Anywhere",
 "ParagraphDirection"=>"LeftToRightDirection",
 "ParagraphGyoudori"=>"false",
 "ParagraphJustification"=>"DefaultJustification",
 "PointSize"=>"12",
 "Position"=>"Normal",
 "PositionalForm"=>"None",
 "Rensuuji"=>"true",
 "RightIndent"=>"0",
 "RotateSingleByteCharacters"=>"false",
 "RubyAlignment"=>"RubyJIS",
 "RubyAutoAlign"=>"true",
 "RubyAutoScaling"=>"false",
 "RubyAutoTcyAutoScale"=>"true",
 "RubyAutoTcyDigits"=>"0",
 "RubyAutoTcyIncludeRoman"=>"false",
 "RubyFontSize"=>"-1",
 "RubyOpenTypePro"=>"true",
 "RubyOverhang"=>"false",
 "RubyOverprintFill"=>"Auto",
 "RubyOverprintStroke"=>"Auto",
 "RubyParentOverhangAmount"=>"RubyOverhangOneRuby",
 "RubyParentScalingPercent"=>"66",
 "RubyParentSpacing"=>"RubyParent121Aki",
 "RubyPosition"=>"AboveRight",
 "RubyStrokeTint"=>"-1",
 "RubyTint"=>"-1",
 "RubyType"=>"PerCharacterRuby",
 "RubyWeight"=>"-1",
 "RubyXOffset"=>"0",
 "RubyXScale"=>"100",
 "RubyYOffset"=>"0",
 "RubyYScale"=>"100",
 "RuleAbove"=>"false",
 "RuleAboveGapOverprint"=>"false",
 "RuleAboveGapTint"=>"-1",
 "RuleAboveLeftIndent"=>"0",
 "RuleAboveLineWeight"=>"1",
 "RuleAboveOffset"=>"0",
 "RuleAboveOverprint"=>"false",
 "RuleAboveRightIndent"=>"0",
 "RuleAboveTint"=>"-1",
 "RuleAboveWidth"=>"ColumnWidth",
 "RuleBelow"=>"false",
 "RuleBelowGapOverprint"=>"false",
 "RuleBelowGapTint"=>"-1",
 "RuleBelowLeftIndent"=>"0",
 "RuleBelowLineWeight"=>"1",
 "RuleBelowOffset"=>"0",
 "RuleBelowOverprint"=>"false",
 "RuleBelowRightIndent"=>"0",
 "RuleBelowTint"=>"-1",
 "RuleBelowWidth"=>"ColumnWidth",
 "ScaleAffectsLineHeight"=>"false",
 "Self"=>"ParagraphStyle/$ID/[No paragraph style]",
 "ShataiAdjustRotation"=>"false",
 "ShataiAdjustTsume"=>"true",
 "ShataiDegreeAngle"=>"4500",
 "ShataiMagnification"=>"0",
 "SingleWordJustification"=>"FullyJustified",
 "Skew"=>"0",
 "SpaceAfter"=>"0",
 "SpaceBefore"=>"0",
 "SpanColumnMinSpaceAfter"=>"0",
 "SpanColumnMinSpaceBefore"=>"0",
 "SpanColumnType"=>"SingleColumn",
 "SplitColumnInsideGutter"=>"6",
 "SplitColumnOutsideGutter"=>"0",
 "StartParagraph"=>"Anywhere",
 "StrikeThroughGapOverprint"=>"false",
 "StrikeThroughGapTint"=>"-1",
 "StrikeThroughOffset"=>"-9999",
 "StrikeThroughOverprint"=>"false",
 "StrikeThroughTint"=>"-1",
 "StrikeThroughWeight"=>"-9999",
 "StrikeThru"=>"false",
 "StrokeAlignment"=>"OutsideAlignment",
 "StrokeColor"=>"Swatch/None",
 "StrokeTint"=>"-1",
 "StrokeWeight"=>"1",
 "Tatechuyoko"=>"false",
 "TatechuyokoXOffset"=>"0",
 "TatechuyokoYOffset"=>"0",
 "Tracking"=>"0",
 "TrailingAki"=>"-1",
 "TreatIdeographicSpaceAsSpace"=>"false",
 "Tsume"=>"0",
 "Underline"=>"false",
 "UnderlineGapOverprint"=>"false",
 "UnderlineGapTint"=>"-1",
 "UnderlineOffset"=>"-9999",
 "UnderlineOverprint"=>"false",
 "UnderlineTint"=>"-1",
 "UnderlineWeight"=>"-9999",
 "VerticalScale"=>"100",
 "Warichu"=>"false",
 "WarichuAlignment"=>"Auto",
 "WarichuCharsAfterBreak"=>"2",
 "WarichuCharsBeforeBreak"=>"2",
 "WarichuLineSpacing"=>"0",
 "WarichuLines"=>"2",
 "WarichuSize"=>"50",
 "XOffsetDiacritic"=>"0",
 "YOffsetDiacritic"=>"0",
 "Properties"=>
  [{"Leading"=>[{"type"=>"enumeration", "content"=>"Auto"}],
    "AppliedFont"=>[{"type"=>"string", "content"=>"Times New Roman"}],
    "RuleAboveColor"=>[{"type"=>"string", "content"=>"Text Color"}],
    "RuleBelowColor"=>[{"type"=>"string", "content"=>"Text Color"}],
    "RuleAboveType"=>[{"type"=>"object", "content"=>"StrokeStyle/$ID/Solid"}],
    "RuleBelowType"=>[{"type"=>"object", "content"=>"StrokeStyle/$ID/Solid"}],
    "BalanceRaggedLines"=>[{"type"=>"enumeration", "content"=>"NoBalancing"}],
    "RuleAboveGapColor"=>[{"type"=>"object", "content"=>"Swatch/None"}],
    "RuleBelowGapColor"=>[{"type"=>"object", "content"=>"Swatch/None"}],
    "UnderlineColor"=>[{"type"=>"string", "content"=>"Text Color"}],
    "UnderlineGapColor"=>[{"type"=>"object", "content"=>"Swatch/None"}],
    "UnderlineType"=>[{"type"=>"object", "content"=>"StrokeStyle/$ID/Solid"}],
    "StrikeThroughColor"=>[{"type"=>"string", "content"=>"Text Color"}],
    "StrikeThroughGapColor"=>[{"type"=>"object", "content"=>"Swatch/None"}],
    "StrikeThroughType"=>
     [{"type"=>"object", "content"=>"StrokeStyle/$ID/Solid"}],
    "SpanSplitColumnCount"=>[{"type"=>"enumeration", "content"=>"All"}],
    "Mojikumi"=>[{"type"=>"enumeration", "content"=>"Nothing"}],
    "KinsokuSet"=>[{"type"=>"enumeration", "content"=>"Nothing"}],
    "RubyFont"=>[{"type"=>"string", "content"=>"$ID/"}],
    "RubyFontStyle"=>[{"type"=>"enumeration", "content"=>"Nothing"}],
    "RubyFill"=>[{"type"=>"string", "content"=>"Text Color"}],
    "RubyStroke"=>[{"type"=>"string", "content"=>"Text Color"}],
    "KentenFont"=>[{"type"=>"string", "content"=>"$ID/"}],
    "KentenFontStyle"=>[{"type"=>"enumeration", "content"=>"Nothing"}],
    "KentenFillColor"=>[{"type"=>"string", "content"=>"Text Color"}],
    "KentenStrokeColor"=>[{"type"=>"string", "content"=>"Text Color"}],
    "BulletChar"=>
     [{"BulletCharacterType"=>"UnicodeOnly", "BulletCharacterValue"=>"8226"}],
    "NumberingFormat"=>[{"type"=>"string", "content"=>"1, 2, 3, 4..."}],
    "BulletsFont"=>[{"type"=>"string", "content"=>"$ID/"}],
    "BulletsFontStyle"=>[{"type"=>"enumeration", "content"=>"Nothing"}],
    "AppliedNumberingList"=>
     [{"type"=>"object", "content"=>"NumberingList/$ID/[Default]"}],
    "NumberingRestartPolicies"=>
     [{"LowerLevel"=>"0",
       "RestartPolicy"=>"AnyPreviousLevel",
       "UpperLevel"=>"0"}],
    "BulletsCharacterStyle"=>
     [{"type"=>"object",
       "content"=>"CharacterStyle/$ID/[No character style]"}],
    "NumberingCharacterStyle"=>
     [{"type"=>"object",
       "content"=>"CharacterStyle/$ID/[No character style]"}]}]}
{"Imported"=>"false",
 "KeyboardShortcut"=>"0 0",
 "Name"=>"$ID/NormalParagraphStyle",
 "NextStyle"=>"ParagraphStyle/$ID/NormalParagraphStyle",
 "Self"=>"ParagraphStyle/$ID/NormalParagraphStyle",
 "Properties"=>
  [{"BasedOn"=>[{"type"=>"string", "content"=>"$ID/[No paragraph style]"}],
    "PreviewColor"=>[{"type"=>"enumeration", "content"=>"Nothing"}]}]}
    
    
module Idml
  class CharStyle
    attr_accessor :self, :imported, :keyboard_shortcut, :name, :font_style, :point_size, :kerning_method, :kerning_value
    attr_accessor :position, :properties
    
    def initialize(hash)
      @self              = hash['Self']
      @imported          = hash['Imported']
      @keyboard_shortcut = hash['KeyboardShortcut']
      @font_style        = hash['FontStyle']
      @point_size        = hash['PointSize']
      @kerning_method    = hash['KerningMethod']
      @kerning_value     = hash['KerningValue']
      @position          = hash['Position']
      @properties        = hash['Properties']
      
      self
    end 
    
    def self.read_char_styles(char_style_list_xml)
      char_styles = []
      style_hash = Hash.from_xml(char_style_list_xml)
      style_hash = style_hash["RootCharacterStyleGroup"] # flatten hash
      @name = style_hash['Self']
      char_styles_data = style_hash['CharacterStyle']
      if char_styles_data.is_a?(Array)
        char_styles_data.each do |hash|
          char_styles << CharStyle.new(hash)
        end
      else
          char_styles << CharStyle.new(char_styles_data)
      end
      
      char_styles
    end
    
    def to_xml
      
    end

  end
  
  class ParagraphStyle
    attr_accessor :self, :name, :imported, :fill_color, :font_style, :point_size, :horizontal_scale, :kerning_method, :ligatures, :page_number_type, :stroke_weight, :tracking, :composer, :drop_cap_characters, :drop_cap_lines, :baseline_shift, :capitalization, :stroke_color, :hyphenate_ladder_limit, :vertical_scale, :left_indent, :right_indent, :first_line_indent, :auto_leading, :applied_language, :hyphenation, :hyphenate_after_first, :hyphenate_before_last, :hyphenate_capitalized_words, :hyphenate_words_longer_than, :no_break, :hyphenation_zone, :space_before, :space_after, :underline, :o_tf_figure_style, :desired_word_spacing, :maximum_word_spacing, :minimum_word_spacing, :desired_letter_spacing, :maximum_letter_spacing, :minimum_letter_spacing, :desired_glyph_scaling, :maximum_glyph_scaling, :minimum_glyph_scaling, :start_paragraph, :keep_all_lines_together, :keep_with_next, :keep_first_lines, :keep_last_lines, :position, :strike_thru, :character_alignment, :keep_lines_together, :stroke_tint, :fill_tint, :overprint_stroke, :overprint_fill, :gradient_stroke_angle, :gradient_fill_angle, :gradient_stroke_length, :gradient_fill_length, :gradient_stroke_start, :gradient_fill_start, :skew, :rule_above_line_weight, :rule_above_tint, :rule_above_offset, :rule_above_left_indent, :rule_above_right_indent, :rule_above_width, :rule_below_line_weight, :rule_below_tint, :rule_below_offset, :rule_below_left_indent, :rule_below_right_indent, :rule_below_width, :rule_above_overprint, :rule_below_overprint, :rule_above, :rule_below, :last_line_indent, :hyphenate_last_word, :paragraph_break_type, :single_word_justification, :o_tf_ordinal, :o_tf_fraction, :o_tf_discretionary_ligature, :o_tf_titling, :rule_above_gap_tint, :rule_above_gap_overprint, :rule_below_gap_tint, :rule_below_gap_overprint, :justification, :dropcap_detail, :positional_form, :o_tf_mark, :hyphen_weight, :o_tf_locale, :hyphenate_across_columns, :keep_rule_above_in_frame, :ignore_edge_alignment, :o_tf_slashed_zero, :o_tf_stylistic_sets, :o_tf_historical, :o_tf_contextual_alternate, :underline_gap_overprint, :underline_gap_tint, :underline_offset, :underline_overprint, :underline_tint, :underline_weight, :strike_through_gap_overprint, :strike_through_gap_tint, :strike_through_offset, :strike_through_overprint, :strike_through_tint, :strike_through_weight, :miter_limit, :stroke_alignment, :end_join, :span_column_type, :split_column_inside_gutter, :split_column_outside_gutter, :keep_with_previous, :span_column_min_space_before, :span_column_min_space_after, :o_tf_swash, :tsume, :leading_aki, :trailing_aki, :kinsoku_type, :kinsoku_hang_type, :bunri_kinshi, :ruby_open_type_pro, :ruby_font_size, :ruby_alignment, :ruby_type, :ruby_parent_spacing, :ruby_xscale, :ruby_yscale, :ruby_xoffset, :ruby_yoffset, :ruby_position, :ruby_auto_align, :ruby_parent_overhang_amount, :ruby_overhang, :ruby_auto_scaling, :ruby_parent_scaling_percent, :ruby_tint, :ruby_overprint_fill, :ruby_stroke_tint, :ruby_overprint_stroke, :ruby_weight, :kenten_kind, :kenten_font_size, :kenten_xscale, :kenten_yscale, :kenten_placement, :kenten_alignment, :kenten_position, :kenten_custom_character, :kenten_character_set, :kenten_tint, :kenten_overprint_fill, :kenten_stroke_tint, :kenten_overprint_stroke, :kenten_weight, :tatechuyoko, :tatechuyoko_xoffset, :tatechuyoko_yoffset, :auto_tcy, :auto_tcy_include_roman, :jidori, :grid_gyoudori, :grid_align_first_line_only, :grid_alignment, :character_rotation, :rotate_single_byte_characters, :rensuuji, :shatai_magnification, :shatai_degree_angle, :shatai_adjust_tsume, :shatai_adjust_rotation, :warichu, :warichu_lines, :warichu_size, :warichu_line_spacing, :warichu_alignment, :warichu_chars_before_break, :warichu_chars_after_break, :o_tf_hv_kana, :o_tf_proportional_metrics, :o_tf_roman_italics, :leading_model, :scale_affects_line_height, :paragraph_gyoudori, :cjk_grid_tracking, :glyph_form, :ruby_auto_tcy_digits, :ruby_auto_tcy_include_roman, :ruby_auto_tcy_auto_scale, :treat_ideographic_space_as_space, :allow_arbitrary_hyphenation, :bullets_and_numbering_list_type, :numbering_start_at, :numbering_level, :numbering_continue, :numbering_apply_restart_policy, :bullets_alignment, :numbering_alignment, :numbering_expression, :bullets_text_after, :digits_type, :kashidas, :diacritic_position, :character_direction, :paragraph_direction, :paragraph_justification, :paragraph_kashida_width, :x_offset_diacritic, :y_offset_diacritic, :o_tf_overlap_swash, :o_tf_stylistic_alternate, :o_tf_justification_alternate, :o_tf_stretched_alternate, :keyboard_direction, :properties
    
    def self.read_styles(xml)
      puts __method__
      hash = Hash.from_xml(xml)
      puts hash.keys
      hash
    end
    
    def initialize(hash)
      # puts hash.keys

      @self                             = hash['Self']
      @name                             = hash['Name']
      @imported                         = hash['Imported']
      @fill_color                       = hash['FillColor']
      @font_style                       = hash['FontStyle']
      @point_size                       = hash['PointSize']
      @horizontal_scale                 = hash['HorizontalScale']
      @kerning_method                   = hash['KerningMethod']
      @ligatures                        = hash['Ligatures']
      @page_number_type                 = hash['PageNumberType']
      @stroke_weight                    = hash['StrokeWeight']
      @tracking                         = hash['Tracking']
      @composer                         = hash['Composer']
      @drop_cap_characters              = hash['DropCapCharacters']
      @drop_cap_lines                   = hash['DropCapLines']
      @baseline_shift                   = hash['BaselineShift']
      @capitalization                   = hash['Capitalization']
      @stroke_color                     = hash['StrokeColor']
      @hyphenate_ladder_limit           = hash['HyphenateLadderLimit']
      @vertical_scale                   = hash['VerticalScale']
      @left_indent                      = hash['LeftIndent']
      @right_indent                     = hash['RightIndent']
      @first_line_indent                = hash['FirstLineIndent']
      @auto_leading                     = hash['AutoLeading']
      @applied_language                 = hash['AppliedLanguage']
      @hyphenation                      = hash['Hyphenation']
      @hyphenate_after_first            = hash['HyphenateAfterFirst']
      @hyphenate_before_last            = hash['HyphenateBeforeLast']
      @hyphenate_capitalized_words      = hash['HyphenateCapitalizedWords']
      @hyphenate_words_longer_than      = hash['HyphenateWordsLongerThan']
      @no_break                         = hash['NoBreak']
      @hyphenation_zone                 = hash['HyphenationZone']
      @space_before                     = hash['SpaceBefore']
      @space_after                      = hash['SpaceAfter']
      @underline                        = hash['Underline']
      @o_tf_figure_style                = hash['OTFFigureStyle']
      @desired_word_spacing             = hash['DesiredWordSpacing']
      @maximum_word_spacing             = hash['MaximumWordSpacing']
      @minimum_word_spacing             = hash['MinimumWordSpacing']
      @desired_letter_spacing           = hash['DesiredLetterSpacing']
      @maximum_letter_spacing           = hash['MaximumLetterSpacing']
      @minimum_letter_spacing           = hash['MinimumLetterSpacing']
      @desired_glyph_scaling            = hash['DesiredGlyphScaling']
      @maximum_glyph_scaling            = hash['MaximumGlyphScaling']
      @minimum_glyph_scaling            = hash['MinimumGlyphScaling']
      @start_paragraph                  = hash['StartParagraph']
      @keep_all_lines_together          = hash['KeepAllLinesTogether']
      @keep_with_next                   = hash['KeepWithNext']
      @keep_first_lines                 = hash['KeepFirstLines']
      @keep_last_lines                  = hash['KeepLastLines']
      @position                         = hash['Position']
      @strike_thru                      = hash['StrikeThru']
      @character_alignment              = hash['CharacterAlignment']
      @keep_lines_together              = hash['KeepLinesTogether']
      @stroke_tint                      = hash['StrokeTint']
      @fill_tint                        = hash['FillTint']
      @overprint_stroke                 = hash['OverprintStroke']
      @overprint_fill                   = hash['OverprintFill']
      @gradient_stroke_angle            = hash['GradientStrokeAngle']
      @gradient_fill_angle              = hash['GradientFillAngle']
      @gradient_stroke_length           = hash['GradientStrokeLength']
      @gradient_fill_length             = hash['GradientFillLength']
      @gradient_stroke_start            = hash['GradientStrokeStart']
      @gradient_fill_start              = hash['GradientFillStart']
      @skew                             = hash['Skew']
      @rule_above_line_weight           = hash['RuleAboveLineWeight']
      @rule_above_tint                  = hash['RuleAboveTint']
      @rule_above_offset                = hash['RuleAboveOffset']
      @rule_above_left_indent           = hash['RuleAboveLeftIndent']
      @rule_above_right_indent          = hash['RuleAboveRightIndent']
      @rule_above_width                 = hash['RuleAboveWidth']
      @rule_below_line_weight           = hash['RuleBelowLineWeight']
      @rule_below_tint                  = hash['RuleBelowTint']
      @rule_below_offset                = hash['RuleBelowOffset']
      @rule_below_left_indent           = hash['RuleBelowLeftIndent']
      @rule_below_right_indent          = hash['RuleBelowRightIndent']
      @rule_below_width                 = hash['RuleBelowWidth']
      @rule_above_overprint             = hash['RuleAboveOverprint']
      @rule_below_overprint             = hash['RuleBelowOverprint']
      @rule_above                       = hash['RuleAbove']
      @rule_below                       = hash['RuleBelow']
      @last_line_indent                 = hash['LastLineIndent']
      @hyphenate_last_word              = hash['HyphenateLastWord']
      @paragraph_break_type             = hash['ParagraphBreakType']
      @single_word_justification        = hash['SingleWordJustification']
      @o_tf_ordinal                     = hash['OTFOrdinal']
      @o_tf_fraction                    = hash['OTFFraction']
      @o_tf_discretionary_ligature      = hash['OTFDiscretionaryLigature']
      @o_tf_titling                     = hash['OTFTitling']
      @rule_above_gap_tint              = hash['RuleAboveGapTint']
      @rule_above_gap_overprint         = hash['RuleAboveGapOverprint']
      @rule_below_gap_tint              = hash['RuleBelowGapTint']
      @rule_below_gap_overprint         = hash['RuleBelowGapOverprint']
      @justification                    = hash['Justification']
      @dropcap_detail                   = hash['DropcapDetail']
      @positional_form                  = hash['PositionalForm']
      @o_tf_mark                        = hash['OTFMark']
      @hyphen_weight                    = hash['HyphenWeight']
      @o_tf_locale                      = hash['OTFLocale']
      @hyphenate_across_columns         = hash['HyphenateAcrossColumns']
      @keep_rule_above_in_frame         = hash['KeepRuleAboveInFrame']
      @ignore_edge_alignment            = hash['IgnoreEdgeAlignment']
      @o_tf_slashed_zero                = hash['OTFSlashedZero']
      @o_tf_stylistic_sets              = hash['OTFStylisticSets']
      @o_tf_historical                  = hash['OTFHistorical']
      @o_tf_contextual_alternate        = hash['OTFContextualAlternate']
      @underline_gap_overprint          = hash['UnderlineGapOverprint']
      @underline_gap_tint               = hash['UnderlineGapTint']
      @underline_offset                 = hash['UnderlineOffset']
      @underline_overprint              = hash['UnderlineOverprint']
      @underline_tint                   = hash['UnderlineTint']
      @underline_weight                 = hash['UnderlineWeight']
      @strike_through_gap_overprint     = hash['StrikeThroughGapOverprint']
      @strike_through_gap_tint          = hash['StrikeThroughGapTint']
      @strike_through_offset            = hash['StrikeThroughOffset']
      @strike_through_overprint         = hash['StrikeThroughOverprint']
      @strike_through_tint              = hash['StrikeThroughTint']
      @strike_through_weight            = hash['StrikeThroughWeight']
      @miter_limit                      = hash['MiterLimit']
      @stroke_alignment                 = hash['StrokeAlignment']
      @end_join                         = hash['EndJoin']
      @span_column_type                 = hash['SpanColumnType']
      @split_column_inside_gutter       = hash['SplitColumnInsideGutter']
      @split_column_outside_gutter      = hash['SplitColumnOutsideGutter']
      @keep_with_previous               = hash['KeepWithPrevious']
      @span_column_min_space_before     = hash['SpanColumnMinSpaceBefore']
      @span_column_min_space_after      = hash['SpanColumnMinSpaceAfter']
      @o_tf_swash                       = hash['OTFSwash']
      @tsume                            = hash['Tsume']
      @leading_aki                      = hash['LeadingAki']
      @trailing_aki                     = hash['TrailingAki']
      @kinsoku_type                     = hash['KinsokuType']
      @kinsoku_hang_type                = hash['KinsokuHangType']
      @bunri_kinshi                     = hash['BunriKinshi']
      @ruby_open_type_pro               = hash['RubyOpenTypePro']
      @ruby_font_size                   = hash['RubyFontSize']
      @ruby_alignment                   = hash['RubyAlignment']
      @ruby_type                        = hash['RubyType']
      @ruby_parent_spacing              = hash['RubyParentSpacing']
      @ruby_xscale                      = hash['RubyXScale']
      @ruby_yscale                      = hash['RubyYScale']
      @ruby_xoffset                     = hash['RubyXOffset']
      @ruby_yoffset                     = hash['RubyYOffset']
      @ruby_position                    = hash['RubyPosition']
      @ruby_auto_align                  = hash['RubyAutoAlign']
      @ruby_parent_overhang_amount      = hash['RubyParentOverhangAmount']
      @ruby_overhang                    = hash['RubyOverhang']
      @ruby_auto_scaling                = hash['RubyAutoScaling']
      @ruby_parent_scaling_percent      = hash['RubyParentScalingPercent']
      @ruby_tint                        = hash['RubyTint']
      @ruby_overprint_fill              = hash['RubyOverprintFill']
      @ruby_stroke_tint                 = hash['RubyStrokeTint']
      @ruby_overprint_stroke            = hash['RubyOverprintStroke']
      @ruby_weight                      = hash['RubyWeight']
      @kenten_kind                      = hash['KentenKind']
      @kenten_font_size                 = hash['KentenFontSize']
      @kenten_xscale                    = hash['KentenXScale']
      @kenten_yscale                    = hash['KentenYScale']
      @kenten_placement                 = hash['KentenPlacement']
      @kenten_alignment                 = hash['KentenAlignment']
      @kenten_position                  = hash['KentenPosition']
      @kenten_custom_character          = hash['KentenCustomCharacter']
      @kenten_character_set             = hash['KentenCharacterSet']
      @kenten_tint                      = hash['KentenTint']
      @kenten_overprint_fill            = hash['KentenOverprintFill']
      @kenten_stroke_tint               = hash['KentenStrokeTint']
      @kenten_overprint_stroke          = hash['KentenOverprintStroke']
      @kenten_weight                    = hash['KentenWeight']
      @tatechuyoko                      = hash['Tatechuyoko']
      @tatechuyoko_xoffset              = hash['TatechuyokoXOffset']
      @tatechuyoko_yoffset              = hash['TatechuyokoYOffset']
      @auto_tcy                         = hash['AutoTcy']
      @auto_tcy_include_roman           = hash['AutoTcyIncludeRoman']
      @jidori                           = hash['Jidori']
      @grid_gyoudori                    = hash['GridGyoudori']
      @grid_align_first_line_only       = hash['GridAlignFirstLineOnly']
      @grid_alignment                   = hash['GridAlignment']
      @character_rotation               = hash['CharacterRotation']
      @rotate_single_byte_characters    = hash['RotateSingleByteCharacters']
      @rensuuji                         = hash['Rensuuji']
      @shatai_magnification             = hash['ShataiMagnification']
      @shatai_degree_angle              = hash['ShataiDegreeAngle']
      @shatai_adjust_tsume              = hash['ShataiAdjustTsume']
      @shatai_adjust_rotation           = hash['ShataiAdjustRotation']
      @warichu                          = hash['Warichu']
      @warichu_lines                    = hash['WarichuLines']
      @warichu_size                     = hash['WarichuSize']
      @warichu_line_spacing             = hash['WarichuLineSpacing']
      @warichu_alignment                = hash['WarichuAlignment']
      @warichu_chars_before_break       = hash['WarichuCharsBeforeBreak']
      @warichu_chars_after_break        = hash['WarichuCharsAfterBreak']
      @o_tf_hv_kana                     = hash['OTFHVKana']
      @o_tf_proportional_metrics        = hash['OTFProportionalMetrics']
      @o_tf_roman_italics               = hash['OTFRomanItalics']
      @leading_model                    = hash['LeadingModel']
      @scale_affects_line_height        = hash['ScaleAffectsLineHeight']
      @paragraph_gyoudori               = hash['ParagraphGyoudori']
      @cjk_grid_tracking                = hash['CjkGridTracking']
      @glyph_form                       = hash['GlyphForm']
      @ruby_auto_tcy_digits             = hash['RubyAutoTcyDigits']
      @ruby_auto_tcy_include_roman      = hash['RubyAutoTcyIncludeRoman']
      @ruby_auto_tcy_auto_scale         = hash['RubyAutoTcyAutoScale']
      @treat_ideographic_space_as_space = hash['TreatIdeographicSpaceAsSpace']
      @allow_arbitrary_hyphenation      = hash['AllowArbitraryHyphenation']
      @bullets_and_numbering_list_type  = hash['BulletsAndNumberingListType']
      @numbering_start_at               = hash['NumberingStartAt']
      @numbering_level                  = hash['NumberingLevel']
      @numbering_continue               = hash['NumberingContinue']
      @numbering_apply_restart_policy   = hash['NumberingApplyRestartPolicy']
      @bullets_alignment                = hash['BulletsAlignment']
      @numbering_alignment              = hash['NumberingAlignment']
      @numbering_expression             = hash['NumberingExpression']
      @bullets_text_after               = hash['BulletsTextAfter']
      @digits_type                      = hash['DigitsType']
      @kashidas                         = hash['Kashidas']
      @diacritic_position               = hash['DiacriticPosition']
      @character_direction              = hash['CharacterDirection']
      @paragraph_direction              = hash['ParagraphDirection']
      @paragraph_justification          = hash['ParagraphJustification']
      @paragraph_kashida_width          = hash['ParagraphKashidaWidth']
      @x_offset_diacritic               = hash['XOffsetDiacritic']
      @y_offset_diacritic               = hash['YOffsetDiacritic']
      @o_tf_overlap_swash               = hash['OTFOverlapSwash']
      @o_tf_stylistic_alternate         = hash['OTFStylisticAlternate']
      @o_tf_justification_alternate     = hash['OTFJustificationAlternate']
      @o_tf_stretched_alternate         = hash['OTFStretchedAlternate']
      @keyboard_direction               = hash['KeyboardDirection']
      @properties                       = hash['Properties']

      self
    end 
    
    def self.read_para_styles(para_style_list_xml)
      para_styles = []
      style_hash  = Hash.from_xml(para_style_list_xml)
      style_hash  = style_hash["RootParagraphStyleGroup"] # flatten hash
      @name       = style_hash['Self']
      para_styles_data = style_hash['ParagraphStyle']
      if para_styles_data.is_a?(Array)
        para_styles_data.each do |hash|
          para_styles << ParagraphStyle.new(hash)
        end
      else
          para_styles << ParagraphStyle.new(para_styles_data)
      end
      
      para_styles      
    end
    
    def to_xml
      
    end
    
    def to_attributted_string
      
    end
  end
  #rectangles, ellipses, graphic lines, polygons, groups, buttons, and text frames

end