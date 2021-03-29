# GroupImageTable

# GroupImage implementation with BoxTable.
# image_data
# ImageCell
# CaptionCell

# image_data format yaml
# ['1.jpg', '2.jpg','3.jpg', '4.jpg' ]
module RLayout
  class GroupImageTable < BoxTable
    attr_rader :image_data, :images_folder


  end
end