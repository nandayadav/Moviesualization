class Film
  include MongoMapper::Document
  key :name, String 
  key :tomato_score, Integer #Rotten Tomatoes score(%)
  key :audience_score, Integer #Audience score from Tomato
  key :studio, String
  key :num_theaters_opening_weekend, Integer 
  key :box_office_avg_per_cinema, Integer
  key :domestic_gross, Float
  key :foreign_gross, Float
  key :worldwide_gross, Float #Sum of domestic and foreign
  key :budget, Integer
  key :profitability, Float #% of budget recovered
  key :year, Integer

  belongs_to :genre
  belongs_to :story
  
  def story_color
    return "##{story.color}" if story && story.color
    "#AABB67"
  end
  
  def story_name
    story ? story.name : ''
  end
  
  def r
    story ? story.red : 123
  end
  
  def g
    story ? story.green : 34
  end
  
  def b
    story ? story.blue : 14
  end
  

end
