
module RLayout
  
  # BoxTable is fixed size table with text and image cell.
  # Layout is created by given data array.
  # BoxTable is used as super class of GroupImage and BoxAd

  # BoxTable should be given two inputs
  # table_data and table_style
  
  # table_data
  # series of row data in Array

  # table_style
  #   graphic_style(shape, and border) for table, 
  # hash of styles and information for 
  # heading_row_style
  # category_row_style
  # heading_style
  # row_styles
  # 
  
  # fit mode
  # fix_to_box_height
  # grow_box_height
  
  # What is table category?
  # Category is a left most column that represent category.
  # Same catgory title cells are merges into one category cell. 
  
  # category_level
  # Sometimes category levels are more than one level deep
  # category_level is number of categories. 

  class BoxTable < Container
    attr_reader :kind, :data, :heading_level, :category_level
    attr_reader :heading_styles, :body_styles
    attr_reader :table_data, :table_style
    attr_reader :pdf_doc, :style_serice
    def initialize(options={})
      super
      @heading_level = options[:heading_level] || 0
      @table_data = options[:table_data]
      if options[:box_text_style]
        @box_text_style = options[:box_text_style]
        RLayout::StyleService.shared_style_service.current_style = @box_text_style
      elsif options[:box_text_style_path]
        RLayout::StyleService.shared_style_service.current_style = YAML::load_file(options[:box_text_style_path])
      end
      set_style
      @row_count  = @table_data.length
      create_rows
      relayout!
      self
    end

    def create_rows
      @table_data.each_with_index do |row, i|
        h                 = {}
        h[:parent]        = self
        h[:layout_direction] = 'horizontal'
        h[:layout_expand] = [:width, :height]
        h[:row_data]      = row
        RLayout::BoxTableRow.new(h)
      end
    end
    
    def default_cell_graphic_style
      {fill_color: 'yellow', stroke_color: 'black', stroke_width: 1}
    end

    def default_cell_text_style

    end
    
    def set_style
      # set body row style
      if @row_styles && @row_styles.length > 0
        @graphics._with_index do |row, i|
          if i <= @heading_level
            # set heading row style

          end
          @row_styles.each_index do |row_style, i|
            @graphics[i].set_graphics_style
          end
        end
      end

      if @category_styles && @category_styles.length > 0
        @graphics._with_index do |row, i|
          if i <= @heading_level
            # set heading category style

          end
          @category_styles.each_index do |category_style, i|
            @graphics[i].set_graphics_style
          end
        end
      end      
      
      # @shape        = @table_style[:shape_hash]        || {shape:'rectangle'}
      # @fill_hash    = @table_style[:fill_hash]    || {fill_color:'red'}
      # @stroke_hash  = @table_style[:stroke_hash]  || {stroke_color:'black', stroke_width: 1}
    end

    def graphic_style_of_cell(colum_index, row_index)


    end

    def text_style_of_cell(colum_index, row_index)


    end
    
    def row_count
      @graphics.length
    end

  end

end



TABLE_STYLE =<<EOF
---
body:
  korean_name: ????????????
  category:
  font_family: Shinmoon
  font: Shinmoon
  font_size: 9.8
  text_color: CMYK=0,0,0,100
  text_alignment: center
  tracking: -0.4
  space_width: 3.0
  scale: 98.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
body_gothic:
  korean_name: ????????????
  category:
  font_family: KoPub?????????_Pro Light
  font: KoPubDotumPL
  font_size: 9.6
  text_color: CMYK=0,0,0,100
  text_alignment: justify
  tracking: -0.2
  space_width: 3.0
  scale: 100.0
  first_line_indent: 0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
running_head:
  korean_name: ????????????
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubDotumPM
  font_size: 9.6
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -0.2
  space_width: 3.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
quote:
  korean_name: ??????
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubBatangPM
  font_size: 12.0
  text_color: CMYK=0,0,0,100
  text_alignment: center
  tracking: -0.5
  space_width: 6.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 2
  space_after_in_lines: 0
  text_height_in_lines: 1
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
announcement_1:
  korean_name: ?????????1???
  category:
  font: KoPubDotumPM
  font_size: 12.0
  text_color: CMYK=0,0,0,0
  text_alignment: left
  tracking: -0.5
  space_width: 6.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 2
  space_after_in_lines: 0
  text_height_in_lines: 1
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
announcement_2:
  korean_name: ?????????2???
  category:
  font: KoPubDotumPM
  font_size: 9.6
  text_color: CMYK=0,0,0,0
  text_alignment: left
  tracking: -0.5
  space_width: 6.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 2
  space_after_in_lines: 0
  text_height_in_lines: 1
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1s
caption_title:
  korean_name: ????????????
  category:
  font_family: KoPub?????????_Pro Bold
  font: KoPubDotumPB
  font_size: 9.0
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -0.2
  space_width: 2.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
