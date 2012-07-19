module MiniSyntax
  module Highlighter
    module ERB
      def self.highlight(code)
        code.gsub /&lt;%(.*?)%&gt;/ do
          "<code>&lt;%" + MiniSyntax.highlight($1, :ruby) + "%&gt;</code>"
        end
      end
    end
  end
end

MiniSyntax.register(:erb, MiniSyntax::Highlighter::ERB)