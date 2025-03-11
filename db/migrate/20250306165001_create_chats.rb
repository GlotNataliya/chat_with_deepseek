class CreateChats < ActiveRecord::Migration[8.0]
  def change
    create_table :chats do |t|
      t.string :title
      t.string :deepseek_model_name
      t.string :role
      t.text :content
      t.float :temperature
      t.integer :max_tokens
      t.float :top_p
      t.boolean :stream
      t.jsonb :result

      t.timestamps
    end
  end
end
