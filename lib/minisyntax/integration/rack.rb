require 'rack/utils'
require 'nokogiri'

# “Inspired” by Wlodek Bzyl’s rack-codehighlighter:
# https://github.com/wbzyl/rack-codehighlighter
# Thanks!

module Rack
  class MiniSyntax
    include Rack::Utils

    def initialize(app, options = {})
      @app = app
      @options = {
        :element => 'code',
        :pattern => /^##+\s*([-_\w\+ ]+)[\s#]*(\n|&#x000A;|$)/i
      }
      @options.merge! options
    end

    def call(env)
      status, headers, response = @app.call(env)
      headers = HeaderHash.new(headers)

      if !STATUS_WITH_NO_ENTITY_BODY.include?(status) and
         !headers['transfer-encoding'] and
         headers['content-type'] and
         headers['content-type'].include?("text/html")

        content = ""
        response.each { |part| content += part }
        doc = Nokogiri::HTML(content, nil, 'UTF-8')
        nodes = doc.search(@options[:element])
        nodes.each do |node|
          code = node.inner_html || ''
          node.swap(highlight(code, node.name))            
        end

        body = doc.to_html
        headers['content-length'] = bytesize(body).to_s

        [status, headers, [body]]
      else
        [status, headers, response]  
      end
    end
    
  private
    def highlight(code, tag_name)
      if code =~ @options[:pattern]
        lang = $1
        code.gsub! @options[:pattern], ''
        if code =~ /^([ \t]+)/
          code.gsub! /^#{$1}/, ''
        end
        code = ::MiniSyntax.highlight(code, lang)
      end
      %Q(<#{tag_name}>#{code}</#{tag_name}>)
    end
  end
end
