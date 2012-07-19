module MiniSyntax
  module Highlighter
    module YAML
      def self.highlight(code)
        code.gsub! /^(  )*([a-z_-]+:)/, "\\1<b>\\2</b>"
        code.gsub! /(\#([^\{].*?)?)\n/, "<i>\\1</i>\n"
        code
      end
    end
  end
end

MiniSyntax.register(:yaml, MiniSyntax::Highlighter::YAML)