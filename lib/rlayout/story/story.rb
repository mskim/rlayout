
#  Created by Min Soo Kim on 12/9/13.
#  Copyright 2013 SoftwareLab. All rights reserved.

# Story Class reads and converts markdown with meta-data heading, files to para_data.
# para_data file is then converted to Asciidoctor 
# Asciidoctor file is used to create html using asciidocor cli.

# Story file format is mixture of markdown, Asciidoctor, and our own tags.
# A subset of Story can be pure markdown for short articles.
# Full Story format adds some markups that markdown doesn't support.
# Full Story format adds some markups that Asciidotor doesn't support.

# TODO
# things after "'" gets ingnored
# example: when I try to do doesn't

# Photo_page is a page with just photos, no text flow
# Photo_page has no headers, or footers
# \photo_page
# image(local_image: 10.pdf, grid_frame:[0,0,1,1])
# image(local_image: 11.pdf, grid_frame:[0,1,1,1])
# \end_photo_page

# float_group is group of floats with position, text flows around them.
# float_group forces for new page, it has heders and footers.
# \image_group
# image(local_image: 10.pdf, grid_frame:[0,0,1,1])
# image(local_image: 11.pdf, grid_frame:[0,1,1,1])
# \end_image_group

# Inline macros
# \sub(sub)
# \sup(super)
# \footnote(footnote_text)
# \xref(xref_mark)
# \index(index_text)
# \ruby{ruby text}(this with ruby)
# \dpt(thext with dot)
# \box(boxed text)
# \circled(circled text)
# \framed(framed text)
# \outlined(outlined text)
# \double_outlined(double outlined text)
# \color(rgb(r,g,b), text)
# \ruby, \ruby_under

