module RLayout

  class NewsPillarMaker
    attr_accessor :pillar_path, :pillar_config, :pillar_config_path


    def initialize(options={})
      time_start          = Time.now
      @time_stamp         = options[:time_stamp]
      @pillar_path        = options[:pillar_path]
      @pillar_config_path = @pillar_path + "/pillar_config.yml"
      unless File.exist?(@pillar_config_path)
        puts "no pillar_config.yml found!!!"
        return
      end
      time_end = Time.now
      read_pillar_config
      adjust_box_path
      # build_up_pillar_pdf
      self
    end

    def fillar_top?(folder)
      File.exist?(@pillar_path + "/pillar_config.yml")
    end

    def read_pillar_config
      @pillar_config = File.open(@pillar_config_path, 'r'){|f| f.read}
      config = YAML::load(@pillar_config)
      @pillar_frame = config[:pillar_frame]
      @pillar_rect = config[:pillar_rect]
    end
    
    def adjust_box_path
      @pillar_frame = @pillar_frame.map do |box|
        [box[0], box[1], box[2], box[3], box[4].split("_").join("/")]
      end
      puts "adjust path @pillar_frame "
      @pillar_frame
    end

    def are_siblings?(first, second)
      File.dirname(File.dirname(first)) == File.dirname(File.dirname(second))
    end

    # given changed folder, update pillar chain
    def update_pdf_chain(folder)
      if File.exist?(folder + "/pillar_config.yml")
        # this is last folder to go up
        pdfs = Dir.glob("#{folder}/*.pdf")
        merge_siblling(pdfs)
      else
        pdfs = Dir.glob("#{folder}/*.pdf")
        merge_siblling(pdfs)
        upper_folder = File.dirname(folder)
        update_pdf_chain(upper_folder)
      end
    end

    def merge_siblling(pdfs)
      puts __method__
      puts "pdfs:#{pdfs}"
      if pdfs.length <= 1
      else
        merged_file = File.dirname(File.dirname(pdfs.first)) + "/merged.pdf"
        system("touch #{merged_file}")
        return merged_file
      end
    end

    def build_up_pillar_pdf
      # if working_article is pillar_member?
      #   box height is adjust with content

      # check for sibling pdfs
      # merge the sibling pdfs and save them in upper foler


      pdf_files = Dir.glob("#{@pillar_path}/**/*.pdf")
      pdf_files =pdf_files.sort_by{|f| f.count("/")}.reverse

      puts "+++++++"
      puts pdf_files
      puts "+++++++"

      current_siblings = []
      first = pdf_files.shift
      current_siblings << first
      while next_pdf = pdf_files.shift
        if are_siblings?(first, next_pdf)
          current_siblings << next_pdf
        else
          pdf_files.unshift(merge_siblling(current_siblings))
          pdf_files =pdf_files.sort_by{|f| f.count("/")}.reverse
          current_siblings = []
          first = next_pdf
          current_siblings << first
        end
      end
      # sort them by the depth and order
      # process from the top group and eliminate the processed depth group

    end

  end

end