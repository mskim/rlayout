#encode :utf-8

module RLayout
  class Styles < XMLDocument
    attr_accessor :character_styles, :paragraph_styles
    attr_accessor :table_styles, :cell_styles, :object_styles
    def initialize(xml, options={})
      super
      @element.root.elements.each do |style_group|
        case style_group.name
        when 'RootCharacterStyleGroup'
          parse_char_styles(style_group)
        when 'RootParagraphStyleGroup'
          parse_paragraph_styles(style_group)
        when 'TOCStyle'
          parse_toc_style(style_group)
        when 'RootCellStyleGroup'
          parse_cell_style(style_group)
        when 'RootTableStyleGroup'
          parse_table_style(style_group)
        when 'RootObjectStyleGroup'
          parse_object_style(style_group)
        when 'TrapPreset'
          # puts 'RootTrapPresetGroup'
        else 
          puts style_group
        end
      end
      
      self
    end  
        
    def parse_char_styles(element)
      @character_styles = []
      element.elements.each do |char_style|
        h = {}
        h[:name] = char_style.attributes['Name']
        @character_styles << h
      end      
    end
    
    def parse_paragraph_styles(style_group)
      @paragraph_styles = []
      style_group.elements.each do |para_style|
        h = {}
        h[:name] = para_style.attributes['Name']
        attrs = para_style.attributes 
        if based_on = para_style.elements['Properties'].elements['BasedOn']
          h[:based_on]        = based_on.text
        else
          h[:text_font]       = para_style.elements['Properties'].elements['AppliedFont'].text
          h[:text_size]       = attrs['PointSize']
          h[:text_style]      = attrs['FontStyle']
          h[:text_alignment]  = attrs['Justification']
          h[:text_leading]    = para_style.elements['Properties'].elements['Leading'].text
          h[:text_first_line_head_indent]= attrs['FirstLineIndent'] 
          h[:text_head_indent]= attrs['LeftIndent']
          h[:text_tail_indent]= attrs['RightIndent']
        end
        @paragraph_styles << h
      end   
    end
    
    def parse_cell_style(style_group)
      # puts style_group
      @cell_styles = []
      style_group.elements.each do |cell_style|
        h = {}
        h[:name] = cell_style.attributes['Name']
        attrs = cell_style.attributes 
        if cell_style.elements['Properties'] && based_on = cell_style.elements['Properties'].elements['BasedOn']
          h[:based_on]        = based_on.text
        else
          # h[:text_size]       = attrs['PointSize']
          # h[:text_style]      = attrs['FontStyle']
          # h[:text_alignment]  = attrs['Justification']
          # h[:text_first_line_head_indent]= attrs['FirstLineIndent'] 
          # h[:text_head_indent]= attrs['LeftIndent']
          # h[:text_tail_indent]= attrs['RightIndent']
        end
        @cell_styles << h
      end   
    end
    
    def parse_table_style(style_group)
      # puts style_group
      @table_styles = []
      style_group.elements.each do |table_style|
        h = {}
        h[:name] = table_style.attributes['Name']
        attrs = table_style.attributes 
        if table_style.elements['Properties'] && based_on = table_style.elements['Properties'].elements['BasedOn']
          h[:based_on]        = based_on.text
        else
          # h[:text_size]       = attrs['PointSize']
          # h[:text_style]      = attrs['FontStyle']
          # h[:text_alignment]  = attrs['Justification']
          # h[:text_first_line_head_indent]= attrs['FirstLineIndent'] 
          # h[:text_head_indent]= attrs['LeftIndent']
          # h[:text_tail_indent]= attrs['RightIndent']
        end
        @table_styles << h
      end   
    end
    
    def parse_toc_style(style_group)
      
    end
    
    def parse_object_style(style_group)
      
    end
  end

end

