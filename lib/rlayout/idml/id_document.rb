#encode :utf-8

# idml is edited by first converting it to an intermediate working folder.
# working folder is created next to idml with same basename with .id_layout extension.
# it contains intermediate format, IDML converted to hash(yaml) in idyml. 
# And other supporing story files, such as hwpml, Word, or markdown files.
# it can also script layout using pgscript. 
# After idyml are edited, it is converted back to IDML.

# my.idml
# my.id_layout
#   idyml
#      designmap.yml
#      story.yml
#      master_spread.yml
#      spread.yml
#      styles.yml
#      
#   my_hangul.hml
#   my_hangul 
#      story.md
#   pgscript.rb
#   images
#   Rakefile

# workflow
# 1. pre-desinged idml file is given
# 1. create id_layout working folder from it.
# 1. place hwpml file into the folder and generate story.md
# 1. place story.md into id_layout 
# 1. update idml file using rake 
# 1. open idml to prreview.

module RLayout
    
  class IdDocument
    attr_accessor :idml_path, :id_layout_path, :styles_folder
    attr_accessor :designmap, :mimetype
    attr_accessor :master_spreads, :spreads, :backing_story, :stories
    attr_accessor :graphic_pkg, :fonts, :styles, :preferences, :tags
    def initialize(idml_path, options={})
      @idml_path    = idml_path
      @stories = []
      @master_spreads = []
      @spreads = []
      Zip::File.open(@idml_path) do |zipped_files|
        design_map_data = zipped_files.get_entry('designmap.xml').get_input_stream.read
        design_map_xml =  REXML::Document.new(design_map_data)
        # Graphic
        src_file =  REXML::XPath.first(design_map_xml, '/Document/idPkg:Graphic').attributes['src']
        pkg_data = zipped_files.get_entry(src_file).get_input_stream.read
        @graphic_pkg = GraphicPkg.new(pkg_data) 
        # Font
        src_file = REXML::XPath.first(design_map_xml, '/Document/idPkg:Fonts').attributes['src']
        pkg_data = zipped_files.get_entry(src_file).get_input_stream.read
        @fonts = Fonts.new(pkg_data) 
        
        # Styles
        src_file =  REXML::XPath.first(design_map_xml, '/Document/idPkg:Styles').attributes['src']
        pkg_data = zipped_files.get_entry(src_file).get_input_stream.read
        @styles = Styles.new(pkg_data) 
        # Preferences
        src_file =  REXML::XPath.first(design_map_xml, '/Document/idPkg:Preferences').attributes['src']
        pkg_data = zipped_files.get_entry(src_file).get_input_stream.read
        @preferences = Preferences.new(pkg_data) 
        # Tags
        src_file =  REXML::XPath.first(design_map_xml, '/Document/idPkg:Tags').attributes['src']
        pkg_data = zipped_files.get_entry(src_file).get_input_stream.read
        @tags = Tags.new(pkg_data) 
        #MasterSpread
        REXML::XPath.match(design_map_xml, "/Document/idPkg:MasterSpread").each do |master_spread|
          pkg_data = zipped_files.get_entry(master_spread.attributes['src']).get_input_stream.read
          @master_spreads << MasterSpread.new(pkg_data)
        end
        # Spread   
        REXML::XPath.match(design_map_xml, "/Document/idPkg:Spread").each do |spread|
          pkg_data = zipped_files.get_entry(spread.attributes['src']).get_input_stream.read
          @spreads << Spread.new(pkg_data)
        end
        # BackingStory
        # Todo this might have to be Array
        REXML::XPath.match(design_map_xml, "/Document/idPkg:BackingStory").each do |story|
          pkg_data = zipped_files.get_entry(story.attributes['src']).get_input_stream.read
          @backing_story = BackingStory.new(pkg_data)
        end
        # Story
        REXML::XPath.match(design_map_xml, "/Document/idPkg:Story").each do |story|
          pkg_data = zipped_files.get_entry(story.attributes['src']).get_input_stream.read
          @stories << IdStory.new(pkg_data)
        end
      end
      self
    end
        
    def all_stories
      text_content = ""
      @stories.each do |story|
        text_content += story.story_content
      end
      text_content
    end
            
    def	to_id_layout(options={})
      @id_layout_path = @idml_path
      if @idml_path =~/.idml$/
    	  @id_layout_path = @idml_path.sub(".idml", '.id_layout')
      end
    	if options[:path]
    	  @id_layout_path = options[:path]	
    	end
    	@styles_folder      =  @id_layout_path + '/styles'
      
    	system "mkdir -p #{@id_layout_path}" unless File.exists?(@id_layout_path)
      save_styles
      save_layout
      save_stories
    end
    
    def save_styles
      system("mkdir -p #{styles_folder}") unless File.exist?(@styles_folder)
      save_master_page
      save_layout
      # paragraph_style
      text_styles       = @styles.paragraph_styles.to_yaml
      # char_style     
      text_styles       += @styles.character_styles.to_yaml
      text_style_path   = @styles_folder + '/text_style.yml'
      File.open(text_style_path, 'w'){|f| f.write text_styles}
      # save cell style
      cell_styles      = @styles.cell_styles.to_yaml
      cell_style_path   = @styles_folder + '/cell_style.yml'
      File.open(cell_style_path, 'w'){|f| f.write cell_styles}
      # save table style
      table_styles      = @styles.table_styles.to_yaml
      table_style_path   = @styles_folder + '/cell_styles.yml'
      File.open(table_style_path, 'w'){|f| f.write table_styles}
      # graphic_defaults
      # heading_style
    end
    
    def save_master_page
      layout_rb_path          = @styles_folder + '/master_page.rb'
    	layout_rb = ""
    	@master_spreads.each_with_index do |spread, i|
        layout_rb += "  # spread_#{i+1}\n"
  	    layout_rb += spread.spread_content
    	end
  	  File.open(layout_rb_path, 'w'){|f| f.write layout_rb}
    end
    
    def save_layout
      layout_rb_path  = @id_layout_path + '/layout.rb'
    	layout_rb = ""
    	@spreads.each_with_index do |spread, i|
        layout_rb += "  # spread_#{i+1}\n"
  	    layout_rb += spread.spread_content
    	end

  	  File.open(layout_rb_path, 'w'){|f| f.write layout_rb}
    end
    
    
    def save_stories
      story_folder = @id_layout_path + "/story"
      system("mkdir -p #{story_folder}") unless File.exist?(story_folder)
      @stories.each_with_index do |story, i|
        story.save_story(story_folder + "/story_#{story.story_id}.md")
      end
    end
    
    # editing idml
    def self.create(path, options={})
      idml_template = options.fetch(:idml_template, "default_tempalte_path")
      IdDocument.new(idml_template)
    end
    
    def add_text_frame
      
    end
    
    def append_story(story, text_frame)
      
    end
    
    def append_page
      
    end    
    
    def append_spread(spread)
      
    end
    
    def add_text_frame(spread, options={}) #story, text_frame
      
    end
    
    
    # update IDML
    def update_idml(path)
      # save_spread
      # save_story
      # update_designmap
    end
    
  end
  

  class GraphicPkg < XMLPkgDocument
    attr_accessor :element
    def initialize(element, options={})
      @element =  element
      self
    end
  end
  
  class Fonts < XMLPkgDocument
    def initialize(xml, options={})
      super
      self
    end  
  end

 
  class Preferences < XMLPkgDocument
    def initialize(xml, options={})
      super
      self
    end  
  end
  
  class Tags < XMLPkgDocument
    def initialize(xml, options={})
      super
      self
    end  
  end

  class BackingStory < XMLPkgDocument
    def initialize(xml, options={})
      super
      self
    end  
  end  
  
  
end

