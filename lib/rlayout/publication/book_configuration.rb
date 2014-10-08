
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
  "title"   =>{:text_font => 'Times', :text_size=>18.0, :text_color => 'red', :text_alignment=>'center'},
  "subtitle"=>{:text_font => 'Times', :text_size=>16.0, :text_color => 'black'},
  "author"  =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "Lead"    =>{:text_font => 'Helvetica', :text_size=>14.0, :text_color => 'black'},
  "lead"    =>{:text_font => 'Helvetica', :text_size=>14.0, :text_color => 'black'},
  "leading" =>{:text_font => 'Times', :text_size=>18.0, :text_color => 'black'},
  "h1"      =>{:text_font => 'Helvetica', :text_size=>18.0, :text_color => 'black'},
  "h2"      =>{:text_font => 'Helvetica', :text_size=>18.0, :text_color => 'black'},
  "h3"      =>{:text_font => 'Helvetica', :text_size=>16.0, :text_color => 'black'},
  "h4"      =>{:text_font => 'Helvetica', :text_size=>14.0, :text_color => 'black'},
  "h5"      =>{:text_font => 'Helvetica', :text_size=>10.0, :text_color => 'black'},
  "head"    =>{:text_font => 'Helvetica', :text_size=>9.0, :text_color => 'black'},
  "h6"      =>{:text_font => 'Helvetica', :text_size=>9.0, :text_color => 'black'},
  "p"       =>{:text_font => 'Times', :text_size=>10.0, :text_line_spacing=>10, :text_alignment=>'left', :text_first_line_head_indent=>20},
  "Body"    =>{:text_font => 'Times', :text_size=>10.0, :text_line_spacing=>10, :text_alignment=>'left', :text_first_line_head_indent=>20},
  "body"    =>{:text_font => 'Times', :text_size=>10.0, :text_line_spacing=>10, :text_alignment=>'left', :text_first_line_head_indent=>20},
  "caption" =>{:text_font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "header"  =>{:text_font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "footer"  =>{:text_font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "footer_page_number" =>{:text_font => 'Times', :text_size=>10.0, :text_color => 'black'},
}

toc_kind = %w[h1 h2 h3 h4 title subtitle author lead, head1, head2, h5, h6]

# image_placement_rule
# image_styles
