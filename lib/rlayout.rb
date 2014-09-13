require "rlayout/version"

require "rlayout/graphic"
require "rlayout/container"
require "rlayout/container_auto_layout"
require "rlayout/container_grid"
require "rlayout/text/rich_paragraph"
require "rlayout/heading"
require "rlayout/object_box"
require "rlayout/page"
require "rlayout/document"
require "rlayout/graphic_view_svg"

if RUBY_ENGINE == 'macruby'
  framework 'cocoa'
  require "rlayout/graphic_view_mac"
  require "rlayout/document_view_mac"
end


module RLayout
  # Your code goes here...
end
