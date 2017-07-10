
module RLayout
  
  class LatexToken < Graphic
    
    attr_accessor :latex_string, :escaped_string, :math_file_path, :math_image
    attr_accessor :math_lib_path, :math_latex_path, :font_size
    
    def initialize(options={})
      @latex_string     = options[:latex_string]      
      @font_size        = options.fetch(font_size, 10)
      #TODO
      # take care fo space char using Shellwords.escape
      
      @escaped_string   = @latex_string.gsub("\\","!") 
      # @escaped_string   = Shellwords.escape(@escaped_string)   
      @escaped_string   = @escaped_string.gsub(" ","")    
      @math_lib_path    = "/Users/Shared/SoftwareLab/math/lib"
      @math_latex_path  = "/Users/Shared/SoftwareLab/math/latex"
      system("mkdir -p #{@math_lib_path}") unless File.directory?(@math_lib_path)
      system("mkdir -p #{@math_latex_path}") unless File.directory?(@math_latex_path)
      @math_file_path   = @math_lib_path + "/#{@escaped_string}.pdf"
      if File.exist?(@math_file_path)
        options[:image_path] = @math_file_path
      else
        options[:image_path] = create_latex_pdf
      end
      # set width and height
      super
      self
    end
    
    def create_latex_pdf

# single quote version
latex_template= <<EOF
\\documentclass[10]{article}
\\pagenumbering{gobble}
\\usepackage{amssymb}
\\usepackage{amsmath}
\\usepackage[utf8]{inputenc}
\\begin{document}
  $<%= @latex_string %>$
\\end{document}
EOF

latex_template =<<EOF
\\documentclass[10]{article}
\\pagenumbering{gobble}
\\usepackage{amsmath}
\\begin{document}
  $<%= @latex_string %>$
\\end{document}

EOF

      erb       = ERB.new(latex_template)
      template  = erb.result(binding)
      puts "template:#{template}"
      tex_file  = @math_latex_path + "/#{@escaped_string}.tex"
      File.open(tex_file, 'w'){|f| f.write template} 
      pdf_file  = tex_file.sub(/\.tex$/, ".pdf")
      tex_file_base_name = File.basename(tex_file)
      base_name = File.basename(pdf_file)
      lib_file  = @math_lib_path + "/#{base_name}"
      system("cd #{@math_latex_path} && /usr/local/texlive/2015/bin/universal-darwin/pdflatex #{tex_file_base_name}")
      system("pdfcrop #{pdf_file}  #{lib_file}")
      lib_file
    end
    
  end
  
end

