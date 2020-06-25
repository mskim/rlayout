module RLayout
  # TableCell uses TitleText as 

  class TableCell < TitleText
    attr_reader :cell_type
    def initialize(options={})
      options[:body_line_height]    = 10
      super
      @cell_type = options[:cell_type] || 'body_cell'
      self
    end

    def ajust_height_as_body_height_multiples
      # not used in table need for table
    end
  end

end
