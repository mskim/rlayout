module RLayout

  # BoxAd is used as flexable design template for BoxAds.
  # BoxAd is used with web apps, Rails. 
  # BoxAd generates PDF output file.
  # It also provides form partial for rails with matching content.
  # html form is generated with label and value fields.

  class BoxAd < Container
    attr_reader :project_path, :content_path, :content
    attr_reader :layout_path

    def initialize(options={}, &block)
      @project_path = project_path
      data_file     = Dir.glob("#{project_path}/*.csv").first
      @item_data    = File.open(data_file, 'r'){|f| f.read}

      self
    end

    # phone
    # company
    # title
    # copy1
    # copy2
    # copy3

    def form_partial(form_key)
      s = ""
      content.each do |k,v|

      end

    end

    def content_path
      @project_path + "/content.yml"
    end

    def layout_path
      @project_path + "/layout.rb"
    end
    
    def output_path
      @project_path + "/output.pdf"
    end

    def generate_pdf

    end

    def default_layout_template
      s=<<~EOF
      RLayout::Container.new(width:#{@width}, height:#{@height}) do

      end

      EOF
    end
  end

end
