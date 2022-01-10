module RLayout

  # 2021-11-04
  class Book
    attr_reader :project_path, :book_info, :page_width, :width, :height
    attr_reader :has_cover_inside_page, :has_wing, :has_toc
    attr_reader :book_toc, :body_matter_toc, :rear_matter_toc, :starting_page_number
    attr_reader :rear_matter_docs, :body_doc_type, :ebook_page_contents
    attr_reader :toc_first_page_number, :toc_doc_page_count, :toc_page_links
    attr_reader :front_matter, :body_matter, :rear_matter
    attr_reader :gripper_margin, :bleed_margin, :binding_margin

    def initialize(project_path, options={})
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @book_info = Hash[@book_info.map{ |k, v| [k.to_sym, v] }]
      @title = @book_info[:title]
      @paper_size = @book_info[:paper_size] || 'A5'
      @paper_size = options[:paper_size] if options[:paper_size]
      @page_width = SIZES[@paper_size][0]
      @width = @page_width
      @height = SIZES[@paper_size][1]
      @starting_page_number = 1
      @gripper_margin = options[:gripper_margin] || 1*28.34646
      @binding_margin = options[:binding_margin] || 20
      @bleed_margin = options[:bleed_margin] || 3*2.834646
      create_book_cover
      @front_matter = FrontMatter.new(@project_path)
      @starting_page_number += @front_matter.page_count
      @body_matter = BodyMatter.new(@project_path, starting_page_number: @starting_page_number, paper_size: @paper_size)
      @rear_matter = RearMatter.new(@project_path)
      generate_toc
      generate_pdf_for_print
      generate_pdf_book 
      generate_ebook unless options[:no_ebook]
      # push_to_git_repo if options[:push_to_git_repo]
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
  
    def create_book_cover
      FileUtils.mkdir_p(build_folder) unless File.exist?(build_folder)
      RLayout::BookCover.new(project_path: build_book_cover_path, source_path: source_book_cover_path, book_info: @book_info)
    end
  
    def build_front_matter_path
      build_folder + "/front_matter"
    end
  
    def book_title
      @book_info[:title] || 'untitled'
    end
  
    # def width
    #   @page_width
    # end
  
    def left_margin
      50
    end
    
    def right_margin
      50
    end
  
    def top_margin
      50
    end
  
    def bottom_margin
      50
    end
  
    def rear_matter_path
      @project_path + "/rear_matter"
    end
  
    def build_rear_matter_path
      build_folder + "/rear_matter"
    end
    
    ########### toc ###########
    def generate_toc
      FileUtils.mkdir_p(toc_folder) unless File.exist?(toc_folder)
      save_book_toc
      h = {}
      h[:document_path] = toc_folder
      h[:page_pdf]      = true
      h[:max_page]      = 1
      h[:toc_item_count] = @book_toc.length
      # h[:parts_count]   = @parts_count
      h[:no_table_title] = true # tells not to creat toc title
      r = RLayout::Toc.new(h)
      new_page_count = r.page_count
      @toc_doc_page_count = new_page_count
      @toc_page_links = r.link_info
    end

    def toc_folder
      build_folder + "/front_matter/toc"
    end

    def toc_yml_path
      build_folder + "/front_matter/toc/toc_content.yml"
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
      # pdf_docs += rear_matter_docs_pdf
      pdf_docs
    end

    def pdf_pages_for_inner_book
      pdf_pages = []
      pdf_pages += @front_matter.pdf_pages
      pdf_pages += @body_matter.pdf_pages
      # pdf_docs += rear_matter_docs_pdf
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
      generate_inner_book
    end

    def build_book_cover_pdf_path
      build_book_cover_path + "/output.pdf"
    end

    def print_book_cover_pdf_path
      print_folder + "/book_cover.pdf"
    end

    def copy_book_cover_pdf
      FileUtils.cp(build_book_cover_pdf_path, print_book_cover_pdf_path)
    end

    def place_page_in_print_page(page_path, side)
      print_page_width = @page_width + @gripper_margin*2
      print_page_height = @height + @gripper_margin*2
      RLayout::PrintPage.new(page_path:page_path, side:side, width: print_page_width, height: print_page_height, gripper_margin: @gripper_margin, bleed_margin: @bleed_margin, binding_margin: @binding_margin)
    end

    def generate_inner_book
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
      pdf = HexaPDF::Document.open(book_without_cover_path)
      pdf.pages.each {|page| target.pages << target.import(page)}

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
      @toc_first_page_number = toc_first_page_number + 2
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
      @toc_first_page_number = @front_matter.toc_first_page_number
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
          RLayout::RChapter.new(chapter_path: "#{source}")  
        end
      end
      
      task :force_layout do
        chapter_files.each do |source|
          RLayout::RChapter.new(chapter_path: "#{source}")  
        end
      end
      
      front_files = Dir.glob("#{File.dirname(__FILE__)}/front_matter/**")
      task :layout_front do
        front_files.each do |source|
          RLayout::RChapter.new(chapter_path: "#{source}")  
        end
      end
      
      rear_files = Dir.glob("#{File.dirname(__FILE__)}/rear_matter/*{.md, .markdown}")
      task :layout_rear do
        rear_files.each do |source|
          RLayout::RChapter.new(chapter_path: "#{source}")  
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

  end
end