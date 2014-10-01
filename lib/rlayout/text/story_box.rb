
#
#
#  story_box.rb
#
#  Created by Min Soo Kim on 4/15/14.
#  Copyright 2014 SoftwareLab. All rights reserved.
#
#  StoryBox
#  StoryBox is subclass of ObjectBox, which has columns that can flow items
#  StoryBox adds concept of "float" to the ObjectBox
#  
#  Float
#  Floats sit layer on top of the base layer.
#  Float are Heading, Image, quote_box and side_box.
#  StoryBox has instance variable called "@floats", which keeps them as list.
#  Floats push out text contents underneath them.
#  Floats can also be set not to push out, push out as Share or Rectangle.
#  Floats force each columns to generates modified frames 
#  called "non_overlapping_frame", and column layout is done using non_overlapping_frame
#  So, the text content results as pushed out .
#  
#  image placement
#  There are two ways to place images in StoryBox. 
#  One way is to pass the image as a paragrah using markdown image tag, 
#  and the other way is to pass the image info in heading info hash.
#  For the first case, image will be inserted as flowing paraggraph image, with column width and proportional image height.
#  And the second way is to place images as floats.
#  We have more control using them as floats, variout image posiion and size can be applied.
#  "size: SMALL" "position: TOP_LEFT"
#  quote_box & side_box 
#  quote_box & side_boxes are handled similar to float image.
# 
#  if the floats get crowded and overlapp, we need to arrage them in a stylish way.
#  One way to do it is to have templates with profile info and float map, 
#  and the other way is to apply rules
#
#  Linked Story
#  Story can overflow from one StoryBox and linked to the next one.
#  Story object is kept in the first StoryBox(@heading_story_box == true).
#  First StoryBox is reaponsiable for saving and reading Story.
# 
#  Laying out Story
#  Story has  "current_item_index" variable, 
#  which is used to pass the infomation for the next StoryBox to start putting the items.
#  And each StoryBox keep the Story and "starting_item_index" 

# TODO
# floats in the the non head StoryBox
 
