module MiniSyntax
  module Highlighter
    module Ruby
      def self.highlight(code)
        keywords = %w(BEGIN begin case class else elsif END end ensure for if in module rescue then unless until when while)
        keywords += %w(def do and not or require)
        keywords += %w(alias alias_method break next redo retry return super undef yield)
        keywords += %w(initialize new loop include extend raise attr_reader attr_writer attr_accessor attr catch throw private module_function public protected)
        code.gsub! /\b(#{keywords.join('|')})\b(?!\?)/, "<em>\\1</em>"
        code.gsub! /\b([A-Z_][a-zA-Z0-9_]+)\b/, "<b>\\1</b>"
        code.gsub! /(\#([^\{].*?)?)\n/, "<i>\\1</i>\n"
        code.gsub! /("(.*?)"|'.*?'|%[qrw]\(.*?\)|%([QRW])\((.*?)\))/ do |text|
          if $2 or type = $3
            text.gsub! /#\{(.*?)\}/ do
              %Q(<code>\#{#{highlight($1)}}</code>)
            end
          end
          %Q(<q>#{text}</q>)
        end
        code.gsub! %r(&lt;&lt;-<b>HALLO</b>.*<b>HALLO</b>) do |text|
          if $2 or type = $3
            text.gsub! /#\{(.*?)\}/ do
              %Q(<code>\#{#{highlight($1)}}</code>)
            end
          end
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
        code.gsub!('<i><i>', '<i>')
        "hallo" +code
      end
    end
  end
end

MiniSyntax.register(:ruby, MiniSyntax::Highlighter::Ruby)
