#encoding=utf-8
require 'uri'
require 'nokogiri'
require 'open-uri'
require 'mechanize'

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
    if not decoded_url.end_with? '.mp3'
        return decoded_url.insert(-4, '.')
    else
        return decoded_url
    end
end


def get_list code
    url = "http://www.xiami.com/song/playlist/id/#{code}/type/1"

    doc = Nokogiri::XML(open(url))
    url_list = []
    doc.css('location').each do |l|
        url_list << decode(l.content)
    end
    return url_list
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
    
