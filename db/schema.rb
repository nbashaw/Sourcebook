class Source
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :author, String
  property :url, Text
  property :note, Text
  property :created_at, DateTime
end

DataMapper.finalize
