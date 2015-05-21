class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body, null: false
      t.integer :user_id, null: false
      t.integer :message_list_id, null: false
      t.timestamps null: false
      t.index :body, name: 'idx_body'
    end
  end
end
