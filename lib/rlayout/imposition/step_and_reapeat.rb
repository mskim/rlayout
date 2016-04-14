#
#  step_and_reapeat.rb
#  CaraYongImposition
#
#  Created by Min Soo Kim on 2/19/12.
#  Copyright 2012 __MyCompanyName__. All rights reserved.
#
# framework 'cocoa'
# framework 'Quartz'


def mm2pt(mm)
  if mm.kind_of?(NSSize)
    NSSize.new(mm2pt(mm.width), mm2pt(mm.height))
  elsif mm.kind_of?(NSRect)
    NSRect.new(NSPoint.new(mm2pt(mm.origin.x), mm2pt(mm.origin.y)), NSSize.new(mm2pt(mm.size.width), mm2pt(mm.size.height)))
  else
    mm * 2.834646
  end
end

# StepPageView draws front and back side as @front_page_mode is true or false
# It return PDF page data to object that calls paf_data
# In this case StepAndRepeatCard calls StepPageView 

class StepPageView <NSView
  # front_page_mode: we have two drawing mode, one is for front side page and other mode is when printing back side page. 
  #{}"front_page_mode=true" indicates front page printing mode
  attr_accessor :front_page_mode, :right_most_x, :card_width, :card_height, :x_margin, :y_margin, :rows, :columns, :card_front_side, :card_back_side, :delivery_address
  def initWithFrame(r)
    super
    # @card_width=150
    # @card_height=90
    @x_margin=mm2pt(7)
    @y_margin=mm2pt(11)
    @x_gutter=mm2pt(7.556)
    @y_gutter=mm2pt(3.5278)
    @front_page_mode=true
    @bleed=mm2pt(1)
    
    self
  end
  
  def isFlipped
    true
  end
  
  def drawRect(r)
    NSColor.grayColor.set
    x=@x_margin
    y=@y_margin
    
    @card_size=mm2pt(NSSize.new(90,50))
    @right_most_x=bounds.size.width- (@x_margin+@card_size.width) 
    @rows.times do |row|
      if @front_page_mode
        card_image = @card_front_side
      else
        card_image = @card_back_side
      end
      return unless card_image
      x=@x_margin 
      @columns.times do |c|
        point=NSPoint.new(x,y)
        rect=NSRect.new(point,@card_size)
        bleed_rect=NSInsetRect(rect, -@bleed,-@bleed)
        card_image.drawInRect(rect, fromRect: NSMakeRect(0.0, 0.0, @card_size.width, @card_size.height), operation: NSCompositeSourceOver, fraction: 1.0, respectFlipped:true, hints:nil)
        draw_registation_mark_around_card(rect) if @front_page_mode
        # @card_image.drawInRect(bleed_rect, fromRect:NSZeroRect, operation: NSCompositeSourceOver, fraction: 1.0, respectFlipped:true, hints:nil)
        x+=@card_size.width+@x_gutter
      end  
      y+=@card_size.height+@y_gutter
      draw_delivery_address     
    end
    # draw_starting_mark_bar
  end
  
  def draw_starting_mark_bar
    rect=NSMakeRect(190,8,50,2)
    NSColor.blackColor.set
		NSRectFill(mm2pt(rect))
  end
  
  def draw_registation_mark_around_card(rect)
    path= NSBezierPath.bezierPath
    # left top
    path.moveToPoint(NSPoint.new(rect.origin.x,rect.origin.y-2))
    path.lineToPoint(NSPoint.new(rect.origin.x,rect.origin.y-4))
    path.stroke 
    path.moveToPoint(NSPoint.new(rect.origin.x-2,rect.origin.y))
    path.lineToPoint(NSPoint.new(rect.origin.x-4,rect.origin.y))
    path.stroke 
    # right top
    path.moveToPoint(NSPoint.new(rect.origin.x+ rect.size.width+2,rect.origin.y))
    path.lineToPoint(NSPoint.new(rect.origin.x+ rect.size.width+4,rect.origin.y))
    path.stroke 
    path.moveToPoint(NSPoint.new(rect.origin.x+ rect.size.width,rect.origin.y-2))
    path.lineToPoint(NSPoint.new(rect.origin.x+ rect.size.width,rect.origin.y-4))
    path.stroke 
    # right bottom
    path.moveToPoint(NSPoint.new(rect.origin.x+ rect.size.width+2,rect.origin.y+rect.size.height))
    path.lineToPoint(NSPoint.new(rect.origin.x+ rect.size.width+4,rect.origin.y+rect.size.height))
    path.stroke 
    path.moveToPoint(NSPoint.new(rect.origin.x+ rect.size.width,rect.origin.y+rect.size.height+2))
    path.lineToPoint(NSPoint.new(rect.origin.x+ rect.size.width,rect.origin.y+rect.size.height+4))
    path.stroke 
    # left bottom
    path.moveToPoint(NSPoint.new(rect.origin.x-2,rect.origin.y+rect.size.height))
    path.lineToPoint(NSPoint.new(rect.origin.x-4,rect.origin.y+rect.size.height))
    path.stroke 
    path.moveToPoint(NSPoint.new(rect.origin.x, rect.origin.y+rect.size.height+2))
    path.lineToPoint(NSPoint.new(rect.origin.x, rect.origin.y+rect.size.height+4))
    path.stroke 
  end
  
  def draw_delivery_address
    
  end
  
  # def save_pdf(path)
  #   dataWithPDFInsideRect(bounds).writeToFile(path, atomically:true)
  # end
  
  def paf_data
    self.dataWithPDFInsideRect(bounds)
  end
  
