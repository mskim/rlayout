module RLayout
  class RDocument

    def save_svg(path, options={})
      @pages.each_with_index do |page, i|
        r_justed_page = (i+1).to_s.rjust(4,'0')
        path = dir + "/#{r_justed_page}.svg"
        page.save_svg(path)
      end

    end
  end

end
