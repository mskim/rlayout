module RLayout

  # class TextCell < TitleText
  class TextCell < Text
      attr_accessor :column_index, :row_index, :fillup_with_leader
    attr_accessor :v_alignment, :text_alignment

    def initialize(options={})
      @column_index   = options[:column_index]
      @row_index      = options[:row_index]
      super
      @height = @parent.height
      @text_alignment = 'center'
      @v_alignment = 'center'
      # @stroke[:thickness] = 1
      # @stroke[:color] = 'red'
      # @fill[:color] = 'blue'
      # @layout_expand = nil
      @layout_expand = :height
      @has_text = true
      self
    end

    def para_style
      h = {}
      h[:font]                = @font       || 'KoPubDotumPL'
      h[:font_size]           = @font_size  || 12
      h[:tracking]            = @tracking   || 0     
      h[:scale]               = @scale      || 100  
      h
    end

  end
end

