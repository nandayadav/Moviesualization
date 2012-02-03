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
  task :csv => :environment do
    raise "Enter year=" if ENV['year'].nil?
    CSV.foreach("data/file_#{ENV['year']}.csv") do |row|
      next unless row[0].nil? 
      f = Film.new
      next if row[1].nil? || row[5].nil?
      f.name = row[1]
      f.studio = row[2]
      f.tomato_score = row[3]
      f.audience_score = row[4]
      story_name = row[5].titleize.strip
      next if story_name == 'Story'
      story_name = 'The Riddle' if story_name == 'Riddle'
      s = Story.find_by_name(story_name)
      begin
        s ||= Story.create!(:name => story_name)
        f.story = s
      rescue Exception => e
        puts e.message
      end
      g = Genre.find_by_name(row[6])
      g ||= Genre.create(:name => row[6])
      f.genre = g
      f.num_theaters_opening_weekend = row[7]
      f.box_office_avg_per_cinema = row[8]
      f.domestic_gross = row[9]
      f.foreign_gross = row[10]
      f.worldwide_gross = row[11]
      f.budget = row[12]
      f.profitability = row[13]
      f.year = ENV['year']
      begin
        f.save!
        puts f.name
      rescue Exception => e
        puts e.message
      end
    end
  end
end