//
//  AppNotification.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation

/// 应用通知模型
struct AppNotification: Codable, Identifiable {
    let id: String              // 通知ID
    let userID: String          // 接收用户ID
    let type: NotificationType  // 通知类型
    let title: String           // 标题
    let body: String            // 内容
    let eventID: String?        // 关联事项ID
    var isRead: Bool            // 是否已读
    var readAt: Date?           // 阅读时间
    let createdAt: Date         // 创建时间

    init(id: String = UUID().uuidString,
         userID: String,
         type: NotificationType,
         title: String,
         body: String,
         eventID: String? = nil,
         isRead: Bool = false,
         readAt: Date? = nil,
         createdAt: Date = Date()) {
        self.id = id
        self.userID = userID
        self.type = type
        self.title = title
        self.body = body
        self.eventID = eventID
        self.isRead = isRead
        self.readAt = readAt
        self.createdAt = createdAt
    }
}

/// 通知类型
enum NotificationType: String, Codable {
    case eventInvite      // 事项邀请
    case eventUpdate      // 事项更新
    case eventReminder    // 事项提醒
    case eventCancel      // 事项取消
    case responseReceived // 收到响应

    var icon: String {
        switch self {
        case .eventInvite: return "📨"
        case .eventUpdate: return "✏️"
        case .eventReminder: return "⏰"
        case .eventCancel: return "❌"
        case .responseReceived: return "💬"
        }
    }

    var displayName: String {
        switch self {
        case .eventInvite: return "邀请通知"
        case .eventUpdate: return "更新通知"
        case .eventReminder: return "提醒通知"
        case .eventCancel: return "取消通知"
        case .responseReceived: return "响应通知"
        }
    }
}
