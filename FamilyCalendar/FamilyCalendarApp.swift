//
//  FamilyCalendarApp.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import SwiftUI

@main
struct FamilyCalendarApp: App {
    @StateObject private var authService = AuthService.shared
    @StateObject private var notificationService = NotificationService.shared

    var body: some Scene {
        WindowGroup {
            if authService.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .modelContainer(/* TODO: SwiftData container */)
        .task {
            await setupServices()
        }
    }

    private func setupServices() async {
        // 设置通知分类
        await notificationService.setupCategories()

        // 请求通知权限
        let granted = try? await notificationService.requestAuthorization()
        if granted == false {
            print("Notification permission denied")
        }

        // 订阅CloudKit变更通知
        do {
            try await CloudKitManager.shared.subscribeToNotifications()
        } catch {
            print("Failed to subscribe to notifications: \(error)")
        }
    }
}
