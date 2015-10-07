module RLayout
  
  # DesignerText
  # merges pre-designed layot template and text
  CUSTOM_HEAD_TEXT = {
    :example => <<-EOF.gsub(/^\s*/, "")
      Container.new(nil) do
        round_text(<%= @text %>)
        line
      end
    EOF
    
  }
  class DesignerText < Container
    attr_accessor :markup, :text, :layout
    def initialize(parent_graphic, options={} &block)
      super
      
      
      self
    end
    
  end
  
  
end