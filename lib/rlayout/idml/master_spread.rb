#encode :utf-8

module RLayout
  class MasterSpread < XMLPkgDocument
    attr_accessor :spread_attributes, :pages, :spread_graphics
    
    def initialize(master_spread_xml_text)
      super
      parse_master_spread
      self
    end  
    
    def spread_content
      " spread content goes here... "
    end
    
    def parse_master_spread
      master_spread_children    = @element.elements
      @spread_attributes        = master_spread_children.first.attributes
      @pages                    = []
      @spread_graphics = []
      master_spread_children.each do |spread_child|
        case spread_child.name
        when 'Page'
          @pages << IdPage.new(spread_child)
        when 'TextFrame'
          @spread_graphics << IdTextFrame.new(spread_child)
        else
          # puts "spread_child.name:#{spread_child.name}"
        end
      end
    end   
  end
end

