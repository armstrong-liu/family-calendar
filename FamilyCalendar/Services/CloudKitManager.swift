//
//  CloudKitManager.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import CloudKit
import Foundation

/// CloudKit管理器
class CloudKitManager {
    static let shared = CloudKitManager()

    private let container: CKContainer
    private let privateDB: CKDatabase
    private let sharedDB: CKDatabase

    private init() {
        self.container = CKContainer(identifier: "icloud.com.familycalendar.app")
        self.privateDB = container.privateCloudDatabase
        self.sharedDB = container.sharedCloudDatabase
    }

    // MARK: - User Operations

    func saveUser(_ user: User) async throws {
        let record = CKRecord(recordType: "User", recordID: CKRecord.ID(recordName: user.id))
        record["phoneNumber"] = user.phoneNumber
        record["appleID"] = user.appleID
        record["nickname"] = user.nickname
        record["avatarURL"] = user.avatarURL
        record["createdAt"] = user.createdAt
        record["lastLoginAt"] = user.lastLoginAt

        try await privateDB.save(record)
    }

    func fetchUser(userID: String) async throws -> User? {
        let recordID = CKRecord.ID(recordName: userID)
        let record = try await privateDB.record(for: recordID)

        return User(
            id: record.recordID.recordName,
            phoneNumber: record["phoneNumber"] as? String,
            appleID: record["appleID"] as? String,
            nickname: record["nickname"] as? String ?? "",
            avatarURL: record["avatarURL"] as? String,
            createdAt: record["createdAt"] as? Date ?? Date(),
            lastLoginAt: record["lastLoginAt"] as? Date
        )
    }

    // MARK: - Family Operations

    func saveFamily(_ family: Family) async throws {
        let record = CKRecord(recordType: "Family", recordID: CKRecord.ID(recordName: family.id))
        record["name"] = family.name
        record["adminID"] = family.adminID
        record["inviteCode"] = family.inviteCode
        record["createdAt"] = family.createdAt
        record["memberCount"] = family.memberCount

        try await sharedDB.save(record)
    }

    func fetchFamilies() async throws -> [Family] {
        let query = CKQuery(recordType: "Family", predicate: NSPredicate(value: true))
        let (matchResults, _) = try await sharedDB.records(matching: query)

        var families: [Family] = []
        for (_, result) in matchResults {
            switch result {
            case .success(let record):
                let family = Family(
                    id: record.recordID.recordName,
                    name: record["name"] as? String ?? "",
                    adminID: record["adminID"] as? String ?? "",
                    inviteCode: record["inviteCode"] as? String ?? "",
                    createdAt: record["createdAt"] as? Date ?? Date(),
                    memberCount: record["memberCount"] as? Int ?? 0
                )
                families.append(family)
            case .failure:
                break
            }
        }

        return families
    }

    func joinFamily(inviteCode: String) async throws -> Family? {
        let query = CKQuery(recordType: "Family", predicate: NSPredicate(format: "inviteCode == %@", inviteCode))
        let (matchResults, _) = try await sharedDB.records(matching: query)

        for (_, result) in matchResults {
            switch result {
            case .success(let record):
                return Family(
                    id: record.recordID.recordName,
                    name: record["name"] as? String ?? "",
                    adminID: record["adminID"] as? String ?? "",
                    inviteCode: record["inviteCode"] as? String ?? "",
                    createdAt: record["createdAt"] as? Date ?? Date(),
                    memberCount: record["memberCount"] as? Int ?? 0
                )
            case .failure:
                continue
            }
        }

        return nil
    }

    // MARK: - FamilyMember Operations

    func saveFamilyMember(_ member: FamilyMember) async throws {
        let record = CKRecord(recordType: "FamilyMember", recordID: CKRecord.ID(recordName: member.id))
        record["familyID"] = member.familyID
        record["userID"] = member.userID
        record["role"] = member.role.rawValue
        record["nickname"] = member.nickname
        record["joinedAt"] = member.joinedAt
        record["notificationEnabled"] = member.notificationEnabled

        try await sharedDB.save(record)
    }

    func fetchFamilyMembers(familyID: String) async throws -> [FamilyMember] {
        let predicate = NSPredicate(format: "familyID == %@", familyID)
        let query = CKQuery(recordType: "FamilyMember", predicate: predicate)
        let (matchResults, _) = try await sharedDB.records(matching: query)

        var members: [FamilyMember] = []
        for (_, result) in matchResults {
            switch result {
            case .success(let record):
                let roleRaw = record["role"] as? String ?? "member"
                let member = FamilyMember(
                    id: record.recordID.recordName,
                    familyID: record["familyID"] as? String ?? "",
                    userID: record["userID"] as? String ?? "",
                    role: MemberRole(rawValue: roleRaw) ?? .member,
                    nickname: record["nickname"] as? String ?? "",
                    joinedAt: record["joinedAt"] as? Date ?? Date(),
                    notificationEnabled: record["notificationEnabled"] as? Bool ?? true
                )
                members.append(member)
            case .failure:
                break
            }
        }

        return members
    }

