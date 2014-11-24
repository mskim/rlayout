
module RLayout
  
  class NewsArticle < Page
    attr_accessor :story_path, :heading, :paragraphs
    attr_accessor :grid_rect, :grid_size, :heading_width
    
    def initialize(parent_graphic, options={})
      @@style_service = StyleService.shared_style_service(:chapter_kind=>"news_article")
      
      if options[:story_path]
        @story_path = options[:story_path]
        read_story
      end
      options[:width]         = @grid_rect[2]*@grid_size[0]
      options[:height]        = @grid_rect[3]*@grid_size[1]
      options[:column_count]  = @grid_rect[2]
      options[:heading_columns]=@heading_columns
      options[:text_box]      = true
      options[:margin]        = 5
      super
      layout_story
      self
    end
    
    def read_story
      story         = Story.from_meta_markdown(@story_path)
      @heading      = story.heading
      @title        = @heading[:title]
      @grid_size    = @heading[:grid_size]
      if @heading[:heading_columns]
        @heading_columns = @heading[:heading_columns]
      else
        @heading_columns = @grid_size[0]
      end
      @grid_rect    = @heading[:grid_rect]
      # puts "@heading_width:#{@heading_width}"
      # @@style_service      ||= StyleService.new(:chapter_kind=>"news_article")
      @paragraphs         =[]
      story.paragraphs.each do |para| 
        para_options      = {}
        para_options[:markup]         = para[:markup]
        if para[:markup] == 'img'
          source                      = para[:image_path]
          para_options[:caption]      = para[:caption]
          para_options[:layout_expand]= [:width]
          para_options[:bottom_margin]= 10
          para_options[:bottom_inset] = 10
          full_image_path = File.dirname(@story_path) + "/#{source}"
          para_options[:image_path]   = full_image_path
          @paragraphs << Image.new(nil, para_options)
          next 
        end
        para_options[:text_string]    = para[:string]
        para_options[:layout_expand]  = [:width]
        para_options[:text_fit]       = FIT_FONT_SIZE
        para_options[:chapter_kind]   = "news_article"
        @paragraphs << Paragraph.new(nil, para_options)        
      end
    end
    
    def layout_story
      @heading[:layout_expand]  = [:height]
      # @heading[:line_width]     = 2
      # @heading[:line_color]     = 'red'
      @heading[:width]        = @main_box.heading_width
      @heading[:align_to_body_text]= true
      @heading[:layout_expand]= nil
      @heading[:top_margin]   = 0
      @heading[:top_inset]    = 10
      @heading[:bottom_margin]= 0
      @heading[:tottom_inset] = 10
      @heading[:left_inset]   = 0
      @heading[:right_inset]  = 0
      @heading[:chapter_kind]  = "news_article"
      @main_box.floats << Heading.new(nil, @heading)
      relayout!
      @main_box.set_non_overlapping_frame_for_chidren_graphics        
      @main_box.layout_items(@paragraphs)
      
    end
  end
  
end

