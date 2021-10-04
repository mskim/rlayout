module RLayout
  class DecoString < Container
    attr_reader :string, :font_color_run, :fill_run, :stroke_run

    def initialize(options={})
      @string         = options[:string]
      @font_color_run = options[:color_run] || default_font_color_run
      @fill_run       = options[:fill_run] || default_fill_run
      @stroke_run     = options[:stroke_run] || default_stroke_run
      create_pretty_sting

      self
    end

    def default_font_color_run

    end

    def default_fill_run

    end

    def default_stroke_run

    end

    def create_pretty_sting
      
    end

  end



end