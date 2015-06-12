require 'rake/testtask'
require 'rdoc/task'

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
