class RemoveFieldsFromChats < ActiveRecord::Migration[8.0]
  def change
    remove_column :chats, :content, :text
    remove_column :chats, :result, :jsonb
    remove_column :chats, :reasoning_content, :text
    remove_column :chats, :deepseek_model_role, :string
    remove_column :chats, :deepseek_model_name, :string
    remove_column :chats, :temperature, :float
    remove_column :chats, :max_tokens, :integer
    remove_column :chats, :top_p, :float
    remove_column :chats, :stream, :boolean
  end
end