module RLayout


  HEADING_WIDTH_LOOKUP_TABLE = [1,2,2,2,3,3,4] #for 7 column page
   
  class StoryBox < ObjectBox
    attr_accessor :heading, :image, :side_box, :quote_box, :grid_frame, :grid_size
    attr_accessor :story, :story_path, :category
    attr_accessor :paragraphs, :starting_item_index, :ending_item_index,  :heading_story_box
    
    def initialize(parent_graphic, options={})
      @starting_item_index  = 0
      @ending_item_index    = 0
      @heading_story_box       = true
      if options[:story_path]
        # when story_path is given
        @story_path = options[:story_path]
        @story      = Story.from_meta_markdown(@story_path)
                
        if @story.heading[:grid_frame]
          options[:grid_frame] = eval(@story.heading[:grid_frame])
          options[:column_count] = options[:grid_frame][2]
        elsif @story.heading[:column_count]
          options[:column_count] = @story.heading[:column_count]
        end
        if @story.heading[:grid_size]
          options[:grid_size] = eval(@story.heading[:grid_size])
        end
        
      elsif options[:story_hash]
        # when story is passed as hash data
        @story  = Story.new(options[:story_hash])
        if @story.heading[:grid_frame]
          options[:grid_frame]    = @story.heading[:grid_frame]
          options[:column_count]  = options[:grid_frame][2]
        end
        if @story.heading[:grid_size]
          options[:grid_size] = @story.heading[:grid_size]
        end
        if @story.heading[:category]
          options[:category] = @story.heading[:category]
        end
      elsif options[:story]
        # when story is passed as story
        @story = options[:story]
        if @story.heading[:grid_frame]
          options[:grid_frame]    = @story.heading[:grid_frame]
          options[:column_count]  = options[:grid_frame][2]
        end
        if @story.heading[:grid_size]
          options[:grid_size] = eval(@story.heading[:grid_size])
        end
        
      elsif options[:linked_story]
        # when story is overflowing from the previous story_box
        @heading_story_box = false
        @story = options[:linked_story]
        # options[:column_count] = options[:grid_frame][2]
        # start from where previous story box has left off
        @starting_item_index  = @story.current_item_index
        @ending_item_index    = @starting_item_index
      end
      
      @style_service                ||= StyleService.new
      @grid_size  = options[:grid_size]       if options[:grid_size]
      @grid_frame = options[:grid_frame]      if options[:grid_frame]
      @image_map  = options[:image_map]       if options[:image_map]
      @category   = options.fetch(:category, "Magazine")
      # if @parent_graphic is using grid based layout like newspaper
      # snapp to parent's grid system
        
      options[:column_count] = @grid_frame[2] if @grid_frame
      
      ######### calling super after seting up parameters for story bpx #####
      super 
      ######### super #####
      # @float_record = GFloatRecord.new(self) unless @float_record
      
      if @story  
        if @parent_graphic && @grid_frame      
          @frame = @parent_graphic.frame_for(@grid_frame)         
          @grid_size = @parent_graphic.grid_size
        elsif @grid_size && @grid_frame
          f_g = @grid_frame
          # @frame      = NSMakeRect(f_g[0]*@grid_size[0], f_g[1]*@grid_size[1], f_g[2]*@grid_size[0], f_g[3]*@grid_size[1]) 
        end
        relayout!   # make sure column are set in place, before adding floats

        if @heading_story_box
          place_heading(options)
          place_head_images if @story.heading[:image]  || @story.heading[:image_path]
          place_quotes if @story.heading[:quotes]  
        end
        
        set_non_overlapping_frame_for_chidren_graphics
        # get the sub array of items excluding the previous ones 
        paragraphs =[]
        @story.paragraphs[@starting_item_index..-1].map do |para, i| 
          para_options  = @style_service.style_for_markup(para[:markup], options)
          para_options[:markup]   = para[:markup]
          para_options[:text_string]   = para[:string]
          # para_options[:style]    = @style_service.style_for(para, :category=>@category)
          para_options[:layout_expand]   = [:width]
          para_options[:text_fit] = FIT_FONT_SIZE
          paragraphs << Paragraph.new(nil, para_options)
          # unless insert_flowing_item(item)
          #   break
          # end
          @story.current_item_index += 1 # @story.paragraphs.index(para)      
          @ending_item_index        = @story.paragraphs.index(para)
        end
      end
      layout_items(paragraphs, 0)
      
      relayout!

      self
    end
    
    def to_hash
      h=super
      h[:story_path]  = @story_path
      h[:category]    = @category
      h
    end
    
    def overflow?
      return false unless @story
      @story.paragraphs.length > @ending_item_index + 1
    end
    
    def drawRect(r)
      super
      NSColor.blackColor.set
      NSBezierPath.bezierPathWithRect(translated_frame).stroke
    end
    
    def place_heading(options={})
      heading_options           = @story.heading.dup
      heading_options.delete(:image_path)
      heading_options           = {} unless heading_options   
      
      if @grid_frame      
        heading_options[:width] = HEADING_WIDTH_LOOKUP_TABLE[@grid_frame[2]-1] * @grid_size[0]
      else
        heading_options[:width] = @width
      end
      heading_options[:style_service]  ||= @StyleService
      heading_options[:category]       = options.fetch(:category, "news")
      # heading_options[:fill_color]     = NSColor.lightGrayColor
      heading_options[:is_float]       = true
      puts "heading_options:#{heading_options}"
      @heading  = Heading.new(self, heading_options)
      @heading.relayout!  
    end
    
      
    def place_side_box
      
    end
    
    def place_quotes
      
    end
    
    def image_folder
      File.dirname(@story_path) + "/image"
    end
    
    # place imaegs that are in the head of the story
    def place_head_images
      image_path = nil
      if @story.heading[:image_path]
        image_path = @story.heading[:image_path]
        return if image_path == ""
      else
        image_name = @story.heading[:image]
        image_path = image_folder + "/#{image_name}"
        return if image == ""
      end
      
      if @parent_graphic && @parent_graphic.grid_record
        # check of @image_map
        width= 2 * @parent_graphic.grid_record.unit_grid_width - 3
      else
        if @graphics.length > 1
          width = @graphics[0].frame.size.width
        else
          width = @width 
        end
      end
      y = 0
      y += @heading.frame.size.height if @heading
      image_data = {}
      image_data[:is_float]       = true
      image_data[:image_path]     = image_path
      image_data[:frame]          = NSMakeRect(0, y, width,300)
      # keep_image_ratio keep origin width height ratio
      image_data[:chane_height_to_keep_image_ratio]     = true
      @image  = Image.new(self, image_data) 
    end
    
    def update_content
      # read .md file and update content
    end
    
    def self.update_content(path)
      
    end
    
    def self.sample
      StoryBox.new(nil, :story => Story.news_article_sample)
    end
    
    def self.rlib_with_map_and_markdown(parent, map, markdown)
      
    end
    
	  def self.news_article_rlib_from_markdown(path, options={})
	    options[:story_path] = path
	    ext_name    = File.extname(path)
	    base_name   = File.basename(path, ext_name)
	    news_article   = StoryBox.new(nil, options)
      if options[:output_path]
        rlib_path = options[:output_path] + "/#{base_name}"
	      news_article.save_rlib(rlib_path) #unless options[:save] == false
      end
	    news_article
	  end
	  	  
	  # layout a newspaper stroies in a given folder
	  def self.create_news_article_rlibs_from(folder, options={})
	    article_types = %w[.md .markdown]
	    output_path = options.fetch(:output_path, folder )
	    Dir.glob("#{folder}/**.*") do |file|
	      extname = File.extname(file)
	      if extname == ".md" || extname == ".markdown"
          StoryBox.news_article_rlib_from_markdown(file, :output_path=>output_path)
        end
      end
    end
    
	end
	
	# StoryBox should adjust its sizes with parent grid values
  # If the columns are larger than 2, News title's columns should not expand to the whole width, 
  # but should be reduced to around half, unless specified to expand to whole width.
  # column numbers of heading should be proportional to the box width
  # this is done by looking up HEADING_WIDTH_LOOKUP_TABLE as follows
  # example:  HEADING_WIDTH_LOOKUP_TABLE =[1,2,2,2,3,3,4] for 7 column news pages
  # array index is the number of columns, and the value is the title width in grid
  # use 1 column heading for 1 column article
  # use 2 column heading for 2 column article
  # use 2 column heading for 3 column article
  # use 2 column heading for 4 column article
  # use 3 column heading for 5 column article
  # use 3 column heading for 6 column article
  # use 4 column heading for 7 column article
  


end