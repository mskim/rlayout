module RLayout
  module Commands
    module Opener
      extend self

      def open!
        book.open_in_browser
      end

      # Returns the book to be opened.
      def book
        RLayout::Book.new(origin: RLayout::Utils::source)
      end

    end
  end
end
