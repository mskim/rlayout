module RLayout
  class DecoChar < Text
    attr_reader :unicode, :font_size, :size

    def initialize(options={})
      options[:text_color]  = random_text_color unless options[:text_color]
      options[:fill_color]  = random_fill       unless options[:fill_color]
      options[:stroke_thickness]  = options[:stroke_thickness]      || random_stroke
      super
      self
    end
  end

  def random_text_color
    %w[black red orange blue yellow].sample
  end

  def random_fill
    %w[black red orange blue yellow].sample
  end

  def random_stroke
    [0,1,2,3,4,5].sample
  end
end