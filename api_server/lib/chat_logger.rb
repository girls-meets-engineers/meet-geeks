require 'singleton'

require 'em-websocket'

require 'api_server'

require 'json'

class ChatLogger
  include Singleton

  LOG_LIMIT = 300

  def initialize
    @logs = {}
    @socket_hash = {}
    @redis_enable = true
  end

  def push(socket, message_list_id)
    @socket_hash[message_list_id] ||= []
    @socket_hash[message_list_id] << socket

    if redis_enabled?
      redis_size = APIServer.settings.redis.llen(message_list_id)
      APIServer.settings.redis.lrange(message_list_id, 0, redis_size).each do |log|
        begin
          socket.send(log)
        rescue
          p log
        end
      end
    else
      unless @logs.empty?
        @logs[message_list_id].to_a.each do |log|
          begin
            socket.send(log)
          rescue
            p log
          end
        end
      end
    end
  end

  def delete(socket, message_list_id)
    @socket_hash[message_list_id].delete(socket)
  end

  def message(msg, message_list_id)
    deliver(msg, message_list_id)
    logging(msg, message_list_id)
  end

  def deliver(msg, message_list_id)
    EM.next_tick do
      @socket_hash.each do |_message_list_id, sockets|
        if message_list_id == _message_list_id
          sockets.each do |socket|
            msg_json = JSON.parse(msg);
            msg_json["is_deliverdata"] = true;
            begin
              socket.send(msg_json.to_json)
            rescue
              p msg_json
            end
          end
        end
      end
    end
  end

  def logging(msg, message_list_id)
    if redis_enabled?
      APIServer.settings.redis.rpush(message_list_id, msg)
    else
      @logs[message_list_id] ||= []
      @logs[message_list_id] << msg
    end

    if redis_enabled?
      redis_size = APIServer.settings.redis.llen(message_list_id)
      if redis_size > LOG_LIMIT
        APIServer.settings.redis.lpop(message_list_id)
      end
    else
      if @logs[message_list_id].size > LOG_LIMIT
        @logs[message_list_id].pop
      end
    end
  end

  def redis_enabled?
    @redis_enable
  end
end
