class Story
  include MongoMapper::Document
  key :name, String
  key :red, Integer
  key :green, Integer
  key :blue, Integer
  key :color, String #HHAA00 format
  many :films
  

end