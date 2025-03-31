class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.string :deepseek_model_role
      t.text :content
      t.jsonb :result
      t.text :reasoning_content

      t.timestamps
    end
  end
end
