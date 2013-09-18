source 'http://rubygems.org'
ruby '2.0.0'

gem 'sinatra'
gem 'data_mapper'
gem 'twilio-ruby'

group :development, :test do
  gem 'sqlite3'
  gem 'dm-sqlite-adapter'
end

group :production do
  gem 'pg'
  gem 'dm-postgres-adapter'
end