require 'rubygems'
require 'sinatra'
require 'logger'
require 'data_mapper'
require 'json'

$stdout.sync = true

$log = Logger.new(STDOUT)
$log.level = Logger::ERROR
if ENV['DEBUG']
  $log.level = Logger::DEBUG
end

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/dev.db")

class User
  include DataMapper::Resource

  property :id, Serial
  property :phone_number, String
  property :user_name, Text
end

DataMapper.finalize.auto_upgrade!

get '/' do
  erb :index
end

get '/users' do
  @users = User.all
  erb :'users/index'
end

get '/users/new' do
  erb :'users/new'
end

get '/users/:id' do |id|
  @user = User.get!(id)
  erb :'users/show'
end

get '/users/:id/edit' do |id|
  @user = User.get!(id)
  erb :'users/edit'
end

post '/users' do
  user = User.new(params[:user])
  
  if user.save
    status 201
    redirect '/users'
  else
    status 400
    redirect '/users/new'
  end
end

put '/users/:id' do |id|
  user = User.get!(id)
  success = user.update!(params[:user])
  
  if success
    status 201
    redirect "/users/#{id}"
  else
    status 400
    redirect "/users/#{id}/edit"
  end
end

delete '/users/:id' do |id|
  user = User.get!(id)
  user.destroy!
  status 201
  redirect "/users"
end

post 'sms' do
  erb :'sms/index'
  unless params['Body'] 
    halt 400, 'Missing "From" or "Body" in POST'
  end
  $log.debug("Incoming SMS POST data: #{params.inspect}")
  
  # @account_sid = ENV['TWILIO_ACCOUNT_SID']
  # @auth_token = ENV['TWILIO_AUTH_TOKEN']

  # # set up a client to talk to the Twilio REST API
  # @client = Twilio::REST::Client.new(@account_sid, @auth_token)

  # @account = @client.account
  # @message = @account.sms.messages.create({:from => ENV['TWILIO_FROM_NUMBER']})
  # puts @message
end
