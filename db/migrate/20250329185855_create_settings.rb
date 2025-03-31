class CreateSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :settings do |t|
      t.references :message, null: false, foreign_key: true
      t.string :deepseek_model_name
      t.float :temperature
      t.integer :max_tokens
      t.float :top_p
      t.boolean :stream

      t.timestamps
    end
  end
end
