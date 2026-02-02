//
//  EventDetailView.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import SwiftUI

/// 事项详情视图
struct EventDetailView: View {
    @StateObject private var viewModel: EventDetailViewModel
    @Environment(\.dismiss) var dismiss

    init(event: Event) {
        _viewModel = StateObject(wrappedValue: EventDetailViewModel(event: event))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 标题和分类
                headerView

                Divider()

                // 时间和地点
                infoView

                Divider()

                // 参与人
                participantsView

                Divider()

                // 描述
                if let description = viewModel.event.description, !description.isEmpty {
                    descriptionView
                    Divider()
                }

                // 操作按钮
                actionButtons
            }
            .padding()
        }
        .navigationTitle("事项详情")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.canEditEvent() {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("编辑") {
                        // TODO: 实现编辑功能
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showResponseSheet) {
            responseSheet
        }
        .task {
            await viewModel.loadParticipants()
        }
    }

    private var headerView: some View {
        HStack(spacing: 12) {
            Text(viewModel.event.category?.icon ?? "📌")
                .font(.largeTitle)
                .frame(width: 60, height: 60)
                .background(Color(uiColor: .systemGray6))
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.event.title)
                    .font(.title2)
                    .fontWeight(.bold)

                if let category = viewModel.event.category {
                    Text(category.rawValue)
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
    }

    private var infoView: some View {
        VStack(alignment: .leading, spacing: 12) {
            InfoRow(icon: "clock", title: "时间", subtitle: timeRangeText)

            if let location = viewModel.event.location {
                InfoRow(icon: "location", title: "地点", subtitle: location)
            }

            if let reminderTime = viewModel.event.reminderTime {
                InfoRow(icon: "bell", title: "提醒", subtitle: formatDateTime(reminderTime))
            }
        }
    }

    private var timeRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日 HH:mm"
        return "\(formatter.string(from: viewModel.event.startDate)) - \(formatter.string(from: viewModel.event.endDate))"
    }

    private var participantsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("参与人员")
                    .font(.headline)

                Spacer()

                let (accepted, pending) = countParticipantStatus()
                Text("\(accepted)/\(viewModel.participants.count) 已响应")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if viewModel.participants.isEmpty {
                Text("暂无参与人")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.participants) { participant in
                    ParticipantRow(participant: participant)
                }
            }
        }
    }

    private var descriptionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("描述")
                .font(.headline)

            Text(viewModel.event.description ?? "")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            if let currentUserID = User.current?.id,
               viewModel.participants.contains(where: { $0.userID == currentUserID }) {
                Button(action: { viewModel.showResponseSheet = true }) {
                    Text("更新响应")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            } else {
                Button(action: { viewModel.showResponseSheet = true }) {
                    Text("响应邀请")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
    }

    private var responseSheet: some View {
        NavigationView {
            Form {
                Section(header: Text("选择你的响应")) {
                    Button(action: {
                        Task {
                            await viewModel.respondToEvent(status: .accepted)
                            viewModel.showResponseSheet = false
                            dismiss()
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("同意参加")
                        }
                    }

                    Button(action: {
                        Task {
                            await viewModel.respondToEvent(status: .declined)
                            viewModel.showResponseSheet = false
                            dismiss()
                        }
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("无法参加")
                        }
                    }

                    TextField("留言（可选）", text: Binding(
                        get: { "" },
                        set: { text in
                            // TODO: 实现留言功能
                        }
                    ))
                    .textInputAutocapitalization(.sentences)
                }
            }
            .navigationTitle("响应")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("取消") {
                        viewModel.showResponseSheet = false
                    }
                }
            }
        }
    }

    private func countParticipantStatus() -> (Int, Int) {
        let accepted = viewModel.participants.filter { $0.status == .accepted }.count
        let pending = viewModel.participants.filter { $0.status == .pending }.count
        return (accepted, pending)
    }

    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日 HH:mm"
        return formatter.string(from: date)
    }
}

/// 信息行
struct InfoRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(subtitle)
                    .font(.body)
            }
        }
    }
}

/// 参与人行
struct ParticipantRow: View {
    let participant: EventParticipant

    var body: some View {
        HStack(spacing: 12) {
            // 头像
            Circle()
                .fill(Color.orange.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(participant.nickname.prefix(1)))
                        .foregroundColor(.orange)
                        .font(.headline)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(participant.nickname)
                    .font(.body)

                if let comment = participant.comment, !comment.isEmpty {
                    Text(comment)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Text(participant.status.icon)
                .font(.title)
        }
    }
}

extension EventParticipant {
    var nickname: String {
        // TODO: 从用户数据获取真实昵称
        return "用户"
    }
}

#Preview {
    NavigationView {
        EventDetailView(event: Event(
            id: "1",
            familyID: "family1",
            creatorID: "user1",
            title: "周末家庭聚餐",
            description: "一起去吃火锅",
            location: "海底捞",
            startDate: Date(),
            endDate: Date().addingTimeInterval(7200),
            category: .dining
        ))
    }
}
