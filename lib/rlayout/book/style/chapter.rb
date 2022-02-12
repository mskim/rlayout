require 'yaml'

# MINSOO = "Minsoo"
# JEEYOON = "Jeejoon"
# Sungkun = "Sungkun"
# MINSOO = "Minsoo"
# SHINMOON = "Shinmoom"
# GOTHIC_L = "KoPubDotumPL"
# GOTHIC_M = "KoPubDotumPM"
# GOTHIC_B = "KoPubDotumPB"
# MYUNGJO_L = "KoPubBatangPL"
# MYUNGJO_M = "KoPubBatangPM"
# MYUNGJO_B = "KoPubBatangPB"i

module RLayout
  class RChapter
    def style_hash
      h = {
        doc_info: @doc_info,
        text_style: text_style,
        char_style: char_style,
      } 
    end

    def default_doc_info
      doc_info = {
        doc_type: 'chapter',
        paper_size: 'A4',
        starting_page_side: 'either',
        margins: [50,50,50,50],
        starting_page: 1,
        height_type: 'half'
        has_footer: true
      }
    end

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
          font_size: 24.0,
          text_alignment: 'left',
          # line_space: 'single' # half, single, double
        },
        subtitle: {
          font: 'Shinmoon',
          font_size: 18.0,
          text_alignment: 'center'
        },
        running_head: {
          font: 'Shinmoon',
          font_size: 12.0,
          markup: '#',
          text_alignment: 'left'
          space_before: 1
        },
        running_head_2: {
          font: 'Shinmoon',
          font_size: 11.0,
          markup: '##',
          text_alignment: 'middle'
          space_before: 1
        },
        running_head_3: {
          font: 'Shinmoon',
          font_size: 11.0,
          markup: '###',
          text_alignment: 'right'
          space_before: 1
        },
        footer: {
          font: 'Shinmoon',
          font_size: 7.0, 
        }
      }
    end
    
    def char_style 
      char_style = {
        itatic: { 
          font: 'Shinmoon',
          marker: "__"
        },
        bold: {
            font: 'Shinmoon',
          marker: "__" 
        }
      }
    end

    def footer_style
      footer_style = {
        left: 
          x: "@left_margin",
          text_string: "#{@page_number}",
        right:
          from_right: "@right_margin",
          text_string: "#{@chapter_title} #{@page_number}",
      }
    end

    def save_style(style_path)
      File.open(style_path, 'w'){|f| f.write style_hash.to_yaml}
    end
  end

end