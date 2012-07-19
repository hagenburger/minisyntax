Dir.glob(File.join(File.dirname(__FILE__), 'highlighter', '*.rb')) do |file|
  require file
end