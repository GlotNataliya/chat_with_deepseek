class Message < ApplicationRecord
  extend Enumerize
  include ChatsHelper

  belongs_to :chat
  has_one :setting, dependent: :destroy

  accepts_nested_attributes_for :setting, allow_destroy: true

  enumerize :deepseek_model_role, in: [ :user, :assistant, :function ]

  # validates :deepseek_model_role, :content, presence: true

  def self.role_choices
    deepseek_model_role.values.map { |k| [ k.humanize.downcase, k ] }
  end
end
