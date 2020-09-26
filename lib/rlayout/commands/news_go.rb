require 'thor'
require_relative '../../rlayout'

# given story.md generate story.pdf
# options -time  time stamed pdf, jpg, page
# options -jpg   generate jpg file
# options -page  generate page pdf file
# options -o     generate output file name diffent fram input file name

# example 
# cd path && NewsGO article story.md -time==true -jpg=true -page=true


require 'rlayout'
require 'thor'

class NewsGO < Thor
  method_option :article_path, aliases: "-p", default: "./"
  method_option :jpg, aliases: "-j", default: :true
  method_option :time, aliases: "-t", default: :true
  def article
    puts "Generating article pdf"
    puts article_path = File.expand_path(options[:path])
    options                 = {}
    options[:article_path]  = article_path
    options[:jpf]           = true
    RLayout::NewsBoxMaker.new(options)
  end 

  desc "section", "Generate section pdf"
  method_option :path, aliases: "-p", default: "./"
  def section
    puts "Generate section pdf"
    puts section_path = File.expand_path(options[:path])
    options = {}
    options[:section_path]  = section_path
    options[:output_path]   = section_path + "/section.pdf"
    options[:jpg]           = true
    RLayout::NewsPage.section_pdf(options)
  end 

  desc "rjob layout.rb", "Generate layout.rb pdf"
  method_option :output, aliases: "-o", default: nil
  method_option :layout_file, aliases: "-l", default: nil
  method_option :jpg, aliases: "-j", default: :true
  def rjob
    folder_path = File.expand_path(".")
    script_path = Dir.glob("#{folder_path}/*.rb").first
    output_name = "output.pdf" unless options[:output]
    if options[:layout_file]
      script_path = folder_path + "/#{options[:layout_file]}"
      output_name = options[:layout_file].sub(/.rb$/, '.pdf')
    end
    # return if no file is found
    unless script_path
      puts "no layout file found !!!"
      return
    end
    rjob_options = {}
    rjob_options[:output_path] = folder_path + "/#{output_name}"
    rjob_options[:scprt_path] = script_path
    puts rjob_options
    RLayout::RJob.new(rjob_options)
  end

  def help
    puts "NewsGo ..."
    super
  end

end