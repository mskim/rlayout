module RLayout
  # MagazineSpread has many spread_items.
  # Spread_items are created with item_1.md, item_2.md and so on.
  # item_x.md has metadata section with markdown
  # metadata has location and size information
  # it create spread_image
  # finally spread_image is place in spread pages
  class MagazineSpread < Container
    att_reader :starting_page_number, :left_page, :right_page
    att_reader :bg_image_path, :spread_items
    def initialize(options={})
      super
      @left_page = options[:left_page]
      @right_page = options[:right_page]

      self
    end
  end



end