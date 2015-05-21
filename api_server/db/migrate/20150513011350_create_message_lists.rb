class CreateMessageLists < ActiveRecord::Migration
  def change
    create_table :message_lists do |t|
      t.integer :engineer, null: false
      t.integer :girl, null: false
    end
  end
end
