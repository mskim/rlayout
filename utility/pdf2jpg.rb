# convert pdf file to jpg
# using pdf_chapter

def	pdf2jpg(pdf_path)
  system("/Applications/pdf_chapter.app/Contents/MacOS/pdf_chapter #{pdf_path} -first_page_only")
end

pdf_path = "/Users/mskim/Documents/Customers/Nungyool/nasaro/pg_0001.pdf"
pdf_folder = "/Users/mskim/Documents/Customers/Nungyool/nasaro"
pdf2jpg(pdf_folder)