

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
    attr_accessor :project_path, :output_path, :jpg, :preview, :created_object
    def initialize(options={})
      @project_path   = options[:project_path]
      @output_path    = options[:output_path]
      unless @project_path
        unless @output_path
          puts "project_path not found!!!"
          return
        else
          @project_path = File.dirname(@output_path)
        end
      else
        @output_path    = @project_path + "/output.pdf" unless @output_path
      end
      @layout_path    = @project_path + "/layout.rb"
      unless File.exist?(@layout_path)
        puts "#{@layout_path} path not found!!"
        return
      end
      @jpg            = options[:jpg]
      layout_rb       = File.open(@layout_path, 'r'){|f| f.read}
      @created_object = eval(layout_rb)
      if @created_object.class == SyntaxError
        puts "eval SyntaxError !!!!"
        puts "@created_object.inspect:#{@created_object.inspect}"
        return
      end
      @created_object.save_pdf(@output_path, jpg:@jpg)
      self
    end
  end
end