caption:
  korean_name: ????????????
  category:
  font_family: KoPub?????????_Pro Light
  font: KoPubDotumPL
  font_size: 7.5
  text_color: CMYK=0,0,0,100
  text_alignment: justify
  tracking: -0.5
  space_width: 1.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
source:
  korean_name: ????????????
  category:
  font_family: KoPub?????????_Pro Light
  font: KoPubDotumPL
  font_size: 7.5
  text_color: CMYK=0,0,0,100
  text_alignment: right
  tracking: -0.2
  space_width: 2.0
  scale: 70.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
reporter:
  korean_name: ?????????
  category:
  font_family: KoPub?????????_Pro Light
  font: KoPubDotumPL
  font_size: 7.0
  text_color: CMYK=0,0,0,100
  text_alignment: right
  tracking: 0.0
  space_width: 2.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 0
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
linked_story:
  korean_name: ????????????
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubDotumPM
  font_size: 9.0
  text_color: CMYK=0,0,0,100
  text_alignment: right
  tracking: 0
  space_width: 2.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 0
  space_after_in_lines: 
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
reporter_editorial:
  korean_name: ????????????
  category:
  font_family: KoPub?????????_Pro Light
  font: KoPubDotumPL
  font_size: 9.4
  text_color: CMYK=0,0,0,100
  text_alignment: right
  tracking: 0.0
  space_width: 2.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes:
    token_union_style:
      stroke_width: 1.5
      stroke_sides:
        - 0
        - 1
        - 0
        - 0
      top_line_space: 3
  publication_id: 1
title_main:
  korean_name: ??????_??????
  category:
  font_family: KoPub?????????_Pro Bold
  font: KoPubBatangPB
  font_size: 42.0
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -1.0
  space_width: 10.0
  scale: 100.0
  text_line_spacing: 3
  space_before_in_lines: 0
  space_after_in_lines: 1
  text_height_in_lines: 3
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
title_4_5:
  korean_name: ??????_4-5???
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubBatangPM
  font_size: 32.0
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -1.5
  space_width: 10.0
  scale: 100.0
  text_line_spacing: 3
  space_before_in_lines: 1
  space_after_in_lines: 1
  text_height_in_lines: 4
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
title_4:
  korean_name: ??????_4???
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubBatangPM
  font_size: 30.0
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -2.0
  space_width: 7.0
  scale: 100.0
  text_line_spacing: 7
  space_before_in_lines: 1
  space_after_in_lines: 0
  text_height_in_lines: 5
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
title_3:
  korean_name: ??????_3???
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubBatangPM
  font_size: 27.0
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -2.0
  space_width: 4.0
  scale: 100.0
  text_line_spacing: 5
  space_before_in_lines: 1
  space_after_in_lines: 1
  text_height_in_lines: 3
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
title_2:
  korean_name: ??????_2???
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubBatangPM
  font_size: 23.0
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -2.0
  space_width: 4.0
  scale: 100.0
  text_line_spacing: 7
  space_before_in_lines: 1
  space_after_in_lines: 1
  text_height_in_lines: 3
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
title_1:
  korean_name: ??????_1???
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubBatangPM
  font_size: 18.0
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -2.0
  space_width: 4.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 1
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
subtitle_main:
  korean_name: ??????_??????
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubBatangPM
  font_size: 18.0
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -1.0
  space_width: 5.0
  scale: 100.0
  text_line_spacing: 7
  space_before_in_lines: 1
  space_after_in_lines: 2
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
subtitle_M:
  korean_name: ??????_14
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubBatangPM
  font_size: 14.0
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -1.0
  space_width: 5.0
  scale: 100.0
  text_line_spacing: 5.0
  space_before_in_lines: 0
  space_after_in_lines: 0.5
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
subtitle_S:
  korean_name: ??????_12
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubBatangPM
  font_size: 13.5
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -1.0
  space_width: 4.0
  scale: 100.0
  text_line_spacing: 6
  space_before_in_lines: 0
  space_after_in_lines: 0.5
  text_height_in_lines: 1
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
subtitle_s_gothic:
  korean_name: ??????_12_??????
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubDotumPM
  font_size: 12.0
  text_color: CMYK=0,0,0,100
  text_alignment: center
  tracking: -1.0
  space_width: 4.0
  scale: 100.0
  text_line_spacing: 6.0
  space_before_in_lines: 0.5
  space_after_in_lines: 0.5
  text_height_in_lines: 1
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
news_line_title:
  korean_name: ????????????_??????
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubDotumPM
  font_size: 13.0
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -0.5
  space_width: 3.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
