
EDITORIAL_MARGIN                  = 14

# front_page_heading_height: height of frontpage heading in lines
# inner_page_heading_height: height of innerpage heading in lines
# page_heading_margin_in_lines: actual heading margin for top positined article

ARTICLE_BOTTOM_SPACES_IN_LINE = 2
module RLayout

  class NewsBoxMaker
    attr_reader :article_path, :template, :story_path, :image_path
    attr_reader :news_box, :output_path, :project_path
    attr_reader :article_info_path
    attr_reader :custom_style, :publication_name, :time_stamp
    attr_reader :pdf_doc, :pdf_data, :story_md, :layout_rb
    attr_reader :adjusted_line_count, :new_height_in_lines, :adjustable_height
    attr_reader :time_stamp, :fixed_height_in_lines

    def initialize(options={})
      # time_start              = Time.now
      stamp_time              if options[:time_stamp]
      @fixed_height_in_lines  = options[:fixed_height_in_lines]
      @adjustable_height      = true if options[:adjustable_height]
      @story_md     = options[:story_md]
      @layout_rb    = options[:layout_rb]
      @article_path = options[:article_path]
      @story_path   = options[:story_path]
      if @story_md && @article_path
        # when content is passed from rails
        @output_path  = @article_path + "/story.pdf"
      elsif @story_path
        # when reading content from file system
        unless File.exist?(@story_path)
          puts "No story_path doen't exist !!!"
          return
        end
        @article_path = File.dirname(@story_path)
        @output_path  = @article_path + "/story.pdf"
      elsif @article_path
        # when reading content from file system
        unless File.directory?(@article_path)
          puts "article_path doesn't exit !!!"
          return
        end
        layout_rb_path  = @article_path + "/layout.rb"
        @layout_rb      = File.open(layout_rb_path, 'r'){|f| f.read}
        @story_path     = Dir.glob("#{@article_path}/*{.md, .markdown}").first

        if @story_path
          ext = File.extname(@story_path)
          @output_path  = @article_path + "/#{File.basename(@story_path, ext)}" + ".pdf"
        else
          @output_path  = @article_path + "/output.pdf"
        end
      end
      $ProjectPath      = @article_path
      @custom_style     = options[:custom_style] if options[:custom_style]
      @publication_name = options[:publication_name] if options[:publication_name]
      RLayout::StyleService.shared_style_service.current_style = YAML::load(NEWSPAPER_STYLE)
      if @custom_style && @publication_name
        @custom_style_path = "/Users/Shared/SoftwareLab/newsman/#{@publication_name}/text_style.yml"
        if File.exist?(@custom_style_path)
          custom_style_yaml = File.open(@custom_style_path, 'r'){|f| f.read}
          RLayout::StyleService.shared_style_service.current_style = YAML::load(custom_style_yaml)
        else
          puts "No custom style file :#{@custom_style_path} found !!!"
          return
        end
      elsif $ProjectPath
        a = $ProjectPath.split("public/1")
        publication_path = a[0] + "public/1"
        @local_style_path = publication_path + "/text_style/text_style.yml"
        if File.exist?(@local_style_path)
          local_style_yaml = File.open(@local_style_path, 'r'){|f| f.read}
          RLayout::StyleService.shared_style_service.current_style =  YAML::load(local_style_yaml)
        else
          default_style_path = "/Users/Shared/SoftwareLab/newsman/newspaper/text_style.yml"
          if File.exist?(default_style_path)
            custom_style_yaml = File.open(default_style_path, 'r'){|f| f.read}
            RLayout::StyleService.shared_style_service.current_style = YAML::load(custom_style_yaml)
          else
            puts "No custom style file :#{@custom_style_path} found !!!"
            return
          end
        end
      end

      if options[:image_path]
        @image_path = options[:image_path]
      else
        @image_path = @article_path + "/images"
      end
      if options[:output_path]
        @output_path = options[:output_path]
      end
      unless @output_path
        @output_path = @article_path + "/output.pdf"
      end
      @svg_path           = @output_path.sub(".pdf", ".svg")
      @article_info_path  = @article_path + "/article_info.yml"

      if @layout_rb
        @news_box   = eval(@layout_rb)
        @news_box.adjustable_height= true if @adjustable_height
      elsif options[:template_path] && File.exist?(options[:template_path])
        @template_path = options[:template_path]
        template    = File.open(@template_path,'r'){|f| f.read}
        @news_box   = eval(template)
      else
        @template_path = Dir.glob("#{@article_path}/*.{rb,script,pgscript}").first
        unless @template_path
        puts "No layout  found !!!"
        return
        else
          template    = File.open(@template_path,'r'){|f| f.read}
          @news_box   = eval(template)
        end
      end
      if @news_box.is_a?(SyntaxError)
        puts "SyntaxError in #{@template_path} !!!!"
        return
      end

      # This is called to set NewsArticleBox with fixed height.
      # Since height value is saved in layout_rb file, 
      # we can replace the layout_rb text with the new value 
      # or we instatialte it with eval and call this to change the height
      # here we are taking the second option

      if @news_box.is_a?(NewsImageBox)
        @news_box.stroke[:sides] = [0,0,0,0]
        @news_box.stroke.thickness = 0.3
      elsif @news_box.is_a?(NewsAdBox)
        @news_box.stroke[:sides] = [0,0,0,0]
        @news_box.stroke.thickness = 0.0
      elsif @news_box.is_a?(NewsComicBox)
      elsif @news_box.is_a?(NewsArticleBox)
        if @news_box.kind == 'overlap'
          @news_box.stroke[:sides] = [0,1,0,1]
          @news_box.stroke.thickness = 0.3
        end
        read_story
        layout_story
      elsif @news_box.is_a?(Container)
      else
      end
      # TODO this should be moved to rails front
      if @news_box.kind_of?(NewsBox) 
        if @news_box.kind == '??????' 
          if @news_box.draw_frame == false
            @news_box.stroke[:sides] = [0,0,0,0]
          else
            @news_box.stroke[:sides] = [0,0,0,1]
          end
        elsif @news_box.is_a?(NewsAdBox) 
          @news_box.stroke[:sides] = [0,0,0,0]
        elsif @news_box.is_a?(NewsImageBox)
          @news_box.stroke[:sides] = [0,0,0,1]
        elsif @news_box.graphics.first.column_type == 'editorial_with_profile_image' # s&& @news_box.kind == '??????'
          @news_box.stroke[:sides] = [1,1,0,1, "open_left_inset_line"]
          @news_box.left_margin = @news_box.gutter
          @news_box.left_inset  = @news_box.gutter*2
        elsif @news_box.kind == '??????' && @news_box.page_number == 23
          @news_box.stroke[:sides] = [1,1,1,1]
          @news_box.left_margin    = @news_box.gutter

        elsif @news_box.kind == '??????'
          if  @news_box.column_count == 6       
            @news_box.stroke[:sides] = [0,1,0,0] 
          elsif @news_box.bottom_article
            @news_box.stroke[:sides] = [0,1,0,1]
          else
            @news_box.stroke[:sides] = [0,1,0,0]
          end
        elsif @news_box.kind == '????????????'
          @news_box.stroke[:sides] = [1,6,1,1]
          @news_box.left_margin   = 0
          @news_box.right_margin  = 0
          @news_box.left_inset    = 0
          @news_box.right_inset   = 0
        elsif @news_box.kind == '??????-??????'
          @news_box.left_margin = 0
          @news_box.right_margin = 0
          @news_box.stroke[:sides] = [0,1,0,1]
        elsif @news_box.embedded
            @news_box.stroke[:sides] = [0,1,0,1]
        # elsif @news_box.bottom_article
        #   @news_box.stroke[:sides] = [0,0,0,1]
        # else
        #   @news_box.stroke[:sides] = [0,0,0,1]
        end
        if @news_box.frame_sides == '?????????'
          @news_box.stroke[:sides] = [1,1,1,1]
          @news_box.stroke[:thickness] = @news_box.frame_thickness
        end
      else
          @news_box.stroke[:sides] = [0,0,0,1]
      end
      if @news_box
        delete_old_files
        @news_box.save_pdf(@output_path, :jpg=>true, :ratio => 2.0)
        if @time_stamp
          stamped_path      = @output_path.sub(/\.pdf$/, "#{@time_stamp}.pdf")
          output_jpg_path   = @output_path.sub(/pdf$/, "jpg")
          stamped_jpg_path  = stamped_path.sub(/pdf$/, "jpg")
          system("cp #{@output_path} #{stamped_path}")
          system("cp #{output_jpg_path} #{stamped_jpg_path}")
        end
      end
      # time_end = Time.now
      # puts "++++++++ NewsBoxMaker took:#{time_end - time_start}"
      self
    end

    def stamp_time
      t = Time.now
      h = t.hour
      @time_stamp = "#{t.day.to_s.rjust(2, '0')}#{t.hour.to_s.rjust(2, '0')}#{t.min.to_s.rjust(2, '0')}#{t.sec.to_s.rjust(2, '0')}"
    end

    def delete_old_files
      old_pdf_files = Dir.glob("#{@article_path}/story*.pdf")
      old_jpg_files = Dir.glob("#{@article_path}/story*.jpg")
      old_pdf_files += old_jpg_files
      old_pdf_files.each do |old|
        system("rm #{old}")
      end
    end


    def read_story
      if @story_md 
        @story  = Story.new(nil).markdown2para_data(source:@story_md)
      else
        @story  = Story.new(@story_path).markdown2para_data
      end
      @heading                = @story[:heading] || {}
      @heading[:is_front_page]= @news_box.is_front_page
      @heading[:top_story]    = @news_box.top_story
      @heading[:top_position] = @news_box.top_position
      if @heading
        @news_box.make_article_heading(@heading)
        # make other floats quotes, opinition writer's personal_picture
        @news_box.make_floats(@heading)
      end

      @paragraphs =[]
      @story[:paragraphs].each do |para|
        para_options = {}
        para_options[:markup]         = para[:markup]
        para_options[:layout_expand]  = [:width]
        para_options[:para_string]    = para[:para_string]
        para_options[:article_type]   = @news_box.kind
        # para_options[:text_fit]       = FIT_FONT_SIZE
        para_options[:line_width]     = @news_box.column_width  if para_options[:create_para_lines]
        @paragraphs << RParagraph.new(para_options)
      end

    end
    
    def total_para_lines_count
      @paragraphs.map{|para| Array(para.lines).length}.reduce(:+)
    end

    def body_text_lines_count
      @news_box.text_lines.length
    end

    def layout_story
      if @fixed_height_in_lines
        @news_box.set_to_fixed_height(@fixed_height_in_lines)
      end
      @news_box.layout_floats!
      @news_box.adjust_overlapping_columns
      @news_box.layout_items(@paragraphs.dup)
      @adjusted_line_count  = @news_box.adjusted_line_count
      @new_height_in_lines  = @news_box.new_height_in_lines
      if  @news_box.adjustable_height
        line_content          = @news_box.collect_column_content
        @news_box.adjust_height
        @adjusted_line_count  = @news_box.adjusted_line_count
        @new_height_in_lines  = @news_box.new_height_in_lines
        @news_box.adjust_middle_and_bottom_floats_position(@adjusted_line_count)
        @news_box.relayout_line_content(line_content)
      end
    end

  end
end


NEWSPAPER_STYLE =<<EOF
---
body:
  korean_name: ????????????
  category:
  font_family: Shinmoon
  font: Shinmoon
  font_size: 9.8
  text_color: CMYK=0,0,0,100
  text_alignment: justify
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
section_name:
  korean_name: ?????????_?????????
  font: KoPubBatangPM
  font_size: 20.5
  text_color: CMYK=0,0,0,100
  text_alignment: center
  tracking: -1.0
page_number:
  korean_name: ?????????_???????????????
  font: KoPubDotumPL
  font_size: 36.0
  text_color: CMYK=0,0,0,100
  text_alignment: center
  tracking: -1.0
EOF
