//
//  Event.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation

/// 事项模型
struct Event: Codable, Identifiable {
    let id: String              // 事项唯一标识
    let familyID: String        // 所属家庭ID
    let creatorID: String       // 创建者用户ID
    var title: String           // 事项标题
    var description: String?    // 详细描述
    var location: String?       // 地点
    var startDate: Date         // 开始时间
    var endDate: Date           // 结束时间
    var category: EventCategory? // 事项分类
    var repeatRule: RepeatRule? // 重复规则
    var reminderTime: Date?     // 提醒时间
    var isDeleted: Bool         // 是否已删除
    var createdAt: Date         // 创建时间
    var updatedAt: Date         // 更新时间

    init(id: String = UUID().uuidString,
         familyID: String,
         creatorID: String,
         title: String,
         description: String? = nil,
         location: String? = nil,
         startDate: Date,
         endDate: Date,
         category: EventCategory? = nil,
         repeatRule: RepeatRule? = nil,
         reminderTime: Date? = nil,
         isDeleted: Bool = false,
         createdAt: Date = Date(),
         updatedAt: Date = Date()) {
        self.id = id
        self.familyID = familyID
        self.creatorID = creatorID
        self.title = title
        self.description = description
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.category = category
        self.repeatRule = repeatRule
        self.reminderTime = reminderTime
        self.isDeleted = isDeleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    /// 是否为全天事件
    var isAllDay: Bool {
        let calendar = Calendar.current
        return calendar.isDate(startDate, inSameDayAs: endDate)
    }
}

/// 事项分类
enum EventCategory: String, Codable, CaseIterable {
    case dining = "聚餐"        // 聚餐
    case travel = "出行"        // 出行
    case shopping = "购物"      // 购物
    case payment = "缴费"       // 缴费
    case healthcare = "医疗"    // 医疗
    case education = "教育"     // 教育
    case other = "其他"         // 其他

    var icon: String {
        switch self {
        case .dining: return "🍽️"
        case .travel: return "✈️"
        case .shopping: return "🛒"
        case .payment: return "💳"
        case .healthcare: return "🏥"
        case .education: return "📚"
        case .other: return "📌"
        }
    }

    var color: String {
        switch self {
        case .dining: return "#FF9500"
        case .travel: return "#007AFF"
        case .shopping: return "#34C759"
        case .payment: return "#FF3B30"
        case .healthcare: return "#AF52DE"
        case .education: return "#5856D6"
        case .other: return "#8E8E93"
        }
    }
}

/// 重复规则
enum RepeatRule: Codable, Equatable {
    case none                   // 不重复
    case daily                  // 每天
    case weekly                 // 每周
    case monthly                // 每月
    case custom(interval: Int)  // 自定义，如每3天

    var displayName: String {
        switch self {
        case .none: return "不重复"
        case .daily: return "每天"
        case .weekly: return "每周"
        case .monthly: return "每月"
        case .custom(let interval): return "每\(interval)天"
        }
    }
}
