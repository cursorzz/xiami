#!/usr/bin/env ruby
#
require 'mechanize'

module Xiami
    class User
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
            form = page.forms.last
            form.email = email
            form.password = password
            page = @agent.submit(form, form.buttons.first)
            if not page.search('#user')
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
    puts user.albums
end
