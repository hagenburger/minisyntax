module MiniSyntax
  module Highlighter
    module HTML
      def self.highlight(code)
        code.gsub! %r((&lt;script( [a-z\-]+(=("|'|\w).*?\4)?)*&gt;)(.*?)(&lt;/script&gt;))m do
          %Q(#{$1}#{MiniSyntax.highlight($5, :javascript)}#{$6})
        end
        code.gsub! %r(&lt;([a-z\-]+[1-6]?)(( [a-z\-]+(=".*?")?)*)( /)?&gt;)m do
          tag = $1
          xml_close_tag = $5
          attributes = $2.gsub %r( ([a-z\-]+)(=(")(.*?)("))?)m do
            if %(onload onclick onmouseover onmousemove onmouseout onfocus onblur onkeyup onkeydown onkeypress).include?($1)
              %Q( <b>#{$1}</b>=#{$3}#{MiniSyntax.highlight($4, :javascript)}#{$3})
            else
              %Q( <b>#{$1}</b>#{$2})
            end
          end if $2
          %Q(<b>&lt;<em>#{tag}</em></b>#{attributes}<b>#{xml_close_tag}&gt;</b>)
        end
        code.gsub! %r(&lt;/([a-z\-]+[1-6]?)&gt;) do
          %Q(<b>&lt;/<em>#{$1}</em>&gt</b>)
        end
        code
      end
    end
  end
end

MiniSyntax.register(:html, MiniSyntax::Highlighter::HTML)