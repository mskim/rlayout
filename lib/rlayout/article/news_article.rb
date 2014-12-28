
module RLayout
  # There are two cases
  # 1. options contains story_path, a path to stroy, read_story is used
  # 2. options contains story_path, a hash of story content, load_story_hash(options[:story_hash])
  
  class NewsArticle < Page
    attr_accessor :story_path, :heading, :paragraphs
    attr_accessor :grid_rect, :grid_size, :heading_width
    attr_accessor :output_path
    def initialize(parent_graphic, options={})
      @output_path = options[:output_path] if options[:output_path]
      if options[:story_path]
        @story_path = options[:story_path]
        read_story
      elsif options[:story_hash]
        puts 
        load_story_hash(options[:story_hash])
      end
      options[:chapter_kind]  = "news_article"
      options[:width]         = @grid_rect[2]*@grid_size[0]
      options[:height]        = @grid_rect[3]*@grid_size[1]
      options[:column_count]  = @grid_rect[2]
      options[:heading_columns]=@heading_columns
      options[:text_box]      = true
      options[:left_margin]   = 5
      options[:top_margin]    = 5
      options[:right_margin]  = 5
      options[:bottom_margin] = 5
      super
      layout_story
      if @output_path
        puts "saving to:#{@output_path}..."
        save_pdf(@output_path)
      end
      self
    end
    
    def current_style
      NEWS_STYLES
    end
    

    # path to story is given  
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
      @paragraphs         =[]
      make_paragraph(story.paragraphs)
    end
    
    # story_hash is given  
    def load_story_hash(story_hash)
      puts __method__
      puts story_hash.keys
      puts "story_hash[:heading]:#{story_hash[:heading]}"
      @heading    = story_hash[:heading]
      @title      = @heading[:title]
      @grid_size  = @heading[:grid_size]
      if @heading[:heading_columns]
        @heading_columns = @heading[:heading_columns]
      else
        @heading_columns = @grid_size[0]
      end
      @grid_rect    = @heading[:grid_frame]
      @paragraphs = []
      para_data_array = Story.parse_markdown(story_hash[:body_markdown])
      make_paragraph(para_data_array)
    end
    
    def make_paragraph(para_data_array)
      @paragraphs         =[]
      para_data_array.each do |para| 
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
      @heading[:current_style] = NEWS_STYLES
      
      
      @main_box.floats << Heading.new(nil, @heading)
      relayout!
      @main_box.set_non_overlapping_frame_for_chidren_graphics        
      @main_box.layout_items(@paragraphs)
      
    end
  end
  
end

