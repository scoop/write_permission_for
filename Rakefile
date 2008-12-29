RAILS_ROOT = "#{File.dirname(__FILE__)}"

require 'rubygems'
require 'spec/rake/spectask'

require 'config/environment'

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--format', 'profile', '--color']
end

desc "Default task is to run specs"
task :default => :spec