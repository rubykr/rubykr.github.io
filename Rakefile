# encoding: utf-8

require 'rubygems'

begin
  require 'bundler/setup'
rescue LoadError => e
  warn e.message
  warn "Run `gem install bundler` to install Bundler"
  exit -1
end

HOST = 'www.ruby-lang.org'
LANGUAGES = %w[bg de en es fr id it ja ko pl pt ru tr vi zh_cn zh_tw]

task :default => [:generate]

desc "Generates the Jekyll site"
task :generate do
  require 'jekyll'
  # workaround for LANG=C environment
  module Jekyll::Convertible
    Encoding.default_external = Encoding::UTF_8
  end

  options = Jekyll.configuration({'auto' => false, 'server' => false})
  puts "Building site: #{options['source']} -> #{options['destination']}"
  $stdout.flush
  Jekyll::Site.new(options).process
end

desc "Generates the Jekyll site and starts local server"
task :preview do
  sh 'jekyll serve --watch'
end