end

# StepAndRepeatCard
class StepAndRepeatCard
  attr_accessor :card_path, :step_pdf_path, :view, :card_width, :card_height
  attr_accessor :page_size, :rows, :columns, :x_margin, :y_margin, :x_gutter, :y_gutter
  def initialize(card_path, options={})
    @card_path= card_path
    if options[:step_pdf_path]
      @step_pdf_path= options[:step_pdf_path]
    else
      @step_pdf_path= @card_path.gsub(".pdf", "_snp.pdf")
    end
    @page_size= options.fetch(:page_size,'A3')
    @rows     = options.fetch(:rows,6)
    @columns  = options.fetch(:columns,4)
    @x_margin = options.fetch(:x_margin,10)
    @y_margin = options.fetch(:y_margin,10)
    @x_gutter = options.fetch(:x_gutter,2)
    @y_gutter = options.fetch(:y_gutter,2)

    @x_margin = mm2pt(@x_margin)
    @y_margin = mm2pt(@y_margin)
    @x_gutter = mm2pt(@x_gutter)
    @y_gutter = mm2pt(@y_gutter)
    
    if @page_size=="A4"      
      @frame=NSRect.new(NSPoint.new(0,0),NSSize.new(mm2pt(595.28), mm2pt(841.89)))
    elsif @page_size=="A3"
      # @frame=NSRect.new(NSPoint.new(0,0),NSSize.new(1190.55, 841.89))
      @frame=NSRect.new(NSPoint.new(0,0),NSSize.new(mm2pt(315), mm2pt(467)))
      @columns=3
      @rows=8
    end    
    @view=StepPageView.alloc.initWithFrame(@frame)
    @view.rows=@rows
    @view.columns=@columns
    @view.x_margin=@x_margin
    @view.y_margin=@y_margin
    @x_gutter=@x_gutter
    @y_gutter=@y_gutter
    
    @card_pdf=PDFDocument.alloc.initWithURL(NSURL.fileURLWithPath card_path)
    @view.card_front_side =NSImage.alloc.initWithData(@card_pdf.pageAtIndex(0).dataRepresentation)
    # check if the pdf file is two page document
    if @card_pdf.pageCount > 1
      puts "++++++ @card_pdf.pageCount:#{@card_pdf.pageCount}"
      @view.card_back_side =NSImage.alloc.initWithData(@card_pdf.pageAtIndex(1).dataRepresentation)
    else
      puts "++++++ @card_pdf.pageCount:#{@card_pdf.pageCount}"
      @view.card_back_side = nil
    end
    @view.delivery_address=File.basename(card_path).gsub(".pdf","")    
    save_pdf(@step_pdf_path)
  end 

  def save_pdf(pdf_path)
    pdfdoc = PDFDocument.alloc.initWithData @view.paf_data
    # set the mode to draw back page
    @view.front_page_mode=false
    page=PDFDocument.alloc.initWithData(@view.paf_data).pageAtIndex(0)
    # append back page pdf
    pdfdoc.insertPage(page, atIndex:1)
    pdfdoc.writeToFile(pdf_path)
  end
  
  # this pdf_folder
  def self.process_folder(pdf_folder, options={})
    Dir.glob("#{pdf_folder}/*.pdf").each do |card_pdf|
      basename = File.basename(card_pdf, ".pdf")
      output_path = pdf_folder + "#{basename}_snp.pdf"
      StepAndRepeatCard.new(card_path, output_path)        
    end
    
  end
  
end


