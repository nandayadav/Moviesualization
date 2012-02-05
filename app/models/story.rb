class Story
  include MongoMapper::Document
  key :name, String, :required => true, :unique => true
  key :red, Integer
  key :green, Integer
  key :blue, Integer
  key :color, String #HHAA00 format
  many :films
  key :gradient, String
  key :average_profit
  key :average_budget
  key :average_tomato_score

end