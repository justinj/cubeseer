require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'test/*_test.rb'
end

task :default => [:server]

task :server do
  `ruby server/server.rb`
end
