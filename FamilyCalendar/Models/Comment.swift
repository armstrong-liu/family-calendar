//
//  Comment.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation

/// 评论模型
struct Comment: Codable, Identifiable {
    let id: String              // 评论ID
    let eventID: String         // 事项ID
    let userID: String          // 评论用户ID
    var content: String         // 评论内容
    var createdAt: Date         // 评论时间

    init(id: String = UUID().uuidString,
         eventID: String,
         userID: String,
         content: String,
         createdAt: Date = Date()) {
        self.id = id
        self.eventID = eventID
        self.userID = userID
        self.content = content
        self.createdAt = createdAt
    }
}
