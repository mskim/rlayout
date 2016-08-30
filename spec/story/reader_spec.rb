require File.dirname(__FILE__) + "/../spec_helper"

describe 'create Reader with sample story file' do
  before do

    sample_text =<<EOF
---
title: My Long Documnet Sample
author: Min Soo Kim
---

= First Section

[photo_page]

= Second Section

[image_group]
{image_path: "1.jpg", grid_frame: [0,0,1,1]}
{image_path: "2.jpg", grid_frame: [0,1,1,1]}
{image_path: "3.jpg", grid_frame: [0,2,1,1]}

= Third Section

== Section3-1

[image]
:image_path: "1.jpg"
:caption: "Some nice image"

EOF

  @reader  = Reader.new(sample_text)

end
  
  it 'shold create story' do
    assert @reader.class == Reader
  end
end

