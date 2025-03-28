class Chat < ApplicationRecord
  extend Enumerize
  include ChatsHelper

  broadcasts_to ->(chat) { "chats" }, inserts_by: :prepend

  enumerize :deepseek_model_name, in: [ "deepseek-chat", "deepseek-reasoner" ]
  enumerize :deepseek_model_role, in: [ :user, :assistant, :system, :function ]

  scope :today, -> { where(created_at: Time.zone.now.all_day) }
  scope :yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :last_7_days, -> { where(created_at: 7.days.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :last_30_days, -> { where(created_at: 30.days.ago.beginning_of_day..Time.zone.now.end_of_day) }

  def self.model_choices
    deepseek_model_name.values.map { |k| [ k.humanize.downcase, k ] }
  end

  def self.role_choices
    deepseek_model_role.values.map { |k| [ k.humanize.downcase, k ] }
  end
end
