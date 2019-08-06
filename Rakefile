require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :default => :test

desc '構文解析器を構築する'
task :parser => ['parser:arithmetic_parser']

namespace :parser do
  desc '算術演算の構文解析器を構築する'
  task :arithmetic_parser => ['lib/toybox_vm/parser/arithmetic_parser.rb']
end

file 'lib/toybox_vm/parser/arithmetic_parser.rb' => ['lib/toybox_vm/parser/arithmetic_parser.rb.y'] do
  chdir('lib/toybox_vm/parser') do
    sh('racc -o arithmetic_parser.rb -v arithmetic_parser.rb.y')
  end
end
