# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minisyntax/version'

Gem::Specification.new do |gem|
  gem.name = 'minisyntax'
  gem.version = MiniSyntax::VERSION

  gem.authors       = ['Nico Hagenburger']
  gem.description   = 'A simple powerful syntax highlighter with minimal HTML output'
  gem.email         = ['nico@hagenburger.net']
  gem.homepage      = 'http://github.com/hagenburger/minisyntax'
  gem.licenses      = ['MIT']
  gem.summary       = 'A simple powerful syntax highlighter with minimal HTML output'
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.require_paths = ['lib']
end

