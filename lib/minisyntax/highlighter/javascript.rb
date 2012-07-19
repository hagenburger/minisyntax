module MiniSyntax
  module Highlighter
    module JavaScript
      def self.highlight(code)
        keywords = %w(break continue do for import new this void case default else function in return typeof while comment delete export if label switch var with)
        keywords += %w(catch enum throw class extends try const finally debugger super)
        code.gsub! /\b(#{keywords.join('|')})\b/, "<em>\\1</em>"
        code.gsub! /\b([A-Z_][a-zA-Z0-9_]+)\b/, "<b>\\1</b>"
        code.gsub! /("(.*?)"|'.*?')/, "<q>\\1</q>"
        code.gsub! %r((//.*?)$) do |comment|
          if comment.gsub(%r(<q>(.*?)</q>), "\\1") =~ %r(</q>)
            comment
          else
            comment.gsub! %r(</?(b|i|em|var|code)>), ""
            %Q(<i>#{comment}</i>)
          end
        end
        code
      end
    end
  end
end

MiniSyntax.register(:javascript, MiniSyntax::Highlighter::JavaScript)