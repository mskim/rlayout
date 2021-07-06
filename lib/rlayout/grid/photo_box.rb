module RLayout
  # PhotoBox 
  # PhotoBox arranges photos into a box accoring to number of photos.
  #
  # large_cells
  # with large_cells array, user can specify which cell should be large sized one.
  # for example when photo_item is 3
  # large_cells[0] 
  # large_cells[0] will make first left cell the large one
  # so we will have two small ones on the right side
  # large_cells[1] will put the second one the large one.
  # so we will have two small ones on the left side
  
  class PhotoBox < Grid
    attr_reader :photo_item, :photo_item_count, :large_cells

    def initialize(options={})
      @photo_item = options[:photo_item]
      # warning if 0 item
      @photo_item_count = @photo_item.length
      @large_cells = options[:large_cells]
      super
      layout_photo_item
      self
    end

    def layout_photo_item
      case @photo_item_count
      when 1
      when 2
      when 3
      when 4

      when 5
      when 6
      when 7
      when 8
      when 9
      when 10
      end
    end

  end


end