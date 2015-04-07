
module RLayout
  class NewsArticleMaker
    attr_accessor :path, :output_path, :output_folder
    def initialize(path, options={})
      @path          = path
      @content_path  = path
      ext            = File.extname(@path)
      @output_path   = @path.gsub(ext, ".pdf")
      @output_folder = File.dirname(@path)
      options[:story_path]   = @content_path
      options[:output_path]  = @output_path
      process_job(options) if valid_job?
      self
    end

    def valid_job?
      unless File.exist?(@path)
        puts "#{@path} does not exist!!! "
        return false
      end
      unless File.exist?(@content_path)
        puts "#{@path} does not exist!!! "
        return false
      end
      true
    end

    def process_job(options)
      system("mkdir -p #{@output_folder}") unless File.exist?(@output_folder)
      NewsArticle.new(nil, options)
    end
  end
end
