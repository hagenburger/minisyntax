module MiniSyntax
  module Highlighter
    module PHP
      def self.highlight(code)
        keywords = %w(abstract and array as break case catch cfunction class clone const continue declare default do else elseif enddeclare endfor endforeach endif endswitch endwhile extends final for foreach function global goto if implements interface instanceof namespace new old_function or private protected public static switch throw try use var while xor)
        keywords += %w(die echo empty exit eval include include_once isset list require require_once return print unset )
        code.gsub! /\b(#{keywords.join('|')})\b/, "<em>\\1</em>"
        code.gsub! /\b([A-Z_][a-zA-Z0-9_]+)\b/, "<b>\\1</b>"
        code.gsub! /\$[a-zA-Z0-9_]+/, "<var>\\0</var>"
        code.gsub! /("(.*?)"|'.*?')/ do |q|
          q.gsub! %r(<(b|i|em|var)>(.*?)</\1>), "\\2"
          if q[0..5] == '"'
            q.gsub! /(\$[a-zA-Z0-9_]+)(\[(.+?)\])?/ do
              hash = $3['$'] ? %Q([<var>#{$3}</var>]) : $2 if $2
              %Q(<code><var>#{$1}</var>#{hash}</code>)
            end
          end
          %Q(<q>#{q}</q>)
        end
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

MiniSyntax.register(:php, MiniSyntax::Highlighter::PHP)