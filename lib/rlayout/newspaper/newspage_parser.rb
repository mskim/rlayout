
module RLayout
  PILLAR_START = /PILLAE|pillar|글기둥/
  ARTICLE_START = /^#\s/

  class NewspageParser
    attr_reader :project_path, :md_file, :page_number

    def initialize(options={})
      @page_number = options[:page_number] || 1
      if options[project_path]
        @project_path = options[project_path]
        @md_file_path = Dir.glob("#{@project_path}/*.md").first
      elsif options[:article_path]
        @md_file_path = options[:article_path]
        @project_path = File.dirname(@md_file_path)
      end

      newspage_md2articles
      self
    end
    
    def build_folder
      @project_path + "/page_#{@page_number.to_s.rjust(2,'0')}"
    end

    def book_info_path
      @project_path + "/book_info.yml"
    end


    # parse newspage.md and create article folders and save it as story.md 
    def newspage_md2articles
      source = File.open(@md_file_path, 'r'){|f| f.read}
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

      reader = RLayout::Reader.new @contents, nil
      text_blocks = reader.text_blocks.dup
      @pillar_order = 1
      @article_order = 1
      @current_doc_foler = build_folder
      while lines_block = text_blocks.shift do
        first_line = lines_block[0]
        if first_line =~ PILLAR_START
          @current_pillar_folder = build_folder + "/part_#{@pillar_order.to_s.rjust(2,'0')}"
          FileUtils.mkdir_p(@current_pillar_folder) unless File.exist?(@current_pillar_folder)
          @current_doc_foler = @current_pillar_folder
          @pillar_order += 1
          @article_order = 1
        elsif first_line=~ARTICLE_START
          # save current article
          article_doc = ""
          while lines_block = text_blocks.shift do
            first_line = lines_block[0]
            if first_line =~PILLAR_START || first_line =~ARTICLE_START
              chapter_folder =  @current_doc_foler + "/article_#{@pillar_order.to_s.rjust(1,'0')}_#{@article_order.to_s.rjust(2,'0')}"
              FileUtils.mkdir_p(chapter_folder) unless File.exist?(chapter_folder)
              doc_path =  chapter_folder + "/story.md"
              File.open(doc_path, 'w'){|f| f.write article_doc}
              text_blocks.unshift(lines_block)
              @article_order += 1
              break
            else
              article_doc += "\n\n" + lines_block.join("\n")
            end
          end
        end
      end
    end

    def self.save_sample_newspage(path)
      File.open(path, 'w'){|f| f.write NewspageParser.sample_newspage}
    end

    def self.sample_newspage
      <<~EOF

      ---
      date: Book Title Here
      page_number: 1
      section: FrontPage

      ---

      # article

      ---
      title: Book Title Here
      subtitle: Book Subitle Here
      reporter: Gil Dong Hong
      ---

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


      # article

      ---
      title: Book Title Here
      subtitle: Book Subitle Here
      reporter: Gil Dong Hong
      ---

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


      # article

      ---
      title: Book Title Here
      subtitle: Book Subitle Here
      reporter: Gil Dong Hong
      ---

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


      # article

      ---
      title: Book Title Here
      subtitle: Book Subitle Here
      reporter: Gil Dong Hong
      ---

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

 
      # article

      ---
      title: Book Title Here
      subtitle: Book Subitle Here
      reporter: Gil Dong Hong
      ---

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