
module RLayout
  PILLAR_START = /PILLAR|pillar|글기둥/
  ARTICLE_START = /^#\s/

  class NewsPageParser
    attr_reader :page_md_path, :project_path, :md_file, :page_number
    attr_reader :filtered_metadata
    attr_reader :page_map
    attr_reader :ad_type
    attr_reader :section_name

    def initialize(options={})
      @page_md_path = options[:page_md_path]
      if options[project_path]
        @project_path = options[project_path]
        @md_file_path = Dir.glob("#{@project_path}/*.md").first
      elsif options[:page_md_path]
        @md_file_path = options[:page_md_path]
        @project_path = File.dirname(@md_file_path)
      end
      @section_name = options[:section_name] || "1면"
      @page_number = File.basename(@md_file_path, '.md')
      parse_newspage_md
      update_page_layout
      self
    end
    
    def build_folder
      @project_path + "/#{@page_number.to_s.rjust(2,'0')}"
    end

    def publication_path
      File.dirname(@project_path)
    end

    def publication_info_path
      @publication_path + "/publication_info.yml"
    end

    def issue_info_path
      @project_path + "/issue_info.yml"
    end

    # parse newspage.md and create article folders and save it as story.md 
    def parse_newspage_md
      source = File.open(@md_file_path, 'r'){|f| f.read}
      begin
        if (md = source.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m))
          @contents = md.post_match
          @metadata = YAML.load(md.to_s)
          # filter smart quptes and stuff
          # RubyPants filters yaml marker --- so, filter heading after YAML is parsed 
          @filtered_metadata = {}
          @metadata = @metadata.each do |k, v|
            next if k == 'demotion'
            @filtered_metadata[k] = RubyPants.new(v).to_html if v
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
      @current_pillar_folder = build_folder + "/pilar_#{@pillar_order.to_s.rjust(2,'0')}"
      # @current_doc_foler = build_folder
      FileUtils.mkdir_p(@current_pillar_folder) unless File.exist?(@current_pillar_folder)

      while lines_block = text_blocks.shift do
        first_line = lines_block[0]
        if first_line =~ PILLAR_START
          @pillar_order += 1
          @article_order = 1
          @current_pillar_folder = build_folder + "/pilar_#{@pillar_order.to_s.rjust(2,'0')}"
          FileUtils.mkdir_p(@current_pillar_folder) unless File.exist?(@current_pillar_folder)
        elsif first_line=~ARTICLE_START
          # save current article
          article_doc = ""
          while lines_block = text_blocks.shift do
            first_line = lines_block[0]
            if first_line =~ARTICLE_START 
              # TODO handle cut, over, drop case
              
              article_folder =  @current_pillar_folder + "/article_#{@article_order.to_s.rjust(1,'0')}"
              FileUtils.mkdir_p(article_folder) unless File.exist?(article_folder)
              doc_path =  article_folder + "/story.md"
              File.open(doc_path, 'w'){|f| f.write article_doc}
              text_blocks.unshift(lines_block)
              @article_order += 1
              break
            elsif first_line =~PILLAR_START
              text_blocks.unshift(lines_block)
              break
            else
              article_doc += "\n\n" + lines_block.join("\n")
            end
          end
        end
      end
    end

    # update layout_rb for each article by pillar
    def update_page_layout
      @page_map = []
      Dir.glob("#{build_folder}/project*").each_with_index do |pillar_folder, i|
        pill_array  = []
        @page_map << pill_array
        parse_pillar_article_folders(pillar_folder, i)
      end
    end

    def parse_pillar_article_folders(pillar_folder, pillar_index)
      articles = Dir.glob("#{pillar_folder}/article*")
      @page_map[pillar_index] << articles
    end

    def update_config

    end

    def default_publication_hash
      h = {}
      h[:page_heading_margin_in_lines] = 3
      h[:lines_per_grid] = 7
      h[:width] = 1114.015
      h[:height] = 1544.881
      h[:left_margin] = 42.519
      h[:top_margin] = 42.519
      h[:right_margin] = 42.519
      h[:bottom_margin] = 42.519
      h[:gutter] = 12.755
      h
    end

    def default_page_config_hash
      h = {}
      h[:section_name] = @section_name || '1면'
      h[:ad_type] = '5단통'
      h[:pillar_map] = [[4,2],[2,3]] # [column_count, article_count]
      h[:draw_divider] = false
      h

    end

    def self.save_sample_newspage(path)
      File.open(path, 'w'){|f| f.write NewsPageParser.sample_newspage}
    end

    # create sample page.md file from current_folder
    def create_sample_pagemd_from_page_folder(page_path)
      page_config_path = page_path + "/config.yml"
      config_hash = YAML::load_file(page_config_path)
      pillar_map = config_hash[:pillar_map]




    end

    def self.sample_newspage
      <<~EOF

      ---

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