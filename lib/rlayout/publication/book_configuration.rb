
# Book Configuration file
# This should go into users hidden downloaded folder
  
doc_info = {
  paper_size: 'A5',
  portrait: true,
  double_side: true,
  starting_page: 1,
}

chapter_starting_page_rule ={
  left_page: true,
  right_page: true,
}

chapter_heading_rule = {
  heading_layout_length: 1,
}

header_rule={
    :first_page_only  => true,
    :left_page        => false,
    :right_page       => false,
}

footer_rule={
    :first_page_only  => true,
    :left_page        => false,
    :right_page       => false,
}

text_styles={
  "title"   =>{:font => 'Times', :font_size=>18.0, :text_color => 'red', :text_alignment=>'center'},
  "subtitle"=>{:font => 'Times', :font_size=>16.0, :text_color => 'black'},
  "author"  =>{:font => 'Helvetica', :font_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "Lead"    =>{:font => 'Helvetica', :font_size=>14.0, :text_color => 'black'},
  "lead"    =>{:font => 'Helvetica', :font_size=>14.0, :text_color => 'black'},
  "leading" =>{:font => 'Times', :font_size=>18.0, :text_color => 'black'},
  "h1"      =>{:font => 'Helvetica', :font_size=>18.0, :text_color => 'black'},
  "h2"      =>{:font => 'Helvetica', :font_size=>18.0, :text_color => 'black'},
  "h3"      =>{:font => 'Helvetica', :font_size=>16.0, :text_color => 'black'},
  "h4"      =>{:font => 'Helvetica', :font_size=>14.0, :text_color => 'black'},
  "h5"      =>{:font => 'Helvetica', :font_size=>10.0, :text_color => 'black'},
  "head"    =>{:font => 'Helvetica', :font_size=>9.0, :text_color => 'black'},
  "h6"      =>{:font => 'Helvetica', :font_size=>9.0, :text_color => 'black'},
  "p"       =>{:font => 'Times', :font_size=>10.0, :text_line_spacing=>10, :text_alignment=>'left', :text_first_line_head_indent=>20},
  "Body"    =>{:font => 'Times', :font_size=>10.0, :text_line_spacing=>10, :text_alignment=>'left', :text_first_line_head_indent=>20},
  "body"    =>{:font => 'Times', :font_size=>10.0, :text_line_spacing=>10, :text_alignment=>'left', :text_first_line_head_indent=>20},
  "caption" =>{:font => 'Times', :font_size=>8.0, :text_color => 'black'},
  "header"  =>{:font => 'Times', :font_size=>8.0, :text_color => 'black'},
  "footer"  =>{:font => 'Times', :font_size=>8.0, :text_color => 'black'},
  "footer_page_number" =>{:font => 'Times', :font_size=>10.0, :text_color => 'black'},
}

toc_kind = %w[h1 h2 h3 h4 title subtitle author lead, head1, head2, h5, h6]

# image_placement_rule
# image_styles
