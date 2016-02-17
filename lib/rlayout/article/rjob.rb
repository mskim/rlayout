

# Rjob works as command line tool.
# echo 'script' | rjob 
# Script should declare @output_path and @jpg as instance variable

# sample_script.rb
# @output_path  = "/Users/name/some_path.pdf"
# @jpg          = false
# RLayout::Page.new(nil, ) do
#  # puts some contrainer here.
#
# end

module RLayout
  class RJob
    attr_accessor :output_path, :jpg
    def initialize(options={})
      created_object = nil
      @output_path   = options[:output_path] if options[:output_path]
      if options[:script]
        # puts "options[:script]:#{options[:script]}"
        created_object = eval(options[:script])
        # puts "@output_path:#{@output_path}"
      elsif options[:script_path]
        unless File.exist?(options[:script_path])
          puts "no file #{options[:script_path]} doesn't exit!!! "
          return
        end
        script = File.open(options[:script_path], 'r'){|f| f.read}
        created_object = eval(script)
        unless @output_path
          @output_path = File.dirname(options[:script_path]) + "/output.pdf"
        end
      end
      
      
      if created_object.class == SyntaxError
        puts "eval SyntaxError !!!!"
        puts "created_object.inspect:#{created_object.inspect}"
        return
      end
      unless @output_path
        puts "no output_path !!!"
        return
      end
      unless @jpg
        @jpg         = created_object.jpg       if created_object.respond_to?(:jpg)
      end
      # puts "created_object.class:#{created_object.class}"
      # puts "created_object.respond_to?(:save_pdf):#{created_object.respond_to?(:save_pdf)}"
      created_object.save_pdf(@output_path, :jpg=>@jpg) if created_object.respond_to?(:save_pdf)
      self
    end
  end
end
