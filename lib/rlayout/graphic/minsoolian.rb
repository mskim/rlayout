module RLayout

  # Piet Mondrian art by Min Soo
  class Minsoolian < Container
    attr_reader :max_level, :level, :stroke_color, :stroke_thickness
    attr_reader :cut_count, :cut_direction
    def initialize(options={})
      options[:fill_color] = %w[white black red yellow blue].sample
      options[:stroke_color] = 'black'
      options[:stroke_width] = 20

      super
      @max_level = options[:max_level] || 3
      @level = options[:level] || 0
      cut_box if @level <= @max_level
      relayout! if @level == 0
      self
    end
  end

  def cut_box
    @layout_direction = %w[vertical horizontal].sample
    @cut_count = 3 #(1..3).to_a.sample
    h = {}
    h[:parent] = self
    h[:level] = @level + 1
    h[:max_level] = @max_level
    @cut_count.times do
      RLayout::Minsoolian.new(h)
    end
  end

end
