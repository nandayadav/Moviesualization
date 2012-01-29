class Film
  include MongoMapper::Document
  key :name, String 
  key :studio, String
  key :tomato_score, Integer #Rotten Tomatoes score(%)
  key :audience_score, Integer #Audience score from Tomato
  key :story, String
  key :num_theaters_opening_weekend, Integer 
  key :box_office_avg_per_cinema, Integer
  key :domestic_gross, Float
  key :foreign_gross, Float
  key :worldwide_gross, Float #Sum of domestic and foreign
  key :budget, Integer
  key :profitability, Float #% of budget recovered
  key :year, Integer

  belongs_to :genre
  

end
