//
//  NotificationService.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation
import UserNotifications

/// 通知服务
class NotificationService: ObservableObject {
    static let shared = NotificationService()

    private let center = UNUserNotificationCenter.current()

    private init() {}

    // MARK: - Authorization

    /// 请求通知权限
    func requestAuthorization() async throws -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        let granted = try await center.requestAuthorization(options: options)
        return granted
    }

    /// 检查通知权限状态
    func getAuthorizationStatus() async -> UNAuthorizationStatus {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }

    // MARK: - Local Notifications

    /// 安排本地通知
    func scheduleLocalNotification(
        title: String,
        body: String,
        at date: Date,
        categoryIdentifier: String? = nil
    ) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        if let categoryIdentifier = categoryIdentifier {
            content.categoryIdentifier = categoryIdentifier
        }

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        try await center.add(request)
    }

    /// 取消所有通知
    func cancelAllNotifications() async {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }

    /// 取消特定通知
    func cancelNotification(withIdentifier identifier: String) async {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    // MARK: - Badge

    /// 设置应用角标数量
    func setBadge(count: Int) async {
        center.setBadgeCount(count)
    }

    /// 清除应用角标
    func clearBadge() async {
        center.setBadgeCount(0)
    }

    // MARK: - Categories

    /// 设置通知分类
    func setupCategories() async {
        // 邀请响应分类
        let acceptAction = UNNotificationAction(
            identifier: "ACCEPT_ACTION",
            title: "同意",
            options: .foreground
        )

        let declineAction = UNNotificationAction(
            identifier: "DECLINE_ACTION",
            title: "拒绝",
            options: .foreground
        )

        let inviteCategory = UNNotificationCategory(
            identifier: "EVENT_INVITE",
            actions: [acceptAction, declineAction],
            intentIdentifiers: [],
            options: []
        )

        await center.setNotificationCategories([inviteCategory])
    }

    // MARK: - Delivered Notifications

    /// 获取已送达的通知
    func getDeliveredNotifications() async -> [UNNotification] {
        return await center.deliveredNotifications()
    }

    /// 移除已送达的通知
    func removeDeliveredNotifications(withIdentifiers identifiers: [String]) {
        center.removeDeliveredNotifications(withIdentifiers: identifiers)
    }

    // MARK: - Helper Methods

    /// 事项提醒通知
    func scheduleEventReminder(for event: Event) async throws {
        guard let reminderTime = event.reminderTime else { return }

        let title = "事项提醒"
        let body = "\(event.title) 将在 \(formatTime(event.startDate)) 开始"

        try await scheduleLocalNotification(
            title: title,
            body: body,
            at: reminderTime,
            categoryIdentifier: "EVENT_REMINDER"
        )
    }

    /// 事项邀请通知
    func sendEventInviteNotification(to userID: String, event: Event) async throws {
        // TODO: 实现推送通知
        // 这里需要后端支持或使用CloudKit的推送功能
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - UNUserNotificationCenterDelegate

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // 在前台也显示通知
        completionHandler([.banner, .sound, .badge])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // 处理通知响应
        handleNotificationResponse(response)

        completionHandler()
    }

    private func handleNotificationResponse(_ response: UNNotificationResponse) {
        switch response.actionIdentifier {
        case "ACCEPT_ACTION":
            // 处理同意操作
            print("User accepted event invitation")
            // TODO: 调用API更新参与人状态

        case "DECLINE_ACTION":
            // 处理拒绝操作
            print("User declined event invitation")
            // TODO: 调用API更新参与人状态

        default:
            // 处理点击通知
            if response.notification.request.content.categoryIdentifier == "EVENT_INVITE" {
                // TODO: 导航到事项详情页
            }
        }
    }
}
