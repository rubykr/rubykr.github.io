# encoding: utf-8

require 'rubygems'

begin
  require 'bundler/setup'
rescue LoadError => e
  warn e.message
  warn "Run `gem install bundler` to install Bundler"
  exit -1
end

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

desc "Release the current commit to ruby-korea/ruby-korea.github.io@gh-pages"
task :release do
  commit = `git rev-parse HEAD`.chomp
  system "mkdir -p vendor/ruby-korea.github.io"
  system "git clone git@github.com:ruby-korea/ruby-korea.github.io.git vendor/ruby-korea.github.io"

  Dir.chdir "vendor/ruby-korea.github.io" do
    sh "git reset --hard HEAD"
    sh "git checkout gh-pages"
    sh "git pull origin gh-pages"

    rm_rf FileList["*"]
    cp_r FileList["../../_site/*"], "./"
    sh "git add -A ."
    sh "git commit -m 'ruby-korea/ruby-korea.github.io@#{commit}'"
    sh "git push origin gh-pages"
  end
end
