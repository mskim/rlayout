

module RLayout
  
  class TextTrain < Container
    attr_accessor :text_string_array, :text_atts_array
    def initialize(pareant_graphic, options={}, &block)
      super
      @text_string_array  = options[:text_string_array]
      @text_atts_array    = options[:text_atts_array]
      @text_string_array.each_with_index do |text_string, i|
        text_options = {}
        text_options[:text_string] = text_string
        if text_atts_array.length - 1 >= i 
          text_options.merge!(@text_atts_array[i])
        else
          #TODO make it roll, not 0
          text_options.merge!(@text_atts_array[0])
        end
        text_options[:parent] = self
        Text.new(text_options)
      end
      self
    end
  
  end
end