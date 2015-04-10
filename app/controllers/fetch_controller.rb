require 'net/http'
require 'uri'

include ActionView::Helpers::OutputSafetyHelper
include ERB::Util

class FetchController < ApplicationController
  def index
    url = (params[:url] or 'https://slack.com')
    source_code = ''
    msg = ''
    if url
        uri = URI.parse(url)
        if uri.instance_of?  URI::HTTPS
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            request = Net::HTTP::Get.new(uri.request_uri)
            begin
                response = http.request(request)
                source_code = response.body
            rescue SocketError => er
                msg = er.message
            end
        else
            begin
                response = Net::HTTP.get_response(uri)
                source_code = response.body
            rescue Errno::ECONNREFUSED => er
                msg = er.message
            end
        end
    end

    if source_code.empty? and msg.empty?
        msg = "Empty content!"
    end

    @url = url
    @tags = get_tags(source_code)
    @source_code = source_code
    @render = html_escape(source_code)
    @msg = msg
  end

  def highlight
    selected_tag = params[:tag]
    source_code = params[:source_code]

    @url = params[:url]
    @tags = get_tags(source_code)
    @source_code = source_code
    @render = highlight_tag(html_escape(source_code), selected_tag)

    render "fetch/index"
  end


  private
  def get_tags(source_code)
    tags = Hash.new(0)
    match_data = source_code.scan(/<\w*/)
    for tag in match_data
        tag = tag.gsub('<','')
        tags[tag] += 1 if tag != ''
    end
    return tags  
  end

  def highlight_tag(source_code, tag)
    re = /&lt;(\/?)#{tag}.*?&gt;/
    source_code.gsub re, '<span style="background-color: #FFFF00">\0</span>'
  end
end
