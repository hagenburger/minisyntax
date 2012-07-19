module MiniSyntax
  module Highlighter
    module Bash
      def self.highlight(code)
        code.gsub! /\$[a-z\-_]+/, "<var>\\0</var>"
        code.gsub! /("(.*?)"|'.*?')/ do |text|
          %Q(<q>#{text}</q>)
        end
        code.gsub! %r((\#.*?)$) do |comment|
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

MiniSyntax.register(:bash, MiniSyntax::Highlighter::Bash)