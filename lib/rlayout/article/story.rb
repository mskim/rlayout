
#  Created by Min Soo Kim on 12/9/13.
#  Copyright 2013 SoftwareLab. All rights reserved.

# TODO
# things after "'" gets ingnored
# example: when I try to do doesn't



module RLayout

  class Story
    attr_accessor :title, :author, :type, :date, :status, :categories, :published, :commnets
    attr_accessor :subtitle, :leading, :heading, :paragraphs

    def initialize(options={})
      @heading     = options.fetch(:heading, story_defaults)
      @published  = heading.fetch(:published, false)
      @paragraphs = options.fetch(:paragraphs,[])

      # if options[:body_markdown]
      #   # for when it was called from Rails though DRb server
      #   # without saving body markdown to the file
      #   @paragraphs = Story.parse_markdown(options[:body_markdown])
      # end

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
    
    def self.story_from_markdown(markdown_path)
      unless File.exists?(story_path)
        puts "Can not find file #{story_path}!!!!"
        return {}
      end
      contents = File.open(markdown_path, 'r'){|f| f.read}
      begin
        if (md = contents.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m))
          @metadata = YAML.load(md.to_s)
          @story_markdown = md.post_match
        end
      rescue => e
        puts "YAML Exception reading #filename: #{e.message}"
      end
      # convert all keys to symbol
      demotion_level = 0
      if @metadata
      	@metadata = @metadata[0] if @metadata.class == Array
      	@metadata=Hash[@metadata.map{ |k, v| [k.to_sym, v] }]
      	demotion_level = @metadata.fetch(:demote, 0).to_i
      end
      paragraphs = markdown_to_para_data(@story_markdown, :demotion_level=>demotion_level)
      @story_hash = {:heading=>@metadata, :paragraphs=>paragraphs}
    end

  end

end
