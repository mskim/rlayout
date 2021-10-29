module RLayout
  # Solution for automating PictureBook.
  # Layout information is stored in the folders with page name.
  # it is usually done by spread unit, rather than by page, so the folder name would be like
  # 02_03, 04_05, and so on. When single page is need it will have 10, 11. 
  # Folders should containing background picter_image and story for the spread.
  # Story can be place at 1:top_left, 2:top_right, 3:bottom_left, 4:bottom_right
  # layout_folder has layout.rb files 1_2.rb, 1_4.rb, 2_1.rb, 2_2.rb for various text story location.
  #

  class PictureBook

    attr_reader :project_path, :paper_size
    attr_reader :cover, :spreads, :layout_folder
    attr_reader :book_info, :picture_folders

    def initialize(project_path, options={})
      @project_path  = project_path
      @paper_size = options[:paper_size] || 'A4'
      read_book_info
      @picture_folders = parse_folders
      @picture_folders = @picture_folders.compact.sort
      build_book
      build_ebook
      self
    end

    def book_info_path
      @project_path + "/book_info.yml"
    end

    def read_book_info
      puts __method__
      t = File.open(book_info_path, 'r'){|f| f.read}
      @book_info = YAML::load(t)
    end

    def parse_folders
      puts __method__
      Dir.glob("#{@project_path}/**").map do |path|
        if File.basename(path) =~/^\d\d/
          path
        end
      end
    end

    def build_book
        puts __method__
        @picture_folders.each do |spread_path|
          @doc = RLayout::PictureSpread.new(document_path: spread_path)
        end
    end

    def build_ebook
      puts __method__

    end
  end


end