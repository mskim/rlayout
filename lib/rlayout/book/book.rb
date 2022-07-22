
module RLayout

  # book creating workflow
  # make sure we have necessay into for the book
  # put width, height, margins, body_line_count,
  # are must have into, do put them in book_info hash


  # 1. if there are no book_info.yml nor book_plan.md in the project folder,
  # this is fresh folder, so create book_plan.md and book_info.md and return
  
  # 2. After intial book_plan.md is created, user should edit and update the content of book_plan.md and book_info.yml,
  
  # 3. if project folder has book_plan.md, assum it is edited and should parse book_plan.md and create book_cover, front_matter folder, and chapters,
  # as 01_chapter, 02_chapter, 03_chapter,
  
  # 4. if chapter folders, starting with 01 are present
  # should update contents to _build and re-generate pdfs etc ...
  # 
  class Book
    attr_reader :book_type, :body_doc_type, :project_path
    attr_reader :book_info, :paper_size, :width, :height
    attr_reader :left_margin, :top_margin, :right_margin, :bottom_margin
    attr_reader :width_mm, :height_mm, :left_margin_mm, :top_margin_mm, :right_margin_mm, :bottom_margin_mm, :binding_margin_mm
    attr_reader :body_line_count
    attr_reader :has_cover_inside_page, :has_wing, :has_toc, :has_part
    attr_reader :book_toc, :body_matter_toc, :rear_matter_toc, :starting_page_number
    attr_reader :rear_matter_docs, :ebook_page_contents
    attr_reader :toc_folder, :toc_first_page_number, :toc_page_count, :toc_page_links
    attr_reader :front_matter, :body_matter, :rear_matter
    attr_reader :gripper_margin, :bleed_margin, :binding_margin
    attr_reader :html
    attr_reader :ebook, :pdf_book, :print_book

    def initialize(project_path, options={})
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_md_path = @project_path + "/book.md"
      @book_txt_path = @project_path + "/book.txt"
      @ebook = options[:ebook]  || false
      @pdf_book = options[:pdf_book]  || false
      @print_book = options[:pdf_book]  || true
      unless File.exist?(@book_info_path)
        @book_info = YAML::load(default_book_info)
        save_default_book_info
      else
        @book_info = YAML::load_file(@book_info_path)
        @book_info = Hash[@book_info.map{ |k, v| [k.to_sym, v] }]
      end
      update_book_info_unit
      unless File.exist?(@book_md_path)
        save_sample_book_md
      end
      @toc_page_count = @book_info[:toc_page_count] || 2
      @book_title = @book_info[:book_title] || @book_info[:title] || 'untitled'
      @starting_page_number = 1
      @gripper_margin = options[:gripper_margin] || 10*2.834646
      @bleed_margin = options[:bleed_margin] || 3*2.834646
      @book_info[:jpg] = @ebook
      @parser = BookParserMd.new(@project_path)
      @toc_folder = @parser.toc_folder
      create_book_cover
      @starting_page_number  = 1
      @front_matter = FrontMatter.new(@project_path, @starting_page_number, @book_info)
      @starting_page_number = @front_matter.starting_page_number
      @body_matter = BodyMatter.new(@project_path, @starting_page_number, @book_info )
      @rear_matter = RearMatter.new(@project_path, @starting_page_number, @book_info )
      generate_toc
      # generate_body_pdf
      generate_pdf_book if @pdf_book
      generate_pdf_for_print if @print_book
      generate_ebook if @ebook
    end

    # make sure dimensionare in point setup is corrent
    # convert inits from mm to points
    def update_book_info_unit
      set_width_and_height_from_paper_size
      @book_info = Hash[@book_info.map{ |k, v| [k, mm_string2pt(v)] }]
      @width = @book_info[:width]
      @height = @book_info[:height]
      @binding_margin = @book_info[:binding_margin] || 3*2.834646
    end

    def mm_string2pt(value)
      return value if value.class == Integer
      return value if value.class == Float
      # return value if value.include?("x")
      return value unless value.include?("mm")
      RLayout::mm2pt(value.sub("mm","").to_i)
    end

    def set_width_and_height_from_paper_size
      @paper_size = @book_info[:paper_size] || @book_info['paper_size']
      if SIZES[@paper_size]
        @width = SIZES[@paper_size][0]
        @height = SIZES[@paper_size][1]
      elsif @paper_size && @paper_size.downcase.include?("x")
        paper_size_array = @paper_size.split("x")
        width_string = paper_size_array[0]
        height_string = paper_size_array[1]
        if width_string.include?("mm")
          @width_mm = width_string
          @width = RLayout::mm2pt(width_string.sub("mm","").to_f)
          @book_info[:width] = @width
        end
        if height_string.include?("mm")
          @width_mm = height_string
          @height =RLayout::mm2pt(height_string.sub("mm","").to_f)
          @book_info[:height] = @height
        end
      end
    end

    def self.book_template_path
      File.dirname(__FILE__) + "/book_template/paperback"
    end

    def first_chapter_folder
      @project_path + "/01"
    end

    def source_front_matter_path
      @project_path + "/front_matter"
    end

    def source_front_md_path
      @project_path + "/front.md"
    end

    def source_body_md_path
      @project_path + "/body.md"
    end

    def source_rear_md_path
      @project_path + "/rear.md"
    end

    def style_guide_folder
      @project_path +  "/style_guide"
    end

    def style_guide_folder_for_toc
      @project_path + "/style_guide/toc"
    end

    def toc_first_page_number
      @front_matter.toc_first_page_number
    end    

    def build_folder
      @project_path + "/_build"
    end
  
    def source_book_cover_path
      @project_path + "/book_cover"
    end
   
    def build_book_cover_path
      build_folder + "/book_cover"
    end

    def parse_book_source
      parse_front_matter
      parse_body_matter
      parse_rear_matter
    end

    def parse_front_matter
      if File.exist?(source_front_md_path)
        RLayout::BodyParser.new(source_front_md_path)
      else
        FileUtils.mkdir_p(build_front_matter_path) unless File.exist?(build_front_matter_path)
        return unless File.exist?(source_front_matter_path)
        Dir.glob("#{source_front_matter_path}/*").sort.each do |file|
          # copy source to build 
          if file =~/isbn$/
              isbn_path = build_front_matter_path + "/isbn"
              copy_source_to_build(file, isbn_path)
          elsif file =~/inside_cover$/
              inside_cover_path = build_front_matter_path + "/inside_cover"
              copy_source_to_build(file, inside_cover_path)
          elsif file =~/dedication$/
              dedication_path = build_front_matter_path + "/dedication"
              copy_source_to_build(file, dedication_path)
          elsif file =~/thanks$/
              thanks_path = build_front_matter_path + "/thanks"
              copy_source_to_build(file, thanks_path)
          elsif file =~/prologue$/
              prologue_path = build_front_matter_path + "/prologue"
              copy_source_to_build(file, prologue_path)
          elsif file =~/toc$/
              toc_path = build_front_matter_path + "/toc"
              copy_source_to_build(file, toc_path)
              @has_toc = true
          end
        end
      end
    end

    # copy front_matter source file or folder to _build
    def copy_source_to_build(source_path, destination_path)
      FileUtils.mkdir_p(destination_path) unless File.exist?(destination_path)
      source_full_path = source_front_matter_path + "/#{source_path}"
      story_md_destination_path = destination_path + "/story.md"
      if File.directory?(source_full_path)
        if Dir.glob("#{source_full_path}/*.md").length == 0
          # handle case when there is no .md file
          # save sample story.md file
          sample_story  = sample_front_matter_story(source_path)
          source_full_story_path = source_full_path + "/story.md"
          File.open(source_full_story_path, 'w'){|f| f.write sample_story}
          File.open(story_md_destination_path, 'w'){|f| f.write sample_story}
        end

        # copy folder to build area
        system("cp -r #{source_full_path}/ #{destination_path}/")
      else
        # source is a file
        system("cp #{source_full_path} #{story_md_destination_path}")
      end
    end

    def parse_body_matter
      if File.exist?(source_body_md_path)
        RLayout::BodyParser.new(source_body_md_path)
      else
        Dir.entries(@project_path).sort.each do |file|
          # copy source to build 
          if file =~/^\d\d/
            chapter_order = file.split("_")[0]
            chapter_folder = build_folder + "/chapter_#{chapter_order}"
            FileUtils.mkdir_p(chapter_folder) unless File.exist?(chapter_folder)
            source_path = @project_path + "/#{file}"
            if File.directory?(source_path)
              # look for .md file and copy it as story.md in build
              Dir.glob("#{source_path}/*").each do |souce_folder_file|
                if File.directory?(souce_folder_file)
                  # copy images folder to build chpater folder
                  FileUtils.cp_r souce_folder_file, chapter_folder
                elsif souce_folder_file =~/.md$/
                  # if a file is .md file, rename it as story.md in build chapter folder
                  FileUtils.cp souce_folder_file, "#{chapter_folder}/story.md"
                else
                  FileUtils.cp souce_folder_file, "#{chapter_folder}"
                end
              end
              @document_folders << chapter_folder
            elsif source_path =~/[.md,.markdown]$/
              FileUtils.cp source_path, "#{chapter_folder}/story.md"
            else
              # this is case when a file starts with \d\d but not a .md file nor folder
              next
            end
          else
            next
          end
        end
      end
    end

    def parse_rear_matter
      if File.exist?(source_rear_md_path)
        RLayout::BodyParser.new(source_rear_md_path)
      else
      # TODO parse rear_matter 
      end
    end

    # do not create book_cover unless there is a source_book_cover_path
    def create_book_cover
      return unless File.exist?(source_book_cover_path)
      FileUtils.mkdir_p(build_folder) unless File.exist?(build_folder)
      RLayout::BookCover.new(project_path: build_book_cover_path, source_path: source_book_cover_path, book_info: @book_info)
    end
  
    def build_front_matter_path
      build_folder + "/front_matter"
    end

    def book_title
      @book_info[:title] || 'untitled'
    end
  
    def rear_matter_path
      @project_path + "/rear_matter"
    end
  
    def build_rear_matter_path
      build_folder + "/rear_matter"
    end
    
    ########### toc ###########
    def generate_toc
      FileUtils.mkdir_p(@toc_folder) unless File.exist?(@toc_folder)
      save_book_toc
      h = @book_info.dup
      h[:page_pdf] = true
      h[:document_path] = @toc_folder
      h[:page_pdf]      = true
      h[:page_count]      = @toc_page_count
      h[:toc_item_count] = @book_toc.length
      h[:no_table_title] = false # tells not to creat toc titl
      h[:style_guide_folder] = style_guide_folder_for_toc
      h[:width] = @width
      h[:height] = @height
      h[:left_margin] = @book_info[:left_margin]
      h[:top_margin] = @book_info[:top_margin]
      h[:right_margin] = @book_info[:right_margin]
      h[:bottom_margin] = @book_info[:bottom_margin]
      r = RLayout::Toc.new(h)
      new_page_count = r.page_count
      @toc_page_links = r.link_info
    end

    def toc_yml_path
      @toc_folder + "/toc_content.yml"
    end

    def save_book_toc
      @book_toc = []
      @book_toc += @front_matter.toc_content if @front_matter
      @book_toc += @body_matter.toc_content if @body_matter
      @book_toc += @rear_matter.toc_content if @rear_matter
      File.open(toc_yml_path, 'w'){|f| f.write @book_toc.to_yaml}
    end

    ########### assemble book ###########
    def pdf_docs_for_inner_book
      pdf_docs = []
      pdf_docs += @front_matter.pdf_docs
      pdf_docs += @body_matter.pdf_docs
      pdf_docs += @rear_matter.pdf_docs
      pdf_docs
    end

    def pdf_pages_for_inner_book
      pdf_pages = []
      pdf_pages += @front_matter.pdf_pages if @front_matter
      pdf_pages += @body_matter.pdf_pages
      pdf_pages += @rear_matter.pdf_pages if @rear_matter
      pdf_pages.flatten
      pdf_pages
    end

    def print_folder
      @project_path + "/_print"
    end

    def book_without_cover_path
      print_folder + "/pdf_without_cover.pdf"
    end

    def generate_pdf_for_print
      FileUtils.mkdir_p(print_folder) unless File.exist?(print_folder)
      copy_book_cover_pdf
      generate_inner_book_for_print
    end

    def build_book_cover_pdf_path
      build_book_cover_path + "/output.pdf"
    end

    def print_book_cover_pdf_path
      print_folder + "/book_cover.pdf"
    end

    def copy_book_cover_pdf
      FileUtils.cp(build_book_cover_pdf_path, print_book_cover_pdf_path) if File.exist?(build_book_cover_pdf_path)
    end

    def place_page_in_print_page(page_path, side)
      print_page_width = @width + @gripper_margin*2
      print_page_height = @height + @gripper_margin*2
      RLayout::PrintPage.new(page_path:page_path, side:side, width: print_page_width, height: print_page_height, gripper_margin: @gripper_margin, bleed_margin: @bleed_margin, binding_margin: @binding_margin)
    end

    def generate_inner_book_for_print
      # merge pdf files into book without cover
      # add cutting page with cutting_line, binding_margin
      # left_page  = left_print_page
      # right_page = right_printing_page
      target = HexaPDF::Document.new
      starting_page_number = 1
      flattened_pdf_files = pdf_pages_for_inner_book.flatten
      flattened_pdf_files.each do |page_path|
        if starting_page_number.odd?
          right_side_print_page = place_page_in_print_page(page_path, "right" ).first_pdf_page
          target.pages << target.import(right_side_print_page)
        else
          left_side_print_page = place_page_in_print_page(page_path, "left").first_pdf_page
          target.pages << target.import(left_side_print_page)
        end
        starting_page_number += 1
      end
      target.write(book_without_cover_path, optimize: true)
    end

    def pdf_folder
      @project_path + "/_pdf"
    end

    def pdf_book_path
      pdf_folder + "/#{book_title}.pdf"
    end

    def front_cover_1_pdf_path
      build_folder + '/book_cover/front_cover/0001/page.pdf'
    end

    def front_cover_2_pdf_path
      build_folder + '/book_cover/front_cover/0002/page.pdf'
    end

    def back_cover_1_pdf_path
      build_folder + '/book_cover/back_cover/0001/page.pdf'
    end

    def back_cover_2_pdf_path
      build_folder + '/book_cover/back_cover/0002/page.pdf'
    end

    def generate_body_pdf
      unless File.exist?(pdf_folder)
        FileUtils.mkdir_p(pdf_folder) 
      else
        target = HexaPDF::Document.new
      end
    end

    def generate_pdf_book
      unless File.exist?(pdf_folder)
        FileUtils.mkdir_p(pdf_folder) 
      else
        # clear old folder
        system("rm -rf #{pdf_folder}")
        FileUtils.mkdir_p(pdf_folder) 
      end
      target = HexaPDF::Document.new
      pdf = HexaPDF::Document.open(front_cover_1_pdf_path)
      pdf.pages.each {|page| target.pages << target.import(page)}
      if @has_no_cover_inside_page
      else
        pdf = HexaPDF::Document.open(front_cover_2_pdf_path)
        pdf.pages.each {|page| target.pages << target.import(page)}
      end
      flattened_pdf_files = pdf_pages_for_inner_book.flatten
      flattened_pdf_files.each do |page_path|
        pdf = HexaPDF::Document.open(page_path)
        pdf.pages.each {|page| target.pages << target.import(page)}
      end
      pdf = HexaPDF::Document.open(back_cover_1_pdf_path)
      pdf.pages.each {|page| target.pages << target.import(page)}
      if @has_no_cover_inside_page
      else
        pdf = HexaPDF::Document.open(back_cover_2_pdf_path)
        pdf.pages.each {|page| target.pages << target.import(page)}
      end
      target.write(pdf_book_path, optimize: true)
    end

    ################### ebook #####################
    def generate_ebook
      FileUtils.mkdir_p(site_folder) unless  File.exist?(site_folder)
      system("rm -rf #{assets_folder}")
      copy_assets
      copy_page_images_to_ebook
      create_ebook_index_page
    end

    def site_folder
      # @project_path + "/_ebook" chnage it for github pages
      @project_path + "/docs"
    end

    def ebook_template_folder
      File.dirname(__FILE__) + "/ebook_template"
    end

    def ebook_index_html_erb
      ebook_template_folder + "/ebook_index.html.erb"
    end

    def assets_folder
      site_folder + "/assets"
    end

    def ebook_assets_template_folder
      ebook_template_folder + "/assets"
    end

    def push_to_git_repo
      unless  File.exist?(site_git_repo_path)
        system "cd #{site_folder} && git init && git add . && git commit -m'initial commit' "
        system "cd #{site_folder} && git remote add origin git@github.com:mskim/mskims.github.io.git"
      end
      system "cd #{site_folder} && git add . && git commit -m'#{Time.now}' "
    end

    # copy javascript code and icons to ebook folder
    def copy_assets
      source = ebook_assets_template_folder
      target_folder = site_folder
      FileUtils.mkdir_p(target_folder) unless File.exist?(target_folder)
      system "cp -r #{source} #{target_folder}/"
    end

    def ebook_page_images_folder
      site_folder + "/assets/images"
    end

    def chapter_folders
      Dir.glob("#{build_folder}/chapter_*").sort
    end

    def build_front_cover_path
      build_book_cover_path + "/front_cover"
    end

    def build_back_cover_path
      build_book_cover_path + "/back_cover"
    end

    def r_justed_number(number)
      number.to_s.rjust(4,'0')
    end

    def copy_page_images_to_ebook
      @ebook_page_contents = ""
      target_folder = ebook_page_images_folder
      FileUtils.mkdir_p(target_folder) unless File.exist?(target_folder)
      @page_number = 1
      # front_cover
      Dir.glob("#{build_front_cover_path}/00**").sort.each do |page_folder|
        page_image = page_folder + "/page.jpg"
        target_image = target_folder + "/#{r_justed_number @page_number}.jpg"
        FileUtils.cp(page_image, target_image)
        @ebook_page_contents += page_html_for_ebook(@page_number)
        @page_number += 1
      end

      # check for @front_matter,  picture_book does not have @front_matter
      if @front_matter
        # front_matter_pages
        @front_matter.document_folders.each do |doc|
          toc_page_index = 0
          Dir.glob("#{build_front_matter_path}/#{doc}/00**").sort.each do |page_folder|
            page_image = page_folder + "/page.jpg"
            target_image = target_folder + "/#{r_justed_number @page_number}.jpg"
            FileUtils.cp(page_image, target_image)
            if doc == 'toc'
              # this page is toc page
              @ebook_page_contents += page_html_for_ebook(@page_number, toc_page:true, toc_page_index:toc_page_index)
              toc_page_index += 1
            else
              @ebook_page_contents += page_html_for_ebook(@page_number)
            end
            @page_number += 1
          end
        end
      end
      # body_matter_pages
      @body_matter.document_folders.each do |chapter|
        Dir.glob("#{chapter}/00**").sort.each do |page_folder|
          page_image = page_folder + "/page.jpg"
          target_image = target_folder + "/#{r_justed_number @page_number}.jpg"
          FileUtils.cp(page_image, target_image)
          @ebook_page_contents += page_html_for_ebook(@page_number)
          @page_number += 1      
        end
      end
      # rear_matter_pages
      if @rear_matter
        @rear_matter.rear_matter_docs.each do |doc|
          Dir.glob("#{build_rear_matter_path}/#{doc}/00**").each do |page_folder|
            page_image = page_folder + "/page.jpg"
            target_image = target_folder + "/#{r_justed_number @page_number}.jpg"
            FileUtils.cp(page_image, target_image)
            @ebook_page_contents += page_html_for_ebook(@page_number)
            @page_number += 1       
          end
        end
      end
      # back_cover
      Dir.glob("#{build_back_cover_path}/00**").sort.each do |page_folder|
        page_image = page_folder + "/page.jpg"
        target_image = target_folder + "/#{r_justed_number @page_number}.jpg"
        FileUtils.cp(page_image, target_image)
        @ebook_page_contents += page_html_for_ebook(@page_number)
        @page_number += 1
      end

      # copy cover image as loading image
      cover_page_image = target_folder + "/0001.jpg"
      loading_image = target_folder + "/loading.jpg"
      FileUtils.cp(cover_page_image, loading_image)
    end

    def ebook_index_html_container
      s=<<~EOF

        <!DOCTYPE html>
        <html lang="ko">
        <head>
        <meta charset="utf-8">
        <title><%= book_title %></title>
        <meta name="apple-mobile-web-app-title" content="<%= book_title %>"
        <meta name="generator" content="ebook">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="viewport" content="initial-scale=1.0,minimum-scale=.2,maximum-scale=1.0,user-scalable=no">
        <!-- CSS only -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous">
        <!-- JavaScript Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/js/bootstrap.bundle.min.js" integrity="sha384-ygbV9kiqUc6oa4msXn9868pTtWMgiQaeYH7/t7LECLbyPA2x65Kgf80OJFdroafW" crossorigin="anonymous"></script>
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script type="text/javascript">window.jQuery || document.write('<script src="assets/js/jquery.min.js"><\/script>')</script>
        <script type="text/javascript" src="assets/js/vmouse.min.js"></script>
        <script type="text/javascript" src="assets/js/turn.min.js"></script>
        <script type="text/javascript" src="assets/js/jquery.touchSwipe.min.js"></script>
        <script type="text/javascript" src="assets/js/ebook.config.js"></script>
        <link rel="stylesheet" href="assets/css/pages.css" media="all">
        <style media="all and (-ms-high-contrast:none)">*::-ms-backdrop, .svg-img{ width: 100%; }</style>
        <script src="http://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <style type="text/css">
          #closeBtn {
            position: absolute;
            text-align: right;
            width: 10px;
            z-index: 1;
            margin-left: 530px;
            margin-top: -15px;
          }
          #popBottom {
            height: 28px;
            text-align: left;
            font-weight: bold;
            color: #FFFFFF;
            padding-left: 10px;
            padding-right: 10px;
            cursor: move;
          }
          #drag_layer {
            position: absolute;
            width: 100%;
            height: 70vh;
            z-index: 1005;
            background-color: rgba(0,0,0,0.02);
            padding-left: 10px;
            padding-right: 10px;
            cursor: move;
            top: 5px;
          }	
        </style>
        </head>
        <body>
        <!--[if lt IE 10]>
        <p class="chromeframe">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">activate Google Chrome Frame</a> to improve your experience.</p>
        <![endif]-->
        <div id="loadIndicator"><img src="assets/images/loading.jpg" alt="loading..."/><span>&nbsp;</span></div>
        <div id="container-wrap">
        <div id="container">
        <ul class="pages flip" id="slider">

          <%= @ebook_page_contents %>

        </ul>
        <div id="prefooter" style="float: left; height: 1px;">&nbsp;</div>
        </div>
        <nav id="page-nav">
        <button id="nextBtn" name="nextBtn">&nbsp;</button>
        <button id="backBtn" name="backBtn">&nbsp;</button>
        </nav>
        </body>
        </html>

      EOF
    end

    def page_html_for_ebook(page_number, options={})
      toc_page = options[:toc_page]
      toc_page_index = options[:toc_page_index]
      template = odd_page_templage
      vertical_page = true
      @toc_page_links #contains all toc links
      static_jpg_url = "images/#{r_justed_number page_number}.jpg"
      if page_number == 1
        # template = cover_page_templage      
        template = even_page_templage      
      elsif options[:toc_page]
          template = toc_page_templage
      else
        if page_number.odd?
          template = odd_page_templage
        else
          template = even_page_templage
        end
      end
      # @toc_first_page_number = toc_first_page_number + 2
      # pdf_pages array is 0 based and page_numbers are 1 based
      @toc_first_page_number = toc_first_page_number + 1
      erb = ERB.new(template)
      r = erb.result(binding)
    end

    def cover_page_templage
      s=<<~EOF

      <li class="page" data-name="<%= page_number %>">
        <div class="page-scale-wrap mq-none mq-default" data-layout-name="undefined" <% if true %>style="width: 652px; height: 865px;"<% else %>style="width: 842px; height: 595px;"<% end %>>
          <!-- <img src="assets/images/blank.gif" class="pageItem hd" alt="Rectangle" id="itemMusicImg<%= page_number %>" data-src="assets/<%= static_jpg_url %>"/> -->
          <svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 <%= width %> <%= height %>' <% vertical_page %>style="height: 100%;"<% end %>>
            <image xlink:href='assets/<%= static_jpg_url %>' x='0' y='0' width='<%= width %>' height='<%= height %>' />
          </svg>
          <button class="pageItem fixLeftTocButton" id="itemTocButton<%= page_number %>" data-id="TocButton<%= page_number %>" name="목차 아이콘 버튼" onclick="nav.to(<%= @toc_first_page_number %>);" alt="목차 아이콘 버튼">
            <div class="pageItem state btn-off">
              <img src="assets/images/blank.gif" class="pageItem hd" alt="Rectangle" style="left: 3px !important; top: 3px !important;" id="itemTocIcon<%= page_number %>" data-src="assets/images/left_page_toc_icon.png"/>
            </div>
          </button>
        </div>
      </li>

      EOF
    end
    
    def toc_page_templage
      s=<<~EOF
      <li class="page" data-name="<%= page_number %>">
        <div class="page-scale-wrap mq-none mq-default" data-layout-name="undefined" style="width: 652px; height: 865px;">
          <!-- <img src="assets/images/blank.gif" class="pageItem hd" alt="Rectangle" id="itemMusicImg<%= page_number %>" data-src="assets/<%= static_jpg_url %>"/> -->
          <svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 <%= width %> <%= height %>' <% if vertical_page %>style="height: 100%;"<% end %>>
            <image xlink:href='assets/<%= static_jpg_url %>' x='0' y='0' width='<%= width %>' height='<%= height %>' />
            <% @toc_page_links[toc_page_index].each do |link| %>
              <rect class='rectfill' stroke='black' stroke-width='0' fill-opacity='0.0' x='<%= link[:x] %>' y='<%= link[:y] %>' width='<%= link[:width] %>' height='<%= link[:height] %>' onclick="nav.to(<%= link[:link_text].to_i + 2 %>);" />
            <% end %>
          </svg>
        </div>
      </li>


      EOF

    end

    def odd_page_templage
      s=<<~EOF

      <li class="page" data-name="<%= page_number %>">
        <div class="page-scale-wrap mq-none mq-default" data-layout-name="undefined" style="width: 652px; height: 865px;">
          <!-- <img src="assets/images/blank.gif" class="pageItem hd" alt="Rectangle" id="itemMusicImg<%= page_number %>" data-src="assets/<%= static_jpg_url %>"/> -->
          <svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 <%= width %> <%= height %>' <% if vertical_page %>style="height: 100%;"<% end %>>
            <image xlink:href='assets/<%= static_jpg_url %>' x='0' y='0' width='<%= width %>' height='<%= height %>' />
          </svg>
          <button class="pageItem fixRightTocButton" id="itemTocButton<%= page_number %>" data-id="TocButton<%= page_number %>" name="목차 <%= @toc_first_page_number %>페이지 버튼" onclick="nav.to(<%= @toc_first_page_number %>);" alt="목차 <%= @toc_first_page_number %>페이지 버튼">
            <div class="pageItem state btn-off">
              <img src="assets/images/blank.gif" class="pageItem hd" alt="Rectangle" style="left: 3px !important; top: 3px !important;" data-src="assets/images/right_page_toc_icon.png"/>
            </div>
          </button>
        </div>
      </li>
      
      EOF
    end

    def even_page_templage
      s=<<~EOF

      <li class="page" data-name="<%= page_number %>">
        <div class="page-scale-wrap mq-none mq-default" data-layout-name="undefined" style="width: 652px; height: 865px;">
          <!-- <img src="assets/images/blank.gif" class="pageItem hd" alt="Rectangle" id="itemMusicImg<%= page_number %>" data-src="assets/<%= static_jpg_url %>"/> -->
          <svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 <%= width %> <%= height %>' <% if vertical_page %>style="height: 100%;"<% end %>>
            <image xlink:href='assets/<%= static_jpg_url %>' x='0' y='0' width='<%= width %>' height='<%= height %>' />
          </svg>
          <button class="pageItem fixLeftTocButton" id="itemTocButton<%= page_number %>" data-id="TocButton<%= page_number %>" name="목차 <%= @toc_first_page_number %>페이지 버튼" onclick="nav.to(<%= @toc_first_page_number %>);" alt="목차 <%= @toc_first_page_number %>페이지 버튼">
            <div class="pageItem state btn-off">
              <img src="assets/images/blank.gif" class="pageItem hd" alt="Rectangle" style="left: 3px !important; top: 3px !important;" data-src="assets/images/left_page_toc_icon.png"/>
            </div>
          </button>
        </div>
      </li>
      
      EOF
    end

    def repo_name
      @title.gsub(" ", "_")
    end

    def static_ebook_assets_template_folder
      "#{Rails.root}/public/ebook_template/assets"
    end

    # index html with repo name
    def repo_name_ebook_index_html_path
      site_folder + "/#{repo_name}.html"
    end

    # index.html for uploading to static site service site
    def ebook_index_html_path
      site_folder + "/index.html"
    end

    def create_ebook_index_page
      width = @width
      height = @height
      vertical_page = true
      template = ebook_index_html_container #File.open(ebook_index_html_erb, 'r') { |f| f.read }
      erb = ERB.new(template)
      # @project = self
      if @front_matter
        @toc_first_page_number = @front_matter.toc_first_page_number
      else
        # for picture book which do not have toc
        1
      end
      s = erb.result(binding)
      # File.open(repo_name_ebook_index_html_path, 'w') { |f| f.write s }
      File.open(ebook_index_html_path, 'w') { |f| f.write s }
    end

    ############### header footer ####################
    ###############################################
    ############### rake tasks ####################
    def rakefile_path
      @project_path + "/Rakefile"
    end

    def rakefile_content
      s =<<~EOF
      require 'rake'
      require 'rlayout'
      
      task :default => :pdf    
      chapter_files = Dir.glob("#{File.dirname(__FILE__)}/*chapter/*{.md, .markdown}")
      
      task :pdf => chapter_files.map {|source_file| source_file.sub(File.extname(source_file), ".pdf") }
      chapter_files.each do |source|
        ext = File.extname(source_file)
        pdf_file = source_file.sub(ext, ".pdf")
        file pdf_file => source_file do
          RLayout::Chapter.new(document_path: "#{source}")  
        end
      end
      
      task :force_layout do
        chapter_files.each do |source|
          RLayout::Chapter.new(document_path: "#{source}")  
        end
      end
      
      front_files = Dir.glob("#{File.dirname(__FILE__)}/front_matter/**")
      task :layout_front do
        front_files.each do |source|
          RLayout::Chapter.new(document_path: "#{source}")  
        end
      end
      
      rear_files = Dir.glob("#{File.dirname(__FILE__)}/rear_matter/*{.md, .markdown}")
      task :layout_rear do
        rear_files.each do |source|
          RLayout::Chapter.new(document_path: "#{source}")  
        end
      end
      EOF
    end

    def save_rakefile
      File.open(rakefile_path, 'w'){|f| f.write rakefile_content}
    end

    def github_action_workflow_path
      @project_path + ".git/workflows/build_pdf"
    end
    
    def git_action_content
      s =<<~EOF
      name: build_pdf
      on: [push, pull_request]
      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v2
            - uses: ruby/setup-ruby@v1
              with:
                ruby-version: 3.0 # not needed if `.ruby-version` exists
                bundler-cache: true # runs `bundle install` and caches installed gems automatically
            - run: bundle exec rake
      EOF
    end

    def create_github_repo
      system "cd #{project_path} && git init && git add . && git commit -m'initial commit' "
      system "cd #{project_path} && gh repo create #{github_repo_name}  -y --public"
      system "cd #{project_path} && git push --set-upstream origin master"  
    end

    def project_rakefile_path
      project_path + "/Rakefile"
    end

    def rakefile_content
      s=<<~EOF
      require 'rlayout'
      # require 'pry-byebug'
      
      task :default => [:generate_book]
      
      desc 'generate book pdf, ebook'
      task :generate_book do
        project_path = File.dirname(__FILE__)
        RLayout::Book.new(project_path)
      end

      EOF
    end

    def save_rakefile
      File.open(project_rakefile_path, 'w'){|f| f.write rakefile_content}
    end

    def git_action_content_path
      project_path + "/.github/workflows/generate_pdf.yml"
    end

    def save_github_action_workflow
      File.open(git_action_content_path, 'w'){|f| f.write git_action_content}
    end

    def save_sample_book_md
      File.open(@book_md_path, 'w'){|f| f.write sample_book_md}
    end

    def save_default_book_info
      File.open(@book_info_path, 'w'){|f| f.write default_book_info}
    end

    def default_book_info
      <<~EOF
      ---
      paper_size: 125mmx188mm
      width: 125mm
      height: 188mm
      left_margin: 20mm
      top_margi: 14mm
      right_margin: 20mm
      bottom_margin: 25mm
      binding_margin: 3mm
      body_line_count: 23
      toc_page_count: 2
      title: 2022년에 책만들기
      subtitle: 새로운 솔류션을 이용하자
      author: 김민수
      EOF
    end

    def sample_book_md
      <<~EOF



      [book_info]
      ---
      paper_size: 125mmx188mm
      width: 125mm
      height: 188mm
      left_margin: 20mm
      top_margi: 14mm
      right_margin: 20mm
      bottom_margin: 25mm
      binding_margin: 3mm
      body_line_count: 23
      toc_page_count: 2
      title: 2022년에 책만들기
      subtitle: 새로운 솔류션을 이용하자
      author: 김민수
      
      # [1p-대도비라]
      
      title: 2020년에 책만들기
      
      # [2p-백]
      
      # [3p-소도비라]
      
      title: 2020년에 책만들기
      author: 김민수
      
      # [4p-백]
      
      # [5p-차례]
      
      
      # [7p- 서문] : 서문 
      
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      # [1장]: 지난 35년을 둘러보며
      
      
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 


      # [2장]: 앞으로 35년을 상상해 보며
    
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      EOF
    end

  end
end