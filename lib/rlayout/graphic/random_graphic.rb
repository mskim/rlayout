module RLayout
  
  MIN_GRAPHIC_WIDTH = 5
  MAX_GRAPHIC_WIDTH = 100
  MIN_GRAPHIC_HEIGHT = 5
  MAX_GRAPHIC_HEIGHT = 100
  MAX_GRAPHIC_Count = 200

  class RandomGraphic < Container
    attr_reader :project_path, :graphic_count

    def initialize(options={})

      super
      @width = options[:width] || 450
      @height = options[:height] || 600
      @project_path = options[:project_path]
      FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
      @graphic_count = options[:graphic_count] || MAX_GRAPHIC_Count
      @graphic_count.times do
        random_rect
        random_circle
        
        # random_ellipse
      end
      @graphic_count.times do
        # random_text
      end
      self
    end

    def random_x
      ((-10)..(@width + 10)).to_a.sample
    end

    def random_y
      ((-10)..(@height + 10)).to_a.sample
    end

    def random_width
      (MIN_GRAPHIC_WIDTH..MAX_GRAPHIC_WIDTH).to_a.sample
    end

    def random_height
      (MIN_GRAPHIC_HEIGHT..MAX_GRAPHIC_HEIGHT).to_a.sample
    end

    def random_color
      COLOR_LIST.keys.sample
    end

    def random_stroke_width
      (0..20).to_a.sample
    end

    def random_radius
      random_width/2
    end

    def random_text_size
      [6, 8, 10, 12, 16, 18, 20, 24, 36].sample
    end

    def random_font

      # M_LIGHT = "KoPubBatangPL"
      # M_MEDIUN = "KoPubBatangPM"
      # M_BOLD = "KoPubBatangPB"
      # G_LIGHT = "KoPubDotumPL"
      # G_MEDIUN = "KoPubDotumPM"
      # G_BOLD = "KoPubDotumPB"

      %w[KoPubBatangPL KoPubBatangPM KoPubBatangPB KoPubDotumPL KoPubDotumPM KoPubDotumPB].sample
    end

    def random_rect
      h = {}
      h[:x] = random_x
      h[:y] = random_y
      h[:width] = random_width
      h[:height] = random_height
      h[:fill_color] = random_color
      h[:stroke_width] = random_stroke_width
      h[:stroke_color] = random_color
      h[:parent] = self
      Rectangle.new(h)
    end

    def random_circle
      h = {}
      h[:parent] = self
      h[:x] = random_x
      h[:y] = random_y
      h[:width] = random_width
      h[:height] = random_height
      h[:fill_color] = random_color
      h[:stroke_width] = random_stroke_width
      h[:stroke_color] = random_color
      c = Circle.new(h)
    end

    def random_ellipse
      h = {}
      h[:parent] = self
      h[:x] = random_x
      h[:y] = random_y
      h[:width] = random_width
      h[:height] = random_height
      h[:fill_color] = random_color
      h[:stroke_width] = random_stroke_width
      h[:stroke_color] = random_color
      Ellipse.new(h)
    end

    def random_text
      h = {}
      h[:parent] = self
      h[:x] = random_x
      h[:y] = random_y
      h[:width] = random_width
      h[:fill_color] = random_color
      h[:stroke_width] = [0,3,5].sample
      h[:stroke_color] = random_color
      h[:text_string] = "소설을 쓰고 있네"
      h[:font] = random_font
      h[:font_size] = random_text_size
      h[:height] = h[:font_size] + 5
      h[:font_color] = 'black'
      h[:text_fit_type] = 'fit_box_to_text'

      Text.new(h)

    end
  end
end