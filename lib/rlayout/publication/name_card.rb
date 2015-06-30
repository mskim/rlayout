
module RLayout
  
  class NameCard < Document
    attr_accessor :logo, :personal, :company, :image, :qr_code
    attr_accessor :logo_back, :personal_back, :conpany_back, :image_back, :qr_code_back
    
    def initialize(options={})
      options[paper_size: "NAMECARD"] unless options[:paper_size]
      options[double_side: true] unless options[:double_side]
      options[grid_base: "3x3"] unless options[:grid_base]
      super
      make_front_side(options)
      make_back_side(options)
      self
    end
    
    def make_front_side(options)
      if pages.length == 0
        page
      end
      front_page = @pages[0]
      if options[:logo]
        if options[:logo].class == RLayout::Container
          @logo = options[:logo]
          front_page.add_graphic @logo
        elsif options[:logo].class == Hash
          @logo = Container.new(front_page, options[:logo])
        end
      end
      
      if options[:personal]
        if options[:personal].class == RLayout::Container
          @personal = options[:personal]
          front_page.add_graphic @personal
        elsif options[:personal].class == Hash
          @personal = Container.new(front_page, options[:personal])
        end
      end
      
      if options[:company]
        if options[:company].class == RLayout::Container
          @company = options[:company]
          front_page.add_graphic @company
        elsif options[:company].class == Hash
          @company = Container.new(front_page, options[:company])
        end
      end
      
      if options[:image]
        if options[:image].class == RLayout::Container
          @image = options[:image]
          front_page.add_graphic @image
        elsif options[:image].class == Hash
          @image = Container.new(front_page, options[:image])
        end
      end
      
      if options[:qr_code]
        if options[:qr_code].class == RLayout::Container
          @qr_code = options[:qr_code]
          front_page.add_graphic @qr_code
        elsif options[:qr_code].class == Hash
          @qr_code = Container.new(front_page, options[:qr_code])
        end
      end
      
    end
    
    def make_back_side(options)      
      page
      back_page = @pages[1]
      if options[:logo_back]
        if options[:logo_back].class == RLayout::Container
          @logo_back = options[:logo_back]
          back_page.add_graphic @logo_back
        elsif options[:logo_back].class == Hash
          @logo_back = Container.new(back_page, options[:logo_back])
        end
      end
      
      if options[:personal_back]
        if options[:personal_back].class == RLayout::Container
          @personal_back = options[:personal_back]
          back_page.add_graphic @personal_back
        elsif options[:personal_back].class == Hash
          @personal_back = Container.new(back_page, options[:personal_back])
        end
      end
      
      if options[:company_back]
        if options[:company_back].class == RLayout::Container
          @company_back = options[:company_back]
          back_page.add_graphic @company_back
        elsif options[:company_back].class == Hash
          @company_back = Container.new(back_page, options[:company_back])
        end
      end
      
      if options[:image_back]
        if options[:image_back].class == RLayout::Container
          @image_back = options[:image_back]
          back_page.add_graphic @image_back
        elsif options[:image_back].class == Hash
          @image_back = Container.new(back_page, options[:image_back])
        end
      end
      
      if options[:qr_code_back]
        if options[:qr_code_back].class == RLayout::Container
          @qr_code_back = options[:qr_code_back]
          back_page.add_graphic @qr_code_back
        elsif options[:qr_code_back].class == Hash
          @qr_code_back = Container.new(back_page, options[:qr_code_back])
        end
      end
    end
  end
  
end