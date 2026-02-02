//
//  EventParticipant.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation

/// 事项参与模型
struct EventParticipant: Codable, Identifiable {
    let id: String              // 参与记录ID
    let eventID: String         // 事项ID
    let userID: String          // 用户ID
    var status: ResponseStatus  // 响应状态
    var comment: String?        // 留言
    var respondedAt: Date?      // 响应时间
    var createdAt: Date         // 创建时间

    init(id: String = UUID().uuidString,
         eventID: String,
         userID: String,
         status: ResponseStatus = .pending,
         comment: String? = nil,
         respondedAt: Date? = nil,
         createdAt: Date = Date()) {
        self.id = id
        self.eventID = eventID
        self.userID = userID
        self.status = status
        self.comment = comment
        self.respondedAt = respondedAt
        self.createdAt = createdAt
    }
}

/// 响应状态
enum ResponseStatus: String, Codable {
    case pending    // 待响应
    case accepted   // 同意
    case declined   // 拒绝
    case tentative  // 可能（可选功能）

    var icon: String {
        switch self {
        case .pending: return "⏳"
        case .accepted: return "✅"
        case .declined: return "❌"
        case .tentative: return "❓"
        }
    }

    var displayName: String {
        switch self {
        case .pending: return "待响应"
        case .accepted: return "同意"
        case .declined: return "拒绝"
        case .tentative: return "可能"
        }
    }

    var color: String {
        switch self {
        case .pending: return "#8E8E93"
        case .accepted: return "#34C759"
        case .declined: return "#FF3B30"
        case .tentative: return "#FFCC00"
        }
    }
}
