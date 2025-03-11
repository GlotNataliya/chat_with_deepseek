class Chat < ApplicationRecord
  extend Enumerize

  enumerize :model, in: ["deepseek-chat", "deepseek-reasoner"]
  enumerize :role, in: [:user, :assistant, :system, :function]

  # scope :today, -> { where(created_at: Date.today.beginning_of_day..Date.today.end_of_day) }
  # scope :yesterday, -> { where(created_at: Date.yesterday.beginning_of_day..Date.yesterday.end_of_day) }
  # scope :last_7_days, -> { where(created_at: 7.days.ago.beginning_of_day..Date.today.end_of_day) }
  # scope :last_30_days, -> { where(created_at: 30.days.ago.beginning_of_day..Date.today.end_of_day) }

  scope :today, -> { where(created_at: Time.zone.now.all_day) }
  scope :yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :last_7_days, -> { where(created_at: 7.days.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :last_30_days, -> { where(created_at: 30.days.ago.beginning_of_day..Time.zone.now.end_of_day) }

  def self.model_choices
    model.values.map { |k| [k.humanize.downcase, k] }
  end

  def self.role_choices
    role.values.map { |k| [k.humanize.downcase, k] }
  end
end
