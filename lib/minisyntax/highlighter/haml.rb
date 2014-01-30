module MiniSyntax
  module Highlighter
    module Haml
      def self.highlight(code)
        code.gsub! /^( *)(%[a-z1-9\-]+)?(([\.\#][a-z\-_]+)*)((&lt;)?(&gt;)?&?)(=.+?$)?/i do
          result = $1 || ''
          tag = $2
          classes_and_id = $3
          options = $5
          ruby = $8
          result << %Q(<em>#{tag}</em>) if tag
          result << %Q(<b>#{classes_and_id}</b>) unless classes_and_id.empty?
          result << options if options
          result << MiniSyntax.highlight(ruby, :ruby) if ruby
          result
        end
        code.gsub! /^((  )*)(-(.+?))$/ do
          %Q(#{$1}-#{MiniSyntax.highlight($4, :ruby)})
        end
        code
      end
    end
  end
end

MiniSyntax.register(:haml, MiniSyntax::Highlighter::Haml)
