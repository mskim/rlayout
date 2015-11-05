
# MemberDirectory
# 
module RLayout
  class MemberDirectory
    # attr_accessor :organization, :book_plan
    def initialize
      
      self
    end
  end
  
  class MemberItem < RLayout::Container
	  attr_accessor :image_path, :name, :spause, :phone, :cell, :group #polaoid, film, 
	  attr_accessor :container_object, :template, :template_erb, :template_erb_path
	  def initialize(parent_graphic, options={}, &block)
	    super
	    @name       = options.fetch(:name, "Hong_Gil_Dong")
      if options[:image_path]
  	    @image_path = options[:image_path]
  	  elsif @image_dir
        @image_path = @image_dir + "/#{@name}.jpg"
      end
	    @spause     = options.fetch(:spause, "")
	    @phone      = options.fetch(:phone, "")
	    @cell       = options.fetch(:cell, "")
	    @group      = options.fetch(:group, "")
	    
      if options[:template_erb]
	      @template_erb     = options[:template_erb]
      elsif options[:template_erb_path]
	      @template_erb_path= options[:template_erb_path]
	      @template_erb     = File.open(@template_erb_path, 'r'){|f| f.read}
      end
      
      unless @template_erb
        member_template_path= "/Users/Shared/SoftwareLab/article_template/church_member.erb"
        @template_erb     = File.open(member_template_path, 'r') {|f| f.read}
      end
      erb                 = ERB.new(@template_erb)
      @template           = erb.result(binding)   
      @container_object   = eval(@template)
	    self
	  end
	  
	  def layout_member!
	    @template.relayout!
	  end
	  
	  def save_pdf(path)
      if RUBY_ENGINE == 'rubymotion'
        @ns_view ||= GraphicViewMac.from_graphic(self)
        @ns_view.save_pdf(path, options)
      elsif RUBY_ENGINE == 'ruby' 
        text = "\n@output_path = \"#{path}\"\n"
        text += @template
        system("echo '#{text}' | /Applications/rjob.app/Contents/MacOS/rjob")
      end
	  end
  end
	  
end