class Setting < ApplicationRecord
  extend Enumerize
  include ChatsHelper

  belongs_to :message

  enumerize :deepseek_model_name, in: [ "deepseek-chat", "deepseek-reasoner" ]

  def self.model_choices
    deepseek_model_name.values.map { |k| [ k.humanize.downcase, k ] }
  end
end
