

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
      unless options[:script]
        puts "no script !!!"
        return
      end
      created_object = eval(options[:script])
      if created_object.class == SyntaxError
        puts "eval SyntaxError !!!!"
        return
      end
      
      unless @output_path
        @output_path = created_object.pdf_path  if created_object.respond_to?(:pdf_path)
      end
      unless @output_path
        puts "no output_path !!!"
        return
      end
      unless @jpg
        @jpg         = created_object.jpg       if created_object.respond_to?(:jpg)
      end
      created_object.save_pdf(@output_path, :jpg=>@jpg) if created_object.respond_to?(:save_pdf)
      self
    end
    
  end
end
