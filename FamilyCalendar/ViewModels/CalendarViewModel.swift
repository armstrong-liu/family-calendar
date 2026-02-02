//
//  CalendarViewModel.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation
import Combine

/// 日历视图模型
@MainActor
class CalendarViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let eventRepository: EventRepositoryProtocol
    private var currentFamilyID: String?

    init(eventRepository: EventRepositoryProtocol = EventRepository()) {
        self.eventRepository = eventRepository
        loadCurrentFamily()
    }

    private func loadCurrentFamily() {
        currentFamilyID = UserDefaults.standard.string(forKey: "currentFamilyID")
    }

    func loadEvents() async {
        guard let familyID = currentFamilyID else {
            errorMessage = "请先创建或加入家庭"
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            events = try await eventRepository.fetchEvents(familyID: familyID, month: selectedDate)
        } catch {
            errorMessage = "加载事项失败: \(error.localizedDescription)"
        }
    }

    func selectDate(_ date: Date) {
        selectedDate = date
        Task {
            await loadEvents()
        }
    }

    func hasEventsOnDay(_ day: Int) -> Bool {
        let calendar = Calendar.current
        return events.contains { event in
            calendar.isDate(event.startDate, inSameDayAs: selectedDate)
        }
    }

    func eventsForSelectedDay() -> [Event] {
        let calendar = Calendar.current
        return events.filter { event in
            calendar.isDate(event.startDate, inSameDayAs: selectedDate)
        }
    }
}
