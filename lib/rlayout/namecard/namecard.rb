module RLayout
  class Namecard < Container
    attr_reader :personal, :company, :logo
    def initialize(options={})

      self
    end
  end

  def template
    s =<<~EOF
    
    # encoding: UTF-8
    @output_path = "<%= @output_path %>"
    @image_dir   = "<%= @image_dir %>"
    # this goes at top left
    logo 	= RLayout::Image.new(parent: nil, tag: "logo", image_path: "<%= @image_dir %>/1.pdf", image_fit_type: 4)
    # qrcode 	= RLayout::Image.new(parent: nil, tag: "qrcode", local_image: "qrcode/<%= @name %>.png", width: 200, height: 200)
    # This goes somewhere in the middle
    personal = RLayout::Container.new(parent: nil, tag: "personal", width: 150, height: 60) do
      RLayout::Text.new(self, tag: "name", text_string: "<%= @name %>", text_size: 12, font: "smGothicP-W70")
      RLayout::Text.new(self, tag: "title", text_string: "<%= @title %>", text_size: 12, font: "smMyungjoP-W30")
      RLayout::Text.new(self, tag: "email", text_string: "<%= @email %>", text_size: 12)
      RLayout::Text.new(self, tag: "cell", text_string: "<%= @cell %>", text_size: 12)
      relayout!
    end
    
    # This goes at the bottom
    company = RLayout::Container.new(parent: nil, tag: "company", width: 200, height: 40) do
      RLayout::Text.new(parent: self, tag: "address1", text_string: "102 Happy Rd.", text_size: 10, text_alignment: "left")
      RLayout::Text.new(parent: self, tag: "address2", text_string: "Sung Nam, Kyunggi-Do Korea 11356", text_size: 10, text_alignment: "left")
      RLayout::Text.new(parent: self, tag: "www", text_string: "www.my_site.com", text_size: 10, text_alignment: "left")
      relayout!
    end
    EOF


  end
end

