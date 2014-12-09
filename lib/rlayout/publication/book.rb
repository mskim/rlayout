# encoding: utf-8
if RUBY_ENGINE == 'macruby'
  framework 'Quartz'
end
require 'yaml'
module RLayout
  
  class Book
    attr_accessor :folder_path
    def initialize(folder_path)
      @folder_path  = folder_path
      unless File.exists?(@folder_path)
        system("mkdir -p #{@folder_path}") 
        copy_template
      end
      self
    end
    
    def copy_template
      source = "/Users/Shared/SoftwareLab/book"
      system("cp -r #{source}/ #{@folder_path}/")
    end
    
    def merge_pdf_chpaters
      return unless RUBY_ENGINE == 'macruby'
      book_pdf = PDFDocument.new
      Dir.glob("#{@folder_path}/*.pdf") do |path|
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
      
      book_pdf.writeToFile("#{@folder_path}/book.pdf")
    end
    
    
    def process_markdown_files(options={})
      options[:starting_page_number]=1
      Dir.glob("#{@folder_path}/*.markdown") do |m|
        result = convert_markdown2pdf(m, options)
        options[:starting_page_number] = result.next_chapter_starting_page_number if result
      end
      
    end
    
    def update_book_tree(options={})
      book_tree_path  = @folder_path + "/chapter_tree.yml" 
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
      Dir.glob("#{@folder_path}/*.pdf") do |m|
        puts "deleting #{m}..."
        system("rm #{m}")
      end
      
    end

    def delete_markdown_files
      Dir.glob("#{@folder_path}/*.markdown") do |m|
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
      title = File.basename(markdown_path, ".markdown")
      if options[:starting_page_number]
        chapter = Chapter.new(:title =>title, :paper_size=>'A5', :starts_left=>false, :chapter_kind=>"chapter", :story_path=>markdown_path, :starting_page_number=>options[:starting_page_number])
      else
        chapter = Chapter.new(:title =>title, :paper_size=>'A5', :starts_left=>false, :chapter_kind=>"chapter", :story_path=>markdown_path)
      end
      chapter.save_pdf(pdf_path)
      chapter
    end
    
    def txt2markdown
      Dir.glob("#{@folder_path}/*.txt") do |m|
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
      yaml_header = <<EOF
---
title: #{title}
---

EOF
      with_yaml_header = yaml_header + "\n" + txt_content
      File.open(markdown_path, "w"){|f| f.write with_yaml_header}
      
    end
    
    def self.rtf2md(path)
      
    end
    
    def make_long_ditit(s,digits)
      s.rjust(digits,"0")
    end
    
    
    #TODO
    # skip files that are already 3 digits or more
    # fix filenames with space 
    def normalize_filenames
      new_names = []
      Dir.glob("#{@folder_path}/*") do |m|
        basename = File.basename(m)
        if basename =~ /^\d+/
          r= /^\d*/
          matching_string = (basename.match r).to_s
          long_digit = make_long_ditit(matching_string, 3)
          new_base = basename.sub(matching_string, long_digit)
          new_path = @folder_path + "/#{new_base}"
          puts m
          puts new_path
          # system("mv #{m} #{new_path}")
        end
      end
      new_names
    end
  end  

end
