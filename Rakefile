require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'test/*_test.rb'
end

task :default do
  `ruby server/server.rb`
end
