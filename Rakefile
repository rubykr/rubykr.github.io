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
  system "git clone https://github.com/ruby-korea/ruby-korea.github.io.git vendor/ruby-korea.github.io"

  Dir.chdir "vendor/ruby-korea.github.io" do
    sh "git config user.name '#{ENV['GIT_NAME']}'"
    sh "git config user.email '#{ENV['GIT_EMAIL']}'"
    sh 'git config credential.helper "store --file=.git/credentials"'
    File.open('.git/credentials', 'w') do |f|
      f.write("https://#{ENV['GH_TOKEN']}:@github.com")
    end
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
