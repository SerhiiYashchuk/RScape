require 'rake/testtask'
require 'rdoc/task'

task default: :sugarscape

task :sugarscape do
  ruby "-Ilib ./bin/sugarscape.rb"
end

task :sugarscape_log do
  ruby "-Ilib ./bin/sugarscape.rb -l"
end

Rake::TestTask.new do |test|
  test.test_files = FileList["test/test*.rb"]
  test.verbose = true
end

RDoc::Task.new do |rdoc|
  rdoc.markup = "tomdoc"
  rdoc.rdoc_dir = "doc"
  rdoc.main = "README"
  rdoc.rdoc_files.include("README")
  rdoc.rdoc_files.include("lib/rscape/*.rb")
  rdoc.rdoc_files.include("lib/rscape/gui/*.rb")
end
