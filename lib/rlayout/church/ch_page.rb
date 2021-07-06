module RLayout


  class ChPage < Container
    attr_reader :page_path, :page_number, :page_image, :image_column, :image_row

    def initialize(options={})
      @page_path = options[:page_path]
      @page_number = options[:page_number]
      @page_image = options[:page_image]
      @image_column = options[:image_column]
      @image_row = options[:image_row]
      options[:left_margin] = options[:left_margin] || 30
      options[:top_margin] = options[:top_margin] || 30
      options[:right_margin] = options[:right_margin] || 30
      options[:bottom_margin] = options[:bottom_margin] || 30
      super
      layout_image
      self
    end

    def layout_image
      h = {}
      h[:parent] = self
      h[:x] = @left_margin
      h[:y] = @top_margin
      h[:width] = @width - @left_margin - @right_margin
      h[:height] = @height - @top_margin - @bottom_margin
      h[:column] =  @image_column
      h[:row] = @image_row
      h[:image_item_full_path_array] = @page_image
      h[:gutter] = 10
      h[:v_gutter] = 10
      h[:member_shape] = 'rect'
      RLayout::GroupImage.new(h)
    end
  end

end