#encoding=utf-8
#
require './utils.rb'
require 'readline'

class Xiami
  class CLI
    include Xiami::Utils

    def initialize
      @search_key = ''
      @code = ''
    end
    
    def start
      while buf = Readline.readline('>', true)
        cmd, arg = buf.split
        if self.respond_to? cmd
          p self.send(cmd, arg)
        end
      end
    end
  end
end

Xiami::CLI.new.start
