
module RLayout
  class NewsArticleMaker
    attr_accessor :path, :output_path, :output_folder
    def initialize(path, options={})
      puts "path:#{path}"
      puts "options:#{options}"
      @path          = path
      @content_path  = path
      ext            = File.extname(@path)
      @output_path   = @path.gsub(ext, ".pdf")
      @output_folder = File.dirname(@path)
      opts = {}
      opts[:story_path]   = @content_path
      opts[:output_path]  = @output_path
      process_job(opts) if valid_job?
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


    # def self.create_section(folder_path)
    #   #copy_section_template(folder_path, opiotions={})
    #   article_grid_frames = File.open(template_path,'r'){|f| f.read}.load_yaml
    #   article_grid_frames.each_with_index do |grid_frame, i|
    #     self.update_article_grid_base(articles[i], grid_frame)
    #   end
    #
    # end

    # def self.update_article_grid_base
    #
    # end

  end
end
