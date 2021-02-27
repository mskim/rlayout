module RLayout
  class Text < Graphic
    def init_text(options={})
      # TextStruct = Struct.new(:string, :size, :color, :font, :style) do
      @text_record = TextStruct.new(options[:string], options[:size])  
    end

  end

end