    // MARK: - Event Operations

    func saveEvent(_ event: Event) async throws {
        let record = CKRecord(recordType: "Event", recordID: CKRecord.ID(recordName: event.id))
        record["familyID"] = event.familyID
        record["creatorID"] = event.creatorID
        record["title"] = event.title
        record["description"] = event.description
        record["location"] = event.location
        record["startDate"] = event.startDate
        record["endDate"] = event.endDate
        record["category"] = event.category?.rawValue
        record["reminderTime"] = event.reminderTime
        record["isDeleted"] = event.isDeleted
        record["createdAt"] = event.createdAt
        record["updatedAt"] = event.updatedAt

        try await sharedDB.save(record)
    }

    func fetchEvents(familyID: String, startDate: Date, endDate: Date) async throws -> [Event] {
        let predicate = NSPredicate(format: "familyID == %@ AND startDate >= %@ AND startDate <= %@",
                                   familyID, startDate as NSDate, endDate as NSDate)
        let query = CKQuery(recordType: "Event", predicate: predicate)
        let (matchResults, _) = try await sharedDB.records(matching: query)

        var events: [Event] = []
        for (_, result) in matchResults {
            switch result {
            case .success(let record):
                guard let isDeleted = record["isDeleted"] as? Bool, !isDeleted else { continue }

                let categoryRaw = record["category"] as? String
                let event = Event(
                    id: record.recordID.recordName,
                    familyID: record["familyID"] as? String ?? "",
                    creatorID: record["creatorID"] as? String ?? "",
                    title: record["title"] as? String ?? "",
                    description: record["description"] as? String,
                    location: record["location"] as? String,
                    startDate: record["startDate"] as? Date ?? Date(),
                    endDate: record["endDate"] as? Date ?? Date(),
                    category: categoryRaw.flatMap { EventCategory(rawValue: $0) },
                    reminderTime: record["reminderTime"] as? Date,
                    isDeleted: isDeleted,
                    createdAt: record["createdAt"] as? Date ?? Date(),
                    updatedAt: record["updatedAt"] as? Date ?? Date()
                )
                events.append(event)
            case .failure:
                break
            }
        }

        return events.sorted { $0.startDate < $1.startDate }
    }

    func deleteEvent(eventID: String) async throws {
        let recordID = CKRecord.ID(recordName: eventID)
        try await sharedDB.deleteRecord(withID: recordID)
    }

    // MARK: - EventParticipant Operations

    func saveEventParticipant(_ participant: EventParticipant) async throws {
        let record = CKRecord(recordType: "EventParticipant", recordID: CKRecord.ID(recordName: participant.id))
        record["eventID"] = participant.eventID
        record["userID"] = participant.userID
        record["status"] = participant.status.rawValue
        record["comment"] = participant.comment
        record["respondedAt"] = participant.respondedAt
        record["createdAt"] = participant.createdAt

        try await sharedDB.save(record)
    }

    func fetchEventParticipants(eventID: String) async throws -> [EventParticipant] {
        let predicate = NSPredicate(format: "eventID == %@", eventID)
        let query = CKQuery(recordType: "EventParticipant", predicate: predicate)
        let (matchResults, _) = try await sharedDB.records(matching: query)

        var participants: [EventParticipant] = []
        for (_, result) in matchResults {
            switch result {
            case .success(let record):
                let statusRaw = record["status"] as? String ?? "pending"
                let participant = EventParticipant(
                    id: record.recordID.recordName,
                    eventID: record["eventID"] as? String ?? "",
                    userID: record["userID"] as? String ?? "",
                    status: ResponseStatus(rawValue: statusRaw) ?? .pending,
                    comment: record["comment"] as? String,
                    respondedAt: record["respondedAt"] as? Date,
                    createdAt: record["createdAt"] as? Date ?? Date()
                )
                participants.append(participant)
            case .failure:
                break
            }
        }

        return participants
    }

    // MARK: - Subscription

    func subscribeToNotifications() async throws {
        let subscription = CKQuerySubscription(
            recordType: "Event",
            predicate: NSPredicate(value: true),
            subscriptionID: "event-changes"
        )

        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo

        try await sharedDB.save(subscription)
    }
}
