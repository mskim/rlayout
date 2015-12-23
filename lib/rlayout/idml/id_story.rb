#encode :utf-8

module RLayout
  
IDML_STORY_ERB = <<-EOF.gsub(/^\s*/, "")
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<idPkg:Story xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" DOMVersion="7.0">
	<Story Self="ud5" AppliedTOCStyle="n" TrackChanges="false" StoryTitle="$ID/" AppliedNamedGrid="n">
    <StoryPreference OpticalMarginAlignment="false" OpticalMarginSize="12" FrameType="TextFrameType" StoryOrientation="Horizontal" StoryDirection="LeftToRightDirection"/>
		<InCopyExportOption IncludeGraphicProxies="true" IncludeAllResources="false"/>
    <%= @story_content %>
	</Story>
</idPkg:Story>

EOF

PARAGRAPH_XML_ERB = <<-EOF.gsub(/^\s*/, "")
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/$ID/<%= @paragraph_style_name %>">
    	<CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/<%= @char_style_name %>">
    		<Content><%= @para_text %></Content>
    	</CharacterStyleRange>
    </ParagraphStyleRange>\n
EOF

IMAGE_XML_ERB = <<-EOF.gsub(/^\s*/, "")
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/Paragraph">
      <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
        <Rectangle Self="uec" ItemTransform="1 0 0 1 75 -50">
          <Properties>
            <PathGeometry>
              <GeometryPathType PathOpen="false">
                <PathPointArray>
                  <PathPointType Anchor="-75 -50" LeftDirection="-75 -50" RightDirection="-75 -50" />
                  <PathPointType Anchor="-75 50" LeftDirection="-75 50" RightDirection="-75 50" />
                  <PathPointType Anchor="75 50" LeftDirection="75 50" RightDirection="75 50" />
                  <PathPointType Anchor="75 -50" LeftDirection="75 -50" RightDirection="75 -50" />
                </PathPointArray>
              </GeometryPathType>
            </PathGeometry>
          </Properties>
          <Image Self="ue6" ItemTransform="1.0 0 0 1.0 -75 -50">
            <Properties>
              <Profile type="string">
                $ID/Embedded
                <GraphicBounds Left="0" Top="0" Right="150" Bottom="100" />
              </Profile>
            </Properties>
            <Link Self="ueb" LinkResourceURI="file:<%= @image_path%>" />
          </Image>
        </Rectangle>
      </CharacterStyleRange><Br />
    </ParagraphStyleRange>\n
EOF

TABLE_XML_ERB = <<-EOF.gsub(/^\s*/, "")
    <Table AppliedTableStyle="TableStyle/Table" HeaderRowCount="1" BodyRowCount="3" ColumnCount="4">
      <Column Name="0" />
      <Column Name="1" />
      <Column Name="2" />
      <Column Name="3" />
      <Cell Name="0:0" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; TableHeader &gt; RightAlign">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>Right</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
      <Cell Name="1:0" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; TableHeader &gt; LeftAlign">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>Left</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
      <Cell Name="2:0" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; TableHeader &gt; CenterAlign">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>Center</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
      <Cell Name="3:0" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; TableHeader">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>Default</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
      <Cell Name="0:1" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; RightAlign">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>12</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
      <Cell Name="1:1" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; LeftAlign">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>12</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
      <Cell Name="2:1" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; CenterAlign">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>12</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
      <Cell Name="3:1" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>12</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
      <Cell Name="0:2" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; RightAlign">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>123</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
      <Cell Name="1:2" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; LeftAlign">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>123</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
      <Cell Name="2:2" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; CenterAlign">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>123</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
      <Cell Name="3:2" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>123</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
      <Cell Name="0:3" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; RightAlign">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>1</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
      <Cell Name="1:3" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; LeftAlign">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>1</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
      <Cell Name="2:3" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar &gt; CenterAlign">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>1</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
      <Cell Name="3:3" AppliedCellStyle="CellStyle/Cell">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/TablePar">
          <CharacterStyleRange AppliedCharacterStyle="$ID/NormalCharacterStyle">
            <Content>1</Content>
          </CharacterStyleRange><Br />
        </ParagraphStyleRange>
      </Cell>
    </Table>

EOF

TABLE_CELLXML_ERB = <<-EOF
<Cell Name="3:3" AppliedCellStyle="CellStyle/Cell">
  <%= @cell_paragraphs %>
</Cell>

