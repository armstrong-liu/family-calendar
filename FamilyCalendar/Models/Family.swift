//
//  Family.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation

/// 家庭模型
struct Family: Codable, Identifiable {
    let id: String              // 家庭唯一标识
    var name: String            // 家庭名称，如"王家小院"
    var adminID: String         // 管理员用户ID
    var inviteCode: String      // 邀请码
    var createdAt: Date         // 创建时间
    var memberCount: Int        // 成员数量

    init(id: String = UUID().uuidString,
         name: String,
         adminID: String,
         inviteCode: String = Self.generateInviteCode(),
         createdAt: Date = Date(),
         memberCount: Int = 1) {
        self.id = id
        self.name = name
        self.adminID = adminID
        self.inviteCode = inviteCode
        self.createdAt = createdAt
        self.memberCount = memberCount
    }

    /// 生成邀请码
    static func generateInviteCode() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map { _ in letters.randomElement()! })
    }
}

/// 家庭成员关系
struct FamilyMember: Codable, Identifiable {
    let id: String              // 成员关系ID
    let familyID: String        // 家庭ID
    let userID: String          // 用户ID
    var role: MemberRole        // 角色
    var nickname: String        // 在家庭中的昵称
    var joinedAt: Date          // 加入时间
    var notificationEnabled: Bool // 是否接收通知

    init(id: String = UUID().uuidString,
         familyID: String,
         userID: String,
         role: MemberRole = .member,
         nickname: String,
         joinedAt: Date = Date(),
         notificationEnabled: Bool = true) {
        self.id = id
        self.familyID = familyID
        self.userID = userID
        self.role = role
        self.nickname = nickname
        self.joinedAt = joinedAt
        self.notificationEnabled = notificationEnabled
    }
}

/// 成员角色
enum MemberRole: String, Codable {
    case admin    // 管理员
    case member   // 普通成员

    var displayName: String {
        switch self {
        case .admin: return "管理员"
        case .member: return "成员"
        }
    }
}
