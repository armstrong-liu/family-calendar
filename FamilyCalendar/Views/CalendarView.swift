//
//  CalendarView.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import SwiftUI

/// 日历主视图
struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @State private var selectedMonth = Date()
    @State private var showingCreateEvent = false
    @State private var selectedEvent: Event?
    @State private var showingEventDetail = false

    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 月份选择器
                monthHeaderView

                Divider()

                // 日历网格
                calendarGridView

                Divider()

                // 当日事项列表
                eventsListView
            }
            .navigationTitle("家庭日历")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingCreateEvent = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingCreateEvent) {
                CreateEventView { event in
                    Task { await viewModel.loadEvents() }
                }
            }
            .sheet(isPresented: $showingEventDetail) {
                if let event = selectedEvent {
                    EventDetailView(event: event)
                }
            }
        }
        .task {
            await viewModel.loadEvents()
        }
    }

    private var monthHeaderView: some View {
        HStack {
            Button(action: { changeMonth(by: -1) }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.orange)
            }

            Spacer()

            Text(dateFormatter.string(from: selectedMonth))
                .font(.headline)
                .frame(minWidth: 120)

            Spacer()

            Button(action: { changeMonth(by: 1) }) {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.orange)
            }
        }
        .padding()
    }

    private var calendarGridView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
            // 星期标题
            ForEach(["日", "一", "二", "三", "四", "五", "六"], id: \.self) { day in
                Text(day)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(height: 20)
            }

            // 日期格子
            ForEach(daysInMonth, id: \.self) { date in
                if let date = date {
                    DayCell(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: viewModel.selectedDate),
                        hasEvents: viewModel.hasEventsOnDay(date: date),
                        isToday: calendar.isDateInToday(date)
                    )
                    .onTapGesture {
                        viewModel.selectDate(date)
                    }
                } else {
                    Color.clear
                        .frame(height: 40)
                }
            }
        }
        .padding()
    }

    private var eventsListView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("今日事项")
                .font(.headline)
                .padding()

            if viewModel.eventsForSelectedDay().isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("今天没有事项")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.eventsForSelectedDay()) { event in
                            EventRow(event: event)
                                .onTapGesture {
                                    selectedEvent = event
                                    showingEventDetail = true
                                }
                        }
                    }
                    .padding()
                }
            }
        }
    }

    private var daysInMonth: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedMonth),
              let monthStart = calendar.dateInterval(of: .month, for: selectedMonth)?.start else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: monthInterval.start)
        let numberOfDays = calendar.range(of: .day, in: .month, for: selectedMonth)?.count ?? 0

        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)

        for day in 1...numberOfDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                days.append(date)
            }
        }

        return days
    }

    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: selectedMonth) {
            selectedMonth = newMonth
            viewModel.selectDate(newMonth)
        }
    }
}

/// 日期单元格
struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let hasEvents: Bool
    let isToday: Bool

    private let calendar = Calendar.current
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()

    var body: some View {
        ZStack {
            Circle()
                .fill(isSelected ? Color.orange : Color.clear)
                .frame(width: 40, height: 40)

            Text(dayFormatter.string(from: date))
                .font(.body)
                .foregroundColor(isToday ? .orange : .primary)

            if hasEvents {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 6, height: 6)
                    .offset(x: 12, y: 12)
            }
        }
        .frame(height: 40)
    }
}

/// 事项行视图
struct EventRow: View {
    let event: Event

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    var body: some View {
        HStack(spacing: 12) {
            // 分类图标
            Text(event.category?.icon ?? "📌")
                .font(.title2)
                .frame(width: 44, height: 44)
                .background(Color(uiColor: .systemGray6))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)

                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text("\(timeFormatter.string(from: event.startDate)) - \(timeFormatter.string(from: event.endDate))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                if let location = event.location {
                    HStack {
                        Image(systemName: "location")
                            .font(.caption)
                        Text(location)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// 扩展CalendarViewModel
extension CalendarViewModel {
    func hasEventsOnDay(date: Date) -> Bool {
        let calendar = Calendar.current
        return events.contains { event in
            calendar.isDate(event.startDate, inSameDayAs: date)
        }
    }
}

#Preview {
    CalendarView()
}
