class AddAssistantPromptToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :add_assistant, :boolean, default: false
    add_column :messages, :assistant_prompt, :text
  end
end
