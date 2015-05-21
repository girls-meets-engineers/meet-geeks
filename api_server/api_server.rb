require 'json'
require 'yaml'
require 'erb'

require 'chat_logger'
require 'models/user'
require 'models/message'
require 'models/message_list'

require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/reloader'
require 'sinatra-websocket'
require 'sinatra/activerecord'
require 'active_record'
require 'redis'

class APIServer < Sinatra::Base
  configure do
    set :root, File.dirname(__FILE__)
    set :environment, :production
    set :redis, Redis.new(host: ENV['REDIS_PORT_6379_TCP_ADDR'], port: 6379)

    enable :logging
    file = File.new("logs/#{settings.environment}.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file

    register Sinatra::ActiveRecordExtension
    use ActiveRecord::ConnectionAdapters::ConnectionManagement
    database_yml = ERB.new(IO.read('config/database.yml.erb')).result
    config = YAML.load(database_yml)
    ActiveRecord::Base.establish_connection(config[settings.environment.to_s])
  end

  configure :development do
    register Sinatra::Reloader
  end

  get '/ws/:message_list_id' do
    if request.websocket?
      request.websocket do |ws|
        ws.onopen do
          @message_list_id = params[:message_list_id]
          ChatLogger.instance.push(ws, @message_list_id)
        end
        ws.onmessage do |msg|
          object = JSON.parse(msg)
          Message.create(body: object['body'], user_id: object['id'], message_list_id: @message_list_id)
          ChatLogger.instance.message(msg, @message_list_id)
        end
        ws.onclose do
          ChatLogger.instance.delete(ws, @message_list_id)
        end
      end
    else
      halt 403
    end
  end

  # User
  get '/users' do
    json User.all
  end

  get '/users/:id' do
    begin
      json User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      raise
    end
  end

  post '/users' do
    begin
      hash = JSON.parse(params[:json])
      user = User.create(hash)
      if user.errors.empty?
        json user
      else
        json User.find_by(profile_url: hash['profile_url'])
      end
    rescue ActiveRecord::RecordNotFound
      raise
    end
  end

  put '/users/:id' do
    begin
      hash = JSON.parse(params[:json])
      user = User.update(params[:id], hash)
      if user.errors.empty?
        json user
      else
        json user.errors.full_messages
      end
    rescue ActiveRecord::RecordNotFound
      raise
    end
  end

  delete '/users/:id' do
    begin
      user = User.find(params[:id])
      json user.destroy
    rescue ActiveRecord::RecordNotFound
      raise
    end
  end

  # Message
  get '/messages' do
    json Message.all
  end

  get '/messages/:id' do
    begin
      json Message.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      raise
    end
  end

  post '/messages' do
    begin
      hash = JSON.parse(params[:json])
      message = Message.create(hash)
      if message.errors.empty?
        json message
      else
        json message.errors.full_messages
      end
    rescue ActiveRecord::RecordNotFound
      raise
    end
  end

  put '/messages/:id' do
    begin
      hash = JSON.parse(params[:json])
      message = Message.update(params[:id], hash)
      if message.errors.empty?
        json message
      else
        json message.errors.full_messages
      end
    rescue ActiveRecord::RecordNotFound
      raise
    end
  end

  delete '/messages/:id' do
    begin
      message = Message.find(params[:id])
      json message.destroy
    rescue ActiveRecord::RecordNotFound
      raise
    end
  end

  get '/message_lists' do
    json MessageList.all
  end

  get '/message_lists/:id' do
    begin
      json MessageList.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      raise
    end
  end

  post '/message_lists' do
    begin
      hash = JSON.parse(params[:json])
      if MessageList.where("engineer = ? AND girl = ?", hash['engineer'], hash['girl']).empty?
        message_list = MessageList.create(hash)
        if message_list.errors.empty?
          json message_list
        else
          json message_list.errors.full_messages
        end
      else
        halt 400
      end
    rescue ActiveRecord::RecordNotFound
      raise
    end
  end

  put '/message_lists/:id' do
    begin
      hash = JSON.parse(params[:json])
      message_list = MessageList.update(params[:id], hash)
      if message_list.errors.empty?
        json message_list
      else
        json message_list.errors.full_messages
      end
    rescue ActiveRecord::RecordNotFound
      raise
    end
  end

  delete '/message_lists/:id' do
    begin
      message_list = MessageList.find(params[:id])
      json message_list.destroy
    rescue ActiveRecord::RecordNotFound
      raise
    end
  end

  get '/users_message_lists/:id' do
    begin
      called_user = User.find(params[:id])

      if called_user.is_engineer
        message_lists = MessageList.where(engineer: called_user.id)
        result = message_lists.each_with_object([]) do |message_list, array|
          girl = User.find(message_list.girl)
          girl_profile = {
            id: girl.id,
            name: girl.name,
            description: girl.description,
            money: girl.money,
            age: girl.age,
            image_url: girl.image_url,
            profile_url: girl.profile_url
          }
          array << { id: message_list.id, companion: girl_profile }
        end
      else
        message_lists = MessageList.where(girl: called_user.id)
        result = message_lists.each_with_object([]) do |message_list, array|
          engineer = User.find(message_list.engineer)
          engineer_profile = {
            id: engineer.id,
            name: engineer.name,
            description: engineer.description,
            money: engineer.money,
            age: engineer.age,
            image_url: engineer.image_url,
            profile_url: engineer.profile_url
          }
          array << { id: message_list.id, companion: engineer_profile }
        end
      end

      json result
    rescue ActiveRecord::RecordNotFound
      raise
    end
  end

  get '/engineers' do
    begin
      engineer = User.where(is_engineer: true)
      json engineer
    rescue ActiveRecord::RecordNotFound
      raise
    end
  end
end
