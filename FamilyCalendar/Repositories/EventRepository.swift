//
//  EventRepository.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation

/// 事项仓储协议
protocol EventRepositoryProtocol {
    func fetchEvents(familyID: String, month: Date) async throws -> [Event]
    func createEvent(_ event: Event) async throws
    func updateEvent(_ event: Event) async throws
    func deleteEvent(_ eventID: String) async throws
    func fetchParticipants(eventID: String) async throws -> [EventParticipant]
    func updateParticipant(_ participant: EventParticipant) async throws
}

/// 事项仓储实现
class EventRepository: EventRepositoryProtocol {
    private let cloudKitManager: CloudKitManager

    init(cloudKitManager: CloudKitManager = .shared) {
        self.cloudKitManager = cloudKitManager
    }

    func fetchEvents(familyID: String, month: Date) async throws -> [Event] {
        let calendar = Calendar.current
        guard let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: month)),
              let endDate = calendar.date(byAdding: .month, value: 1, to: startDate) else {
            return []
        }

        return try await cloudKitManager.fetchEvents(
            familyID: familyID,
            startDate: startDate,
            endDate: endDate
        )
    }

    func createEvent(_ event: Event) async throws {
        try await cloudKitManager.saveEvent(event)
    }

    func updateEvent(_ event: Event) async throws {
        var updatedEvent = event
        updatedEvent.updatedAt = Date()
        try await cloudKitManager.saveEvent(updatedEvent)
    }

    func deleteEvent(_ eventID: String) async throws {
        try await cloudKitManager.deleteEvent(eventID: eventID)
    }

    func fetchParticipants(eventID: String) async throws -> [EventParticipant] {
        return try await cloudKitManager.fetchEventParticipants(eventID: eventID)
    }

    func updateParticipant(_ participant: EventParticipant) async throws {
        try await cloudKitManager.saveEventParticipant(participant)
    }
}
