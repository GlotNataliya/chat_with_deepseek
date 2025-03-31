class Chat < ApplicationRecord
  has_many :messages, dependent: :destroy

  accepts_nested_attributes_for :messages, allow_destroy: true

  # validates :title, presence: true

  broadcasts_to ->(chat) { "chats" }, inserts_by: :prepend

  scope :today, -> { where(created_at: Time.zone.now.all_day) }
  scope :yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :last_7_days, -> { where(created_at: 7.days.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :last_30_days, -> { where(created_at: 30.days.ago.beginning_of_day..Time.zone.now.end_of_day) }
end
