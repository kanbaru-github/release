module Public::NotificationsHelper

  # 未確認の通知を検索するメソッド
  def unchecked_notifications
    @notifications = current_customer.passive_notifications.where(checked: false)
  end

end
