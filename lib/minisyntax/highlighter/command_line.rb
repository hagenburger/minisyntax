module MiniSyntax
  module Highlighter
    module CommandLine
      def self.highlight(code)
        code = '<kbd>' + code.gsub(/\n/, %Q(</kbd>\n<kbd>)) + '</kbd>'
        code.gsub! %r((\#.*?)$) do |comment|
          if comment =~ %r(</q>)
            comment
          else
            comment.gsub! %r(</?(b|i|em|var|code|kbd)>), ""
            %Q(<i>#{comment}</i>)
          end
        end
        code.gsub! %r(<kbd><i>), "<i>"
        code
      end
    end
  end
end

MiniSyntax.register(:command_line, MiniSyntax::Highlighter::CommandLine)