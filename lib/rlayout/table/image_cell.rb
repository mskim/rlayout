module RLayout

  class ImageCell < Image
    attr_accessor :column_index, :row_index

    def initialize(options={})
      @column_index   = options[:column_index]
      @row_index      = options[:row_index]
      super


      self
    end
end