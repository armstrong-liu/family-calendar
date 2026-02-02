//
//  FamilyViewModel.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation
import Combine

/// 家庭视图模型
@MainActor
class FamilyViewModel: ObservableObject {
    @Published var families: [Family] = []
    @Published var members: [FamilyMember] = []
    @Published var currentFamily: Family?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showInviteSheet = false
    @Published var inviteCode = ""

    private let familyRepository: FamilyRepositoryProtocol

    init(familyRepository: FamilyRepositoryProtocol = FamilyRepository()) {
        self.familyRepository = familyRepository
        loadCurrentFamily()
    }

    private func loadCurrentFamily() {
        if let familyID = UserDefaults.standard.string(forKey: "currentFamilyID") {
            Task {
                await loadFamilies()
                currentFamily = families.first { $0.id == familyID }
                if let family = currentFamily {
                    await loadMembers(familyID: family.id)
                }
            }
        }
    }

    func loadFamilies() async {
        isLoading = true
        defer { isLoading = false }

        do {
            families = try await familyRepository.fetchFamilies()
        } catch {
            errorMessage = "加载家庭失败: \(error.localizedDescription)"
        }
    }

    func createFamily(name: String) async -> Bool {
        guard let currentUserID = User.current?.id else {
            errorMessage = "未登录"
            return false
        }

        isLoading = true
        defer { isLoading = false }

        let newFamily = Family(
            name: name,
            adminID: currentUserID
        )

        do {
            try await familyRepository.createFamily(newFamily)

            // 创建者作为管理员加入
            let adminMember = FamilyMember(
                familyID: newFamily.id,
                userID: currentUserID,
                role: .admin,
                nickname: User.current?.nickname ?? "我"
            )
            try await familyRepository.addMember(adminMember)

            await loadFamilies()
            currentFamily = newFamily
            UserDefaults.standard.set(newFamily.id, forKey: "currentFamilyID")

            return true
        } catch {
            errorMessage = "创建家庭失败: \(error.localizedDescription)"
            return false
        }
    }

    func joinFamily(inviteCode: String) async -> Bool {
        isLoading = true
        defer { isLoading = false }

        do {
            guard let family = try await familyRepository.joinFamily(inviteCode: inviteCode) else {
                errorMessage = "邀请码无效"
                return false
            }

            guard let currentUserID = User.current?.id else {
                errorMessage = "未登录"
                return false
            }

            // 添加成员
            let member = FamilyMember(
                familyID: family.id,
                userID: currentUserID,
                role: .member,
                nickname: User.current?.nickname ?? ""
            )
            try await familyRepository.addMember(member)

            await loadFamilies()
            currentFamily = family
            UserDefaults.standard.set(family.id, forKey: "currentFamilyID")

            return true
        } catch {
            errorMessage = "加入家庭失败: \(error.localizedDescription)"
            return false
        }
    }

    func loadMembers(familyID: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            members = try await familyRepository.fetchMembers(familyID: familyID)
        } catch {
            errorMessage = "加载成员失败: \(error.localizedDescription)"
        }
    }

    func getInviteCode() {
        inviteCode = currentFamily?.inviteCode ?? ""
        showInviteSheet = true
    }

    func isAdmin() -> Bool {
        guard let currentUserID = User.current?.id,
              let family = currentFamily else {
            return false
        }
        return family.adminID == currentUserID
    }
}
