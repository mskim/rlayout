module RLayout
  # PART_START = /PART|part|파트/
  # DOC_START  start of chapter or new pdf_document
  # DOC_START = /^#\s/
  # FRONT_MATTER_TYPE = /prologue|thanks|dedication/
  # REAR_MATTER_TYPE = /appendix|index/

  class BodyParser
    attr_reader :project_path
    # attr_reader :docs, :md_file
    attr_reader :part_titles
    def initialize(md_file)
      @md_file = md_file
      @project_path = File.dirname(@md_file)
      body_md2docs
      self
    end

    def bookfile_path
      @md_file
    end
    
    def build_folder
      @project_path + "/_build"
    end

    def book_info_path
      @project_path + "/book_info.yml"
    end

    def book_cover_folder
      build_folder + "/book_cover"
    end

    def front_matter_folder
      build_folder + "/front_matter"
    end

    def self.push_to_github
      BookPlan.create_github_repo(project_path)
    end

    #read body.md and convert it to StyeleableDoc format
    def body_md2docs
      source = File.open(bookfile_path, 'r'){|f| f.read}
      begin
        if (md = source.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m))
          @contents = md.post_match
          @metadata = YAML.load(md.to_s)
          # filter smart quptes and stuff
          # RubyPants filters yaml marker --- so, filter heading after YAML is parsed 
          @updated_metadata = {}
          @metadata = @metadata.each do |k, v|
            next if k == 'demotion'
            @updated_metadata[k] = RubyPants.new(v).to_html if v
          end
          starting_heading_level += @metadata['demotion'].to_i if @metadata['demotion']
        else
          @contents = source
        end
        @contents = RubyPants.new(@contents).to_html if @contents
      rescue => e
        puts "YAML Exception reading #filename: #{e.message}"
      end
      update_book_info(@updated_metadata)
      reader = RLayout::Reader.new @contents, nil
      text_blocks = reader.text_blocks.dup
      @part_titles = []
      @front_matter_order = 1
      @part_order = 1
      @chapter_order = 1
      @rear_matter_order = 0
      @current_doc_foler = build_folder
      while lines_block = text_blocks.shift do
        first_line = lines_block[0]
        if first_line =~PART_START
          @current_part_folder = build_folder + "/part_#{@part_order.to_s.rjust(2,'0')}"
          FileUtils.mkdir_p(@current_part_folder) unless File.exist?(@current_part_folder)
          @current_doc_foler = @current_part_folder
          part_cover_foler = @current_doc_foler + "/00_part_cover"
          FileUtils.mkdir_p(part_cover_foler) unless File.exist?(part_cover_foler)
          @part_order += 1
          part_title = first_line.split(":")[1] || ""
          @part_titles << part_title
          @chapter_order = 1
        elsif first_line=~DOC_START
          @doc_type = 'chapter'
          @title = first_line.split("# ")[1]
          # save current doc
          chapter_doc =<<~EOF
          ---
          doc_type: chapter
          title: #{@title}
          ---

          EOF
          while lines_block = text_blocks.shift do
            first_line = lines_block[0]
            if first_line =~PART_START || first_line =~DOC_START
              chapter_folder =  @current_doc_foler + "/#{@chapter_order.to_s.rjust(2,'0')}_chapter"
              FileUtils.mkdir_p(chapter_folder) unless File.exist?(chapter_folder)
              doc_path =  chapter_folder + "/story.md"
              File.open(doc_path, 'w'){|f| f.write chapter_doc}
              text_blocks.unshift(lines_block)
              @chapter_order += 1
              break
            else
              chapter_doc += "\n\n" + lines_block.join("\n")
            end
          end

          # save unsaved chapter_doc
          # check if initial chapter_doc content was changed
          if chapter_doc.split("\n").length > 4
            chapter_folder =  @current_doc_foler + "/#{@chapter_order.to_s.rjust(2,'0')}_chapter"
            FileUtils.mkdir_p(chapter_folder) unless File.exist?(chapter_folder)
            doc_path =  chapter_folder + "/story.md"
            File.open(doc_path, 'w'){|f| f.write chapter_doc}
            text_blocks.unshift(lines_block)
            @chapter_order += 1
          end

        end

      end
      update_part_titles if @part_titles.length > 0
    end


    
    def update_book_info(book_info)
      if File.exist?(book_info_path)
        # book_info = YAML::load_file(book_info_path)
      else
       File.open(book_info_path, 'w'){|f| f.write book_info.to_yaml}
      end
    end
    # update book_info part
    def update_part_titles
      book_info = YAML::load_file(book_info_path)
      book_info['part'] = @part_titles
      File.open(book_info_path, 'w'){|f| f.write book_info.to_yaml}
    end

    def self.save_sample(path)
      File.open(path, 'w'){|f| f.write BodyParser.sample_book_md}
    end

    def self.sample_paragraph
      <<~EOF
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      EOF
    end

    def self.sample_book_md
      <<~EOF

      ---
      title: Book Title Here
      subtitle: Book Subitle Here
      author: Gil Dong Hong

      ---


      # chapter1 title

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      # chapter2 title

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      # chapter3 title

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      # chapter4 title

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      EOF
    end

    def self.save_sample_front_matter_doc(path)
      File.open(path, 'w'){|f| f.write BodyParser.sample_front_matter_doc}
    end

    def self.sample_front_matter_doc
        <<~EOF
  
        # prologue: Prologue
  
        This is body text. This is body text. This is body text. 
        This is body text. This is body text. This is body text. 
        This is body text. This is body text. This is body text. 
        This is body text. This is body text. This is body text. 
        This is body text. 
  
        This is body text. This is body text. This is body text. 
        This is body text. This is body text. This is body text. 
        This is body text. This is body text. This is body text. 
        This is body text. This is body text. This is body text. 
        This is body text. 

        EOF
    end

    def self.save_sample_with_part(path)
      File.open(path, 'w'){|f| f.write BodyParser.sample_with_part}
    end

    def self.sample_with_part
      <<~EOF

      ---
      title: Book Title Here
      subtitle: Book Subitle Here
      author: Gil Dong Hong

      ---


      PART_1

      # chapter1 title

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      # chapter2 title

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      # chapter3 title

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      # chapter4 title

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      PART_2

      # chapter1 title

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      # chapter2 title

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      # chapter3 title


      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      # chapter4 title

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 

      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. This is body text. This is body text. 
      This is body text. 



      EOF
    end


  end



end