# encoding: utf-8

# NewsBoxMaker.
# NewsBoxMaker works with given folder with story.md, layout.rb, and images
# layout.rb defines the layout of the article.
#
# NEWSPAPER_STYLE = {"body"=>{"name"=>"본문명조", "font_family"=>"윤신문명조", "font"=>"YDVYSinStd", "font_size"=>9.6, "text_color"=>"black", "alignment"=>"justified", "tracking"=>-0.5, "space_width"=>5.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
# "body_gothic"=>{"name"=>"본문고딕", "font_family"=>"윤고딕120", "font"=>"YDVYGOStd12", "font_size"=>9.4, "text_color"=>"black", "alignment"=>"justified", "tracking"=>-0.5, "space_width"=>5.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
# "running_head"=>{"name"=>"본문중제", "font_family"=>"윤고딕130", "font"=>"YDVYGOStd13", "font_size"=>9.6, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>5.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
# "quote"=>{"name"=>"발문", "font_family"=>"윤명조130", "font"=>"YDVYMjOStd13", "font_size"=>12.0, "text_color"=>"black", "alignment"=>"center", "tracking"=>-0.5, "space_width"=>6.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
# "related_story"=>{"name"=>"관련기사", "font_family"=>"윤고딕120", "font"=>"YDVYGOStd12", "font_size"=>9.4, "text_color"=>"black", "alignment"=>"right", "tracking"=>-0.5, "space_width"=>5.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
# "caption_title"=>{"name"=>"사진제목", "font_family"=>"윤고딕140", "font"=>"YDVYGOStd14", "font_size"=>8.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>4.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
# "caption"=>{"name"=>"사진설명", "font_family"=>"윤고딕120", "font"=>"YDVYGOStd12", "font_size"=>8.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>4.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
# "source"=>{"name"=>"사진출처", "font_family"=>"윤고딕120", "font"=>"YDVYGOStd12", "font_size"=>7.0, "text_color"=>"black", "alignment"=>"right", "tracking"=>-0.5, "space_width"=>4.0, "scale"=>80.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
# "reporter"=>{"name"=>"기자명", "font_family"=>"윤고딕120", "font"=>"YDVYGOStd12", "font_size"=>8.0, "text_color"=>"black", "alignment"=>"right", "tracking"=>-0.5, "space_width"=>5.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
#
# 'subject_head_L'  => {font: 'YDVYGOStd14', font_size: 18.0, alignment: 'left', tracking: -0.5, text_color: "black", space_width: 9.0, space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
# 'subject_head_M'  => {font: 'YDVYGOStd14', font_size: 14.0, alignment: 'left', tracking: -0.5, text_color: "black", space_width: 7.0, space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
# 'subject_head_S'  => {font: 'YDVYGOStd14', font_size: 12.0, alignment: 'left', tracking: -0.5, text_color: "black", space_width: 5.0, space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#
# "title_main"=>{"name"=>"제목_메인", "font_family"=>"윤명조150", "font"=>"YDVYMjOStd15", "font_size"=>42.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>21.0, "scale"=>100.0, "text_line_spacing"=>20, "space_before_in_lines"=>1, "space_after_in_lines"=>0, "text_height_in_lines"=>3, "box_attributes"=>nil, "publication_id"=>1},
# "title_4_5"=>{"name"=>"제목_4-5단", "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>32.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>18.0, "scale"=>100.0, "text_line_spacing"=>16, "space_before_in_lines"=>1, "space_after_in_lines"=>2, "text_height_in_lines"=>3, "box_attributes"=>nil, "publication_id"=>1},
# "title_3"=>{"name"=>"제목_3단", "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>26.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>13.0, "scale"=>100.0, "text_line_spacing"=>13, "space_before_in_lines"=>1, "space_after_in_lines"=>2, "text_height_in_lines"=>2, "box_attributes"=>nil, "publication_id"=>1},
# "title_2"=>{"name"=>"제목_2단", "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>22.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>11.0, "scale"=>100.0, "text_line_spacing"=>11, "space_before_in_lines"=>1, "space_after_in_lines"=>2, "text_height_in_lines"=>2, "box_attributes"=>nil, "publication_id"=>1},
# "title_1"=>{"name"=>"제목_1단", "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>15.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>7.0, "scale"=>100.0, "text_line_spacing"=>7, "space_before_in_lines"=>1, "space_after_in_lines"=>2, "text_height_in_lines"=>2, "box_attributes"=>nil, "publication_id"=>1},
# "subtitle_main"=>{"name"=>"부제_메인", "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>18.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>9.0, "scale"=>100.0, "text_line_spacing"=>7.0, "space_before_in_lines"=>1, "space_after_in_lines"=>2, "text_height_in_lines"=>2, "box_attributes"=>nil, "publication_id"=>1},
# "subtitle_M"=>{"name"=>"부제_14", "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>14.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>7.0, "scale"=>100.0, "text_line_spacing"=>5, "space_before_in_lines"=>0, "space_after_in_lines"=>1, "text_height_in_lines"=>2, "box_attributes"=>nil, "publication_id"=>1},
# "subtitle_S"=>{"name"=>"부제_12", "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>12.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>6.0, "scale"=>100.0, "text_line_spacing"=>4, "space_before_in_lines"=>0, "space_after_in_lines"=>1, "text_height_in_lines"=>2, "box_attributes"=>nil, "publication_id"=>1},
# "news_line_title"=>{"name"=>"뉴스라인_제목", "font_family"=>"윤고딕120", "font"=>"YDVYGOStd12", "font_size"=>13.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>6.0, "scale"=>nil, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
# "brand_name"=>{"name"=>"애드_브랜드명", "font_family"=>"윤고딕130", "font"=>"YDVYMjOStd13", "font_size"=>13.0, "text_color"=>"black", "alignment"=>"center", "tracking"=>-0.5, "space_width"=>6.0, "scale"=>nil, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
# "name_tag-18"=>{"name"=>"문패_18", "font_family"=>"윤고딕140", "font"=>"YDVYGOStd14", "font_size"=>18.0, "color"=>"CMYK=100,60,0,0", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>9.0, "scale"=>nil, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
# "name_tag-14"=>{"name"=>"문패_14", "font_family"=>"윤고딕140", "font"=>"YDVYGOStd14", "font_size"=>14.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>7.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
# "name_tag-12"=>{"name"=>"문패_12", "font_family"=>"윤고딕140", "font"=>"YDVYGOStd14", "font_size"=>12.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>6.0, "scale"=>nil, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
# "editor_note"=>{"name"=>"편집자주", "font_family"=>"윤고딕130", "font"=>"YDVYGOStd13", "font_size"=>8.8, "color"=>"CMYK=0,0,0,80", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>5.0, "scale"=>nil, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1}}

