

# Rjob works as command line tool.
# echo 'script' | rjob // disabled!!!
# Script should declare @output_path and @jpg as instance variable

# sample_script.rb
# @output_path  = "/Users/name/some_path.pdf"
# @jpg          = false
# RLayout::Page.new() do
#  # puts some contrainer here.
#
# end

module RLayout
  class RJob
    attr_accessor :output_path, :jpg, :preview, :created_object
    def initialize(options={})
      @created_object  = nil
      @output_path    = options[:output_path] if options[:output_path]
      @jpg            = options[:jpg] if options[:jpg]
      @preview        = options[:preview] if options[:preview]
      $ProjectPath    = options[:project_folder] if options[:project_folder]
      if options[:script]
        @created_object = eval(options[:script])
        unless @output_path
          if $ProjectPath
            @output_path = $ProjectPath + "/output.pdf"
          else
            puts "output_path not specified!!! "
            return
          end
        end
      elsif options[:script_path]
        unless File.exist?(options[:script_path])
          puts "no file #{options[:script_path]} doesn't exit!!! "
          return
        end
        $ProjectPath    = File.dirname(options[:script_path]) unless options[:project_folder]
        script = File.open(options[:script_path], 'r'){|f| f.read}
        @created_object = eval(script)
        unless @output_path
          @output_path = File.dirname(options[:script_path]) + "/output.pdf"
        end
      end
      if @created_object.class == SyntaxError
        puts "eval SyntaxError !!!!"
        puts "@created_object.inspect:#{@created_object.inspect}"
        return
      end
      unless @output_path
        puts "no output_path !!!"
        return
      end
      unless @jpg
        @jpg         = @created_object.jpg       if @created_object.respond_to?(:jpg)
      end
      output_options            = {}
      output_options[:jpg]      = @jpg if @jpg
      # output_options[:preview]  = @preview if @preview
      @created_object.save_pdf(@output_path, output_options) if @created_object.respond_to?(:save_pdf)
      self
    end
  end
end
