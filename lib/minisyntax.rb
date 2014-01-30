module MiniSyntax
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