brand_name:
  korean_name: ??????_????????????
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubDotumPM
  font_size: 13.0
  text_color: CMYK=0,0,0,100
  text_alignment: center
  tracking: -0.5
  space_width: 3.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
subject_head_main:
  korean_name: ??????_??????
  category:
  font_family: KoPub?????????_Pro Bold
  font: KoPubDotumPB
  font_size: 16.0
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -0.5
  space_width: 3.0
  scale: 100.0
  text_line_spacing: 10
  space_before_in_lines: 1
  space_after_in_lines: 1
  text_height_in_lines: 0
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
subject_head_L:
  korean_name: ??????_18
  category:
  font_family: KoPub?????????_Pro Bold
  font: KoPubDotumPB
  font_size: 18.0
  text_color: CMYK=100,50,0,0
  text_alignment: left
  tracking: -0.5
  space_width: 0.0
  scale: 100.0
  text_line_spacing: 10
  space_before_in_lines: 1
  space_after_in_lines: 1
  text_height_in_lines: 0
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
subject_head_M:
  korean_name: ??????_14
  category:
  font_family: KoPub?????????_Pro Bold
  font: KoPubDotumPB
  font_size: 14.0
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -0.5
  space_width: 3.0
  scale: 100.0
  text_line_spacing: 10
  space_before_in_lines: 1
  space_after_in_lines: 1
  text_height_in_lines: 0
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
subject_head_S:
  korean_name: ??????_12
  category:
  font_family: KoPub?????????_Pro Bold
  font: KoPubDotumPB
  font_size: 12.0
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -0.5
  space_width: 3.0
  scale: 100.0
  text_line_spacing: 10
  space_before_in_lines: 1
  space_after_in_lines: 0
  text_height_in_lines: 0
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
subject_head_editorial:
  korean_name: ????????????
  category:
  font_family: KoPub?????????_Pro Bold
  font: KoPubDotumPB
  font_size: 12.0 
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -0
  space_width: 3
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 0.6
  space_after_in_lines: 1
  text_height_in_lines: 1
  box_attributes: ''
  markup: ''
  graphic_attributes:
    token_union_style:
      stroke_width: 3
      stroke_sides:
        - 0
        - 1
        - 0
        - 0
      top_line_space: 8
  publication_id: 1
editor_note:
  korean_name: ????????????
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubDotumPM
  font_size: 8.8
  text_color: CMYK=0,0,0,80
  text_alignment: left
  tracking: -0.3
  space_width: 3.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
title_opinion:
  korean_name: ?????? ??????
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubBatangPM
  font_size: 22.0
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -1.5
  space_width: 7.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 2
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
title_editorial:
  korean_name: ?????? ??????
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubBatangPM
  font_size: 19.0
  text_color: CMYK=0,0,0,100
  text_alignment: left
  tracking: -1.5
  space_width: 5.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 0
  space_after_in_lines: 1
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
title_7:
  korean_name: ??????_7???
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubBatangPM
  font_size: 36.0
  text_color: ''
  text_alignment: left
  tracking: -2.0
  space_width: 7.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 2
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
title_6:
  korean_name: ??????_6???
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubBatangPM
  font_size: 34.0
  text_color: ''
  text_alignment: left
  tracking: -2.0
  space_width: 7.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 2
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
title_5:
  korean_name: ??????_5???
  category:
  font_family: KoPub?????????_Pro Medium
  font: KoPubBatangPM
  font_size: 32.0
  text_color: ''
  text_alignment: left
  tracking: -2.0
  space_width: 7.0
  scale:
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 2
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
title_main_7:
  korean_name: ??????_??????_7
  category:
  font_family: KoPub?????????_Pro Bold
  font: KoPubBatangPB
  font_size: 45.0
  text_color: ''
  text_alignment: left
  tracking: -1.0
  space_width: 10.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 0
  text_height_in_lines: 3
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
title_main_6:
  korean_name: ??????_??????_6
  category:
  font_family: KoPub?????????_Pro Bold
  font: KoPubBatangPB
  font_size: 45.0
  text_color: ''
  text_alignment: left
  tracking: -1.0
  space_width: 10.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 0
  text_height_in_lines: 3
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
title_main_5:
  korean_name: ??????_??????_5
  category:
  font_family: KoPub?????????_Pro Bold
  font: KoPubBatangPB
  font_size: 42.0
  text_color: ''
  text_alignment: left
  tracking: -1.0
  space_width: 10.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 0
  text_height_in_lines: 3
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1
EOF
