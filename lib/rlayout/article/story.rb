
#  Created by Min Soo Kim on 12/9/13.
#  Copyright 2013 SoftwareLab. All rights reserved.

# Story Class is reads and converts marked files to para_data.
# Story file format is mixture of markdown, Asciidoctor, and our own tags.
# A subset of Story can be pure markdown for short articles.
# Full Story format adds some markups that markdown doesn't support.
# Full Story format adds some markups that Asciidotor doesn't support.

# To generate HTML, Full Story have be coverted to Asciidoctor, or GHF-markdown.

# TODO
# things after "'" gets ingnored
# example: when I try to do doesn't

# Photo_page is a page with just photos, no text flow
# Photo_page has no headers, or footers
# \photo_page
# image(local_image: 10.pdf, grid_frame:[0,0,1,1])
# image(local_image: 11.pdf, grid_frame:[0,1,1,1])
# \end_photo_page

# image_group is a page with group of images with position, text flows around them.
# image_group forces for new page, it has heders and footers.
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

module RLayout

  class Story
    attr_accessor :title, :author, :type, :date, :status, :categories, :published, :commnets
    attr_accessor :subtitle, :leading, :heading, :paragraphs

    def initialize(options={})
      @heading     = options.fetch(:heading, story_defaults)
      @published  = heading.fetch(:published, false)
      @paragraphs = options.fetch(:paragraphs,[])
      self
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
    

    #read story file and convert it to para_data format
    def self.markdown2para_data(path, options={})
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
        Story.block2para_data(lines_block, :starting_heading_level=>starting_heading_level)
      end
      {:heading=>@metadata, :paragraphs =>paragraphs}
    end

    #processing a block of parsed text 
    def self.block2para_data(text_block, options={})
      s=StringScanner.new(text_block[0])
      # starting_heading_level is 1, h1
      # if starting_heading_level = 3, h1 => h3
      #
      starting_heading_level = options.fetch(:starting_heading_level, 1)
      markup_stirng = s.scan(/#*\s?/)
      if markup_stirng == "" || markup_stirng.nil?
        markup_stirng = s.scan(/=*\s?/)
      end
      if markup_stirng == "" || markup_stirng.nil?
        markup_stirng = s.scan(/table/)
      end
      if markup_stirng == "" || markup_stirng.nil?
        markup_stirng = s.scan(/image/) 
      end
      if markup_stirng == "" || markup_stirng.nil?
        markup_stirng = s.scan(/\[image\]/) 
      end
      if markup_stirng == "" || markup_stirng.nil?
        markup_stirng = s.scan(/photo_page/) 
      end
      if markup_stirng == "" || markup_stirng.nil?
        markup_stirng = s.scan(/\[photo_page\]/) 
      end
      if markup_stirng == "" || markup_stirng.nil?
        markup_stirng = s.scan(/image_group/) 
      end
      if markup_stirng == "" || markup_stirng.nil?
        markup_stirng = s.scan(/\[image_group\]/) 
      end
      if markup_stirng == "" || markup_stirng.nil?
        markup_stirng = s.scan(/pdf_insert/) 
      end
      if markup_stirng == "" || markup_stirng.nil?
        markup_stirng = s.scan(/\[pdf_insert\]/) 
      end
      if markup_stirng == "" || markup_stirng.nil?
        markup_stirng = s.scan(/\[math\]/) 
      end
      
      #TODO img, math, table, admonition, quote, code
      #TODO don't allow more than h6
      case markup_stirng
      when "\# ", "\#", "=", "= "
        if starting_heading_level > 6
          markup = "h6"
        else
          markup = "h#{starting_heading_level}"
        end
      when "\#\# ", "\#\#", "==", "== "
        if starting_heading_level > 5
          markup = "h6"
        else
          markup = "h#{starting_heading_level + 1}"
        end
      when "\#\#\# ", "\#\#\#", "===", "=== "
        if starting_heading_level > 4
          markup = "h6"
        else
          markup = "h#{starting_heading_level + 2}"
        end
      when "\#\#\#\# ", "\#\#\#\#", "====", "==== "
        if starting_heading_level > 3
          markup = "h6"
        else
          markup = "h#{starting_heading_level + 3}"
        end
      when "\#\#\#\#\# ", "\#\#\#\#\#", "=====", "===== "
        if starting_heading_level > 2
          markup = "h6"
        else
          markup = "h#{starting_heading_level + 4}"
        end
      when "\#\#\#\#\#\# ", "\#\#\#\#\#\#", "======", "====== "
        markup = 'h6'
      when "table", "[table]"
        markup = 'table'
      when "pdf_insert", "[pdf_insert]"
        markup = 'photo_page'
      when "photo_page", "[photo_page]"
        markup = 'photo_page'
      when "image_group", "[image_group]"
        markup = 'image_group'
      when "[image]"
        markup = 'image'
      when "[math]"
        markup = 'math'
      else
        markup = 'p'
      end
      
      @string = s.scan(/.*/)
      if text_block.length > 1
        @string = ""
        text_block.each_with_index do |text_line, i|
          next if i == 0
          @string += text_line + "\n"
        end
      end
      # string += text_block.join("\n")
      if markup == "p" && @string =~/!\[/
        image_info = @string.match(/\{.*\}/)
        {:markup =>"img", :local_image=>image_info.to_s}
      # elsif markup == "image" 
      #   {:markup =>"image", :local_image=>@string.gsub("::", "")}
      elsif markup == "table"
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
        {:markup =>markup, :string=>@string}
      end
    end

    #TODO
    def to_asciidoctor
      
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

end
