//
//  SettingsView.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import SwiftUI

/// 设置视图
struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var quietModeEnabled = false
    @State private var quietStartTime = Date()
    @State private var quietEndTime = Date()
    @State private var showingAbout = false

    var body: some View {
        NavigationView {
            Form {
                // 用户信息
                Section {
                    if let user = User.current {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.orange.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text(String(user.nickname.prefix(1)))
                                        .foregroundColor(.orange)
                                        .font(.title)
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.nickname)
                                    .font(.headline)

                                if let phone = user.phoneNumber {
                                    Text(phone)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }

                // 通知设置
                Section(header: Text("通知设置")) {
                    Toggle("接收通知", isOn: $notificationsEnabled)

                    if notificationsEnabled {
                        Toggle("免打扰模式", isOn: $quietModeEnabled)

                        if quietModeEnabled {
                            DatePicker(
                                "开始时间",
                                selection: $quietStartTime,
                                displayedComponents: .hourAndMinute
                            )

                            DatePicker(
                                "结束时间",
                                selection: $quietEndTime,
                                displayedComponents: .hourAndMinute
                            )
                        }
                    }
                }

                // 外观
                Section(header: Text("外观")) {
                    HStack {
                        Text("主题")
                        Spacer()
                        Text("跟随系统")
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }

                // 数据
                Section(header: Text("数据")) {
                    Button("同步状态") {
                        // TODO: 实现同步状态
                    }

                    Button("清除缓存") {
                        // TODO: 实现清除缓存
                    }
                }

                // 关于
                Section(header: Text("关于")) {
                    Button("关于家庭日历") {
                        showingAbout = true
                    }

                    Button("隐私政策") {
                        // TODO: 打开隐私政策
                    }

                    Button("用户协议") {
                        // TODO: 打开用户协议
                    }

                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }

                // 退出
                Section {
                    Button("退出登录") {
                        logout()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("设置")
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
        }
    }

    private func logout() {
        User.clearCurrent()
        UserDefaults.standard.removeObject(forKey: "currentFamilyID")
        // TODO: 返回到登录界面
    }
}

/// 关于视图
struct AboutView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)

                Text("家庭日历")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 12) {
                    Text("一款专为家庭设计的日程协作工具")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)

                    Text("让家庭沟通更简单")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)

                Spacer()

                VStack(spacing: 8) {
                    Link("隐私政策", destination: URL(string: "https://familycalendar.app/privacy")!)
                        .font(.caption)
                        .foregroundColor(.orange)

                    Link("用户协议", destination: URL(string: "https://familycalendar.app/terms")!)
                        .font(.caption)
                        .foregroundColor(.orange)
                }

                Text("© 2026 FamilyCalendar. All rights reserved.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
            }
            .padding()
            .navigationTitle("关于")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
