
# NewsPage is used to merge working_article PDF files into a page.
# There are two cases
# First case is when it is used from Rails, where all infomation is given in options hash,
# And the second case is when it is used as offline, where we have to read info from config.yml

module RLayout
  class NewsPage < Container
    attr_reader :section_path, :section_name, :output_path
    attr_reader :is_front_page, :paper_size, :page_heading
    attr_reader :story_frames, :grid_width, :grid_height, :number_of_stories
    attr_reader :body_line_height, :ad_type, :page_heading_margin_in_lines, :heading_space, :lines_per_grid
    attr_reader :draw_divider, :divider_line_thickness, :time_stamp, :reduced_size
    
    def initialize(options={}, &block)
      super
      # given config_hash, directly from Rails 
      @time_stamp = options[:time_stamp]
      if options[:config_hash]
        setup(options[:config_hash])
      # offline reading config.yml file
      else
        @section_path   = options[:section_path]
        config_path     = @section_path + "/config.yml"
        if File.exist?(config_path)
          config_hash = File.open(config_path, 'r'){|f| f.read}
          config_hash = YAML::load(config_hash)
          setup(config_hash)
        else
          return 'config.yml not found!!!'
        end
      end
      relayout if options[:relayout]
      merge_pdf
      self
    end

    def setup(options)
      @page_heading_margin_in_lines = options[:page_heading_margin_in_lines].to_i
      @lines_per_grid = options[:lines_per_grid].to_i
      @grid_size      = options.fetch(:grid_size, [137.40142857142857, 96.94466666666668])
      @grid_width     = @grid_size[0]
      @grid_height    = @grid_size[1]
      if options[:heading_space]
        @heading_space =  options[:heading_space]
      else
        @heading_space =  @page_heading_margin_in_lines*@grid_height/@lines_per_grid
      end
      unless @section_path
        @section_path = options[:section_path]
      end
      @output_path    = @section_path + "/section.pdf"
      @width          = options[:width] 
      @height         = options[:height] 
      @lines_in_grid  = options.fetch(:lines_in_grid, 7)
      @section_name   = options[:section_name] || "untitled"
      @gutter         = options.fetch(:gutter, 10)
      @left_margin    = options.fetch(:left_margin, 50)
      @top_margin     = options.fetch(:top_margin, 50)
      @right_margin   = options.fetch(:right_margin, 50)
      @bottom_margin  = options.fetch(:bottom_margin, 50)
      @is_front_page  = options[:is_front_page] || false
      @body_line_height = @grid_height/@lines_in_grid
      @section_name   = options[:section_name] || "untitled"
      @output_path    = options[:output_path]   if options[:output_path]
      @width          = options[:width]
      @height         = options[:height]
      @gutter         = options[:gutter]
      @left_margin    = options[:left_margin]
      @top_margin     = options[:top_margin]
      @right_margin   = options[:right_margin]
      @bottom_margin  = options[:bottom_margin]
      @ad_type        = options[:ad_type]
      @ad_box_rect    = options[:ad_box_rect] if options[:ad_box_rect]
      @is_front_page  = options[:is_front_page]
      @draw_divider   = options[:draw_divider]
      @pillar_map     = options[:pillar_map]
    end


    def relayout
      # relayout articles
      @pillar_map.each do |pillar|
        pillar[:article_map].each do |article|
          pdf_path = @section_path + article[:pdf_path]
          article_path = File.dirname(pdf_path)
          # check for updated_at date for story.md and story.pdf
          story_md = article_path + "/story.md"
          story_pdf = article_path + "/story.pdf"
          if File.mtime(story_pdf) < File.mtime(story_md)
            NewsBoxMaker.new(article_path: article_path, adjustable_height:true)
          end
        end
      end

      # relayout page_heading

      # relayout ad
    end

    def merge_pdf
      layout_ad_box if @ad_box_rect
      # layout pillars
      @pillar_map.each do |pillar|
        pillar_rect = pillar[:pillar_rect]
        article_height_sum = 0
        parent_y = 0
        parent_height = 0
        pillar_top = @heading_space + pillar_rect[1]
        pillar[:article_map].each do |article|
          h = {}
          h[:parent] = self
          h[:image_path] = @section_path + "#{article[:pdf_path]}"
          article_info_path = File.dirname(h[:image_path]) + "/article_info.yml"
          article_info      = YAML::load_file(article_info_path)
          article_width     = article_info[:image_width].to_f
          article_height    = article_info[:image_height].to_f
          h[:x] = article[:pdf_rect][0] + pillar_rect[0]
          if article_info[:attached_type] == 'overlap'
            h[:y] = parent_y + (parent_height - article_height)
          elsif article_info[:attached_type]
            h[:y] = parent_y
          else
            h[:y] = pillar_top + article_height_sum
            parent_y = h[:y]  
            parent_height = article_info[:image_height]
          end
          h[:width] = article_width
          h[:height]= article_height
          Image.new(h)
          unless article_info[:attached_type]
            article_height_sum += article_height 
          end
        end
      end
      layout_page_heading
      # create_divider_lines if @draw_divider

      # save_pdf(output_path: @output_path)
      save_pdf_with_ruby(@output_path, :jpg=>true, :ratio => 2.0)

      # options[:thumbnail] = false
      if @time_stamp
        output_jpg_path       = @output_path.sub(/\.pdf$/, ".jpg")
        time_stamped_path     = @output_path.sub(/\.pdf$/, "#{@time_stamp}.pdf")
        time_stamped_jpg_path = @output_path.sub(/\.pdf$/, "#{@time_stamp}.jpg")
        system("cp #{@output_path} #{time_stamped_path}")
        system("cp #{output_jpg_path} #{time_stamped_jpg_path}")
      end
    end

    def layout_page_heading
      # page heading
      heading_info = {}
      heading_info[:parent] = self
      new_heading_path = heading_info[:image_path] = @section_path + "/heading/output.pdf" 
      #TODO delete this after settling to new
      heading_info[:image_path] = @section_path + "/heading/layout.pdf" unless File.exist?(new_heading_path)
      heading_info[:x]          = @left_margin
      heading_info[:y]          = @top_margin
      heading_info[:width]      = @width - @left_margin - @right_margin
      heading_info[:layout_expand]  = nil
      heading_info[:image_fit_type] = IMAGE_FIT_TYPE_IGNORE_RATIO
      # heading_info[:stroke_width] = 1
      # heading_info[:image_fit_type] = IMAGE_FIT_TYPE_ORIGINAL
      if @is_front_page
        #TODO
        # NEWS_ARTICLE_FRONT_PAGE_EXTRA_HEADING_SPACE_IN_LINES     = 1
        # NEWS_ARTICLE_HEADING_SPACE_IN_LINES                      = 3
        heading_info[:height]   = (@lines_per_grid + @page_heading_margin_in_lines) * @body_line_height
      else
        heading_info[:height]   = @page_heading_margin_in_lines * @body_line_height
      end
      # puts "heading_info[:height]:#{heading_info[:height]}"
      @page_heading = Image.new(heading_info)

    end

    # need to save ad_box_rect in cofig
    def layout_ad_box
      ad_info = {}
      ad_info[:parent]  = self
      ad_info[:x]       = @ad_box_rect[0] + @left_margin
      ad_info[:y]       = @ad_box_rect[1] + @top_margin
      ad_info[:width]   = @ad_box_rect[2]
      ad_info[:height]  = @ad_box_rect[3]
      ad_info[:image_path] = @section_path + "/ad/output.pdf"
      @ad_box           = Image.new(ad_info)
    end


    def top_position?(grid_frame)
      return true if grid_frame[1] == 0
      return true if @is_front_page && grid_frame[1] == 1
      false
    end

    # this checks if the article's right side top is covered by other article
    def top_covered?(grid_frame)
      @story_frames.each do |other_frame|
        other_frame_max_x = other_frame[0] + other_frame[2]
        other_frame_max_y = other_frame[1] + other_frame[3]
        grid_max_x = grid_frame[0] + grid_frame[2]
        if (other_frame_max_y == grid_frame[1]) # &&  (other_frame[2] != grid_frame[2])
          return true if (other_frame[0] < grid_max_x) && grid_max_x < other_frame_max_x 
        end
      end
      false
    end
    
    # this is used when drawing vertical line
    # if the artice is at the bottom, we need to make it not to touch the bottom
    # we need to leave some space 
    # same rule applies if article touchs the bottom ad
    def bottom_position?(grid_frame)
      return true if grid_frame[1] + grid_frame[3]== 15
      return true if bottom_touches_ad?(grid_frame)
      false
    end

    # this checks if the article's right side bottom is covered by other article
    def bottom_covered?(grid_frame)
      @story_frames.each do |other_frame|
        other_frame_max_x = other_frame[0] + other_frame[2]
        other_frame_y = other_frame[1]
        grid_max_x = grid_frame[0] + grid_frame[2]
        grid_max_y = grid_frame[1] + grid_frame[3]
        if (other_frame_y == grid_max_y)
          return true if (other_frame[0] < grid_max_x) && (grid_max_x < other_frame_max_x)
        end
      end
      false
    end

    def bottom_touches_ad?(grid_frame)
      return true if has_ad? && ad_top_in_grid == (grid_frame[1] + grid_frame[3])
      false
    end

    def ad_top_in_grid
      case @ad_type
      when '전면광고'
        0
      else
        if @ad_type
          15 - @ad_type[0].to_i
        else
          0
        end
      end
    end

    def latest_story_pdf(article_path)
      Dir.glob("#{article_path}/story*.pdf").last
    end

    # convert stopry frames into layout format
    def make_layout_info
      @layout_info = []
      story_count = 0 
      @sorted_story_frames = @story_frames.sort_by{|r| [r[1], r[0]]}
      @sorted_story_frames.each do |grid_frame|
        info = {}
        found_ad = false
        if grid_frame.length == 5 && grid_frame[4] =~/^광고/
          info[:image_path] = ad_image_path
          @right_side_ad = true if grid_frame[4] =~/홀$/
        elsif grid_frame.length == 5 && grid_frame[4].class == Integer
          story_count += 1
          pillar_article_count = grid_frame[4]
          info = make_pillar_image(story_count)
        else
          story_count += 1
          info[:image_path] = @section_path + "/#{story_count}/story.pdf"
        end

        # info[:x] = grid_frame[0]*(@grid_width + @gutter) + @left_margin
        if @right_side_ad == true 
          info[:x]              = grid_frame[0]*@grid_width + @left_margin + @gutter
        else
          info[:x]              = grid_frame[0]*@grid_width + @left_margin
        end
        info[:y]              = grid_frame[1]*@grid_height + @top_margin
        info[:width]          = grid_frame[2]*@grid_width
        info[:height]         = grid_frame[3]*@grid_height

        if top_position?(grid_frame)
          heading_space       = @body_line_height*@page_heading_margin_in_lines
          info[:y]            += heading_space
          info[:height]       -= heading_space
        end
        if grid_frame.last.class == Hash
          if grid_frame.last['extend']
            @extened_line_count = grid_frame.last['extend'].to_i
            info[:height] += @body_line_height*@extened_line_count
          end
          if grid_frame.last['push']
            @pushed_line_count = grid_frame.last['push'].to_i
            info[:y]          += @body_line_height*@pushed_line_count
            info[:height]     -= @body_line_height*@pushed_line_count
          end
        elsif grid_frame.length > 4
          # support legacy format
          # TODO deprecate this at next upgrading
          if grid_frame.last =~/^extend/
            @extened_line_count = grid_frame.last.split("_")[1].to_i
            info[:height] += @body_line_height*@extened_line_count
          elsif grid_frame.last =~/^push/
            @pushed_line_count = grid_frame.last.split("_")[1].to_i
            info[:y]          += @body_line_height*@pushed_line_count
            info[:height]     -= @body_line_height*@pushed_line_count
          end
        end
        info[:layout_expand]  = nil
        info[:image_fit_type] = IMAGE_FIT_TYPE_IGNORE_RATIO
        # info[:image_fit_type] = IMAGE_FIT_TYPE_ORIGINAL
        @layout_info << info.dup
      end
      @layout_info
    end

    def make_pillar_image(pillar_order, pillar_count)
      info = {}
      info[:pillar] = true
      info[:pillar_images] = []
      pillar_count.times do |i|
        info[:pillar_images] << "#{pillar_order}_#{i+1}"
      end
      info
    end

    def self.section_pdf(options)
      time_start = Time.now
      section_page = self.open(options)
      section_page.merge_layout_pdf(options)
      time_end = Time.now
      puts "++++++++ section_pdf took:#{time_end - time_start}"
    end

    def self.open(options={})
      config_path     = options[:section_path] + "/config.yml"
      config          = File.open(config_path, 'r'){|f| f.read}
      section_options = YAML::load(config)
      section_options.merge!(options)
      NewsPage.new(section_options)
    end

    def has_ad?
      @ad_type && @ad_type !='no_ad'
    end

    def merge_layout_pdf(options={})
      @output_path = options[:output_path] if options[:output_path]
      make_layout_info.each_with_index do |info, i|
        info[:parent] = self
        if info[:pillar]
          puts "++++++++ draw pillar here"
          # PillarImage.new(info)
        else
          Image.new(info)
        end
	    end
      # page heading
      heading_info = {}
      heading_info[:parent] = self
      new_heading_path = heading_info[:image_path] = @section_path + "/heading/output.pdf" 
      #TODO delete this after settling to new
      heading_info[:image_path] = @section_path + "/heading/layout.pdf" unless File.exist?(new_heading_path)
      heading_info[:x]          = @left_margin
      heading_info[:y]          = @top_margin
      heading_info[:width]      = @width - @left_margin - @right_margin
      heading_info[:layout_expand]  = nil
      heading_info[:image_fit_type] = IMAGE_FIT_TYPE_IGNORE_RATIO
      # heading_info[:stroke_width] = 1
      # heading_info[:image_fit_type] = IMAGE_FIT_TYPE_ORIGINAL
      if @is_front_page
        #TODO
        # NEWS_ARTICLE_FRONT_PAGE_EXTRA_HEADING_SPACE_IN_LINES     = 1
        # NEWS_ARTICLE_HEADING_SPACE_IN_LINES                      = 3
        heading_info[:height]   = (@lines_per_grid + @page_heading_margin_in_lines) * @body_line_height
      else
        heading_info[:height]   = @page_heading_margin_in_lines * @body_line_height
      end
      # puts "heading_info[:height]:#{heading_info[:height]}"
      @page_heading = Image.new(heading_info)
      create_divider_lines if @draw_divider

      if @output_path
        # options[:thumbnail] = false
        save_pdf(@output_path, options)
        if @time_stamp
          output_jpg_path       = @output_path.sub(/\.pdf$/, ".jpg")
          time_stamped_path     = @output_path.sub(/\.pdf$/, "#{@time_stamp}.pdf")
          time_stamped_jpg_path = @output_path.sub(/\.pdf$/, "#{@time_stamp}.jpg")
          system("cp #{@output_path} #{time_stamped_path}")
          system("cp #{output_jpg_path} #{time_stamped_jpg_path}")
        end
      else
        puts "No @output_path!!!"
      end
      self
    end

    def make_vertical_line(box_frame)
      grid_max_x = box_frame[0] + box_frame[2]
      grid_max_y = box_frame[1] + box_frame[3]
      # x_position = grid_max_x*@grid_width + (grid_max_x - 1)*@gutter + @gutter
      x_position = grid_max_x*@grid_width + @left_margin
      y_position = box_frame[1]*@grid_height + @top_margin
      box_height = box_frame[3]*@grid_height

      if box_frame.length == 5 
        if box_frame[4].class == Hash
          # handle extended and push values
          if box_frame[4]['extend']
            extended     = box_frame[4]['extend'] 
            box_height   += extended*@body_line_height
          end
          if box_frame[4]['push']
            pushed       = box_frame[4]['push'] 
            box_height   -= pushed*@body_line_height
            y_position   += pushed*@body_line_height
          end
        elsif box_frame[4].class == Integer
          # this is for pillar
          # we don't need to do anything special here.
          # just treat the whole pillar as a single box
        end
      end
      if top_position?(box_frame)
        heading_margin = @body_line_height*@page_heading_margin_in_lines
        y_position +=  heading_margin + @body_line_height
        box_height -=  heading_margin + @body_line_height

      elsif top_covered?(box_frame)
        y_position +=  @body_line_height
        box_height -=  @body_line_height
      end
      if bottom_position?(box_frame) || bottom_covered?(box_frame)
        box_height -=  @body_line_height*2
      end

      # Rectangle.new(parent:self, x:x_position, y:y_position, width:0, height:box_height, stroke_thickness: 0.3)
      Line.new(parent:self, x:x_position, y:y_position, width:0, height:box_height, stroke_thickness: 0.1)
    end

    def create_divider_lines
      @story_frames.each do |box_frame|
        grid_max_x = box_frame[0] + box_frame[2]
        grid_max_y = box_frame[1] + box_frame[3]
        if grid_max_x < @grid_base[0]
          make_vertical_line(box_frame)
        end
      end
    end

  end

end
