
Motion::Project::App.setup do |app|
  app.name = 'rlayout'
  app.frameworks << 'AppKit'
  Dir.glob(File.join(File.dirname(__FILE__), 'lib/**/*.rb')).each do |file|
    app.files.unshift(file)
  end
end
