require 'active_record'

class User < ActiveRecord::Base
  has_many :messages

  validates :name, presence: true
  validates :description, length: { maximum: 300 }
  validates :money, length: { maximum: 11 }
  validates :age, length: { maximum: 4 }
  validates :image_url, length: { minimum: 10 }, uniqueness: true
  validates :profile_url, length: { minimum: 10 }, uniqueness: true
  validates :is_engineer, inclusion: { in: [true, false] }
end