EOF


  class IdStory < XMLPkgDocument
    attr_accessor :paragraphs, :story_id
    def initialize(story_text)
      super
      @story_id = @element.attributes['Self']
      @paragraphs = []
      @element.elements.each do |story_item|
        # puts "story_item.name:#{story_item.name}"
        case story_item.name
        when 'StoryPreference'
        when 'InCopyExportOption'
        when 'ParagraphStyleRange'
          if story_item.elements['CharacterStyleRange'] && rect = story_item.elements['CharacterStyleRange'].elements['Rectangle']
            if rect.elements['Image']
              @paragraphs << IdImage.new(story_item) 
            end
          else
            @paragraphs << IdParagraph.new(story_item) 
          end         
        when 'Table'
          @paragraphs << IdTable.new(story_item)
        else
          
        end
      end
      self
    end
    
    def save_story(path)
      markdown = ""
      @paragraphs.each do |para|
        markdown += para.to_markdown
      end
      # puts "markdown:#{markdown}"
      File.open(path, 'w'){|f| f.write markdown}
    end
    
    def self.icml_from_story_hash(story_hash)
      @story_content = ""
      story_hash.each do |key, value|
        case key
        when :h1, :h2, :h3, :h4, :h5, :h6, 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', :p, 'p'
          @paragraph_style_name = key.to_s
          @char_style_name      = "[No name]"
          @para_text       = value
          erb   = ERB.new(PARAGRAPH_XML_ERB)
          xml   = erb.result(binding)         
          @story_content        += xml
        when :table, 'table'
        
        when :image, 'image'
      
        else
        
        end
      end
      erb   = ERB.new(IDML_STORY_ERB)
      erb.result(binding)         
    end
  end
  
  class IdParagraph < XMLElement
    attr_accessor :markup, :text_string
    def initialize(element)
      super
      @markup       = @element.attributes['AppliedParagraphStyle'].sub("ParagraphStyle/$ID/","")
      @text_string  = REXML::XPath.first(@element, '//ParagraphStyleRange/CharacterStyleRange/Content').text
      self
    end
    
    def to_markdown
      case markup
      when 'NormalParagraphStyle', 'NoParagraphStyle', :p, 'p'
        "#{@text_string}\n"
      when 'h1', :h1, 'Heading1'
        "# #{@text_string}\n"
      when 'h2', :h2, 'Heading2'
        "## #{@text_string}\n"
      when 'h3', :h3, 'Heading3'
        "### #{@text_string}\n"
      when 'h4', :h4, 'Heading4'
        "#### #{@text_string}\n"
      when 'h5', :h5, 'Heading5'
        "##### #{@text_string}\n"
      when 'h6', :h6, 'Heading6'
        "###### #{@text_string}\n"
      else
        "#{@text_string}\n"
      end
    end
    
    def self.from_para_data(para_data)
      @text     = para_data[:string]
      erb       = ERB.new(PARAGRAPH_XML_ERB)
      xml       = erb.result(binding)         
      @element  = REXML::Document.new(xml)
    end  
  end  
  
  class IdImage < XMLElement
    attr_accessor :image_path
    def initialize(element)
      super
      image_element = REXML::XPath.first(@element, '//ParagraphStyleRange/CharacterStyleRange/Rectangle/Image')
      # REXML::Element.elements are 1 base, not 0 based
      @image_path   = image_element.elements[2].attributes['LinkResourceURI'].sub("file:", "")
      #TODO get image frame??
      # since this is running image, frame size may not be important
      self
    end
    
    def self.from_para_data(para_data)
      @image_path = para_data[:image_path]
      erb         = ERB.new(IMAGE_XML_ERB)
      xml         = erb.result(binding)         
      @element    = REXML::Document.new(xml)
    end  
  end
  
  # 
  class IdTable < XMLElement
    attr_accessor :table_style, :header_row_count, :body_row_count, :column_count
    attr_accessor :cells
    def initialize(element)
      super
      # puts @element
      @table_attributes     = @element.root.attributes
      @table_style          = @table_attributes['AppliedTableStyle']
      @header_row_count     = @table_attributes['HeaderRowCount'].to_i
      @body_row_count       = @table_attributes['BodyRowCount'].to_i
      @column_count         = @table_attributes['ColumnCount'].to_i
      @cells                = []
      REXML::XPath.match(@element, '//Table/Cell').each do |cell|
        @cells << IdTableCell.new(cell)
      end
      
      self
    end
    
    def self.from_para_data(para_data)
      @image_path     = para_data[:image_path]
      erb             = ERB.new(TABLE_XML_ERB)
      xml             = erb.result(binding)         
      @element        = REXML::Document.new(xml)
    end  
    
    def to_markdown
      
    end
  end
    
  class IdTableCell < XMLElement
    attr_accessor :cell_name, :cell_style, :cell_text, :cell_paragraphs
    def initialize(element)
      super
      @cell_name      = @element.attributes['Name']
      @cell_style     = @element.attributes['AppliedCellStyle']
      @cell_paragraphs= []
      # REXML::XPath.match(@element, '/Cell/ParagraphStyleRange').each do |cell_para|
      #   @cell_paragraphs  << IdParagraph.new(cell_para)
      # end
      @element.elements.each do |cell_para|
        @cell_paragraphs  << IdParagraph.new(cell_para)
      end
      
      self
    end
  
    def self.from_para_data(para_data)
      #TODO convert cell_paragraphs into elements
      @cell_paragraphs  = para_data[:cell_paragraphs]
      erb               = ERB.new(TABLE_CELL_XML_ERB)
      xml               = erb.result(binding)         
      @element          = REXML::Document.new(xml)
    end  
  end
  

end
