require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
end

task :default do
  sh "ruby lib/cubepic.rb"
  sh "google-chrome cube.svg"
end
