module MiniSyntax
  module Highlighter
    module CSS
      def self.highlight(code)
        code.gsub! %r(( *)((\$[a-z\-_]+):(.+?);|([_\*]?[a-z\-]+:)(("|[^&])+?);|@import (.+?);|(([\.\#]?[a-z0-9\-_&:]+([,\s]\s*[\.\#]?[a-z0-9\-_&:]+)*))(\s*)\{(.*?\n\1)\})|@media (.+?)\{|@(include|extend) (.+?);)im do
          intendation = $1
          if $3
            %Q(#{intendation}<var>#{$3}</var>:#{highlight_value($4)};)
          elsif $5
            %Q(#{intendation}<b>#{$5}</b>#{highlight_value($6)};)
          elsif $8
            %Q(#{intendation}@<em>import</em> <q>#{$8}</q>;)
          elsif $10
            whitespace = $12
            rules = $13
            # selector = $10.gsub(/([\.\#\b])([a-z0-9\-_]+)\b/i) do
            #   if $1 == '.'
            #     %Q(<b><i>#{$1}#{$2}</i></b>)
            #   elsif $1 == '#'
            #     %Q(<b>#{$1}#{$2}</b>)
            #   else
            #     %Q(<em>#{$2}</em>)
            #   end
            # end
            selector = %Q(<b><i>#{$10}</i></b>)
            %Q(#{intendation}#{selector}#{whitespace}{#{highlight(rules)}})
          elsif $14
            %Q(#{intendation}@<em>media</em> #{$14.gsub('and', '<em>and</em>')}{)
          elsif $15
            keyword = $15
            call = $16
            rule = call.gsub(/^([\.#]?[a-z\-_]+).*$/, '<b>\\1</b>')
            parameter = call.gsub(/^.*?\((.+?)\)/) { "(#{highlight_value($1)})" }
            %Q(#{intendation}@<em>#{keyword}</em> #{rule}#{parameter};)
          end
        end
        code.gsub! %r((<i>)?(//.*?$|/\*.*?\*/)) do
          comment = $2
          if $1 == '<i>' or comment.gsub(%r(<q>(.*?)</q>), "\\1") =~ %r(</q>)
            comment
          else
            comment.gsub! %r(</?(b|i|em|var|code)>), ""
            %Q(<i>#{comment}</i>)
          end
        end
        code
      end

    private
      def self.highlight_value(code)
        keywords = %w(!important left-side far-left left center-left center center-right right far-right right-side behind leftwards rightwards inherit)
        keywords << %w(scroll fixed transparent none top center bottom middle)
        keywords << %w(repeat repeat-x repeat-y no-repeat collapse separate auto both normal)
        keywords << %w(attr open-quote close-quote no-open-quote no-close-quote)
        keywords << %w(crosshair default pointer move e-resize ne-resize nw-resize n-resize se-resize sw-resize s-resize w-resize text wait help progress)
        keywords << %w(ltr rtl)
        keywords << %w(inline block list-item run-in inline-block table inline-table table-row-group table-header-group table-footer-group table-row table-column-group table-column table-cell table-caption)
        keywords << %w(below level above higher lower)
        keywords << %w(show hide italic oblique small-caps bold bolder lighter)
        keywords << %w(caption icon menu message-box small-caption status-bar)
        keywords << %w(inside outside disc circle square decimal decimal-leading-zero lower-roman upper-roman lower-greek lower-latin upper-latin armenian georgian lower-alpha upper-alpha)
        keywords << %w(invert)
        keywords << %w(visible hidden scroll)
        keywords << %w(always avoid)
        keywords << %w(x-low low medium high x-high)
        keywords << %w(static relative absolute fixed)
        keywords << %w(spell-out)
        keywords << %w(x-slow slow medium fast x-fast faster slower)
        keywords << %w(left right center justify)
        keywords << %w(underline overline line-through blink)
        keywords << %w(capitalize uppercase lowercase)
        keywords << %w(embed bidi-override)
        keywords << %w(baseline sub super top text-top middle bottom text-bottom)
        keywords << %w(silent x-soft soft medium loud x-loud)
        keywords << %w(normal pre nowrap pre-wrap pre-line)
        keywords << %w(maroon red yellow olive purple fuchsia white lime green navy blue aqua teal black silver gray orange)
        code.gsub! /\b#{keywords.join('|')}\b/, "<b>\\0</b>"
        code.gsub! /\$[a-z\-_]+/, "<var>\\0</var>"
        code.gsub! /("|')(.*?)\1/ do |q|
          q.gsub! %r(<(b|i|em|var)>(.*?)</\1>), "\\2"
          q.gsub!(/#\{(.*?)\}/) do
            %Q(<code>\#{#{highlight_value($1)}}</code>)
          end
          %Q(<q>#{q}</q>)
        end
        code
      end
    end
  end
end

MiniSyntax.register(:css, MiniSyntax::Highlighter::CSS)