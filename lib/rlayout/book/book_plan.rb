module RLayout
  class BookPlan
    attr_reader :project_path
    def initialize(project_path, options={})
      @project_path =  project_path
      File.open(book_info_path, 'w'){|f| f.write sample_book_info}
      File.open(book_plan_path, 'w'){|f| f.write sample_book_plan}
      self
    end

    def self.create_book(project_path)
      RLayout::BookPlan.new(project_path)
      RLayout::BookPlan.parse(project_path)
    end

    def self.parse(project_path)
      plan_path = project_path + "/book_plan.md"
      File.open(plan_path, 'r'){|f| f.read}
      book_plsn2docs(plan_path)
    end

    def book_plan_path
      @project_path + "/book_plan.md"
    end

    def book_info_path
      @project_path + "/book_info.yml"
    end

    def sample_book_info
      <<~EOF
      ---
      title: Docker Book
      subtitle: How Docker is used in BookCheeGo
      author: Min Soo Kim
      publisher: Tech Books for the Rest
      paper_size: A4
      ---
           
      EOF
    end

    def sample_book_plan_yml
      <<~EOF
      ---
      book_info:
        title: Bookcheego
        subtitle: Bookcheego
        author: Min Soo Kim
        paper_size: A4
      book_cover:
        front_wing: author_bio
        back_wing: book_promo
      front_matter:
        - inside_cover: true
        - inside_cover: true
        - isbn: true
        - prologue: true
      body_matter:
        - 01: History  
        - 02: Problem?
        - 03: How to to solve the problem
        - 04: Expected outcome 
        - 04: Getting Started 
      ---
    end

    def sample_book_plan
      <<~EOF
      ---
      title: How to use Docker
      subtitle: Docker will change the way you developent!
      author: Min Soo Kim
      github_repo: mskim/how-to-use-docker

      ---

      # front_wing: author_proflie
      
      # back_wing: book_promo
            
      # isbn:
      
      # inside_cover:
      
      # dedication: 이책을 사랑하는 아내와 가족글에게 바침니다.
      
      # thanks: 감사의 글
      
      # prologue: 이글을 쓰면서
            
      # What is Docker?
      
      # Installing Docker
      
      # Using BookCheeGo with Docker
      
      # Creating Paperback
      
      # Creating Poetry Book
      
      EOF
    end

    def sample_rakefile
      <<~EOF

      require 'rlayout'
      require 'debug'
      
      
      task :default => [:generate_book]
      
      desc 'generate book pdf, ebook'
      task :generate_book do
        puts "generate_book"
        RLayout::BookPlan.new(File.dirname(__FILE__))
      end

      desc 'generate book structure'
      task :generate_files do
        puts "generate book structure"
        RLayout::BookParser.new(File.dirname(__FILE__) + "/book_plan.md)
      end

      EOF
    end

    def sample_github_action
      <<~EOF
      name: Deploy to GitHub pages

      on:
        push:
          branches:
            - main
      
      jobs:
        deploy:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v2
      
            - name: Setup Ruby
              uses: ruby/setup-ruby@v1
              with:
                bundler-cache: true
      
            - name: Setup Node
              uses: actions/setup-node@v2
              with:
                node-version: "16"
                cache: "yarn"
            - run: yarn install
      
            - name: Build
              run: bin/bridgetown deploy
      
            - name: Deploy
              uses: peaceiris/actions-gh-pages@v3
              with:
                github_token: ${{ secrets.GITHUB_TOKEN }}
                publish_dir: ./_ebook
      
      EOF
    end
    #read bookfile.md and convert it to StyeleableDoc format
    def book_plsn2docs
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
      save_book_info(@updated_metadata)  
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
          if first_line =~/:/
            @doc_type = first_line.split(":")[0].split("# ")[1]
          else
            @doc_type = 'chapter'
          end
          if first_line=~FRONT_MATTER_TYPE
            @title = first_line.split(":")[1]
            # save current doc
            front_matter_order_string = @front_matter_order.to_s.rjust(2,'0')
            @front_matter_doc_foler = front_matter_folder + "/#{front_matter_order_string}_#{@doc_type}"
            FileUtils.mkdir_p(@front_matter_doc_foler) unless File.exist?(@front_matter_doc_foler)
            @front_matter_order += 1
            front_matter_doc =<<~EOF
            ---
            doc_type: #{@doc_type}
            title: #{@title}
            ---

            EOF
            while lines_block = text_blocks.shift do
              first_line = lines_block[0]
              if first_line =~PART_START || first_line =~DOC_START
                doc_path =  @front_matter_doc_foler + "/story.md"
                File.open(doc_path, 'w'){|f| f.write front_matter_doc}
                text_blocks.unshift(lines_block)
                break
              else
                front_matter_doc += "\n\n" + lines_block.join("\n")
              end
            end
            
          elsif first_line=~REAR_MATTER_TYPE

            file_path = rear_matter_folder + "/#{doc_type}"
            @rear_matter_order += 1
          else # this is a body doc 
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
          end
        end

      end
      update_part_titles if @part_titles.length > 0
    end

    def save_book_info(book_info)
      File.open(book_info_path, 'w'){|f| f.write book_info}
    end
  end
end