require 'csv'
namespace :import do 
  task :csv => :environment do
    CSV.foreach("data/file.csv") do |row|
      next unless row[0].nil?
      f = Film.new
      f.name = row[1]
      f.studio = row[2]
      f.tomato_score = row[3]
      f.audience_score = row[4]
      f.story = row[5]
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
      f.year = ENV['year'] || 2007
      begin
        f.save!
        puts f.name
      rescue Exception => e
        puts e.message
      end
    end
  end
end