# MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
# MongoMapper.database = "moviesualization-#{Rails.env}"

MongoMapper.config = { 
  Rails.env => { 'uri' => ENV['MONGOHQ_URL'] || 
                          'mongodb://localhost/sushi' } }

MongoMapper.connect(Rails.env)

if defined?(PhusionPassenger)
   PhusionPassenger.on_event(:starting_worker_process) do |forked|
     MongoMapper.connection.connect if forked
   end
end