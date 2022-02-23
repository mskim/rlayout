require 'yaml'
module RLayout
  class WingBookPromo < DocumentBase

    def text_style
      text_style = {
        body: {
          font: 'Shinmoon',
          font_size: 11.0,
          text_alignment: 'justify'
          first_line_indent: 11.0
        },
        title: {
          font: 'Shinmoon',
          font_size: 16.0,
          text_alignment: 'left',
          # line_space: 'single' # half, single, double
        },
        subtitle: {
          font: 'Shinmoon',
          font_size: 14.0,
          text_alignment: 'center'
        },
        running_head: {
          font: 'Shinmoon',
          font_size: 12.0,
          markup: '#',
          text_alignment: 'left'
          space_before: 1
        },
      }
    end
    

  end

end