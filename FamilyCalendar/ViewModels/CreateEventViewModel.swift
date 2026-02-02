//
//  CreateEventViewModel.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation
import Combine

/// 创建事项视图模型
@MainActor
class CreateEventViewModel: ObservableObject {
    @Published var title = ""
    @Published var eventDescription = ""
    @Published var location = ""
    @Published var startDate = Date()
    @Published var endDate = Date().addingTimeInterval(3600)
    @Published var selectedCategory: EventCategory?
    @Published var selectedMemberIDs = Set<String>()
    @Published var hasReminder = false
    @Published var reminderTime = Date()
    @Published var isLoading = false
    @Published var errorMessage: String?

    let availableCategories = EventCategory.allCases
    var availableMembers: [FamilyMember] = []

    private let eventRepository: EventRepositoryProtocol
    private var familyID: String

    init(familyID: String, eventRepository: EventRepositoryProtocol = EventRepository()) {
        self.familyID = familyID
        self.eventRepository = eventRepository
    }

    func setMembers(_ members: [FamilyMember]) {
        availableMembers = members
    }

    func validateInput() -> Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "请输入事项标题"
            return false
        }

        guard endDate > startDate else {
            errorMessage = "结束时间必须晚于开始时间"
            return false
        }

        return true
    }

    func createEvent() async -> Bool {
        guard validateInput() else { return false }

        guard let currentUserID = User.current?.id else {
            errorMessage = "未登录"
            return false
        }

        isLoading = true
        defer { isLoading = false }

        let newEvent = Event(
            familyID: familyID,
            creatorID: currentUserID,
            title: title,
            description: eventDescription.isEmpty ? nil : eventDescription,
            location: location.isEmpty ? nil : location,
            startDate: startDate,
            endDate: endDate,
            category: selectedCategory,
            reminderTime: hasReminder ? reminderTime : nil
        )

        do {
            try await eventRepository.createEvent(newEvent)

            // 创建参与人记录
            if !selectedMemberIDs.isEmpty {
                for memberID in selectedMemberIDs {
                    let participant = EventParticipant(
                        eventID: newEvent.id,
                        userID: memberID,
                        status: .pending
                    )
                    try await eventRepository.updateParticipant(participant)
                }
            }

            return true
        } catch {
            errorMessage = "创建事项失败: \(error.localizedDescription)"
            return false
        }
    }
}
