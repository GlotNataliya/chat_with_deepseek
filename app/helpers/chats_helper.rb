module ChatsHelper
  def format_period_name(period)
    case period
    when :today then "Today"
    when :yesterday then "Yesterday"
    when :last_7_days then "7 Days"
    when :last_30_days then "30 Days"
    end
  end
end
