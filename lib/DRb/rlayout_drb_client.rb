

require 'drb'
URI = "druby://127.0.0.1:8222"
layout_server = DRbObject.new_with_uri(URI)
puts layout_server.generate_book(options)