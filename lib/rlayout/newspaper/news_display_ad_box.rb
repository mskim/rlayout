module RLayout
  class DisplayAdInfo
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

  # Individual display item
  class DisplayAdItem < Container
    attr_accessor :data

  end

  # Area for  display ad item
  class DisplayAdBox < NewsBox
    attr_accessor :item_row, :item_column, :item_gutter, :item_v_gutter
    def initialize(options={})
      #code
      self
    end
  end
end
