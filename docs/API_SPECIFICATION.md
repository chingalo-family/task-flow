# API Specification for Task Flow

This document provides a comprehensive specification for implementing backend API endpoints to support Task Flow's complete functionality, including authentication, CRUD operations for all modules using ObjectBox.

## Table of Contents
- [Overview](#overview)
- [Authentication](#authentication)
- [API Endpoints](#api-endpoints)
  - [User Management](#user-management)
  - [Task Management](#task-management)
  - [Team Management](#team-management)
  - [Notification Management](#notification-management)
- [Data Models](#data-models)
- [Error Handling](#error-handling)
- [Rate Limiting](#rate-limiting)
- [Security Considerations](#security-considerations)

## Overview

### Base URL
```
Production: https://api.taskflow.com/v1
Development: https://dev-api.taskflow.com/v1
Local: http://localhost:8080/v1
```

### Content Type
All requests and responses use `application/json` unless otherwise specified.

### Date Format
All dates follow ISO 8601 format: `YYYY-MM-DDTHH:mm:ss.sssZ`

## Authentication

### Supported Authentication Methods

#### 1. Email/Password Authentication
Traditional email and password based authentication.

**POST** `/auth/register`
```json
// Request
{
  "username": "johndoe",
  "email": "john@example.com",
  "password": "SecurePass123!",
  "firstName": "John",
  "surname": "Doe",
  "phoneNumber": "+1234567890"
}

// Response (201 Created)
{
  "user": {
    "id": "usr_123abc",
    "username": "johndoe",
    "email": "john@example.com",
    "fullName": "John Doe",
    "phoneNumber": "+1234567890",
    "createdAt": "2026-01-05T10:00:00.000Z"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "refresh_token_here"
}
```

**POST** `/auth/login`
```json
// Request
{
  "username": "johndoe",
  "password": "SecurePass123!"
}

// Response (200 OK)
{
  "user": {
    "id": "usr_123abc",
    "username": "johndoe",
    "email": "john@example.com",
    "fullName": "John Doe",
    "phoneNumber": "+1234567890",
    "isLogin": true
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "refresh_token_here",
  "expiresIn": 3600
}
```

#### 2. Google OAuth Authentication
OAuth 2.0 authentication flow with Google.

**POST** `/auth/google`
```json
// Request
{
  "idToken": "google_id_token_here"
}

// Response (200 OK)
{
  "user": {
    "id": "usr_123abc",
    "username": "johndoe",
    "email": "john@example.com",
    "fullName": "John Doe",
    "avatarUrl": "https://..."
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "refresh_token_here",
  "isNewUser": false
}
```

#### 3. Apple Sign-In Authentication
Sign in with Apple integration.

**POST** `/auth/apple`
```json
// Request
{
  "identityToken": "apple_identity_token",
  "authorizationCode": "apple_auth_code",
  "user": {
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com"
  }
}

// Response (200 OK)
{
  "user": {
    "id": "usr_123abc",
    "username": "johndoe",
    "email": "john@example.com",
    "fullName": "John Doe"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "refresh_token_here",
  "isNewUser": true
}
```

### Token Management

**POST** `/auth/refresh`
```json
// Request
{
  "refreshToken": "refresh_token_here"
}

// Response (200 OK)
{
  "token": "new_access_token",
  "refreshToken": "new_refresh_token",
  "expiresIn": 3600
}
```

**POST** `/auth/logout`
```json
// Request Headers
Authorization: Bearer {token}

// Response (200 OK)
{
  "message": "Successfully logged out"
}
```

**POST** `/auth/password/change`
```json
// Request
{
  "currentPassword": "OldPass123!",
  "newPassword": "NewSecurePass456!"
}

// Response (200 OK)
{
  "message": "Password changed successfully"
}
```

**POST** `/auth/password/reset/request`
```json
// Request
{
  "email": "john@example.com"
}

// Response (200 OK)
{
  "message": "Password reset email sent"
}
```

**POST** `/auth/password/reset/confirm`
```json
// Request
{
  "token": "reset_token_from_email",
  "newPassword": "NewSecurePass456!"
}

// Response (200 OK)
{
  "message": "Password reset successful"
}
```

## API Endpoints

### User Management

All user endpoints require authentication via Bearer token.

#### Get Current User
**GET** `/users/me`

```json
// Response (200 OK)
{
  "id": "usr_123abc",
  "username": "johndoe",
  "email": "john@example.com",
  "fullName": "John Doe",
  "phoneNumber": "+1234567890",
  "isLogin": true,
  "createdAt": "2026-01-01T00:00:00.000Z",
  "updatedAt": "2026-01-05T10:00:00.000Z"
}
```

#### Update Current User
**PATCH** `/users/me`

```json
// Request
{
  "fullName": "John Updated Doe",
  "phoneNumber": "+1234567891",
  "email": "john.updated@example.com"
}

// Response (200 OK)
{
  "id": "usr_123abc",
  "username": "johndoe",
  "email": "john.updated@example.com",
  "fullName": "John Updated Doe",
  "phoneNumber": "+1234567891",
  "updatedAt": "2026-01-05T11:00:00.000Z"
}
```

#### Get User by ID
**GET** `/users/{userId}`

```json
// Response (200 OK)
{
  "id": "usr_123abc",
  "username": "johndoe",
  "fullName": "John Doe",
  "email": "john@example.com",
  "createdAt": "2026-01-01T00:00:00.000Z"
}
```

#### List Users
**GET** `/users`

Query Parameters:
- `page` (integer, default: 1)
- `limit` (integer, default: 30, max: 100)
- `search` (string, optional)
- `sortBy` (string: username|fullName|createdAt, default: username)
- `sortOrder` (string: asc|desc, default: asc)

```json
// Response (200 OK)
{
  "users": [
    {
      "id": "usr_123abc",
      "username": "johndoe",
      "fullName": "John Doe",
      "email": "john@example.com"
    },
    {
      "id": "usr_456def",
      "username": "janedoe",
      "fullName": "Jane Doe",
      "email": "jane@example.com"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 30,
    "total": 150,
    "totalPages": 5
  }
}
```

#### Sync Users
**GET** `/users/sync`

Query Parameters:
- `lastSyncedAt` (ISO date, optional) - Returns users updated after this timestamp

```json
// Response (200 OK)
{
  "users": [...],
  "syncedAt": "2026-01-05T12:00:00.000Z",
  "hasMore": false
}
```

### Task Management

#### Create Task
**POST** `/tasks`

```json
// Request
{
  "title": "Implement user authentication",
  "description": "Add Google and Apple sign-in options",
  "status": "pending",
  "priority": "high",
  "category": "Development",
  "assignedToUserId": "usr_456def",
  "teamId": "team_789ghi",
  "dueDate": "2026-01-15T23:59:59.000Z",
  "tags": ["auth", "security", "feature"],
  "attachments": ["https://...", "https://..."],
  "subtasks": [
    {
      "title": "Setup Google OAuth",
      "completed": false
    },
    {
      "title": "Setup Apple Sign-In",
      "completed": false
    }
  ],
  "remindMe": true,
  "progress": 0
}

// Response (201 Created)
{
  "id": "task_abc123",
  "taskId": "task_abc123",
  "title": "Implement user authentication",
  "description": "Add Google and Apple sign-in options",
  "status": "pending",
  "priority": "high",
  "category": "Development",
  "assignedToUserId": "usr_456def",
  "assignedToUsername": "janedoe",
  "teamId": "team_789ghi",
  "teamName": "Development Team",
  "dueDate": "2026-01-15T23:59:59.000Z",
  "tags": ["auth", "security", "feature"],
  "attachments": ["https://...", "https://..."],
  "subtasks": [...],
  "remindMe": true,
  "progress": 0,
  "isSynced": true,
  "createdAt": "2026-01-05T12:00:00.000Z",
  "updatedAt": "2026-01-05T12:00:00.000Z"
}
```

#### Get Task by ID
**GET** `/tasks/{taskId}`

```json
// Response (200 OK)
{
  "id": "task_abc123",
  "taskId": "task_abc123",
  "title": "Implement user authentication",
  "description": "Add Google and Apple sign-in options",
  "status": "in_progress",
  "priority": "high",
  "category": "Development",
  "assignedToUserId": "usr_456def",
  "assignedToUsername": "janedoe",
  "assignedUserIds": ["usr_456def", "usr_789ghi"],
  "teamId": "team_789ghi",
  "teamName": "Development Team",
  "projectId": "proj_001",
  "projectName": "Q1 2026 Release",
  "dueDate": "2026-01-15T23:59:59.000Z",
  "completedAt": null,
  "tags": ["auth", "security", "feature"],
  "attachments": ["https://...", "https://..."],
  "subtasks": [...],
  "remindMe": true,
  "progress": 30,
  "isSynced": true,
  "createdAt": "2026-01-05T12:00:00.000Z",
  "updatedAt": "2026-01-06T09:30:00.000Z"
}
```

#### Update Task
**PATCH** `/tasks/{taskId}`

```json
// Request
{
  "status": "in_progress",
  "progress": 50,
  "assignedUserIds": ["usr_456def", "usr_789ghi"]
}

// Response (200 OK)
{
  "id": "task_abc123",
  "status": "in_progress",
  "progress": 50,
  "assignedUserIds": ["usr_456def", "usr_789ghi"],
  "updatedAt": "2026-01-07T14:20:00.000Z",
  ...
}
```

#### Delete Task
**DELETE** `/tasks/{taskId}`

```json
// Response (204 No Content)
```

#### List Tasks
**GET** `/tasks`

Query Parameters:
- `page` (integer, default: 1)
- `limit` (integer, default: 30, max: 100)
- `status` (string: pending|in_progress|completed)
- `priority` (string: low|medium|high)
- `category` (string)
- `assignedToUserId` (string)
- `teamId` (string)
- `search` (string)
- `sortBy` (string: dueDate|priority|createdAt|updatedAt)
- `sortOrder` (string: asc|desc)
- `dueDateFrom` (ISO date)
- `dueDateTo` (ISO date)

```json
// Response (200 OK)
{
  "tasks": [
    {
      "id": "task_abc123",
      "title": "Implement user authentication",
      "status": "in_progress",
      "priority": "high",
      "dueDate": "2026-01-15T23:59:59.000Z",
      ...
    },
    ...
  ],
  "pagination": {
    "page": 1,
    "limit": 30,
    "total": 250,
    "totalPages": 9
  },
  "summary": {
    "pending": 100,
    "inProgress": 50,
    "completed": 100
  }
}
```

#### Sync Tasks
**GET** `/tasks/sync`

Query Parameters:
- `lastSyncedAt` (ISO date, optional)
- `teamId` (string, optional)

```json
// Response (200 OK)
{
  "tasks": [...],
  "deleted": ["task_xyz789"],
  "syncedAt": "2026-01-07T15:00:00.000Z",
  "hasMore": false
}
```

### Team Management

#### Create Team
**POST** `/teams`

```json
// Request
{
  "name": "Development Team",
  "description": "Core development team for Task Flow",
  "teamIcon": "rocket",
  "teamColor": "#2E90FA",
  "memberIds": ["usr_123abc", "usr_456def"],
  "customTaskStatuses": [
    {
      "key": "code_review",
      "label": "Code Review",
      "color": "#F59E0B"
    },
    {
      "key": "testing",
      "label": "Testing",
      "color": "#10B981"
    }
  ]
}

// Response (201 Created)
{
  "id": "team_789ghi",
  "teamId": "team_789ghi",
  "name": "Development Team",
  "description": "Core development team for Task Flow",
  "teamIcon": "rocket",
  "teamColor": "#2E90FA",
  "memberCount": 2,
  "memberIds": ["usr_123abc", "usr_456def"],
  "taskIds": [],
  "customTaskStatuses": [...],
  "createdByUserId": "usr_123abc",
  "createdByUsername": "johndoe",
  "isSynced": true,
  "createdAt": "2026-01-05T12:00:00.000Z",
  "updatedAt": "2026-01-05T12:00:00.000Z"
}
```

#### Get Team by ID
**GET** `/teams/{teamId}`

```json
// Response (200 OK)
{
  "id": "team_789ghi",
  "teamId": "team_789ghi",
  "name": "Development Team",
  "description": "Core development team for Task Flow",
  "teamIcon": "rocket",
  "teamColor": "#2E90FA",
  "memberCount": 5,
  "memberIds": ["usr_123abc", "usr_456def", ...],
  "members": [
    {
      "id": "usr_123abc",
      "username": "johndoe",
      "fullName": "John Doe"
    },
    ...
  ],
  "taskIds": ["task_abc123", ...],
  "tasks": [...],
  "customTaskStatuses": [...],
  "createdByUserId": "usr_123abc",
  "createdByUsername": "johndoe",
  "createdAt": "2026-01-05T12:00:00.000Z",
  "updatedAt": "2026-01-07T10:00:00.000Z"
}
```

#### Update Team
**PATCH** `/teams/{teamId}`

```json
// Request
{
  "name": "Updated Development Team",
  "description": "Updated description",
  "teamColor": "#FF6B9D"
}

// Response (200 OK)
{
  "id": "team_789ghi",
  "name": "Updated Development Team",
  "description": "Updated description",
  "teamColor": "#FF6B9D",
  "updatedAt": "2026-01-07T11:00:00.000Z",
  ...
}
```

#### Delete Team
**DELETE** `/teams/{teamId}`

```json
// Response (204 No Content)
```

#### List Teams
**GET** `/teams`

Query Parameters:
- `page` (integer, default: 1)
- `limit` (integer, default: 30, max: 100)
- `search` (string)
- `memberUserId` (string) - Filter teams by member

```json
// Response (200 OK)
{
  "teams": [
    {
      "id": "team_789ghi",
      "name": "Development Team",
      "memberCount": 5,
      "taskCount": 25,
      ...
    },
    ...
  ],
  "pagination": {
    "page": 1,
    "limit": 30,
    "total": 12,
    "totalPages": 1
  }
}
```

#### Add Team Member
**POST** `/teams/{teamId}/members`

```json
// Request
{
  "userId": "usr_999xyz"
}

// Response (200 OK)
{
  "team": {
    "id": "team_789ghi",
    "memberCount": 6,
    "memberIds": ["usr_123abc", ..., "usr_999xyz"],
    ...
  },
  "notification": {
    "id": "notif_abc123",
    "type": "team_invite",
    "userId": "usr_999xyz"
  }
}
```

#### Remove Team Member
**DELETE** `/teams/{teamId}/members/{userId}`

```json
// Response (200 OK)
{
  "team": {
    "id": "team_789ghi",
    "memberCount": 5,
    "memberIds": ["usr_123abc", ...],
    ...
  }
}
```

#### Add Task to Team
**POST** `/teams/{teamId}/tasks`

```json
// Request
{
  "taskId": "task_abc123"
}

// Response (200 OK)
{
  "team": {
    "id": "team_789ghi",
    "taskIds": ["task_abc123", ...],
    ...
  }
}
```

#### Sync Teams
**GET** `/teams/sync`

```json
// Response (200 OK)
{
  "teams": [...],
  "deleted": ["team_old123"],
  "syncedAt": "2026-01-07T15:00:00.000Z",
  "hasMore": false
}
```

### Notification Management

#### Create Notification
**POST** `/notifications`

```json
// Request
{
  "title": "New task assigned",
  "body": "You have been assigned to 'Implement user authentication'",
  "type": "task_assigned",
  "relatedEntityId": "task_abc123",
  "relatedEntityType": "task",
  "recipientUserId": "usr_456def",
  "actorUserId": "usr_123abc",
  "metadata": {
    "taskTitle": "Implement user authentication",
    "taskPriority": "high"
  }
}

// Response (201 Created)
{
  "id": "notif_abc123",
  "notificationId": "notif_abc123",
  "title": "New task assigned",
  "body": "You have been assigned to 'Implement user authentication'",
  "type": "task_assigned",
  "isRead": false,
  "relatedEntityId": "task_abc123",
  "relatedEntityType": "task",
  "actorUserId": "usr_123abc",
  "actorUsername": "johndoe",
  "actorAvatarUrl": null,
  "metadata": {...},
  "isSynced": true,
  "createdAt": "2026-01-07T15:30:00.000Z"
}
```

#### Get Notification by ID
**GET** `/notifications/{notificationId}`

```json
// Response (200 OK)
{
  "id": "notif_abc123",
  "notificationId": "notif_abc123",
  "title": "New task assigned",
  "body": "You have been assigned to 'Implement user authentication'",
  "type": "task_assigned",
  "isRead": false,
  ...
}
```

#### Mark Notification as Read
**PATCH** `/notifications/{notificationId}/read`

```json
// Response (200 OK)
{
  "id": "notif_abc123",
  "isRead": true,
  "updatedAt": "2026-01-07T16:00:00.000Z"
}
```

#### Mark All Notifications as Read
**PATCH** `/notifications/read-all`

```json
// Response (200 OK)
{
  "message": "All notifications marked as read",
  "count": 15
}
```

#### Delete Notification
**DELETE** `/notifications/{notificationId}`

```json
// Response (204 No Content)
```

#### List Notifications
**GET** `/notifications`

Query Parameters:
- `page` (integer, default: 1)
- `limit` (integer, default: 30, max: 100)
- `isRead` (boolean)
- `type` (string: task_assigned|team_invite|task_completed|mention|system)
- `sortBy` (string: createdAt, default: createdAt)
- `sortOrder` (string: asc|desc, default: desc)

```json
// Response (200 OK)
{
  "notifications": [
    {
      "id": "notif_abc123",
      "title": "New task assigned",
      "type": "task_assigned",
      "isRead": false,
      "createdAt": "2026-01-07T15:30:00.000Z",
      ...
    },
    ...
  ],
  "pagination": {
    "page": 1,
    "limit": 30,
    "total": 150,
    "totalPages": 5
  },
  "unreadCount": 12
}
```

#### Sync Notifications
**GET** `/notifications/sync`

```json
// Response (200 OK)
{
  "notifications": [...],
  "deleted": ["notif_old123"],
  "syncedAt": "2026-01-07T16:00:00.000Z",
  "hasMore": false
}
```

## Data Models

### User Entity
```typescript
interface User {
  id: string;              // ObjectBox id mapped to apiUserId
  apiUserId: string;       // API user id
  username: string;        // Unique username
  fullName?: string;       // Display name
  password?: string;       // Hashed password (not returned in API responses)
  email?: string;          // Email address
  phoneNumber?: string;    // Phone number
  isLogin: boolean;        // Login status
  createdAt: Date;         // Account creation date
  updatedAt: Date;         // Last update date
}
```

### Task Entity
```typescript
interface Task {
  id: string;                    // ObjectBox id
  taskId: string;                // API task id
  title: string;                 // Task title
  description?: string;          // Task description
  status: 'pending' | 'in_progress' | 'completed'; // Task status
  priority: 'low' | 'medium' | 'high';             // Priority level
  category?: string;             // Task category
  assignedToUserId?: string;     // Primary assignee
  assignedToUsername?: string;   // Primary assignee username
  assignedUserIds?: string[];    // Multiple assignees (JSON)
  teamId?: string;               // Associated team
  teamName?: string;             // Team name
  dueDate?: Date;                // Due date
  completedAt?: Date;            // Completion date
  projectId?: string;            // Project ID
  projectName?: string;          // Project name
  tags?: string[];               // Tags (JSON array)
  attachments?: string[];        // Attachment URLs (JSON array)
  subtasks?: Subtask[];          // Subtasks (JSON array)
  remindMe?: boolean;            // Reminder flag
  progress: number;              // Progress 0-100
  isSynced: boolean;             // Sync status
  createdAt: Date;               // Creation date
  updatedAt: Date;               // Last update date
}

interface Subtask {
  title: string;
  completed: boolean;
}
```

### Team Entity
```typescript
interface Team {
  id: string;                    // ObjectBox id
  teamId: string;                // API team id
  name: string;                  // Team name
  description?: string;          // Team description
  avatarUrl?: string;            // Team avatar URL
  memberCount: number;           // Number of members
  createdByUserId?: string;      // Creator user ID
  createdByUsername?: string;    // Creator username
  createdAt: Date;               // Creation date
  updatedAt: Date;               // Last update date
  isSynced: boolean;             // Sync status
  memberIds?: string[];          // Member IDs (JSON array)
  taskIds?: string[];            // Task IDs (JSON array)
  customTaskStatuses?: CustomStatus[]; // Custom statuses (JSON array)
  teamIcon?: string;             // Icon key
  teamColor?: string;            // Hex color
}

interface CustomStatus {
  key: string;
  label: string;
  color: string;
}
```

### Notification Entity
```typescript
interface Notification {
  id: string;                    // ObjectBox id
  notificationId: string;        // API notification id
  title: string;                 // Notification title
  body?: string;                 // Notification body
  type: string;                  // Notification type
  isRead: boolean;               // Read status
  relatedEntityId?: string;      // Related entity ID
  relatedEntityType?: string;    // Related entity type
  actorUserId?: string;          // Actor user ID
  actorUsername?: string;        // Actor username
  actorAvatarUrl?: string;       // Actor avatar URL
  createdAt: Date;               // Creation date
  metadata?: any;                // Additional metadata (JSON)
  isSynced: boolean;             // Sync status
}
```

## Error Handling

All error responses follow this format:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": {
      // Additional error details
    }
  }
}
```

### HTTP Status Codes

- `200 OK` - Successful GET, PATCH requests
- `201 Created` - Successful POST requests
- `204 No Content` - Successful DELETE requests
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Missing or invalid authentication
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Resource not found
- `409 Conflict` - Resource conflict (e.g., duplicate username)
- `422 Unprocessable Entity` - Validation errors
- `429 Too Many Requests` - Rate limit exceeded
- `500 Internal Server Error` - Server error

### Common Error Codes

```typescript
// Authentication errors
AUTH_INVALID_CREDENTIALS      // Invalid username/password
AUTH_TOKEN_EXPIRED            // Access token expired
AUTH_TOKEN_INVALID            // Invalid token format
AUTH_GOOGLE_FAILED            // Google OAuth failed
AUTH_APPLE_FAILED             // Apple Sign-In failed

// Validation errors
VALIDATION_FAILED             // General validation error
VALIDATION_REQUIRED_FIELD     // Required field missing
VALIDATION_INVALID_FORMAT     // Invalid data format
VALIDATION_DUPLICATE          // Duplicate entry

// Resource errors
RESOURCE_NOT_FOUND            // Resource doesn't exist
RESOURCE_ALREADY_EXISTS       // Resource already exists
RESOURCE_CONFLICT             // Resource state conflict

// Permission errors
PERMISSION_DENIED             // Insufficient permissions
TEAM_ACCESS_DENIED            // No access to team
TASK_ACCESS_DENIED            // No access to task

// Rate limiting
RATE_LIMIT_EXCEEDED           // Too many requests
```

## Rate Limiting

API implements rate limiting to prevent abuse:

- **Authentication endpoints**: 5 requests per minute per IP
- **Standard endpoints**: 100 requests per minute per user
- **Sync endpoints**: 30 requests per minute per user

Rate limit headers are included in all responses:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1704632400
```

## Security Considerations

### Authentication
- Use JWT tokens with short expiration (1 hour recommended)
- Implement refresh token rotation
- Store tokens securely on client (Flutter Secure Storage)
- Support token revocation on logout

### Data Protection
- Use HTTPS for all API communications
- Encrypt sensitive data in transit and at rest
- Implement proper password hashing (bcrypt, Argon2)
- Sanitize all user inputs

### Authorization
- Implement role-based access control (RBAC)
- Verify team membership before granting access to team resources
- Validate task assignment permissions
- Implement proper scope validation for OAuth flows

### Best Practices
- Implement CORS policies
- Use API versioning
- Log security events
- Implement request signing for critical operations
- Regular security audits
- Keep dependencies updated

## ObjectBox Integration

The app uses ObjectBox for local data persistence. The backend API should support:

### Sync Strategy
1. **Initial Sync**: Fetch all data when user first logs in
2. **Incremental Sync**: Fetch only changes since last sync using `lastSyncedAt`
3. **Conflict Resolution**: Server wins for conflicts, but flag for manual review
4. **Offline Support**: Queue local changes and sync when online

### Sync Endpoints Pattern
All sync endpoints follow this pattern:
- Accept `lastSyncedAt` query parameter
- Return `syncedAt` timestamp for next sync
- Return `deleted` array of IDs removed since last sync
- Support pagination with `hasMore` flag

### Local-First Approach
The app should:
1. Store all data locally in ObjectBox
2. Work fully offline with local data
3. Sync in background when connectivity available
4. Show sync status to users
5. Handle sync conflicts gracefully

## Pagination

All list endpoints support pagination:

```json
// Query Parameters
?page=1&limit=30

// Response includes
{
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 30,
    "total": 250,
    "totalPages": 9,
    "hasNext": true,
    "hasPrev": false
  }
}
```

## Filtering and Sorting

List endpoints support filtering and sorting:

```
// Filtering
?status=in_progress&priority=high&teamId=team_789ghi

// Sorting
?sortBy=dueDate&sortOrder=desc

// Searching
?search=authentication

// Combining
?status=pending&search=api&sortBy=priority&sortOrder=desc&page=1&limit=50
```

## Webhooks (Future)

Future support for webhooks to notify external systems:

```json
POST https://your-app.com/webhook
{
  "event": "task.created",
  "timestamp": "2026-01-07T17:00:00.000Z",
  "data": {
    "taskId": "task_abc123",
    "title": "New Task",
    ...
  }
}
```

Event types:
- `task.created`, `task.updated`, `task.deleted`, `task.completed`
- `team.created`, `team.updated`, `team.deleted`
- `user.created`, `user.updated`
- `notification.created`

## API Versioning

The API uses URL versioning:
- Current version: `/v1`
- Future versions: `/v2`, `/v3`, etc.
- Deprecated versions will be supported for at least 6 months

## Additional Resources

- [Authentication Guide](AUTHENTICATION.md)
- [Database Schema](DATABASE_SCHEMA.md)
- [Architecture Overview](ARCHITECTURE.md)
- [Getting Started Guide](GETTING_STARTED.md)

---

**Last Updated:** January 2026  
**API Version:** 1.0.0
