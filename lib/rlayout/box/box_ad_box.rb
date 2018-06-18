module RLayout
  class BoxAdBox < Container
    attr_accessor :catagory_level, :project_path, :item_data, :box_ad_array
    def initialize(options={}, &block)
      @project_path = project_path
      data_file     = Dir.glob("#{project_path}/*.csv").first
      @item_data    = File.open(data_file, 'r'){|f| f.read}

      self
    end

    def layout_box_ad!
      @box_ad_array = []
      keys = @item_data[0]
      @item_data.each do |item|
        options= Hash(keys, item)
        options[:parent] = self
        @box_ad_array <<  BoxAd.new(options)
      end

    end
  end

  # class BoxAd < Container
  #   attr_accessor :category, :template_path
  #   attr_accessor :company, :phone, :address, :copy1, :copy2, :copy3
  #   attr_accessor :map
  #
  #   def initialize(parents, options={}, &block)
  #
  #     self
  #   end
  # end

end
