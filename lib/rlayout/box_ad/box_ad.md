# BoxAd

## Data
___
title: This is title
subtitle: This is subtitle
subtitle: This is wonderful product you have been waining for
email: steve@apple.com
address: 100 DeAnsa Blvd. Cupertino, CA
www: apple.com
phone: 010-444-555
___

## layout

1. top level is layed out in vertical direction
2. second level is layed out in horizontal direction

["title", "subtitle", "body", ["www","phone"], "address" ]

## implematation strategy

1. given data, style_info, and width, height, 
  - create cells with given data
  - later, this will be used as relative size with other cells
2. Adjust row_size acoring to the heights of top leve cell
3. Adjust cell's size on each row to fit into row, 

