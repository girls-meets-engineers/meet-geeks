class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.text :description
      t.integer :money, limit: 11
      t.integer :age
      t.string :image_url
      t.string :profile_url
      t.boolean :is_engineer, null: false
      t.timestamps null: false
      t.index :image_url, unique: true
      t.index :profile_url, unique: true
    end
  end
end
