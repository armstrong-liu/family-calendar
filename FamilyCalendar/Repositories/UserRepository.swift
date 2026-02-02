//
//  UserRepository.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation

/// 用户仓储协议
protocol UserRepositoryProtocol {
    func fetchUser(userID: String) async throws -> User?
    func saveUser(_ user: User) async throws
    func getCurrentUser() -> User?
    func saveCurrentUser(_ user: User)
}

/// 用户仓储实现
class UserRepository: UserRepositoryProtocol {
    private let cloudKitManager: CloudKitManager

    init(cloudKitManager: CloudKitManager = .shared) {
        self.cloudKitManager = cloudKitManager
    }

    func fetchUser(userID: String) async throws -> User? {
        return try await cloudKitManager.fetchUser(userID: userID)
    }

    func saveUser(_ user: User) async throws {
        try await cloudKitManager.saveUser(user)
    }

    func getCurrentUser() -> User? {
        return User.loadCurrent()
    }

    func saveCurrentUser(_ user: User) {
        User.saveCurrent(user)
    }
}
