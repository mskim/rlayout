module RLayout

  # layout_direction horizontal, vertical, nxn(2x2 or 3x3)

  class NewsImageGroup < Container
    attr_accessor :column, :row, :article_column, :article_row, :image_size, :image_position

    def initialize(options={}, &block)
      super
      if block
        instance_eval(&block)
      end
      relayout!
      self
    end
  end

  def news_image(options = {})
    NewsImage.new(options)
  end
end