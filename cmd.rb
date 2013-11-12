#encoding=utf-8
#
require './utils.rb'

def pp input
    if input.is_a? Hash
        input = input.entries
    end
    print input, 'dsfas'
    input.each_with_index {|pair, index| puts "#{index}: #{pair[0]}"} if input
    input
end

def ask(question, &blk)
    puts "#{question}"
    out = blk.call(gets)
    pp out
end

def confirm(question, &blk)
    puts "#{question}:(y/n)"
    out = blk.call(gets)
end

def save(result_list)
    path = Dir.tmpdir + '/playlist'
    unless File.exist? path
        FileUtils.touch path
    end
    File.write(path, result_list.join("\n"))
    result_list
end

def play play_path
    `mplayer -playlist #{play_path}`
end

albums = ask("album:") do |q|
    search q
end

ask('choose one') do |index|
    code = albums[index.to_i][1]
    save get_list(code)
end

play (Dir.tmpdir + '/playlist')
