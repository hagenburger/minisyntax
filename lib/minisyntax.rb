module MiniSyntax
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 1
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end

  @@languages = {}

  def self.register(lang, lang_module)
    @@languages[lang] = lang_module
  end

  def self.highlight(code, lang)
    if highlighter = @@languages[lang.to_sym]
      highlighter.highlight(code)
    elsif lang.is_a?(String)
      lang.split(/\s*\+\s*/).each do |lang|
        code = highlight(code, lang.strip.to_sym)
      end
      code
    else
      code
    end
  end
end

require 'minisyntax/highlighter'

if defined? Rack
  require 'minisyntax/integration/rack'
end
