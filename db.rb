require 'data_mapper'

DataMapper::Logger.new($stdout, :debug)

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/develop.db")

class Track
    include DataMapper::Resource
    property :id, Serial
    property :name, String
    property :track_id, String
    property :artist, String
    has n, :musics
end

class Music
    include DataMapper::Resource
    property :id,    Serial
    property :title, String
    property :url,   String
    property :lyric, Text

    belongs_to :track
end

DataMapper.finalize
DataMapper.auto_upgrade!
