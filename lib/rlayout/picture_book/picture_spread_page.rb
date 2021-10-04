module RLayout
  # This ia page for PictureSpread
  class PictureSpreadPage < Container
    attr_reader :text_location, :spread_image_path, :page_image_path, :stories
    attr_reader :left_side, :story_width

    def initialize(options={})
      @left_side = options[:left_side]
      @spread_image_path = options[:spread_image_path]
      @page_image_path = options[:page_image_path]
      @story         = options[:story]
      super
      @left_margin   = 50
      @top_margin    = 50
      @right_margin  = 50
      @bottom_margin = 50
      @text_location = options[:text_location].to_i
      @left_side     = options[:left_side]
      @stories       = options[:stories]
      if @spread_image_path
        add_spread_image
      elsif @page_image_path
        add_page_image
      end
      add_stories
      self
    end

    def add_spread_image
      h = {}
      h[:parent] = self
      h[:image_path] = @spread_image_path
      if @left_side
        h[:x] = -2
      else
        h[:x] = -2 - @width
      end
      h[:width] = @width*2 + 4
      h[:height] = @height + 4
      Image.new(h)
    end

    def add_page_image
      h = {}
      h[:parent] = self
      h[:image_path] = @page_image_path
      h[:x] = -2
      h[:width] = @width*2 + 4
      h[:height] = @height + 4
      Image.new(h)
    end

    def alignments_array
      %w[left center right 좌 중앙 우 왼쪽 중간 오른쪽]
    end

    def add_stories
      @story_width = @width/2 - @left_margin
      @story_height = @height/2 - @top_margin
      @stories.each do |story|
        h = {}
        h[:parent] = self
        h[:text_string] = File.open(story, 'r'){|f| f.read}
        h[:width] = @story_width
        h[:height] = @story_height
        h[:font] = "KoPubBatangPM"
        h[:font_size] = 20
        h[:style_name] = 'title'
        h[:text_alignment] = 'center'
        h[:font_color] = 'black'
        ext      = File.extname(story)
        basename = File.basename(story, ext)
        story_attrs = basename.split("_")
        if story_attrs.length > 1
          location = story_attrs[1]
          h[:x], h[:y] = get_position(location.to_i)
          if story_attrs.length > 2
            extra_attrs_length = story_attrs.length - 2
            story_styles = story_attrs[2..-1]
            story_styles.each do |story_style|
              if alignments_array.include?(story_style)
                h[:text_alignment] = story_style
              end
              if COLOR_NAMES.include?(story_style)
                h[:font_color] = story_style
              end
            end
          end
        end
        TitleText.new(h)
      end
    end

    def get_position(location)
      x = @left_margin
      y = @top_margin
      @h_middle = @width/2
      @v_middle = @height/2
      case location
      when 1
      when 2
        x = @h_middle - @story_width/2
      when 3
        x = @width - @story_width - @right_margin
      when 4
        x = @width - @story_width - @right_margin
        y = @v_middle - @story_height/2
      when 5
        x = @h_middle - @story_width/2
        y = @v_middle - @story_height/2
      when 6
        x = @width - @story_width - @right_margin
        y = @v_middle - @story_height/2
      when 7
        y = @height - @story_height - @bottom_margin
      when 8
        x = @h_middle - @story_width/2
        y = @height - @story_height - @bottom_margin
      when 9
        x = @width - @story_width - @right_margin
        y = @height - @story_height - @bottom_margin
      else
      end
      return x, y
    end
  end

end