module RLayout
  
  class Story
    attr_accessor :path, :para_data, :adoc, :options
    def initialize(path, options={})
      @path           = path
      @options        = options
      self
    end
    
    def self.sample
      @heading    = options.fetch(:heading, story_defaults)
      @published  = heading.fetch(:published, false)
      @paragraphs = options.fetch(:paragraphs,[])
      {:heading=>@metadata, :paragraphs =>paragraphs}
    end
    
    def story_defaults
      h={}
      h[:title]     = 'Untitled Story '
      h[:subtitle]  = 'This is a sample subtitle '
      h[:leading]   = "This is a sample leading.  you to learn!"
      h[:author]    = '-Min Soo Kim'
      h[:type]      = 'article'
      h[:date]      = Time.now
      h[:status]    = "first draft"
      h[:categories]= "none"
      h[:published] =  false
      h
    end

    def to_hash
      h = {}
      h[:heading]     = @heading
      h[:paragraphs]  = @paragraphs
      h
    end
    
    def to_html
      para_data_to_asciidoctor
      ext = File.extname(@path)
      adoc_path = @path.gsub(ext, ".adoc")
      folder_path = File.dirname(@path)
      File.open(adoc_path, 'w'){|f| f.write @adoc}
      system("cd #{folder_path} && asciidoctor #{adoc_path}")
    end
        
    def para_data_to_asciidoctor
      @para_data  = markdown2para_data(@options) unless @para_data
      heading     = @para_data[:heading]
      paragraphs  = @para_data[:paragraphs]
      # convert heading to asciidoctor title and preamble
      @adoc = ""
      if heading[:title]
        @adoc += "= " + heading[:title] + "\n"
      end
      if heading['title']
        @adoc += "= " + heading['title'] + "\n"
      end
      if heading[:author]
        @adoc += heading[:author] + "\n\n"
      end
      if heading['author']
        @adoc += heading['author'] + "\n\n"
      else
        @adoc += "\n"
      end
      
      if heading[:leading]
        @adoc += "[.lead] " + heading[:leading] + "\n\n"
      end
      if heading[:quote]
        @adoc += "[.quote] " + heading[:quote] + "\n\n"
      end
      if heading[:subtitle]
        @adoc += "== " + heading[:subtitle] + "\n\n"
      end
      # convert paragraphs to asciidoctor blocks
      paragraphs.each do |para|
        case para[:markup]
        when 'p'
          @adoc +=para[:string] + "\n\n"
        when 'h1'
          @adoc +="= " + para[:string] + "\n\n"
        when 'h2'
          @adoc +="== " + para[:string] + "\n\n"
        when 'h3'
          @adoc +="=== " + para[:string] + "\n\n"
        when 'h4'
          @adoc +="==== " + para[:string] + "\n\n"
        when 'h5'
          @adoc +="===== " + para[:string] + "\n\n"
        when 'h6'
          @adoc +="====== " + para[:string] + "\n\n"
        when 'image'
        when 'table'
        when 'warning'
        when 'source' , 'code'
        end
      end
      @adoc
    end
    
    def remote_paragraphs
      reader = RLayout::RemoteReader.new @remote_options
      paragraphs = reader.text_blocks.map do |lines_block|
        block2para_data(lines_block, :starting_heading_level=>starting_heading_level)
      end
      @para_data = {:heading=>@metadata, :paragraphs =>paragraphs}
      
    end
    
    #read story file and convert it to para_data format
    def markdown2para_data(options={})
      source = File.open(path, 'r'){|f| f.read}
      begin
        if (md = source.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m))
          @contents = md.post_match
          @metadata = YAML.load(md.to_s)
        else
          @contents = source
        end
      rescue => e
        puts "YAML Exception reading #filename: #{e.message}"
      end
      starting_heading_level = options.fetch(:demotion, 1)
      if @metadata
        if @metadata.class == Array
          #TODO it seem like a bug in motion-yaml
          # YAML.load(md.to_s) returns Array
          @metadata = @metadata[0]
        end
        starting_heading_level += @metadata['demotion'].to_i if @metadata['demotion']
      end
      # if we have meta-data, then
      # take out the top meta-data part from source
      # Set Document Options
      # And Create Heading from this
      reader = RLayout::Reader.new @contents, nil
      paragraphs = reader.text_blocks.map do |lines_block|
        block2para_data(lines_block, :starting_heading_level=>starting_heading_level)
      end
      @para_data = {:heading=>@metadata, :paragraphs =>paragraphs}
      # {:heading=>@metadata, :paragraphs =>paragraphs}
    end
    
    # markdown2section_data 
    # it parses metadata heading
    # it puts paragraphs by sections in an array, each array starting with section head para
    # stroy[:heading]
    # section_para = stroy[:section_para_data]
    # section_para[0]     # title paragraphs
    # section_para[1]     # first section paragraphs
    def markdown2section_data(options={})
      starting_heading_level = options.fetch(:demotion, 1)
      source = File.open(path, 'r'){|f| f.read}
      begin
        if (md = source.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m))
          @contents = md.post_match
          @metadata = YAML.load(md.to_s)
        else
          @contents = source
        end
      rescue => e
        puts "YAML Exception reading #filename: #{e.message}"
      end
      @section_para_data    = []
      @current_section      = []
      section_number        = 0
      reader = RLayout::Reader.new @contents, nil
      reader.text_blocks.each do |lines_block|  
        para = block2para_data(lines_block, :starting_heading_level=>starting_heading_level)
        if para[:markup] == "h2"
          @current_section << para
          @section_para_data << @current_section
          @current_section  = []
          section_number    += 1
        else
          @current_section << para
        end
      end
      @section_para_data << @current_section if @current_section.length > 0      
      # return 
      {:heading=>@metadata, :sections_paragraph =>@section_para_data}
      
    end
    
    #processing a block of parsed text 
    def block2para_data(text_block, options={})
      starting_heading_level = options.fetch(:starting_heading_level, 1)
      s = text_block.shift if text_block[0] =~ /(?>^\s*\n)+/
      s = text_block[0]
      if s =~/^#\s/ || s =~/^=\s/
        @markup = "h#{starting_heading_level}"
        s = text_block.join("\n")
        @string = s.sub(/#\s?/, "")
      elsif s =~/^##\s?/ || s =~/^==\s?/
        @markup = "h#{1 + starting_heading_level}"
        s = text_block.join("\n")
        @string = s.sub(/##\s?/, "")
      elsif s =~/^###\s/ || s =~/^===\s/
        @markup = "h#{2 + starting_heading_level}"
        @string = s.sub(/###\s?/, "")
      elsif s =~/^####\s/ || s =~/^====\s/
        @markup = "h#{3 + starting_heading_level}"
        @string = s.sub(/####\s?/, "")
      elsif s =~/^#####\s/ || s =~/^=====\s/
        @markup = "h#{4 + starting_heading_level}"
        @string = s.sub(/#####\s?/, "")
      elsif s =~/^######\s/ || s =~/^======\s/
        @markup = "h#{5 + starting_heading_level}"
        @string = s.sub(/######\s/, "")
      # label some:: some more text
      elsif s =~/^\.\s?/
        # ordered list li1
        return {:markup =>"ordered_list", :text_block=>text_block}
      elsif s =~/^[0-9]\.\s/
        return {:markup =>"ordered_section", :text_block=>text_block}
      elsif s =~/^[A-Z]\s/
        return {:markup =>"ordered_upper_alpha_list", :text_block=>text_block}
      elsif s =~/^\*\s?/
        # unordered list uli1
        return {:markup =>"unordered_list", :text_block=>text_block}
      elsif s =~/^table\s?/   
        # parse block   
        @markup = "table"
        @string = s.sub(/table\s?/, "")
      elsif s =~/^image\s?/      
        @markup = "image"
        #TODO multi line?
        @string = s.sub(/image\s?/, "")
      elsif s =~/^photo_page\s?/      
        @markup = "photo_page"
      elsif s =~/^\[float_group\]\s?/      
        #float_group, changed to include other graphics
        return {:markup =>"float_group", :text_block=>text_block}        
      elsif s =~/^pdf_insert\s?/      
        @markup = "pdf_insert"
      elsif s =~/^math\s?/      
        @markup = "math"
      else
        @markup = "p"
        if text_block.length > 0
          @string = ""
          text_block.each_with_index do |text_line, i|
            @string += text_line + "\n"
          end
        end
      end
      # 
      # 
      # string += text_block.join("\n")
      if @markup == "p" && @string =~/!\[/
        image_info = @string.match(/\{.*\}/)
        {:markup =>"img", :local_image=>image_info.to_s}
      # elsif markup == "image" 
      #   {:markup =>"image", :local_image=>@string.gsub("::", "")}
      elsif @markup == "table"
        if text_block.length > 1
          text_block.shift
          {:markup =>"table", :csv_data=>text_block.join("\n")}
        else
          csv_path = @string.gsub("::", "")
          {:markup =>"table", :csv_path=>csv_path}
        end
      # elsif markup == "image"
      #   {:markup =>markup, :string=>@string}
      else
        {:markup =>@markup, :para_string=>@string}
      end      
    end

    #TODO
    def to_asciidoctorpa
      
    end
    
    def to_meta_markdown
      text = @heading.to_yaml + "\n---\n\n"
      @paragraphs.each do |para|
        text += para.to_markdown
      end
      text
    end

    def self.open(path)
      story_hash = YAML::load_file(path)
      Story.new(story_hash)
    end

    def save_story(path)
      unless path =~/.yml$/
        path += ".yml"
        system("mkdir -p #{File.dirname(path)} ") unless File.exists?(File.dirname(path))
        File.open(path, 'w'){|f| f.write to_hash.to_yaml}
      end
    end

    def self.sample_story_yaml
      heading         = ParagraphModel.heading
      heading[:type]  = "article"
      {
        :heading     => heading,
        :paragraphs => ParagraphModel.body_part(5)
      }
    end

    def self.sample(options={})
      heading         = ParagraphModel.heading
      heading[:type]  = "article"
      h={
        :heading     => heading,
        :paragraphs => ParagraphModel.body_part(5)
      }
      Story.new(h)
    end
    
    def self.magazine_article_sample(options={})
      heading         = ParagraphModel.heading
      heading[:type]  = "magazine article"
      h={
        :heading     => heading,
        :paragraphs => ParagraphModel.body_part(5)
      }
      Story.new(h)
    end

    def self.news_article_sample(options={})
      heading         = ParagraphModel.news_article_heading
      heading[:type]  = "news article"
      h={
        :heading     => heading,
        :paragraphs => ParagraphModel.body_part(5)
      }
      Story.new(h)
    end

    def self.book_chapter(count=10)
      heading         = ParagraphModel.heading
      heading[:type]  = "book_chapter"
      h={
        :heading     => heading,
        :paragraphs => ParagraphModel.body_part(5)
      }
      Story.new(h)
    end
            
    def self.get_metadata_from_stroy(story_path)
      contents = File.open(story_path, 'r'){|f| f.read}
      begin
        if (md = contents.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m))
          @story_markdown = md.post_match
          @metadata = YAML.load(md.to_s)
        end
      rescue => e
        puts "YAML Exception reading #filename: #{e.message}"
      end
      @metadata
    end
    
    def Story.update_metadata(story_path, new_metadata_hash)
      contents = File.open(story_path, 'r'){|f| f.read}
      begin
        if (md = contents.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m))
          @story_markdown = md.post_match
          @metadata = YAML.load(md.to_s)
        end
      rescue => e
        puts "YAML Exception reading #filename: #{e.message}"
      end
      
      @metadata.merge!(new_metadata_hash)
      meta_data_yaml = @metadata.to_yaml
      new_story = meta_data_yaml + "\n---\n" + @story_markdown
      File.open(story_path, 'w'){|f| f.write new_story}
    end
  end

  class RemoteStory < Story
    attr_accessor :remote_options
    def initialize(path, options={})
      super
      @remote_options = @options.fetch(:remote_options, nil)
      self
    end
    
  end

end
