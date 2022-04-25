module RLayout

  # Used to drop char or image in paragraph
  class RDropParagraph < RParagraph
    attr_reader :drop_width, :drop_height
    attr_reader :drop_kind # string, image
    attr_reader :drop_lines
    attr_reader :drop_char_count # string, image
    attr_reader :drop_full_column # drop full height

    def initialize(options={}, &block)
      super
      create_drop_box
      @drop_lines = options[:drop_lines] || 4
      @drop_kind = options[:drop_kind] || 'image'

      self
    end

    def create_drop_box

      
    end
  end
end