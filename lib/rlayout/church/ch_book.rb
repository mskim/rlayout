module RLayout

  class ChBook
    attr_reader :book_path, :page_size, :sections

    def initialize(options={})
      @book_path = options[:book_path]
      @sections = options[:sections] || default_sections
      layout_sections
      self
    end

    def default_sections
      %w[제1교구 제2교구 제3교구 제4교구 제5교구]
    end

    def layout_sections

    end
  end




end