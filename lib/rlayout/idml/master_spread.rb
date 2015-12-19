#encode :utf-8

module RLayout
  class MasterSpread < IdPkg
    attr_accessor :spread_attributes, :pages
    def initialize(hash)
      super
      parse_master_spread
      self
    end  
    
    def parse_master_spread
      master_spread = REXML::XPath.match(@element, "/idPkg:MasterSpread/MasterSpread")
      @spread_attributes = master_spread.first.attributes
      # @spread_hash =   XmlSimple.xml_in(master_spread.to_s)
      @pages = []
      REXML::XPath.match(@element, "/idPkg:MasterSpread/MasterSpread/Page").each do |page|
        @pages << XmlSimple.xml_in(page.to_s)
      end
    end   
  end
end

