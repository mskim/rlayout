# NewsPlan
# NewsPlan is a tooi for creating newspaper_issue.
# NewsPlan uses csv file as input and creates issue structure from it.

# How NewsPlan Works
# 양면,같러,면이름,광고크기,광고주,가사박스
# 1,같러,1면,5단통-6,삼성전자_2016_12,4
# ,,8면,5단통,LG전자_2016_12,3
# 2,흑백,2면,없음,,5
# ,,7면,5단통,현대자동차_2016_12,4
# 3,같러,3면,5단통,포스코_2016_12,4
# ,,6면,5단통,KT_2016_12,4
# 4,흑백,4면,5단통,애플컴퓨터_2016_12,4
# ,,5면,전면,CJ_2016_12,0
#
# 1. Create NewsPlan worksheet with Spreadsheet.
#
# spread, color, page_name, ad_size, number_of_stories, advertiser
#   1-8,  color, Current,   5x7-6,    4,           , Samsung
#         color, Business,  5x7-7,    4,           , LG
#   2-7,  bw,    Culture,   5x7-6,    4,           , Hyungdai
#         bw,    Sports,    5x7-6,    4,           , Naver
#   3-6,  bw,    Technology,5x7-6,    4,           , Apple
#         bw,    Travel,    5x7-6,    4,           , SK
#   4-5,  color, Food,      5x7-6,    4,           , KT
#         color, Health,    5x7-6,    4,           , Hynix

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
      @project_path = project_path
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
