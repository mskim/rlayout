
module RLayout

  class BookPromo < StyleablePage
    attr_reader :layout_info, :page_images
    def initialize(options={})
      @layout_info = options[:layout_info]
      super

      if @layout_rb
        @document = eval(@layout_rb)
        if @document.is_a?(SyntaxError)
          puts "SyntaxError in #{@document} !!!!"
          return
        end
        unless @document.kind_of?(RLayout::RDocument) || @document.kind_of?(RLayout::Container)
          puts "Not a @document kind created !!!"
          return
        end
      end
      @output_path = options[:output_path] || @document_path + "/story.pdf"
      @story_path = @document_path + "/story.md"
      @page_path = File.dirname(File.dirname(@document_path))
      @page_images_path = @page_path + "/images"
      @issue_images_path = File.dirname(@page_path) + "/images"
      layout_rb_path  = @document_path + "/layout.rb"
      layout_rb = File.open(layout_rb_path, 'r'){|f| f.read }
      @article = eval(layout_rb)
      @news_article.document_path = @document_path 
      read_story
      layout_story
      @article.save_pdf(@output_path)
      self
    end

    def read_story
      if @story_md 
        @story  = Story.new(nil).markdown2para_data(source:@story_md)
      else
        @story  = Story.new(@story_path).markdown2para_data
      end
      @heading                = @story[:heading] || {}
      @heading[:is_front_page]= @news_article.is_front_page
      @heading[:top_story]    = @news_article.top_story
      @heading[:top_position] = @news_article.top_position
      if @heading
        @news_article.make_article_heading(@heading)
        # make other floats quotes, opinition writer's personal_picture
        @news_article.make_floats(@heading)
        # make other floats quotes, opinition writer's personal_picture
        if @heading['image']
          @image_info = {}
          @image_info[:image_path] = @issue_images_path + "/#{@heading['image']}"
          @image_info[:row] = @heading['row'] || 2
          @image_info[:column] = @heading['column'] || 2 
          @image_info[:position] = @heading['image_position'] || 3
          @image_info[:caption] = @heading['caption']
          @image_info[:caption_title] = @heading['caption_title']
          
          @news_article.news_image(@image_info)
        end
        if @heading['quote']
          @quote_info = {}
          @quote_info[:quote_box_size] = @heading['quote_box_size'] || 4
          @quote_info[:column] = @heading['column'] || 2 
          @quote_info[:position] = @heading['image_position'] || 3
          @news_article.float_quote(@quote_info)
        end
      end

      @paragraphs =[]
      @story[:paragraphs].each do |para|
        para_options = {}
        para_options[:markup]         = para[:markup]
        para_options[:layout_expand]  = [:width]
        para_options[:para_string]    = para[:para_string]
        para_options[:article_type]   = @news_article.kind
        # para_options[:text_fit]       = FIT_FONT_SIZE
        para_options[:line_width]     = @news_article.column_width  if para_options[:create_para_lines]
        @paragraphs << RParagraph.new(para_options)
      end
    end


    def layout_story
      if @fixed_height_in_lines
        @news_article.set_to_fixed_height(@fixed_height_in_lines)
      end
      @news_article.layout_floats!
      @news_article.adjust_overlapping_columns
      @news_article.layout_items(@paragraphs.dup)
      @adjusted_line_count  = @news_article.adjusted_line_count
      @new_height_in_lines  = @news_article.new_height_in_lines
      if  @news_article.adjustable_height
        line_content          = @news_article.collect_column_content
        @news_article.adjust_height
        @adjusted_line_count  = @news_article.adjusted_line_count
        @new_height_in_lines  = @news_article.new_height_in_lines
        @news_article.adjust_middle_and_bottom_floats_position(@adjusted_line_count)
        @news_article.relayout_line_content(line_content)
      end
    end
    
    def default_layout_rb
      <<~EOF
      RLayout::RColumn.new(#{layout_info})
  
      EOF
    end
  
    def default_text_style
  
    end
  end

end