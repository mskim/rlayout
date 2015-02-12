
#  Created by Min Soo Kim on 12/9/13.
#  Copyright 2013 SoftwareLab. All rights reserved.

# TODO
# things after "'" gets ingnored
# example: when I try to do doesn't  


# require 'kramdown'

module RLayout
  class Story
    attr_accessor :title, :author, :type, :date, :status, :categories, :published, :commnets
    attr_accessor :subtitle, :leading, :heading, :paragraphs
    attr_accessor :current_item_index
    
    def initialize(options={})
      @heading     = options.fetch(:heading, story_defaults)
      @published  = heading.fetch(:published, false)
      @paragraphs = options.fetch(:paragraphs,[])
      @current_item_index = 0
      
      if options[:body_markdown]
        # for when it was called from Rails though DRb server
        # without saving body markdown to the file
        @paragraphs = Story.parse_markdown(options[:body_markdown])
      end
      
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
    
    def to_meta_markdown
      text = @heading.to_yaml + "\n---\n\n"
      @paragraphs.each do |para|
        text += para.to_markdown
      end
      text
    end
    
    def done_layout?
      @current_item_index >= @paragraphs.length
    end
    
    def self.open(path)
      story_hash = YAML::load_file(path)
      Story.new(story_hash)
    end
    
    def save_stroy(path)
      unless path =~/.yml$/
        path += ".yml"
        system("mkdir -p #{File.dirname(path)} ") unless File.exists?(File.dirname(path))
        File.open(path, 'w'){|f| f.write to_hash.to_yaml}
      end
    end
    
    def self.parse_markdown(source, options={})
      @para_data=[]
      return @para_data if source == " " || source == ""
      demotion_level = options.fetch(:demotion_level, 0).to_i
       
      Kramdown::Document.new(source).root.children.each do |child|
        unless child.type == :blank
          para={}
          # puts "child.type:#{child.inspect}"
          case child.type
          when :p
            # puts "child.child.class:#{child.child.class}" 
            para[:markup] = "p" 
            para[:string] = child.children[0].value # inner text
            if child.children[0].type == :img
              para[:markup] = "img" 
              # puts "child.children[0].attr:#{child.children[0].attr}"
              para[:image_path] = child.children[0].attr['src']
              para[:caption] = child.children[0].attr['alt']
              @para_data << para
            else
              @para_data << para
            end
          when :header
            # puts "child.options[:level].class:#{child.options[:level].class}"
            # demotion_level = child.options[:level] + demotion_level
            # puts "demotion_level:#{demotion_level}"
            # if demotion_level  > 6
            #   demotion_level = 6
            # end
            level = child.options[:level] + demotion_level
            level = 6 if level > 6
            para[:markup] = "h#{level}"
            para[:string] = child.options[:raw_text] # inner text
            @para_data << para
            
          when "hr"
            para[:markup] = "h#{child.attrubute.level}"
            para << child.value
            @para_data << para

          else
            # para[:markup] = child.value # markup
            # para[:string] = child.value # inner text
            # @para_data << para
          end

        end
      end
      @para_data
    end
    
    
    def self.from_meta_markdown(filename)
      unless File.exists?(filename)
        puts "Can not find file #{filename}!!!!"
        return 
      end
      
      contents = File.read(filename)
      begin
        if (md = contents.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m))
          @contents = md.post_match
          @metadata = YAML.load(md.to_s)          
        end
      rescue => e
        puts "YAML Exception reading #filename: #{e.message}"
      end  
      # convert all keys to symbol
      @metadata=Hash[@metadata.map{ |k, v| [k.to_sym, v] }]
      demotion_level = @metadata.fetch(:demote, 0).to_i
      Story.new(:heading=>@metadata, :paragraphs=>Story.parse_markdown(@contents, :demotion_level=>demotion_level))
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
  end
  
end


