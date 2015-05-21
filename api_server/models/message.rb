require 'active_record'

class Message < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :message_list, dependent: :destroy

  validates :body, presence: true
  validates :user_id, presence: true
  validates :message_list_id, presence: true
end
