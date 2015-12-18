#encode :utf-8

module RLayout
  
IDML_STORY_ERB = <<-EOF.gsub(/^\s*/, "")



<%= @story_content %>

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

\n
EOF

TABLE_ROW_XML_ERB = <<-EOF.gsub(/^\s*/, "")
\n
EOF
  class IdStory
    def initialize(text)
      
      self
    end
    
    def self.icml_from_story_hash(story_hash)
      puts __method__
      @story_content = ""
      puts "story_hash.length:#{story_hash.length}"
      story_hash.each do |key, value|
        puts key 
        puts value 
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

  # 
  # class Paragraph < Idml::IdPkg
  #   def initialize(xml)
  #     super
  #     self
  #   end
  #   
  #   def self.from_para_data(para_data)
  #     @text = para_data[:string]
  #     erb   = ERB.new(PARAGRAPH_XML_ERB)
  #     xml   = erb.result(binding)         
  #     @element = REXML::Document.new(xml)
  #   end  
  # end  
  # 
  # 
  # class Image < Idml::IdPkg
  #   def initialize(xml)
  #     super
  #     self
  #   end
  #   
  #   def self.from_para_data(para_data)
  #     @image_path = para_data[:image_path]
  #     erb   = ERB.new(IMAGE_XML_ERB)
  #     xml   = erb.result(binding)         
  #     @element = REXML::Document.new(xml)
  #   end  
  #     
  # end
  # 
  # class Table < Idml::IdPkg
  #   def initialize(xml)
  #     super
  #     
  #     self
  #   end
  #   
  #   def self.from_para_data(para_data)
  #     
  #   end      
  # end
  # 
  # class TableRow < Idml::IdPkg
  #   def initialize(xml)
  #     super
  #     self
  #   end
  #         
  #   def self.from_para_data(para_data)
  #     @row_data = para_data[:row_data]
  #     erb   = ERB.new(TABLE_ROW_XML_ERB)
  #     xml   = erb.result(binding)         
  #     @element = REXML::Document.new(xml)
  #   end  
  # end

end






__END__
module Idml
  class CharRange
    attr_accessor :applied_character_style, :point_size, :tracking, :baseline_shift
    attr_accessor :capitalization, :kerning_value, :properties, :content
  
    def initialize(hash)
      @applied_character_style  = hash['AppliedCharacterStyle']
      @point_size               = hash['PointSize']
      @tracking                 = hash['Tracking']
      @baseline_shift           = hash['BaselineShift']
      @capitalization           = hash['Capitalization']
      @kerning_value            = hash['KerningValue']
      @properties               = hash['Properties']
      @content                  = hash['Content']

      self
    end
  
    def content
      if @content.class == Array
        return @content.join(" ")
      end
      @content
    end
  end

  class ParagraphRange
    attr_accessor :applied_paragraph_style, :hyphenate_ladder_limit, :hyphenate_capitalized_words, :hyphenation_zone
    attr_accessor :properties, :character_style_ranges
  
    def initialize(para_data)
        @character_style_ranges = []
        @applied_paragraph_style      = para_data['AppliedParagraphStyle']
        @hyphenate_ladder_limit       = para_data['HyphenateLadderLimit']
        @hyphenate_capitalized_words  = para_data['HyphenateCapitalizedWords']
        @hyphenation_zone             = para_data['HyphenationZone']
        @properties                   = para_data['Properties']
      
        # Some of the char_ranges are Array, insted of Hash
        # Look into how xml is converted to Hash, mean time 
        # have temp_char_array of attrubys to collect and convert the collections into Hash
        # Flushed when Hash para_range is dectected or repeting attribute is detected
      
        temp_char_arry = []
        if para_data['CharacterStyleRange']
          para_data['CharacterStyleRange'].each do |char_range|
            if char_range.is_a?(Hash)
              if temp_char_arry.length > 0
                # flush current char_range
                h= {}
                temp_char_arry.each do |pair|
                  h[pair[0]] = pair[1]
                end
                @character_style_ranges  << CharRange.new(h)
                temp_char_arry = []
              end
              @character_style_ranges  << CharRange.new(char_range)
            else
              # check if we have another run with array
              if temp_char_arry.flatten.include?(char_range[0])
                # flush current char_range
                h= {}
                temp_char_arry.each do |pair|
                  h[pair[0]] = pair[1]
                end
                @character_style_ranges  << CharRange.new(h)
                temp_char_arry = []
              
              end
              temp_char_arry << char_range
            end
          end
        
          # flush left over char_range in the temp
          if temp_char_arry.length > 0
            h={}
            temp_char_arry.each do |pair|
              h[pair[0]] = pair[1]
            end
            @character_style_ranges  << CharRange.new(h)
          end        
        end
  
      self
    end
  
    def content
      content = ""
      @character_style_ranges.each do |char_range|
        content += char_range.content if char_range.content
      end
      content + "\n"
    end
  end

  class Story
    attr_accessor :document, :paragraph_ranges
    attr_accessor :self, :applied_to_cstyle, :track_changes, :story_title, :applied_named_grid
    attr_accessor :story_preference, :in_copy_export_option, :paragraph_style_range
    def initialize(document, story_xml, options={})
      puts "story_xml: #{story_xml}"
      @hash = Hash.from_xml(story_xml)
      puts "hash: #{@hash}"
      @document              = document
      @paragraph_ranges      = []
      hash                   = Hash.from_xml(story_xml)
      hash                   = hash['Story']  # flatten hash
      hash                   = hash['Story']  # flatten hash      
      @self                  = hash['Self']
      @applied_to_cstyle     = hash['AppliedTOCStyle']
      @track_changes         = hash['TrackChanges']
      @story_title           = hash['StoryTitle']
      @applied_named_grid    = hash['AppliedNamedGrid']
      @story_preference      = hash['StoryPreference']
      @in_copy_export_option = hash['InCopyExportOption']
      @paragraph_style_range = hash['ParagraphStyleRange']
    
      # Some of the para_range are Array, insted of Hash
      # Look into how xml is converted to Hash, mean time 
      # have temp_para_array of attrubys to collect and convert the collections into Hash
      # Flushed when Hash para_range is dectected. or repeting attribute is detected
    
      temp_para_array = []
      hash['ParagraphStyleRange'].each do |para_range|
        if para_range.class == Hash
        
          if temp_para_array.length > 0
            # construct hash wtih para_temp_para_array
            h={}
            temp_para_array.each do |pair|
              h[pair[0]] = pair[1]
            end
            @paragraph_ranges << ParagraphRange.new(h)
            temp_para_array = []
            # clear temp temp_para_array
          end
          @paragraph_ranges << ParagraphRange.new(para_range)
        
        elsif  para_range.class == Array
        
          # check if we have another para_run
          if temp_para_array.flatten.include?(para_range[0])
            # flush old and start new tmep_para_array run
            h={}
            temp_para_array.each do |pair|
              h[pair[0]] = pair[1]
            end
            @paragraph_ranges << ParagraphRange.new(h)
            temp_para_array = []
          
          else
            temp_para_array << para_range
          end
        end
              
      end    
      
      # flush left over para_range in the temp
      if temp_para_array.length > 0
        # construct hash wtih temp_para_array
        h={}
        temp_para_array.each do |pair|
          h[pair[0]] = pair[1]
        end
        @paragraph_ranges << ParagraphRange.new(h)
      end

      self
    end
  
    def to_xml
    
    end
  
    def story_content
      content = ""
      @paragraph_ranges.each do |para_range|
        content += para_range.content
      end
      content
    end
  
    def to_att_string
    
    end
  
    def save_xml(path)
    
    end
  end

end