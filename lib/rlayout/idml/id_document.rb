#encode :utf-8

# require 'nokogiri'
# require 'active_support'
# require "active_support/core_ext"
# require 'xmlsimple'
# require 'awesome_print'
# require 'xmlsimple'

# I have tried with XmlSimple.xml_in to convert xml to Hash
# and XmlSimple.xml_out to get back xml.

# It draws error for some reason when I try to convert designmap.xml.
# it is getting rid of the idPak:name. 
# I could use Nokogiri and just get the source files using XPath
# but I am trying to use pure Ruby imlementatios only for rubymotion port.
# TODO Maybe I can use REXML with XPath ??
# So, after some trial error, I am using the following combination.

# I am using active_support/core_ext for Hash.from_xml for parsing designmap.xml
# And for each pkg files
#   using xmlsimple xml_in(xml) and XmlSimple.xml_out(@hash) and 
# TODO I need to find a way to merge two into one.
# My final goal is to run it as rubymotoion commonad line app
# So, I need pure Ruby implementation, so no Nokogiri if I can avoid it.

module RLayout
    
  class IdDocument
    attr_accessor :path, :designmap, :sections, :mimetype
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
    
    def paragraph_styles
      @styles.paragraph_styles
    end
    
    def get_char_styles
      
    end
    
    def all_stories
      text_content = ""
      @stories.each do |story|
        text_content += story.story_content
      end
      text_content
    end
    
    def create_folders(path)
      system("mkdir -p #{path}") unless File.exists?(path)
      system("mkdir -p #{path + '/MasterSpreads'}") unless File.exists?(path + '/MasterSpreads')
      system("mkdir -p #{path + '/META-INF'}") unless File.exists?(path + '/META-INF')
      system("mkdir -p #{path + '/Resources'}") unless File.exists?(path + '/Resources')
      system("mkdir -p #{path + '/Spreads'}") unless File.exists?(path + '/Spreads')
      system("mkdir -p #{path + '/Stories'}") unless File.exists?(path + '/Stories')
      system("mkdir -p #{path + '/XML'}") unless File.exists?(path + '/XML')
    end
    
    def save_idml(path)
      # create_folders(path)
      # @graphic.save
      # save_font
      # save_styles
      # @preferences.save
      # save_tags
      # save_master_spread
      # save_spread
      # save_story
      # save_designmap
    end
    
    def	to_rlayout(options={})
      @rlayout_path = @idml_path
      if @idml_path =~/.idml$/
    	  @rlayout_path = @idml_path.sub(".idml", '.rlayout')
      end
    	if options[:path]
    	  @rlayout_path = options[:path]	
    	end
    	system "mkdir -p #{@rlayout_path}" unless File.exists?(@rlayout_path)
      save_master_page
      save_styles
      save_layout
      save_stories
    end
    
    def save_styles
      # master_page
      # paragraph_style
      # char_style
      # table_style
      # graphic_defaults
      # heading_style
      
      styles_folder =  @rlayout_path + '/styles'
      system("mkdir -p #{styles_folder}") unless File.exist?(styles_folder)
    end
    
    def save_master_page
      master_page_folder =  @rlayout_path + '/styles'
      system("mkdir -p #{master_page_folder}") unless File.exist?(master_page_folder)
      layout_rb_path          = master_page_folder + '/master_page.rb'
    	content                 = {}
    	pages                   = []
    	@spreads.each do |spread|
  	    pages += spread.pages
    	end
    	layout_rb = ""
    	pages.each_with_index do |page, i|
    	  layout_rb += "  # page_#{i+1}\n"
    	  layout_rb += page.page_layout_text
  	  end
  	  File.open(layout_rb_path, 'w'){|f| f.write layout_rb}
    end
    
    def save_layout
      layout_rb_path  = @rlayout_path + '/layout.rb'
    	content         = {}
    	pages           = []
    	@spreads.each do |spread|
  	    pages += spread.pages
    	end
    	layout_rb = ""
    	pages.each_with_index do |page, i|
    	  layout_rb += "  # page_#{i+1}\n"
    	  layout_rb += page.page_layout_text
  	  end
  	  File.open(layout_rb_path, 'w'){|f| f.write layout_rb}
    end
    
    def save_stories
      @stories.each_with_index do |story, i|
        story.save_story(@rlayout_path + "/story_#{i + 1}.md")
      end
    end
    
    
    # editing idml
    def self.create(path, options={})
      idml_template = options.fetch(:idml_template, "default_tempalte_path")
      IdDocument.new(idml_template)
    end
        
    def append_spread(spread)
      
    end
    
    def add_text_frame(spread, options={}) #story, text_frame
      
    end
    
    def append_story(story, text_frame)
      
    end
  end
  
  class XMLElement
    attr_accessor :element
    def initialize(element, options={})
      @element =  element
      self
    end    
  end
  
  class XMLPkgDocument
    def initialize(xml_text, options={})
      # super 
      package   = REXML::Document.new(xml_text)
      @element  = package.root.elements.first  if package.root.elements
      self
    end    
  end
  #   
  # 
  class XMLDocument
    attr_accessor :element
    def initialize(xml_text, options={})
      @element   = REXML::Document.new(xml_text)
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

