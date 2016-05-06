# encoding: utf-8

# book new name --template==spring
# rake create chapters
# rake update pdf 
# rake publish pdf_book
# rake publish web_site

module RLayout
  
  class Book
    attr_accessor :project_path
    def initialize(project_path, options={})
      @project_path  = project_path
      unless File.exists?(@project_path)
        system("mkdir -p #{@project_path}") 
        copy_template if options[:template]
      end
      self
    end
    
    def copy_template
      source = "/Users/Shared/SoftwareLab/book"
      system("cp -r #{source}/ #{@project_path}/")
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
    
    def process_articles
      
    end
    
    def process_markdown_files(options={})
      options[:starting_page_number]=1
      Dir.glob("#{@project_path}/*.markdown") do |m|
        result = convert_markdown2pdf(m, options)
        options[:starting_page_number] = result.next_chapter_starting_page_number if result
      end
    end
    
    def update_book_tree(options={})
      book_tree_path  = @project_path + "/chapter_tree.yml" 
      book_tree_hash  = YAML.load_file(book_tree_path)
      starting_page   = options.fetch(:strating_page, 1)
      book_tree_hash.each do |node|
        node[2] = starting_page
        starting_page += node[3]
      end
      File.open(book_tree_path, 'w'){|f| f.write book_tree_hash.to_yaml} 
    end
    
    #update markdown files metadata starting_page:
    def update_markdown_file_starting_page
      
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
    # Use markdown file as working temp file? or shuld I create filename.yml
    # it should have book layout informations, 
    # such as starting page, page_count, toc_elements index_elements in metadata hash
    # add starting_page, page_count, toc into markdown file after pdf generation
    def convert_markdown2pdf(markdown_path, options={})
      pdf_path = markdown_path.gsub(".markdown", ".pdf")
      if options[:check_time]
        if File.ctime(pdf_path) > File.ctime(markdown_path)
          puts "#{pdf_path} is upto date...."
          return nil
        end
      end
      puts "generating #{pdf_path}..."
      options[:title]             = File.basename(markdown_path, ".markdown") unless options[:title]
      options[:starts_left]       = false unless options[:starts_left]
      options[:article_type]      = "chapter" unless options[:article_type]
      options[:story_path]        = markdown_path
      options[:starting_page_number]= options[:starting_page_number] if options[:starting_page_number]
      chapter = Chapter.new(options)
      chapter.save_pdf(pdf_path)
      chapter
    end
    
    def txt2markdown
      Dir.glob("#{@project_path}/*.txt") do |m|
        convert_txt2markdown(m)
      end
    end
      
    def rtf2md(path)
      
    end
    
    # convert .txt file to markdown file by
    # inserting yml header in front 
    # filename becomes yml header title
    def convert_txt2markdown(txt_path)
      txt_content = File.open(txt_path, 'r'){|f| f.read}
      title = File.basename(txt_path, ".txt")
      markdown_path = txt_path.gsub(".txt", ".markdown")
      yaml_header = <<-EOF.gsub(/^\s*/, "")
      ---
      title: #{title}
      ---

      EOF
      with_yaml_header = yaml_header + "\n" + txt_content
      File.open(markdown_path, "w"){|f| f.write with_yaml_header}
      
    end
    
    def self.rtf2md(path)
      
    end
    
    def self.merge_pdf_articles(project_path)
      # Dir.glob("#{@project_path}/*.pdf") 
      puts "Project Path: #{project_path}"
      if RUBY_ENGINE == 'ruby'
        puts "RUBY_ENGINE:#{RUBY_ENGINE}"
        return
      end
      book_pdf = PDFDocument.new
      puts "book_pdf.class:#{book_pdf.class}"
      Dir.glob("#{project_path}/**/*.pdf") do |pdf_path|
        next if pdf_path =~ /book.pdf$/
        puts "merging ...: #{pdf_path}"
        url = NSURL.fileURLWithPath pdf_path
        pdf_chapter = PDFDocument.alloc.initWithURL url
        pdf_chapter.pageCount.times do |i|
          page = pdf_chapter.pageAtIndex i
          pdf_data = page.dataRepresentation
          page=PDFDocument.alloc.initWithData(pdf_data).pageAtIndex(0)
          book_pdf.insertPage(page, atIndex: book_pdf.pageCount)
        end
      end
      book_pdf.writeToFile("#{project_path}/book.pdf")
    end
    
    #TODO
    # skip files that are already 3 digits or more
    # fix filenames with space 
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
