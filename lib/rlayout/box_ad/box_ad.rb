module RLayout
  class BoxAd < Container
    attr_reader :project_path, :ad_content
    attr_reader :layout_template
    attr_reader :ouput_path

    def initialize(options={}, &block)
      super
      @project_path     = options[:project_path]
      @catagory         = options[:catagory]
      @ad_content       = options[:ad_content]
      @layout_template  = options[:layout_template]
      @advertiser       = @ad_content[:advertiser]
      @company          = @ad_content[:company].gsub(" ", "_")
      @email            = @ad_content[:email]
      @phone            = @ad_content[:phone]
      @phone            = @ad_content[:phone]
      @title            = @ad_content[:title]
      @subtitle         = @ad_content[:subtitle]
      @body             = @ad_content[:body]
      @slogan           = @ad_content[:slogan]
      @ouput_path       = @project_path + "/#{@company}.pdf"
      layout_content
      self
    end

    def layout_content
      erb = ERB.new(@layout_template )
      reault = erb.result(binding)
      reault.save_pdf(@ouput_path)
    end
  end
end