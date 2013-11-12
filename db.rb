require 'data_mapper'

DataMapper::Logger.new($stdout, :debug)

DataMapper.setup(:default, 'sqlite::memory:')

class Track
    include DataMapper::Resource
    property :id, Serial
    property :name, String

    has n, :musics
end

class Music
    include DataMapper::Resource
    property :id,    Serial
    property :title, String
    property :url,   String

    belongs_to :track
end

DataMapper.finalize

