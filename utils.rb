#encoding=utf-8
require 'uri'
require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'json'

module Xiami
  module Utils
    def decode str
      row = str.slice!(0).to_i
      step = str.length / row
      @comp = str.length % row
      array = []
      row.times do |num|
        cut = num > (@comp - 1)?step:step + 1
        array << str.slice!(0, cut).split('')
      end
      url = array.inject {|sum, a| sum.zip(a)}.flatten.join
      #puts url, row, step, @comp
      decoded_url = URI.decode(url).gsub('^', '0')
      #if not decoded_url.end_with? '.mp3' then decoded_url.insert(-4, '.') end
      return decoded_url
    end

    def get_list code
      url = "http://www.xiami.com/song/playlist/id/#{code}/type/1"
      doc = Nokogiri::XML(open(url))
      info_list = track_info doc
      info_list.collect {|item| by_id(item['song_id'])}
    end

    def by_id id
      url = "http://www.xiami.com/song/gethqsong/sid/#{id}"
      #puts url
      encoded = JSON.parse(@agent.get(url).search('p').text)['location']
      #puts encoded
      decode(encoded)
    end

    def search key
      url = "http://www.xiami.com/ajax/search-index?key=#{key}"
      agent = Mechanize.new
      page = agent.get(url)
      album = Hash.new
      page.links_with(:href => /album/).each do |link|
        album[link.text] = link.href.match(/\d+/).to_s
      end
      album
    end

    def track_info doc
      info = Array.new
      doc.css('track').each do |t|
        track = Hash.new
        t.children.each {|c| track[c.name] = ( if c.name == 'location'; decode c.text;else c.text;end) }
        info << track
    end
    info
  end
end
end

