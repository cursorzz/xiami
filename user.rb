#!/usr/bin/env ruby
#
require 'mechanize'
require './utils'

module Xiami
  class User
    include Utils
    attr_accessor :albums, :user_id, :agent
    def initialize
      @agent = Mechanize.new
      @user_id = nil
      @albums = []
      @url = 'http://www.xiami.com'
      @is_login = false
    end

    def home_page
      @agent.get(@url)
    end

    def login(email, password)
      page = home_page
      form = page.form_with(:action=>/login/)
      form.email = email
      form.password = password
      page = @agent.submit(form, form.buttons.first)
      if page.search('#user').empty?
        puts 'login failed'
        return
      end
      @is_login = true 
      get_userid
    end

    def get_userid
      if @is_login
        @user_id = @agent.page.search('#user a').first.attr('name_card')
      end
    end

    def get_album_lib
      page = @agent.get("http://www.xiami.com/space/lib-album/u/#{@user_id}")
      page.links_with(:href => /mode=list/, :text => /\d+/).each do |link|
        get_album_fav link
      end
    end

    def get_album_fav link
      page = link.click
      @albums << page.links_with(:href=>/^\/album\/\d+/).map do |link|
        [link.text, link.href.match(/\d+/)]
      end.uniq
    end
  end
end

if __FILE__ == $0
  user = Xiami::User.new
  user.login 'zengzhilg@gmail.com', '50433434'
  user.get_album_lib
  #p user.agent.cookie_jar.jar

  #p user.decode '8h2fmF2zLO244Zz1zt1tFiihvhAf54ka%4hu2t%l.%MmxV2yJQ2WNmEp2ec2HhcGBsZQ5HcwJ%F.oFI6CTYAIA2LOa%3mxm%8ewm9YfJBW9r5A3i%5ZeZAQm8NSUakE%.a2E4S4%jOj2r2IQM'
  # should be
  # http://m3.file.xiami.com/h/02vMHI8Z4zhmh6eeSLAxcCwZ4OfVGTmA%2BY9Qj44ysAYmO4kJZIf8jZaQQAJN2z%2BSr14WHLWU2zhNcO9aItumwarkQ12EJ0M
  #puts user.albums
  user.get_list('32965').each {|f| p f}
end