NEWSPAPER_STYLE = {
"body"=>{"korean_name"=>"본문명조", "category"=>nil, "font_family"=>"조선일보명조", "font"=>"ChosunilboNM", "font_size"=>9.6, "text_color"=>"black", "alignment"=>"justified", "tracking"=>-0.4, "space_width"=>3.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"body_gothic"=>{"korean_name"=>"본문고딕", "category"=>nil, "font_family"=>"KoPub돋움체_Pro Light", "font"=>"KoPubDotumPL", "font_size"=>9.4, "text_color"=>"black", "alignment"=>"justified", "tracking"=>-0.2, "space_width"=>3.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"running_head"=>{"korean_name"=>"본문중제", "category"=>nil, "font_family"=>"KoPub돋움체_Pro Medium", "font"=>"KoPubDotumPM", "font_size"=>9.4, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.1, "space_width"=>3.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"quote"=>{"korean_name"=>"발문", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Medium", "font"=>"KoPubBatangPM", "font_size"=>12.0, "text_color"=>"black", "alignment"=>"center", "tracking"=>-0.5, "space_width"=>6.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"related_story"=>{"korean_name"=>"관련기사", "category"=>nil, "font_family"=>"KoPub돋움체_Pro Medium", "font"=>"KoPubDotumPM", "font_size"=>9.0, "text_color"=>"black", "alignment"=>"right", "tracking"=>-0.5, "space_width"=>3.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"caption_title"=>{"korean_name"=>"사진제목", "category"=>nil, "font_family"=>"KoPub돋움체_Pro Bold", "font"=>"KoPubDotumPB", "font_size"=>9.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.2, "space_width"=>2.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"caption"=>{"korean_name"=>"사진설명", "category"=>nil, "font_family"=>"KoPub돋움체_Pro Light", "font"=>"KoPubDotumPL", "font_size"=>7.5, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>1.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"source"=>{"korean_name"=>"사진출처", "category"=>nil, "font_family"=>"KoPub돋움체_Pro Light", "font"=>"KoPubDotumPL", "font_size"=>7.5, "text_color"=>"black", "alignment"=>"right", "tracking"=>-0.2, "space_width"=>2.0, "scale"=>70.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"reporter"=>{"korean_name"=>"기자명", "category"=>nil, "font_family"=>"KoPub돋움체_Pro Light", "font"=>"KoPubDotumPL", "font_size"=>7.0, "text_color"=>"black", "alignment"=>"right", "tracking"=>0.0, "space_width"=>2.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"title_main"=>{"korean_name"=>"제목_메인", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Bold", "font"=>"KoPubBatangPB", "font_size"=>42.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-1.0, "space_width"=>10.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>1, "space_after_in_lines"=>0, "text_height_in_lines"=>3, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"title_4_5"=>{"korean_name"=>"제목_4-5단", "category"=>nil, "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>32.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-1.5, "space_width"=>10.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>1, "space_after_in_lines"=>2, "text_height_in_lines"=>2, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"title_4"=>{"korean_name"=>"제목_4단", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Medium", "font"=>"KoPubBatangPM", "font_size"=>30.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-2.0, "space_width"=>7.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>1, "space_after_in_lines"=>2, "text_height_in_lines"=>2, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"title_3"=>{"korean_name"=>"제목_3단", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Medium", "font"=>"KoPubBatangPM", "font_size"=>27.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-2.0, "space_width"=>4.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>1, "space_after_in_lines"=>2, "text_height_in_lines"=>2, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"title_2"=>{"korean_name"=>"제목_2단", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Medium", "font"=>"KoPubBatangPM", "font_size"=>23.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-2.0, "space_width"=>4.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>1, "space_after_in_lines"=>2, "text_height_in_lines"=>2, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"title_1"=>{"korean_name"=>"제목_1단", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Medium", "font"=>"KoPubBatangPM", "font_size"=>18.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-2.0, "space_width"=>4.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>1, "space_after_in_lines"=>1, "text_height_in_lines"=>2, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"subtitle_main"=>{"korean_name"=>"부제_메인", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Medium", "font"=>"KoPubBatangPM", "font_size"=>18.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-1.0, "space_width"=>5.0, "scale"=>100.0, "text_line_spacing"=>6.0, "space_before_in_lines"=>1, "space_after_in_lines"=>2, "text_height_in_lines"=>2, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"subtitle_M"=>{"korean_name"=>"부제_14", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Medium", "font"=>"KoPubBatangPM", "font_size"=>14.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-1.0, "space_width"=>5.0, "scale"=>100.0, "text_line_spacing"=>7.0, "space_before_in_lines"=>0, "space_after_in_lines"=>1, "text_height_in_lines"=>2, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"subtitle_S"=>{"korean_name"=>"부제_12", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Medium", "font"=>"KoPubBatangPM", "font_size"=>12.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-1.0, "space_width"=>4.0, "scale"=>100.0, "text_line_spacing"=>6.0, "space_before_in_lines"=>0, "space_after_in_lines"=>1, "text_height_in_lines"=>2, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"news_line_title"=>{"korean_name"=>"뉴스라인_제목", "category"=>nil, "font_family"=>"KoPub돋움체_Pro Medium", "font"=>"KoPubDotumPM", "font_size"=>13.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>3.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"brand_name"=>{"korean_name"=>"애드_브랜드명", "category"=>nil, "font_family"=>"KoPub돋움체_Pro Medium", "font"=>"KoPubDotumPM", "font_size"=>13.0, "text_color"=>"black", "alignment"=>"center", "tracking"=>-0.5, "space_width"=>3.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"subject_head_L"=>{"korean_name"=>"문패_18", "category"=>nil, "font_family"=>"KoPub돋움체_Pro Bold", "font"=>"KoPubDotumPB", "font_size"=>18.0, "text_color"=>"CMYK=100,50,0,0", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>0.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"subject_head_M"=>{"korean_name"=>"문패_14", "category"=>nil, "font_family"=>"KoPub돋움체_Pro Bold", "font"=>"KoPubDotumPB", "font_size"=>14.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>3.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"subject_head_S"=>{"korean_name"=>"문패_12", "category"=>nil, "font_family"=>"KoPub돋움체_Pro Bold", "font"=>"KoPubDotumPB", "font_size"=>12.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>3.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"editor_note"=>{"korean_name"=>"편집자주", "category"=>nil, "font_family"=>"KoPub돋움체_Pro Medium", "font"=>"KoPubDotumPM", "font_size"=>8.8, "text_color"=>"CMYK=0,0,0,80", "alignment"=>"left", "tracking"=>-0.3, "space_width"=>3.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"title_opinion"=>{"korean_name"=>"기고 제목", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Medium", "font"=>"KoPubBatangPM", "font_size"=>22.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-1.5, "space_width"=>7.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"title_editorial"=>{"korean_name"=>"사설 제목", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Medium", "font"=>"KoPubBatangPM", "font_size"=>18.0, "text_color"=>"black", "alignment"=>"left", "tracking"=>-1.5, "space_width"=>5.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>nil, "space_after_in_lines"=>nil, "text_height_in_lines"=>nil, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"title_7"=>{"korean_name"=>"제목_7단", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Medium", "font"=>"KoPubBatangPM", "font_size"=>36.0, "text_color"=>"", "alignment"=>"left", "tracking"=>-2.0, "space_width"=>7.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>1, "space_after_in_lines"=>2, "text_height_in_lines"=>2, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"title_6"=>{"korean_name"=>"제목_6단", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Medium", "font"=>"KoPubBatangPM", "font_size"=>34.0, "text_color"=>"", "alignment"=>"left", "tracking"=>-2.0, "space_width"=>7.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>1, "space_after_in_lines"=>2, "text_height_in_lines"=>2, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"title_5"=>{"korean_name"=>"제목_5단", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Medium", "font"=>"KoPubBatangPM", "font_size"=>32.0, "text_color"=>"", "alignment"=>"left", "tracking"=>-2.0, "space_width"=>7.0, "scale"=>nil, "text_line_spacing"=>nil, "space_before_in_lines"=>1, "space_after_in_lines"=>2, "text_height_in_lines"=>2, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"title_main_7"=>{"korean_name"=>"제목_메인_7", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Bold", "font"=>"KoPubBatangPB", "font_size"=>45.0, "text_color"=>"", "alignment"=>"left", "tracking"=>-1.0, "space_width"=>10.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>1, "space_after_in_lines"=>0, "text_height_in_lines"=>3, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"title_main_6"=>{"korean_name"=>"제목_메인_6", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Bold", "font"=>"KoPubBatangPB", "font_size"=>45.0, "text_color"=>"", "alignment"=>"left", "tracking"=>-1.0, "space_width"=>10.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>1, "space_after_in_lines"=>0, "text_height_in_lines"=>3, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1},
"title_main_5"=>{"korean_name"=>"제목_메인_5", "category"=>nil, "font_family"=>"KoPub바탕체_Pro Bold", "font"=>"KoPubBatangPB", "font_size"=>42.0, "text_color"=>"", "alignment"=>"left", "tracking"=>-1.0, "space_width"=>10.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>1, "space_after_in_lines"=>0, "text_height_in_lines"=>3, "box_attributes"=>"", "markup"=>"", "dynamic_style"=>"", "publication_id"=>1}}

# front_page_heading_height: height of frontpage heading in lines
# inner_page_heading_height: height of innerpage heading in lines
# page_heading_margin_in_lines: actual heading margin for top positined article

module RLayout

  class NewsBoxMaker
    attr_accessor :article_path, :template, :story_path, :image_path
    attr_accessor :news_box, :style, :output_path, :project_path
    attr_reader :article_info_path, :paragraphs_copy, :fill_up_enpty_lines
    attr_accessor :custom_style, :publication_name

    def initialize(options={} ,&block)
      @story_path = options[:story_path]
      if options[:story_path]
        @story_path = options[:story_path]
        unless File.exist?(@story_path)
          puts "No story_path doen't exist !!!"
          return
        end
        @article_path = File.dirname(@story_path)
        @output_path  = @article_path + "/story.pdf"
      elsif options[:article_path]
        @article_path = options[:article_path]
        puts "@article_path:#{@article_path}"
        unless File.directory?(@article_path)
          puts "article_path doesn't exit !!!"
          return
        end

        @story_path = Dir.glob("#{@article_path}/*{.md, .markdown}").first

        if @story_path
          ext = File.extname(@story_path)
          @output_path  = @article_path + "/#{File.basename(@story_path, ext)}" + ".pdf"
        else
          @output_path  = @article_path + "/output.pdf"
        end
      end

      $ProjectPath      = @article_path
      @custom_style     = options[:custom_style] if options[:custom_style]
      @publication_name = options[:publication_name] if options[:publication_name]
      # puts "@custom_style:#{@custom_style}"
      # puts "@publication_name:#{@publication_name}"
      RLayout::StyleService.shared_style_service.current_style = NEWSPAPER_STYLE

      if @custom_style && @publication_name
        @custom_style_path = "/Users/Shared/SoftwareLab/newsman/#{@publication_name}/text_style.yml"
        if File.exist?(@custom_style_path)
          custom_style_yaml = File.open(@custom_style_path, 'r'){|f| f.read}
          @custom_style = YAML::load(custom_style_yaml)
          RLayout::StyleService.shared_style_service.current_style = @custom_style
        else
          puts "No custom style file :#{@custom_style_path} found !!!"
          return
        end
      end

      if options[:image_path]
        @image_path = options[:image_path]
      else
        @image_path = @article_path + "/images"
      end
      if options[:output_path]
        @output_path = options[:output_path]
      end

      unless @output_path
        @output_path = $ProjectPath + "/output.pdf"
      end
      @svg_path           = @output_path.sub(".pdf", ".svg")
      @article_info_path  = @article_path + "/article_info.yml"
      if options[:template_path] && File.exist?(options[:template_path])
        @template_path = options[:template_path]
      else
        @template_path = Dir.glob("#{@article_path}/*.{rb,script,pgscript}").first
      end
      unless @template_path
        puts "No layout  found !!!"
        return
      end
      template = File.open(@template_path,'r'){|f| f.read}
      @news_box       = eval(template)
      if @news_box.is_a?(SyntaxError)
        puts "SyntaxError in #{@template_path} !!!!"
        return
      end
      if @news_box.is_a?(NewsImageBox)
        @news_box.stroke.sides = [0,0,0,1]
        @news_box.stroke.thickness = 0.3
      elsif @news_box.is_a?(NewsComicBox)
      elsif @news_box.is_a?(NewsArticleBox)
        read_story
        layout_story
      elsif @news_box.is_a?(NewsAdBox)
        # puts "@news_box is ad_box..."
      elsif @news_box.is_a?(Container)
        # puts "@news_box is container..."
      else
        # puts "@news_box is Graphic..."
      end
      if RUBY_ENGINE =="rubymotion"
        puts "@output_path:#{@output_path}"
        @news_box.save_pdf(@output_path, :jpg=>true)
      else
        @news_box.save_svg(@svg_path)
      end
      self
    end

    def read_story
      @story                  = Story.new(@story_path).markdown2para_data
      @heading                = @story[:heading] || {}
      @heading[:is_front_page]= @news_box.is_front_page
      @heading[:top_story]    = @news_box.top_story
      @heading[:top_position] = @news_box.top_position
      if @heading
        @news_box.make_article_heading(@heading)
        # make other floats quotes, opinition writer's personal_picture
        @news_box.make_floats(@heading)
      end

      @paragraphs =[]
      @story[:paragraphs].each do |para|
        para_options = {}
        para_options[:markup]         = para[:markup]
        para_options[:layout_expand]  = [:width]
        para_options[:para_string]    = para[:para_string]
        para_options[:article_type]   = "news_article"
        para_options[:text_fit]       = FIT_FONT_SIZE
        para_options[:layout_lines]   = false
        @paragraphs << NewsParagraph.new(para_options)
      end
    end

    def layout_comic_article
      #code
    end

    def layout_story
      @news_box.layout_floats!
      @news_box.adjust_overlapping_columns
      @news_box.layout_items(@paragraphs)
    end

    # copy current_;pargraphs until qwh hAVE 1 line for reposter
    def fill_with_paragraphs

      # story_path          = "#{$ProjectPath}/story.md"
      # need_chars          = average_characters_per_line*(@empty_lines - 1)
      # base_string         = "여기는 본문이 입니다. "
      # string_half_length  = base_string.length/2
      # target_chart_count  = need_chars - string_half_length
      # puts "target_chart_count:#{target_chart_count}"
      # sample_string       = "\n\n" + base_string
      # count = 0
      # while  sample_string.length < target_chart_count && count < 100 do
      #   sample_string += base_string
      #   count +=1
      #   mutiples = count % 20
      #   if mutiples == 0
      #     sample_string +="\n\n"
      #   end
      # end
      # sample_string += "\n\n\# 홍깅돌 기자 gdhong@naver.com"
      # story = File.open(story_path, 'r'){|f| f.read}
      # story += sample_string
      # File.open(story_path, 'w'){|f| f.write story}
    end

    def draw_line_grids
      @graphics.each do |column|
        column.draw_line_rect
      end
    end
  end
end
