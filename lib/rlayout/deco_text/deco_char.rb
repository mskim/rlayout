module RLayout
  class DecoChar < Text
    attr_reader :unicode, :font_size, :size

    def initialize(options={})
      options[:font_color]  = random_font_color unless options[:font_color]
      options[:fill_color]  = random_fill       unless options[:fill_color]
      options[:stroke_thickness]  = options[:stroke_thickness]      || random_stroke
      super
      self
    end
  end

  def random_font_color
    %w[black red orange blue yellow].sample
  end

  def random_fill
    %w[black red orange blue yellow].sample
  end

  def random_stroke
    [0,1,2,3,4,5].sample
  end
end