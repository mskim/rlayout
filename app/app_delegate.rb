class AppDelegate
  
  def main(argc, argv)
    # your code
    puts "Number of arguments:"
    p argc
    puts "Arguments:"
    p argv
    message =<<EOF
usgage 
  motion-rlayout [action_name] [path]
  example: 
    motion-rlayout photo_album my_photo_project/path
    motion-rlayout chapter my_book_project/path
    motion-rlayout news_article my_news_article/path
    motion-rlayout news_section my_new_section_project/path
    
  actions:
    photo_album, 
    chapter, book, 
    news_article, news_section
    magazine_article, magazine_section
    mart_flier, name_card, id_card, calendar, banner
    quiz_item, quiz_section
    catalog_item, catalog_section
    rlayout
EOF
    
    if argc > 2
    
      action = argv[1]
      path = argv[2]
      options = argv[2]
      
      puts "path:#{path}"
      puts "action:#{action}"
      
      case action
      when 'photo_book'
        puts "processing photo_book"
        RLayout::PhotoBook.new(path: path)
        
      when 'news_section'
        puts "processing news_section"
        RLayout::NewspaperSection.new(nil, options)
        
      when 'news_article'
        puts "processing news_section"
        RLayout::NewsArticle.new(nil, options)
        
      when 'chapter'
        puts "processing chapter"
        RLayout::Chapter.new(options)
        
      when 'book'
        puts "processing book"
        RLayout::Book.new(options)
        
      when 'mart_flier'
        puts "processing mart_flier"
        RLayout::Mart.new(nil, options)
        
      when 'name_card'
        puts "processing name_card"
        RLayout::NameCard.new(project_path: path)
        
      when 'id_card'
        puts "processing id_card"
        RLayout::IdCard.new(project_path: path)
      else
       puts message
      end
    else
      puts message
    end
      
  end
  
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.orderFrontRegardless
  end
end
