# encoding: utf-8

require 'rubygems'

begin
  require 'bundler/setup'
rescue LoadError => e
  warn e.message
  warn "Run `gem install bundler` to install Bundler"
  exit(-1)
end

task :default => [:build]

desc "Test plugins"
task :test do
  sh 'rspec spec'
end

desc "Build the Jekyll site"
task :build do
  sh 'jekyll build'
end

desc "Generates the Jekyll site and starts local server"
task :preview do
  sh 'jekyll serve --watch'
end

task travis: ENV["TRAVIS_PULL_REQUEST"] == "false" ? [:test, :build, :validate_markup, :release] : [:test, :build, :validate_markup]

desc "Release the current commit to ruby-korea/ruby-korea.github.io@master"
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
    sh "git checkout master"
    sh "git pull origin master"

    rm_rf FileList["*"]
    cp_r FileList["../../_site/*"], "./"
    sh "git add -A ."
    sh "git commit -m 'ruby-korea/ruby-korea.github.io@#{commit}'"
    sh "git push origin master"
  end
end

desc 'validate _site markup with validate-website'
task :validate_markup do
  Dir.chdir('_site') do
    sh "validate-website-static --site 'https://ruby-korea.github.io/'"
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
