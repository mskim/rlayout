# BookPlan
# BookPlan is  a tooi for creating book.
# BookPlan uses csv file as input and creates folders from it.
# csv file also containe information about types of documents,  so pre-made templates can be copied from library.
# it also has page count for document,so that toc can be created and starting page numbers for each documents.

# How BookPlan Works
# 
# 1. Create BookPlan worksheet with Spreadsheet.
# 
# Headers are 
# Part, Document, SubDocument, Template, Page, Color
# 
# 2. THose spreadsheet file is converted into a folders as following.
#
# Book
#   Front
#     cover
#     preface
#     toc
#   Body
#     Chapter
#       photo_page
#     Chpater
#       Illustrated_Page
#     Chpater
#     Chpater
#     
#   Rear
#     index
# 
# 3. After creating folders, template files are also copied from library

# Template
# Template indicates type of document
# pre-made folders are copied into working space.
# 
# Page
# Page indicates how many pages the document should occupy.
# 
# From these information TOC is  
# 
# Metadata section of text file gets update by BookPlan
# 
# ---
# book_title: "Title of the book"
# document_title: "Title of chapter"
# starting_page_number: 34
# page_count: 4
# ---
# 
# # Title of Chapter
# 
# ## Section Title
# 
# body text 

module RLayout
  
  class BookPlan
    attr_accessor :project_path, :csv_text, :csv, :template_path
    
    def initialize(options={})
      if options[:project_path]
        @project_path = options[:project_path]
        @csv_path     = Dir.glob("#{@project_path}/*.csv").first
      elsif options[:csv]
        @csv_path     = options[:csv] 
        @project_path = File.dirname(@csv_path)
      end
      unless @csv_path
        puts "No csv file found !!!"
        return        
      end
      @template_path = options.fetch(:project_path,"/Users/Shared/SoftwareLab/document_template")
      parse_csv
      self
    end
    
    def parse_csv
      @csv_text = File.read(@csv_path)
      @csv       = CSV.parse(@csv_text, :headers => true)
      # heders    = @csv.headers      
      @current_part  = @csv.first.first[1].gsub(" ","_")
      @csv.each do |row|
        if row.first[1] == nil
          row.first[1]  = @current_part
        elsif row.first[1] != @current_part
          @current_part = row.first[1].gsub(" ","_")
          row.first[1]  = @current_part
        end
        create_document_template(row)
      end
    end
    
    def parameterize_row(row)
      row.map{|e| e[1].gsub(" ","_") if e[1]}
    end
    
    # part, document, subdocument, type, page, item, color
    def create_document_template(row)
      part_folder = @project_path + "/#{row.first[1]}"
      FileUtils.mkdir_p(part_folder) unless File.directory?(part_folder)
      document_name = row[1] if row[1] 
      if document_name
        @document_path = part_folder + "/#{document_name.gsub(" ","_")}"
        # puts "@document_path:#{@document_path}"
        FileUtils.mkdir_p(@document_path) unless File.directory?(@document_path)
        template_name = row[3] if row[3]
        #copy content
        source = @template_path + "/#{template_name.gsub(" ","_")}"
        system("cp -R #{source}/* #{@document_path}/")
      elsif sub_document = row[2]
        sub_document_path = @document_path + "/#{sub_document.gsub(" ","_")}"
        FileUtils.mkdir_p(sub_document_path) unless File.directory?(sub_document_path)
        template_name = row[3] if row[3]
        #copy content
        source = @template_path + "/#{template_name}"
        system("cp -R #{source}/* #{sub_document_path}/")
      end
    end


  end
  
  
end