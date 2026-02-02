//
//  Helpers.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation
import SwiftUI

// MARK: - Date Formatter Helper

/// 日期格式化助手
struct DateHelper {
    static let shared = DateHelper()

    private let dateFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    private let dateTimeFormatter: DateFormatter
    private let relativeFormatter: RelativeDateTimeFormatter

    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_CN")
        dateFormatter.dateFormat = "yyyy年M月d日"

        timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "zh_CN")
        timeFormatter.dateFormat = "HH:mm"

        dateTimeFormatter = DateFormatter()
        dateTimeFormatter.locale = Locale(identifier: "zh_CN")
        dateTimeFormatter.dateFormat = "yyyy年M月d日 HH:mm"

        relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.locale = Locale(identifier: "zh_CN")
        relativeFormatter.unitsStyle = .short
    }

    /// 格式化日期（年月日）
    func formatDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    /// 格式化时间（时分）
    func formatTime(_ date: Date) -> String {
        return timeFormatter.string(from: date)
    }

    /// 格式化日期时间（年月日 时分）
    func formatDateTime(_ date: Date) -> String {
        return dateTimeFormatter.string(from: date)
    }

    /// 相对时间（如"2小时前"）
    func formatRelative(_ date: Date) -> String {
        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }

    /// 是否为同一天
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }

    /// 获取星期几
    func weekday(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}

// MARK: - Validation Helper

/// 验证助手
struct ValidationHelper {
    /// 验证手机号
    static func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^1[3-9]\\d{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }

    /// 验证邮箱
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    /// 验证邀请码（6位字母数字）
    static func isValidInviteCode(_ code: String) -> Bool {
        let codeRegex = "^[A-Z0-9]{6}$"
        let codePredicate = NSPredicate(format: "SELF MATCHES %@", codeRegex)
        return codePredicate.evaluate(with: code)
    }
}

// MARK: - Haptic Feedback Helper

/// 触觉反馈助手
struct HapticFeedback {
    /// 轻微触觉反馈
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    /// 中等触觉反馈
    static func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    /// 重度触觉反馈
    static func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }

    /// 成功反馈
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    /// 警告反馈
    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }

    /// 错误反馈
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

// MARK: - Alert Helper

/// 提示助手
struct AlertHelper {
    /// 显示成功提示
    static func showSuccess(message: String) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else { return }
            let alert = UIAlertController(title: "成功", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default))
            window.rootViewController?.present(alert, animated: true)
        }
    }

    /// 显示错误提示
    static func showError(message: String) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else { return }
            let alert = UIAlertController(title: "错误", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default))
            window.rootViewController?.present(alert, animated: true)
        }
    }

    /// 显示确认对话框
    static func showConfirm(
        title: String,
        message: String,
        confirmTitle: String = "确定",
        cancelTitle: String = "取消",
        onConfirm: @escaping () -> Void
    ) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else { return }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
            alert.addAction(UIAlertAction(title: confirmTitle, style: .default) { _ in
                onConfirm()
            })

            window.rootViewController?.present(alert, animated: true)
        }
    }
}
