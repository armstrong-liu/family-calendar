//
//  FamilyRepository.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation

/// 家庭仓储协议
protocol FamilyRepositoryProtocol {
    func fetchFamilies() async throws -> [Family]
    func createFamily(_ family: Family) async throws
    func joinFamily(inviteCode: String) async throws -> Family?
    func fetchMembers(familyID: String) async throws -> [FamilyMember]
    func addMember(_ member: FamilyMember) async throws
    func removeMember(memberID: String) async throws
}

/// 家庭仓储实现
class FamilyRepository: FamilyRepositoryProtocol {
    private let cloudKitManager: CloudKitManager

    init(cloudKitManager: CloudKitManager = .shared) {
        self.cloudKitManager = cloudKitManager
    }

    func fetchFamilies() async throws -> [Family] {
        return try await cloudKitManager.fetchFamilies()
    }

    func createFamily(_ family: Family) async throws {
        try await cloudKitManager.saveFamily(family)
    }

    func joinFamily(inviteCode: String) async throws -> Family? {
        return try await cloudKitManager.joinFamily(inviteCode: inviteCode)
    }

    func fetchMembers(familyID: String) async throws -> [FamilyMember] {
        return try await cloudKitManager.fetchFamilyMembers(familyID: familyID)
    }

    func addMember(_ member: FamilyMember) async throws {
        try await cloudKitManager.saveFamilyMember(member)
    }

    func removeMember(memberID: String) async throws {
        // 实现删除逻辑
        let recordID = CKRecord.ID(recordName: memberID)
        try await cloudKitManager.sharedDB.deleteRecord(withID: recordID)
    }
}
