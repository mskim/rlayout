module RLayout
  # This ia page for PictureSpread
  class PictureSpreadPage < Container
    attr_reader :text_location, :bg_image_path, :story
    attr_reader :left_side

    def initialize(options={})
      @left_side = options[:left_side]
      @bg_image_path = options[:bg_image_path]
      @story         = options[:story]
      super
      @left_margin   = 50
      @top_margin    = 50
      @text_location = options[:text_location].to_i
      @left_side     = options[:left_side]
      @story         = options[:story]
      add_bg_image
      add_story
      self
    end

    def add_bg_image
      h = {}
      h[:parent] = self
      h[:image_path] = @bg_image_path
      if @left_side
        h[:x] = -2
      else
        h[:x] = -2 - @width
      end
      h[:width] = @width*2 + 4
      h[:height] = @height + 4
      Image.new(h)
    end

    def add_story
      h = {}
      h[:parent] = self
      h[:text_string] = @story
      h[:width] = @width/2 - @left_margin
      h[:height] = @height/2 - @top_margin
      h[:font_size] = 20
      h[:style_name] = 'title'
      h[:text_alignment] = 'center'
      h[:fill_color] = 'yellow'
      case @text_location
      when 1
        h[:x] = @left_margin
        h[:y] = @top_margin
      when 2
        h[:x] = @width/2
        h[:y] = @top_margin
      when 3
        h[:x] = @left_margin
        h[:y] = @height/2 + @top_margin
      when 4
        h[:x] = @width/2
        h[:y] = @height/2 +@top_margin
      end    
      TitleText.new(h)
    end

  end

end