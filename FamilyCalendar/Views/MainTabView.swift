//
//  MainTabView.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import SwiftUI

/// 主标签视图
struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            CalendarView()
                .tabItem {
                    Label("日历", systemImage: selectedTab == 0 ? "calendar.fill" : "calendar")
                }
                .tag(0)

            FamilyView()
                .tabItem {
                    Label("家庭", systemImage: selectedTab == 1 ? "person.2.fill" : "person.2")
                }
                .tag(1)

            NotificationView()
                .tabItem {
                    Label("通知", systemImage: selectedTab == 2 ? "bell.fill" : "bell")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Label("设置", systemImage: selectedTab == 3 ? "gearshape.fill" : "gearshape")
                }
                .tag(3)
        }
        .accentColor(.orange)
    }
}

#Preview {
    MainTabView()
}
