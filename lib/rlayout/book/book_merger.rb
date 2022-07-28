module RLayout

  # merge book directory into a single book.md file.

  class BookMerger
    attr_reader :project_path

    def initialize(options={})
      @project_path = options[:project_path]
      merge_front_matter
      merge_body_matter
      merge_rear_matter
      save_merged_story
      self
    end

    def book_info_path
      @project_path + "/book_info.yml"
    end

    def front_matter_path
      @project_path + "/front_matter"
    end

    def rear_matter_path
      @project_path + "/rear_matter"
    end

    def book_info_yaml
      File.open(book_info_path, 'r'){|f| f.read}
    end
    
    def merge_front_matter
      @merged_story = book_info_yaml
      @merged_story += "\n
      Dir.glob("#{front_matter_path}/**").each do |folder|
        doc_type = File.basename(folder).split("_")[1]
        story_path = folder + "/story.md"
        @merged_story += "# #{doc_type}:\n\n"
        if  File.exist?(story_path)
          @merged_story += File.open(story_path, 'r'){|f| f.read}
          @merged_story += "\n"
        end
      end
    end

    def merge_body_matter
      Dir.glob("#{@project_path}/**").grep(/\d\d$/).each do |folder|
        if File.basename(folder) =~/^part/
          # handle part folder 
          # add part text 
          @merged_story += "# part\n"
          Dir.glob("#{folder}/*").grep(/\d\d/).each do |article_path|
            story_path = article_path + "/story.md"
            @merged_story += "# chapter\n"
            @merged_story += File.open(story_path, 'r'){|f| f.read}
          end
        elsif folder =~/\d\d$/
          # handle first level chapter folders
          story_path = folder + "/story.md"
          @merged_story += "# chapter\n\n"
          if File.exist?(story_path)
            story_source = File.open(story_path, 'r'){|f| f.read}
            story_heading, story_body = RLayout::Story.heading_and_boby(story_source)
            @merged_story += story_heading[:title] + "\n\n"
            @merged_story += story_body
          else
            puts "No story found: #{story_path}!!!"
          end
        end
      end
    end

    def merge_rear_matter
      puts __method__
    end

    def book_md_path
      @project_path + "/book.md"
    end

    def save_merged_story
      File.open(book_md_path, 'w'){|f| f.write @merged_story}
    end

  end

end