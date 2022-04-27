module RLayout
  class CoverPage

    # for creating undefined TextArea placeholder in CoverPage
    def book_promo(grid_x, grid_y, grid_width, grid_height, options={})
      h = options.dup
      h[:parent] = self
      h[:tag] = 'book_promo'
      h[:grid_frame]  = [grid_x, grid_y, grid_width, grid_height]
      h[:fill_color]  = options[:fill_color] || 'clear'
      RLayout::TextArea.new(h)
    end

    # for creating undefined TextArea placeholder in CoverPage
    def author_profile(grid_x, grid_y, grid_width, grid_height, name, options={})
      h = options.dup
      h[:parent] = self
      h[:tag] = 'author_profile'
      h[:grid_frame]  = [grid_x, grid_y, grid_width, grid_height]
      h[:fill_color]  = options[:fill_color] || 'clear'
      RLayout::TextArea.new(h)
    end
  end
end