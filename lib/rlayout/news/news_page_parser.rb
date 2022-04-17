
module RLayout
  PILLAR_START = /PILLAR|pillar|글기둥/
  ARTICLE_START = /^#\s/

  # NewsPageParser
  # Parse data_page.md into folder structure
  # example:   
  # with 2022-0419_1.md a file with 2 pillar data
  # create folder 2022-0419/
  #   01/01
  #     /02
  #   02/01
  #     /02
  #     /03
  #   config.yml
  
  #   config.yml
  #
  class NewsPageParser
    attr_reader :project_path, :page_md_path, :md_file_path, :page_number
    attr_reader :filtered_metadata
    attr_reader :page_map
    attr_reader :ad_type
    attr_reader :section_name

    def initialize(options={})
      @project_path = options[:project_path]
      @date = options[:date]
      @page_number = options[:page_number]
      @md_file_path = @project_path + "/#{@date}_#{@page_number.to_s.rjust(2,'0')}.md"
      @basename = File.basename(@md_file_path, '.md')
      # @date = @basename.split("_")[0]
      # @page_number = @basename.split("_")[1].to_i
      @build_folder = @project_path + "/#{@date}/#{@page_number.to_s.rjust(2,'0')}"
      FileUtils.mkdir_p(@build_folder) unless File.exist?(@build_folder)
      if options[:merge_story]
        # merge edited stoies back to page source markdown file. 
        merge_story
      else
        parse_newspage_md 
      end
      self
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
          @section_name = @filtered_metadata[:section_name] || '1면'
          @pillar_width_array = @filtered_metadata[:pillar_width] || [6]
          @ad_type = @filtered_metadata[:ad_type] || '5단통'
          starting_heading_level += @metadata['demotion'].to_i if @metadata['demotion']
        else
          @contents = source
        end
        @contents = @contents if @contents
      rescue => e
        puts "YAML Exception reading #filename: #{e.message}"
      end

      reader = RLayout::Reader.new @contents, nil
      text_blocks = reader.text_blocks.dup

      # divide text block by pillar



      @pillar_order = 1
      @article_order = 1
      @current_pillar_folder = @build_folder + "/#{@pillar_order.to_s.rjust(2,'0')}"
      # @current_doc_foler = @build_folder
      @article_folder =  @current_pillar_folder + "/#{@article_order.to_s.rjust(2,'0')}"

      FileUtils.mkdir_p(@current_pillar_folder) unless File.exist?(@current_pillar_folder)
      @article_doc = ""
      while lines_block = text_blocks.shift do
        first_line = lines_block[0]
        if first_line =~ PILLAR_START
          if @article_doc != ""
            doc_path =  @article_folder + "/story.md"
            FileUtils.mkdir_p(@article_folder) unless File.exist?(@article_folder)
            File.open(doc_path, 'w'){|f| f.write @article_doc}
            @article_doc = ""
          end
          @current_pillar_folder = @build_folder + "/#{@pillar_order.to_s.rjust(2,'0')}"
          FileUtils.mkdir_p(@current_pillar_folder) unless File.exist?(@current_pillar_folder)
          @pillar_order += 1
          @article_order = 1
        elsif first_line=~ARTICLE_START
          # save current article
          @article_doc = ""
          while lines_block = text_blocks.shift do
            first_line = lines_block[0]
            if first_line =~ARTICLE_START 
              # TODO handle cut, over, drop case
              
              @article_folder =  @current_pillar_folder + "/#{@article_order.to_s.rjust(2,'0')}"
              FileUtils.mkdir_p(@article_folder) unless File.exist?(@article_folder)
              doc_path =  @article_folder + "/story.md"
              File.open(doc_path, 'w'){|f| f.write @article_doc}
              @article_doc = ""
              text_blocks.unshift(lines_block)
              @article_order += 1
              @article_folder =  @current_pillar_folder + "/#{@article_order.to_s.rjust(2,'0')}"

              break
            elsif first_line =~PILLAR_START
              if @article_doc != ""
                doc_path =  @article_folder + "/story.md"
                FileUtils.mkdir_p(@article_folder) unless File.exist?(@article_folder)
                File.open(doc_path, 'w'){|f| f.write @article_doc}
                @article_doc = ""
              end
              text_blocks.unshift(lines_block)
              break
            else
              @article_doc += "\n\n" + lines_block.join("\n")
            end
          end
        end
        if @article_doc != ""
          doc_path =  @article_folder + "/story.md"
          FileUtils.mkdir_p(@article_folder) unless File.exist?(@article_folder)
          File.open(doc_path, 'w'){|f| f.write @article_doc}
          @article_doc = ""
        end
      end
    end

    # create sample page.md file from current_folder
    def create_sample_pagemd_from_page_folder(page_path)
      page_config_path = page_path + "/config.yml"
      config_hash = YAML::load_file(page_config_path)
      pillar_map = config_hash[:pillar_map]
    end

    def layout_options
      h = {}
      h[:adjustable_height] = false
      h[:subtitle_type] = "1단"
      h[:page_number] = 1
      h[:column] = 5
      h[:row] = 5
      
    end


    def layout_template
      <<~EOF
      RLayout::NewsArticleBox.new({:adjustable_height=>false, :subtitle_type=>"1단", :page_number=>1, :column=>5, :row=>5, :height_in_lines=>35, :grid_width=>146.99662542182026, :grid_height=>97.32283464566795, :gutter=>12.755905511810848, :on_left_edge=>true, :on_right_edge=>false, :is_front_page=>true, :top_story=>true, :top_position=>false, :bottom_article=>false, :article_bottom_space_in_lines=>2, :article_line_thickness=>0.3, :article_line_draw_sides=>[0, 1, 0, 1], :draw_divider=>false}) do
      end
      EOF
    end

    def self.save_sample_newspage(publication_path, date, page_number)
      path = "#{publication_path}/#{date}_#{page_number.to_s.rjust(2,'0').md}"
      File.open(path, 'w'){|f| f.write NewsPageParser.sample_newspage_of_pillar_count(2)}
    end

    def self.sample_news_page
      <<~EOF

      ---

      section: FrontPage

      ---


      # article

      ---
      title: Russia invades Ukraine
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

    def merge_story
      @page_story =@page_config_yaml
      pillars = @page_config[:pillar_map]
      pillars.each_with_index do |pillar, pillar_index|
        @page_story += "\n\npillar\n\n"
        pillar.each do |article_path|
          article_story_path = article_path + "/story.md"
          article_story = File.open(article_story_path, 'r'){|f| f.read}
          @page_story += "# article\n"
          @page_story += article_story + "\n"
        end
      end
      # save it to page story source
      File.open(md_file_path, 'w'){|f| f.write @page_story}
    end
    
  end



end