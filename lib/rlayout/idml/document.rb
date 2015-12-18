#encode :utf-8

# require 'nokogiri'
# require 'active_support'
# require "active_support/core_ext"
# require 'xmlsimple'
# require 'awesome_print'
# require 'xmlsimple'

# I am trying to make the idPkg xml into Hash and using is as an Object 
#   and edit them
#   and get back the same idPkg xml

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
        @graphic = GraphicPkg.new(pkg_data) 
        # Font
        src_file = REXML::XPath.first(design_map_xml, '/Document/idPkg:Fonts').attributes['src']
        pkg_data = zipped_files.get_entry(src_file).get_input_stream.read
        @fonts = Fonts.new(pkg_data) 
        
        # Styles
        src_file =  REXML::XPath.first(design_map_xml, '/Document/idPkg:Styles').attributes['src']
        pkg_data = zipped_files.get_entry(src_file).get_input_stream.read
        @styles = Styles.new(pkg_data) 
        puts "@styles:#{@styles}"
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

    def	to_rlayout(options={})
    	path = @idml_path.sub(".idml", '.rlayout')
    	if options[:path]
    	  path = options[:path]	
    	end
    	system "mkdir -p #{path}" unless File.exists?(path)
    	layout_yaml = path + '/layout.yml'
    	content = {}
    	pages = []
    	@spreads.each do |spread|
  	    pages << spread.pages_hash
    	end
    	content[:pages] = pages
    	File.open(layout_yaml, 'w'){|f| f.write content.to_yaml}
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
  
  class IdPkg
    attr_accessor :element
    def initialize(element, options={})
      @element =  REXML::Document.new(element)
      self
    end
  end
  
  class GraphicPkg < IdPkg
    attr_accessor :element
    def initialize(element, options={})
      @element =  element
      self
    end
  end
  
  class Fonts < IdPkg
    def initialize(xml, options={})
      super
      self
    end  
  end

 
  class Preferences < IdPkg
    def initialize(xml, options={})
      super
      self
    end  
  end
  
  class Tags < IdPkg
    def initialize(xml, options={})
      super
      self
    end  
  end

  class BackingStory < IdPkg
    def initialize(xml, options={})
      super
      self
    end  
  end  
  

  
end

