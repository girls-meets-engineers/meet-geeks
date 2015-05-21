require 'active_record'

class MessageList < ActiveRecord::Base
  has_many :messages
  validates :engineer, presence: true
  validates :girl, presence: true
end
