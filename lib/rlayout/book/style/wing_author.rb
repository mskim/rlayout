module RLayout
  class WingAuthor < Container
    attr_reader :project_path
    def initialize(options={})
      super
      @project_path
      read_storry
      layout_story
      @pdf_path = @project_path + "/output.pdf"
      save_pdf(@pdf_path)
      self
    end

    def read_storry

    end

    def layout_story

    end


  end




  
end