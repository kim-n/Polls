class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :user_id, :null => false
      t.integer :answer_id, :null => false

      t.timestamps
    end

    add_index :responses, :user_id
    add_index :responses, :answer_id
  end
end
