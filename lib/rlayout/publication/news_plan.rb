# NewsPlan
# NewsPlan is a tooi for creating newspaper_issue.
# NewsPlan uses csv file as input and creates issue structure from it.

# How NewsPlan Works
#
# 1. Create NewsPlan worksheet with Spreadsheet.
#
# section,  type,    size,  name,     title
# Current   article, l,     mskim,
#           article, m,     mskim,
#           article, m      jklee,
#           ad,      5x7,   samsung,
#           ad,      2x5,   lg
# Economy   article, l,     mskim,
#           article, m,     mskim,
#           article, m      jklee,
#           ad,      5x7,   samsung,
#           ad,      2x5,   lg

#
#
#
#
# 2. THose spreadsheet file is converted into a folders as following.
#
# 2016_11_7
#   Current
#     1.story
#     2.story
#     3.story
#     4.story
#     5.story
#     6.Ad
#     7.Ad
#   Economy
#     1.story
#     2.story
#     3.story
#     4.story
#     5.story
#     6.Ad
#     7.Ad
#
# 3. After creating folders, template files are copied from library

# Template
# Template indicates type of document
# pre-made folders are copied into working space.
#
#
# ---
# title: "Title of chapter"
# author: name of reporter
#
# ---
#
# # head
# body text goes here. body text goes here.
# body text goes here. body text goes here.
# body text goes here. body text goes here. body text goes here.
# body text

module RLayout

  class NewsPlan
    attr_accessor :project_path, :csv_text, :csv, :template_path

    def initialize(project_path, options={})
      puts @project_path = project_path

      @csv_path     = Dir.glob("#{@project_path}/*.csv").first
      puts @csv_path
      if options[:csv]
        @csv_path     = options[:csv]
        @project_path = File.dirname(@csv_path)
      end
      unless @csv_path
        puts "No csv file found !!!"
        return
      end
      @template_path = options.fetch(:template_path,"/Users/Shared/SoftwareLab/news_template")
      parse_csv
      self
    end

    def parse_csv
      puts __method__
      puts @csv_text = File.read(@csv_path)
      @csv       = CSV.parse(@csv_text, :headers => true)
      # heders    = @csv.headers
      @current_section  = @csv.first.first[1].gsub(" ","_")
      @csv.each do |row|
        if row.first[1] == nil
          row.first[1]  = @current_section
        elsif row.first[1] != @current_section
          @current_section = row.first[1].gsub(" ","_")
          row.first[1]  = @current_section
        end
        create_section_template(row)
      end
    end

    def parameterize_row(row)
      row.map{|e| e[1].gsub(" ","_") if e[1]}
    end

    # part, document, subdocument, type, page, item, color
    def create_section_template(row)
      section_folder = @project_path + "/#{row.first[1]}"
      FileUtils.mkdir_p(section_folder) unless File.directory?(section_folder)
      article_type = row[1] if row[1]
      if article_type
        @article_path = section_folder + "/#{article_type.gsub(" ","_")}"
        puts "@article_path:#{@article_path}"
        FileUtils.mkdir_p(@article_path) unless File.directory?(@article_path)
        template_name = article_type
        #copy content
        source = @template_path + "/#{template_name.gsub(" ","_")}"
        puts "source:#{source}"

        system("cp -R #{source}/* #{@article_path}/")
      end
    end
  end
end
#
# require 'minitest/autorun'
# include RLayout
#
# describe 'create NewsPlan' do
#
#   before do
#     @csv_path = '/Users/mskim/demo_news_plan/2016_11_28'
#     @n_plan   = NewsPlan.new(@csv_path)
#   end
#
#   it 'should create NewsPlan' do
#     @n_plan.must_be_kind_of NewsPlan
#   end
#
# end
