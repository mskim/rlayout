module RLayout

  class Thanks < RChapter
    attr_reader :book, :path
    def initialize(options={})
      options[:heading_height_type] = "quarter"
      # @path = path
      # @width = options[:width]
      # @height = options[:height]
      # @layout_template_path = options[:layout_template_path]
      # generate_pdf
      # self
      super
    end


    def self.sample_story
      <<~EOF
      ---
      layout: thanks
      title: 감사의 말
      ---


      여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 
      여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 
      여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 
      여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 
      여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 
      여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 여기는 감사의 말 본문입니다. 

      EOF
    end

  end

end