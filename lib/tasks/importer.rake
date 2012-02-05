require 'csv'
namespace :import do 
  
  task :colors => :environment do
    f = YAML::load(File.read('./data/stories.yml'))
    f.each do |story, val|
      puts story
      s = Story.find_by_name(story)
      next unless s
      s.color = val['color'].to_s
      rgb = val['color'].to_s.match /(..)(..)(..)/
      s.red = rgb[1].hex
      s.green = rgb[2].hex
      s.blue = rgb[3].hex
      s.save!
    end
  end
  
  task :story_averages => :environment do
    Story.all.each do |story|
      puts story.name
      films = story.films.all
      total_budget = films.map(&:budget).sum
      story.average_budget = (total_budget/films.size).round
      puts "Budget: #{story.average_budget}"
      story.average_worldwide_gross = ((films.map(&:worldwide_gross).compact.sum)/films.size).round
      story.average_tomato_score = ((films.map(&:tomato_score).compact.sum)/films.size).round
      story.save!
    end
  end
  task :csv => :environment do
    raise "Enter year=" if ENV['year'].nil?
    index = 0
    CSV.foreach("data/latest_#{ENV['year']}.csv") do |row|
      index += 1
      #puts row.inspect
      next if index < 3
      #Dont proceed if don't have all of name, story, worldwide_gross and budget
      next if row[0].nil? || row[4].nil? || row[11].nil? || row[10].nil?
      f = Film.new
      f.name = row[0].strip
      f.studio = row[1]
      f.tomato_score = row[2]
      f.audience_score = row[3]
      story_name = row[4].titleize.strip
      next if story_name == 'Story'
      story_name = 'The Riddle' if story_name == 'Riddle'
      s = Story.find_by_name(story_name)
      begin
        s ||= Story.create!(:name => story_name)
        f.story = s
      rescue Exception => e
        puts e.message
      end
      g = Genre.find_by_name(row[5])
      g ||= Genre.create(:name => row[5])
      f.genre = g
      f.num_theaters_opening_weekend = row[6]
      f.box_office_avg_per_cinema = row[7]
      f.domestic_gross = row[8]
      f.foreign_gross = row[9]
      f.worldwide_gross = row[10]
      f.budget = row[11]
      f.profitability = row[12]
      f.year = ENV['year']
      begin
        f.save!
        puts f.name
      rescue Exception => e
        puts "Error for #{f.name}"
        puts e.message
      end
    end
  end
end