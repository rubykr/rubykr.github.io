# encoding: utf-8

require 'rubygems'

begin
  require 'bundler/setup'
rescue LoadError => e
  warn e.message
  warn "Run `gem install bundler` to install Bundler"
  exit -1
end

task :default => [:build]

desc "Build the Jekyll site"
task :build do
  sh 'jekyll build'
end

desc "Generates the Jekyll site and starts local server"
task :preview do
  sh 'jekyll serve --watch'
end

namespace :check do
  desc 'validate _site markup with validate-website'
  task :markup => :generate do
    options = Jekyll.configuration({'auto' => false, 'server' => false})
    Dir.chdir('_site') do
      system("validate-website-static --site '#{options['url']}/' --quiet")
      exit($?.exitstatus)
    end
  end
  desc "Checks for broken links on http://0.0.0.0:4000/"
  task :links do
    require 'spidr'
    Spidr.start_at('http://0.0.0.0:4000/') do |agent|
      agent.every_failed_url do |url|
        puts "Broken link #{url} found."
      end
    end
  end
end
