module RLayout

  # Area for  display ad item
  class NewsBoxAd < NewsBox
    attr_reader :data, :row, :column, :gutter, :v_gutter
    attr_reader :advertiser, :company, :copy, :display_image, :phone, :email, :cell

    def initialize(options={})
      super
      @data       = options[:data]
      @row        = options.fetch(:row, 4)
      @column     = options.fetch(:column, 4)
      @gutter     = options.fetch(:column, 3)
      @v_gutter   = options.fetch(:column, 3)
      self
    end
  end
  
  class NewsAdData
    attr_accessor :advertiser, :company, :copy, :display_image, :phone, :email, :cell
    attr_accessor :price, :starting_date, :duration
    def initialize(options={})
      @advertiser   = options[:advertiser]
      @company      = options[:company]
      @copy1        = options[:copy1]
      @copy2        = options[:copy2]
      @phone        = options[:phone]
      @email        = options[:email]
      @cell         = options[:cell]
      @price        = options[:price]
      @starting     = options[:starting_date]
      @duration     = options[:cell]
      self
    end
  end

  # Individual Line item
  class NewsLineAd < Container
    attr_accessor :data
    def initialize(options={})
      super
      @data        = options[:data]
      @grid_x      = options[:grid_x]
      @grid_y      = options[:grid_x]
      @grid_width  = options[:grid_width]
      @grid_height = options[:grid_height]
      self
    end
  end

end
