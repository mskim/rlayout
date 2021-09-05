module RLayout


  # The goal of Nogada is to allow designers to create re-usable Nogada, 
  # Instead of manually creating layout using Illusgtrator, designers should be able to "code" the design
  # so that developers do not have to hard coded the layout.
  # Designers should be able to design the layout with content set and corresponding layout.erb.

  # To accomplish this, we have two files, one for layout(layout.rb) and one for content(content.md), 
  # layout.rb and content.md is saved in Nogada project folder.
  # Designers should modify these two files to edit the layout.
  # layout.rb has layout information where and how the content should be placed.
  # content.md has text that goes in Nogada. It should be written in markdown format.
  # These two files are processed and PDF, jpg files are produced.
  
  # steps
  # 1. process is triggered by calling Nogada.new(project_path)
  # 2. layout.rb is read.
  # 3. content.md is read.
  # 4. contents  are layed-out.
  # 5. PDF,jpg is generated from layed-out 

  class Nogada
    attr_reader :project_path, :output_path, :column, :content
    def initialize(options={})
      @project_path = options[:project_path]
      FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
      
      kind = current_folder_kind
      case kind
      when 'book'
        Book.new(@project_path)
      when 'book_cover'
        BookCover.new(@project_path)
      when 'back_wing'
        BackWind.new(@project_path)
      when 'back_page'
        BackPage.new(@project_path)
      when 'seneca'
        Seneca.new(@project_path)
      when 'front_page'
        FrontPage.new(@project_path)
      when 'front_wing'
        FrontWing.new(@project_path)
      when 'prolog'
        Prolog.new(@project_path)
      when 'chapter'
        Chapter.new(@project_path)
      when 'appendix'
        Appendix.new(@project_path)
      when 'index'
        Index.new(@project_path)
      else
      end
    
    end

    def current_folder_kind
      # return "book" if @project_path =~/book$/
      return "book_cover" if @project_path =~/book_cover/
      return "back_wing" if @project_path =~/back_wing$/
      return "back_page" if @project_path =~/back_page$/
      return "seneca" if @project_path =~/seneca$/
      return "front_page" if @project_path =~/front_page$/
      return "front_wing" if @project_path =~/front_wing$/
      return "prolog" if @project_path =~/prolog$/
      return "chapter" if @project_path =~/chapter_\d/
      return "appendix" if @project_path =~/appendix/
      return "index" if @project_path =~/index/
    end

  end

end