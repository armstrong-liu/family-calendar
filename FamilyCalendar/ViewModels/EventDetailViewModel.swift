//
//  EventDetailViewModel.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation
import Combine

/// 事项详情视图模型
@MainActor
class EventDetailViewModel: ObservableObject {
    @Published var event: Event
    @Published var participants: [EventParticipant] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showResponseSheet = false

    private let eventRepository: EventRepositoryProtocol

    init(event: Event, eventRepository: EventRepositoryProtocol = EventRepository()) {
        self.event = event
        self.eventRepository = eventRepository
    }

    func loadParticipants() async {
        isLoading = true
        defer { isLoading = false }

        do {
            participants = try await eventRepository.fetchParticipants(eventID: event.id)
        } catch {
            errorMessage = "加载参与人失败: \(error.localizedDescription)"
        }
    }

    func respondToEvent(status: ResponseStatus, comment: String? = nil) async {
        guard let currentUserID = User.current?.id else {
            errorMessage = "未登录"
            return
        }

        isLoading = true
        defer { isLoading = false }

        // 查找或创建参与者记录
        var participant = participants.first { $0.userID == currentUserID }
        if participant == nil {
            participant = EventParticipant(
                eventID: event.id,
                userID: currentUserID,
                status: status,
                comment: comment
            )
        } else {
            participant?.status = status
            participant?.comment = comment
            participant?.respondedAt = Date()
        }

        do {
            try await eventRepository.updateParticipant(participant!)
            await loadParticipants()
        } catch {
            errorMessage = "响应失败: \(error.localizedDescription)"
        }
    }

    func canEditEvent() -> Bool {
        guard let currentUserID = User.current?.id else { return false }
        return event.creatorID == currentUserID
    }
}
