module RLayout
  # caption_paragraph creates caption_title, cation, and source tokens
  # them it is layed out into the CaptionColumn
  # CaptionColumn grows upward from bottom with caption_paragraph content
  class DBColumn < CaptionColumn
    attr_reader :title_position #same_line, separate_line

    # in CaptionColumn, default title position is same_line
    # we could like to be able to controll this position
    def initialize(options={})
      unless options[:title_position]
        super
        self
      end

      # implement db_column title in separate_line
      # TODO

      self
    end
  end
end
