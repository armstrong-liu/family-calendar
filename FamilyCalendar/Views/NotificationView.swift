//
//  NotificationView.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import SwiftUI

/// 通知视图
struct NotificationView: View {
    @State private var notifications: [AppNotification] = mockNotifications

    var body: some View {
        NavigationView {
            List {
                if notifications.isEmpty {
                    emptyStateView
                } else {
                    ForEach(notifications) { notification in
                        NotificationRow(notification: notification)
                    }
                }
            }
            .navigationTitle("通知中心")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("全部已读") {
                        markAllAsRead()
                    }
                    .disabled(notifications.isEmpty || notifications.allSatisfy { $0.isRead })
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.slash")
                .font(.system(size: 50))
                .foregroundColor(.secondary)

            Text("暂无通知")
                .font(.headline)

            Text("当有新事项或更新时，\n这里会显示通知")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    private func markAllAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }
    }
}

/// 通知行
struct NotificationRow: View {
    let notification: AppNotification

    var body: some View {
        HStack(spacing: 12) {
            // 图标
            Text(notification.type.icon)
                .font(.title2)
                .frame(width: 44, height: 44)
                .background(notification.isRead ? Color(uiColor: .systemGray6) : Color.orange.opacity(0.1))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(.headline)
                    .foregroundColor(notification.isRead ? .secondary : .primary)

                Text(notification.body)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                Text(formatDate(notification.createdAt))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            if !notification.isRead {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 4)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// 模拟数据
private let mockNotifications: [AppNotification] = [
    AppNotification(
        id: "1",
        userID: "user1",
        type: .eventInvite,
        title: "新事项邀请",
        body: "爸爸邀请你参加：周末家庭聚餐",
        eventID: "event1",
        isRead: false,
        createdAt: Date().addingTimeInterval(-3600)
    ),
    AppNotification(
        id: "2",
        userID: "user1",
        type: .responseReceived,
        title: "妈妈响应了邀请",
        body: "妈妈同意参加周末家庭聚餐",
        eventID: "event1",
        isRead: true,
        readAt: Date().addingTimeInterval(-7200),
        createdAt: Date().addingTimeInterval(-10800)
    ),
    AppNotification(
        id: "3",
        userID: "user1",
        type: .eventReminder,
        title: "事项提醒",
        body: "周末家庭聚餐将在1小时后开始",
        eventID: "event1",
        isRead: true,
        readAt: Date().addingTimeInterval(-86400),
        createdAt: Date().addingTimeInterval(-90000)
    )
]

#Preview {
    NotificationView()
}
