
module RLayout
  class ChapterMaker
    attr_accessor :path, :pgscript, :output_path, :output_folder
    def initialize(path, options={})
      @path          = path
      if File.extname(@path) == ".rlayout"
        @path          = path
        @pgscript_path = @path + "/layout.rb"
        @content_path  = @path + "/content.yml"
        @output_path   = @path + "/QuickLook/Preview.pdf"
        @output_folder = @path + "/QuickLook"
        @pgscript = File.open(@pgscript_path, 'r'){|f| f.read} if File.exist?(@pgscript_path)

      else
        @output_folder = File.dirname(@path)
        @content_path  = path
        ext            = File.extname(@path)
        @output_path   = @path.gsub(ext, ".pdf")
        @pgscript = nil

      end
      process_job if valid_job?
      self
    end

    def valid_job?
      unless File.exist?(@path)
        puts "#{@path} doen not exist!!! "
        return false
      end
      unless File.exist?(@content_path)
        puts "#{@path} doen not exist!!! "
        return false
      end
      true
    end

    def process_job
      chapter = nil
      system("mkdir -p #{@output_folder}") unless File.exist?(@output_folder)

      if  @pgscript
        # This is when we have layout.rb file for custom designed Chapter
        chapter = eval(pgscript)
        # content = chapter.read_story(@content_path)
        # content = File.open(@content_path, 'r'){|f| f.read}
        # chapter.layout_story
        # chapter.save_pdf(@output_path)
      else
        # Using default Chapter design
        chapter = Chapter.new(story_path: @content_path, save_path: output_path)
      end
    end
  end
end
