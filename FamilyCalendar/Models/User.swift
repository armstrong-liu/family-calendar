//
//  User.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation

/// 用户模型
struct User: Codable, Identifiable {
    let id: String                  // 用户唯一标识
    var phoneNumber: String?        // 手机号
    var appleID: String?           // Apple ID
    var nickname: String           // 昵称
    var avatarURL: String?         // 头像URL
    var createdAt: Date            // 注册时间
    var lastLoginAt: Date?         // 最后登录时间

    init(id: String = UUID().uuidString,
         phoneNumber: String? = nil,
         appleID: String? = nil,
         nickname: String = "",
         avatarURL: String? = nil,
         createdAt: Date = Date(),
         lastLoginAt: Date? = nil) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.appleID = appleID
        self.nickname = nickname
        self.avatarURL = avatarURL
        self.createdAt = createdAt
        self.lastLoginAt = lastLoginAt
    }
}

/// 当前用户扩展
extension User {
    static var current: User?

    static func saveCurrent(_ user: User) {
        current = user
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: "currentUser")
        }
    }

    static func loadCurrent() -> User? {
        if let current = current {
            return current
        }
        if let data = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            current = user
            return user
        }
        return nil
    }

    static func clearCurrent() {
        current = nil
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
}
