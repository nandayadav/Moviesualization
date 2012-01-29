class Genre
  include MongoMapper::Document
  key :name, String
  many :films

end
