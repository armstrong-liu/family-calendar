# CloudKit Schema for Family Calendar

This document defines the CloudKit schema for the Family Calendar app.

## Record Types

### User
Represents a user in the system.

**Fields:**
- `phoneNumber` (String): User's phone number (optional)
- `appleID` (String): Apple ID identifier
- `nickname` (String): Display name
- `avatarURL` (String): URL to avatar image (optional)
- `createdAt` (DateTime): Account creation timestamp
- `lastLoginAt` (DateTime): Last login timestamp (optional)

**Database:** Private

### Family
Represents a family group.

**Fields:**
- `name` (String): Family display name
- `adminID` (String): User ID of the family admin
- `inviteCode` (String): 6-character invitation code
- `createdAt` (DateTime): Family creation timestamp
- `memberCount` (Int): Number of members

**Database:** Shared

### FamilyMember
Represents the relationship between a user and a family.

**Fields:**
- `familyID` (String): Reference to Family record
- `userID` (String): Reference to User record
- `role` (String): "admin" or "member"
- `nickname` (String): Nickname within the family
- `joinedAt` (DateTime): Join timestamp
- `notificationEnabled` (Boolean): Whether notifications are enabled

**Database:** Shared

### Event
Represents a calendar event.

**Fields:**
- `familyID` (String): Reference to Family record
- `creatorID` (String): User ID of the creator
- `title` (String): Event title
- `description` (String): Detailed description (optional)
- `location` (String): Event location (optional)
- `startDate` (DateTime): Event start time
- `endDate` (DateTime): Event end time
- `category` (String): Event category (optional)
- `reminderTime` (DateTime): Reminder time (optional)
- `isDeleted` (Boolean): Soft delete flag
- `createdAt` (DateTime): Creation timestamp
- `updatedAt` (DateTime): Last update timestamp

**Database:** Shared

**Indexes:**
- `familyID` (Queriable, Sortable)
- `startDate` (Queriable, Sortable)
- `creatorID` (Queriable)

### EventParticipant
Represents a user's participation in an event.

**Fields:**
- `eventID` (String): Reference to Event record
- `userID` (String): Reference to User record
- `status` (String): "pending", "accepted", "declined", or "tentative"
- `comment` (String): Comment (optional)
- `respondedAt` (DateTime): Response timestamp (optional)
- `createdAt` (DateTime): Creation timestamp

**Database:** Shared

**Indexes:**
- `eventID` (Queriable)
- `userID` (Queriable)

### Comment
Represents a comment on an event.

**Fields:**
- `eventID` (String): Reference to Event record
- `userID` (String): Reference to User record
- `content` (String): Comment content
- `createdAt` (DateTime): Creation timestamp

**Database:** Shared

**Indexes:**
- `eventID` (Queriable, Sortable)

### Notification
Represents an app notification.

**Fields:**
- `userID` (String): Reference to User record
- `type` (String): Notification type
- `title` (String): Notification title
- `body` (String): Notification body
- `eventID` (String): Reference to Event record (optional)
- `isRead` (Boolean): Read status
- `readAt` (DateTime): Read timestamp (optional)
- `createdAt` (DateTime): Creation timestamp

**Database:** Private

**Indexes:**
- `userID` (Queriable)
- `createdAt` (Sortable)

## Security Roles

### Owner
- Full access to all records
- Can delete the database

### User
- Read access to shared records
- Create access to shared records
- Update access to own records only
- No delete access

## Reference Actions

**FamilyMember.familyID → Family:**
- Action: Cascade delete
- When Family is deleted, all FamilyMembers are deleted

**EventParticipant.eventID → Event:**
- Action: Cascade delete
- When Event is deleted, all EventParticipants are deleted

**Comment.eventID → Event:**
- Action: Cascade delete
- When Event is deleted, all Comments are deleted

## Query Tips

### Fetch events for a family
```
SELECT * FROM Event
WHERE familyID = '<family_id>'
  AND startDate >= '<start_date>'
  AND startDate <= '<end_date>'
  AND isDeleted = false
ORDER BY startDate ASC
```

### Fetch members for a family
```
SELECT * FROM FamilyMember
WHERE familyID = '<family_id>'
```

### Fetch participants for an event
```
SELECT * FROM EventParticipant
WHERE eventID = '<event_id>'
```

## Subscriptions

### Event Changes Subscription
- **Record Type:** Event
- **Predicate:** `TRUEPREDICATE`
- **Query Subscription:** Yes
- **Notification Info:** `shouldSendContentAvailable = true`

This subscription enables real-time updates when events are created, modified, or deleted.

## Asset Handling

### User Avatars
- **Location:** Private Database
- **Field:** User.avatarURL (CKAsset)
- **Max Size:** 5 MB

### Event Images (Future)
- **Location:** Shared Database
- **Field:** Event.imageURLs (List of CKAsset)
- **Max Size:** 10 MB per image

## Schema Versioning

Current Version: 1.0.0

Version History:
- 1.0.0 - Initial schema

## Migration Strategy

When updating the schema:
1. Add new fields as optional
2. Maintain backward compatibility
3. Use schema versioning in CloudKit Dashboard
4. Test migration with sample data
