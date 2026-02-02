//
//  Constants.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation

/// 应用常量
enum AppConstants {
    // MARK: - App Info

    static let appName = "家庭日历"
    static let appVersion = "1.0.0"
    static let bundleIdentifier = "com.familycalendar.app"

    // MARK: - CloudKit

    static let cloudKitContainerID = "icloud.com.familycalendar.app"

    // MARK: - UserDefaults Keys

    enum UserDefaultsKeys {
        static let currentUser = "currentUser"
        static let currentFamilyID = "currentFamilyID"
        static let notificationsEnabled = "notificationsEnabled"
        static let quietModeEnabled = "quietModeEnabled"
        static let quietStartTime = "quietStartTime"
        static let quietEndTime = "quietEndTime"
        static let launchCount = "launchCount"
        static let lastVersion = "lastVersion"
    }

    // MARK: - Notification Categories

    enum NotificationCategories {
        static let eventInvite = "EVENT_INVITE"
        static let eventReminder = "EVENT_REMINDER"
        static let eventUpdate = "EVENT_UPDATE"
        static let eventCancel = "EVENT_CANCEL"
        static let responseReceived = "RESPONSE_RECEIVED"
    }

    // MARK: - Notification Actions

    enum NotificationActions {
        static let accept = "ACCEPT_ACTION"
        static let decline = "DECLINE_ACTION"
        static let view = "VIEW_ACTION"
    }

    // MARK: - UI

    enum UI {
        static let primaryColor = "FF9500"  // Orange
        static let successColor = "34C759"  // Green
        static let errorColor = "FF3B30"    // Red
        static let warningColor = "FFCC00"  // Yellow
    }

    // MARK: - Pagination

    enum Pagination {
        static let defaultPageSize = 20
        static let maxPageSize = 100
    }

    // MARK: - Dates

    enum Dates {
        static let iso8601Formatter: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter
        }()

        static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "zh_CN")
            return formatter
        }()
    }
}
