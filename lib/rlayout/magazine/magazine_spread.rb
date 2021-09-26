module RLayout

  class MagazineSpread < Container
    att_reader :starting_page_number, :left_page, :right_page

    def initialize(options={})
      super
      @left_page = options[:left_page]
      @right_page = options[:right_page]

      self
    end
  end



end