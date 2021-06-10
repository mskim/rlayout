

module RLayout

  # ItemContainer is used to generate product catalogs, travel guide books, box_ads, book_lists ect ...
  # ItemContainer is a layout of an item that acts like paragraph, meaning it flows along the columns page tp page.
  # It will also trigger to add new pages, if content exceed current pages.
  # Item usually consists of picture, title, description, price, size, and so on 
  # Since the data is in Hash, we can assign any keys and values to item and any layout we want in the form of rlayout.erb template.
  # This make it very poerful, since is is so flexiable.

  # typically we will have Rails app with Product database.
  # And each item can be viewed, editted and Product PDF can be createded using ItemContainer.
  # After products are done organizing, it can be turened into a book format.

  class ItemContainer < Container
    attr_accessor :x, :y, :width, :height
    attr_reader :kind, :data, :layout_erb
    attr_reader :fit_type # grow_box, squeeze

    def initialize(options={})
      @data   = options[:data]
      @width  = options[:width]
      @height = options[:heigh]t
      self
    end

    def make_image_path(options={})
      @url          = options[:url]
      @image_name   = options[:image_name]
      @url + "/#{@image_name}"
    end

    def prodect_data_sample

    end

    def product_layout_sample

    end

    def namecard_data_sample
      
    end

    def namecard_layout_sample
      
    end

  end

end