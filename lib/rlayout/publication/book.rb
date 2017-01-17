# encoding: utf-8


# Creating a book
# 1. book new sample_book
#     this creates a folder
# 2. cd sample_book
#     there will be a file called book_info.yml
#     And a folder called source
#     put text source files in source folder
#     # source
#        1.chapter/
            # images/
            #   photo1.jpg
            #   photo2.jpg
            # output.pdf
            # story.md
#        2.chapter/
#        3.chapter/
#        4.chapter/
#        5.chapter/
#        6.chapter/

#     and edit book_info.yml
#     comment out item if you wish to include it.
#       example: forward is commented out, include it by uncommenting it.
#     book_info.yml
#        title: sample_book
#        author: author_name
#        template: spring
#        cover: true
#        preface: true
#        #forward: true
#        toc: true
#        # colophone: true
#        index: true
#        # appendix: true

# 3. create_document
#     this will create folders for documents and copy templates
#     it will link sources into folders
#     so it will be ready to create a book.
#     front
#        cover
#        toc
#     body
#        001_chapter
#          layout.rb
#          1.chapter.md (linked file from source)
#          images (linked file from source)
#        002_chapter
#        003_chapter
#        004_chapter
#        005_chapter
#     rear
#        index

# 4. rake
#        This generates PDF, preview, and doc_info.yml

# 5. rake pdf_book
#        This will merge all PDF files into a book.
# 6. rake web_site
#        This will generate HTML version of the book.

# rake update pdf
# rake publish pdf_book
# rake publish web_site

module RLayout

  class Book
    attr_accessor :project_path, :starting_page
    def initialize(project_path, options={})
      @project_path  = project_path
      unless File.directory?(@project_path)
        system("mkdir -p #{@project_path}")
        copy_template(options)
      end
      @book_tree      = {}
      @starting_page  = 1
      self
    end

    #TODO update template
    # fix Rakefile, add cover, toc, forward, dedication
    def copy_template(options={})
      puts __method__
      source = options.fetch(:template,"/Users/Shared/SoftwareLab/book")
      if File.directory?(source)
        system("cp -r #{source}/ #{@project_path}/")
      end
    end

    def merge_pdf_chpaters
      book_pdf = PDFDocument.new
      Dir.glob("#{@project_path}/*.pdf") do |path|
        next if path =~ /book.pdf$/
        puts path
        url = NSURL.fileURLWithPath path
        pdf_chapter = PDFDocument.alloc.initWithURL url
        pdf_chapter.pageCount.times do |i|
          page = pdf_chapter.pageAtIndex i
          pdf_data = page.dataRepresentation
          page=PDFDocument.alloc.initWithData(pdf_data).pageAtIndex(0)
          book_pdf.insertPage(page, atIndex: book_pdf.pageCount)
        end
        puts "book_pdf.pageCount:#{book_pdf.pageCount}"
      end
      book_pdf.writeToFile("#{@project_path}/book.pdf")
    end

    def merge_pdf_articles
      # Dir.glob("#{@project_path}/*.pdf")
      if RUBY_ENGINE == 'rubymotion'
        book_pdf = PDFDocument.new
      end
      Dir.glob("#{@project_path}/**/*.pdf") do |pdf_path|
        next if pdf_path =~ /book.pdf$/
        if RUBY_ENGINE == 'rubymotion'
          url = NSURL.fileURLWithPath pdf_path
          pdf_chapter = PDFDocument.alloc.initWithURL url
          pdf_chapter.pageCount.times do |i|
            page = pdf_chapter.pageAtIndex i
            pdf_data = page.dataRepresentation
            page=PDFDocument.alloc.initWithData(pdf_data).pageAtIndex(0)
            book_pdf.insertPage(page, atIndex: book_pdf.pageCount)
          end
        else
          puts "RUBY_ENGINE:#{RUBY_ENGINE}"
        end
      end
      if RUBY_ENGINE == 'rubymotion'
        book_pdf.writeToFile("#{@project_path}/book.pdf")
      end
    end

    def parse_front_matter_toc
      content = ""
      Dir["#{@project_path}/front_matter/**/doc_info.yml"].each do |front_mater_info|
        yml     = YAML::load(File.open(front_mater_info, 'r'){|f| f.read})
        content += yml[:toc]
        # @starting_page += yml[:page_count]
      end
      content
    end

    def parse_chapter_toc
      content = ""
      Dir["#{@project_path}/*chapter*/doc_info.yml"].each do |chapter_info|
        yml     = YAML::load(File.open(chapter_info, 'r'){|f| f.read})
        content += yml[:toc].gsub(/0$/, @starting_page.to_s)
        @starting_page += yml[:page_count]
      end
      content
    end

    def parse_rear_matter_toc
      content = ""
      Dir["#{@project_path}/rear_matter/**/doc_info.yml"].each do |read_mater_info|
        content += File.open(read_mater_info, 'r'){|f| f.read}
      end
      content
    end

    def self.update_toc(project_path)
      b=Book.new(project_path)
      b.update_toc
    end

    def update_toc
      @front_matter_path = @project_path + "/front_matter/toc"
      system("mkdir -p #{@front_matter_path}") unless File.directory?(@front_matter_path)

      content =<<EOF
# Table of content \n
EOF
      content += parse_chapter_toc
      content += parse_rear_matter_toc
      toc_path = @project_path + "/front_matter/toc/toc.md"
      system("touch #{toc_path}")
      File.open(toc_path, 'w'){|f| f.write content}
    end

    #update markdown files metadata starting_page:
    def update_starting_page
      @new_starting_page = 1
      Dir["#{@project_path}/*chapter*/doc_info.yml"].each_with_index do |chapter_info, i|
        yml  = YAML::load(File.open(chapter_info, 'r'){|f| f.read})
        if i == 0
          # yml = File.open(chapter_info, 'w'){|f| f.write yml.to_yaml}
          page_count = yml[:page_count]
          @new_starting_page += page_count
          next
        end
        yml[:starting_page] = @new_starting_page
        File.open(chapter_info, 'w'){|f| f.write yml.to_yaml}
        @new_starting_page += yml[:page_count]

      end

    end

    def delete_pdf_files
      Dir.glob("#{@project_path}/*.pdf") do |m|
        puts "deleting #{m}..."
        system("rm #{m}")
      end
    end

    def delete_markdown_files
      Dir.glob("#{@project_path}/*.markdown") do |m|
        puts "deleting #{m}..."
        system("rm #{m}")
      end
    end

    #TODO
    # skip files that are already 3 digits or more
    # fix filenames with space
    # 000_chapter
    def normalize_filenames
      new_names = []
      Dir.glob("#{@project_path}/*") do |m|
        basename = File.basename(m)
        if basename =~ /^\d+/
          r= /^\d*/
          matching_string = (basename.match r).to_s
          long_digit = make_long_ditit(matching_string, 3)
          new_base = basename.sub(matching_string, long_digit)
          new_path = @project_path + "/#{new_base}"
          puts m
          puts new_path
          # system("mv #{m} #{new_path}")
        end
      end
      new_names
    end
  end

end
