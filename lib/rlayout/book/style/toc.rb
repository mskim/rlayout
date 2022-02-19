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
  class Toc
    include Styleable


    def default_text_style
      s=<<~EOF
      ---
      body:
        font: Shinmoon
        font_size: 11.0
        text_alignment: justify
        first_line_indent: 11.0
      title:
        font: KoPubBatangPB
        font_size: 16.0
        text_alignment: left
        text_line_spacing: 10
        space_before: 0
      subtitle:
        font: KoPubDotumPL
        font_size: 12.0
        text_color: 'DarkGray'
        text_alignment: center
        text_line_spacing: 5
        space_after: 20
      author:
        font: KoPubDotumPL
        font_size: 10.0
        text_color: 'DarkGray'
        text_alignment: right
        text_line_spacing: 5
        space_after: 10
      running_head:
        font: KoPubDotumPM
        font_size: 12.0
        markup: "#"
        text_alignment: left
        space_before: 1
      running_head_2:
        font: KoPubDotumPL
        font_size: 11.0
        markup: "##"
        text_alignment: middle
        space_before: 1
      body_gothic:
        font: KoPubDotumPM
        font_size: 12.0
        markup: "#"
        text_alignment: left
      footer:
        korean_name: 하단페이지번호
        font: KoPubBatangPM
        font_size: 7.0
      caption_title:
        korean_name: 사진제목
        font: KoPubDotumPB
        font_size: 9.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
      caption:
        korean_name: 사진설명
        font_family: KoPub돋움체_Pro Light
        font: KoPubDotumPL
        font_size: 7.5
        text_color: CMYK=0,0,0,100
        text_alignment: justify
      source:
        korean_name: 사진출처
        category:
        font_family: KoPub돋움체_Pro Light
        font: KoPubDotumPL
        font_size: 7.5
        text_color: CMYK=0,0,0,100
        text_alignment: right
        tracking: -0.2
      EOF

    end
    

    def save_style(style_path)
      File.open(style_path, 'w'){|f| f.write style_hash.to_yaml}
    end
  end

end