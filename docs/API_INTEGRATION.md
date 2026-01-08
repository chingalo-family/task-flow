# API Integration Guide

This document provides a comprehensive guide to the Task Flow API integration, including endpoint details, authentication flow, and testing instructions.

## Base URL

```
https://vmi2503861.contaboserver.net/task-flow-api
```

API Documentation: https://vmi2503861.contaboserver.net/task-flow-api-docs/

## Authentication

### Register a New User

**Endpoint**: `POST /api/auth/register`

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "securepassword",
  "username": "johndoe",
  "name": "John Doe",
  "phoneNumber": "+1234567890"
}
```

**Success Response** (200/201):
```json
{
  "success": true,
  "message": "User registered successfully",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 604800,
  "expiresAt": "2026-01-15T08:23:43.434Z",
  "user": {
    "id": "e552f042-273c-4292-9bf6-f869e78b7094",
    "email": "user@example.com",
    "name": "John Doe",
    "username": "johndoe",
    "phoneNumber": "+1234567890"
  }
}
```

**Error Response** (400):
```json
{
  "success": false,
  "message": "Email or username already exists"
}
```

### Login

**Endpoint**: `POST /api/auth/login`

**Request Body**:
```json
{
  "username": "johndoe",
  "password": "securepassword"
}
```

**Success Response** (200):
```json
{
  "success": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 604800,
  "expiresAt": "2026-01-15T08:23:43.434Z",
  "user": {
    "id": "e552f042-273c-4292-9bf6-f869e78b7094",
    "email": "user@example.com",
    "name": "John Doe",
    "username": "johndoe",
    "phoneNumber": "+1234567890"
  }
}
```

### Forgot Password

**Endpoint**: `POST /api/auth/forgot-password`

**Request Body**:
```json
{
  "email": "user@example.com"
}
```

**Success Response** (200):
```json
{
  "success": true,
  "message": "Password reset instructions sent to your email"
}
```

### Refresh Token

**Endpoint**: `POST /api/auth/refresh`

**Headers**:
```
Authorization: Bearer <token>
```

**Success Response** (200):
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresAt": "2026-01-15T08:23:43.434Z"
}
```

## User Endpoints

### Get Current User

**Endpoint**: `GET /api/users/me`

**Headers**:
```
Authorization: Bearer <token>
```

**Success Response** (200):
```json
{
  "id": "e552f042-273c-4292-9bf6-f869e78b7094",
  "email": "user@example.com",
  "name": "John Doe",
  "username": "johndoe",
  "phoneNumber": "+1234567890"
}
```

## Task Endpoints

### Get All Tasks

**Endpoint**: `GET /api/tasks`

**Headers**:
```
Authorization: Bearer <token>
```

**Query Parameters**:
- `status` (optional): Filter by status (pending, in_progress, completed)
- `priority` (optional): Filter by priority (low, medium, high, urgent)

**Success Response** (200):
```json
{
  "tasks": [
    {
      "id": "task-123",
      "title": "Complete API integration",
      "description": "Integrate with the hosted API",
      "status": "in_progress",
      "priority": "high",
      "category": "dev",
      "assignedToUserId": "user-456",
      "assignedToUsername": "johndoe",
      "teamId": "team-789",
      "dueDate": "2026-01-20T00:00:00.000Z",
      "createdAt": "2026-01-08T08:00:00.000Z",
      "updatedAt": "2026-01-08T10:00:00.000Z"
    }
  ]
}
```

### Create Task

**Endpoint**: `POST /api/tasks`

**Headers**:
```
Authorization: Bearer <token>
```

**Request Body**:
```json
{
  "title": "New task",
  "description": "Task description",
  "status": "pending",
  "priority": "medium",
  "category": "general",
  "assignedToUserId": "user-456",
  "teamId": "team-789",
  "dueDate": "2026-01-20T00:00:00.000Z"
}
```

### Update Task

**Endpoint**: `PUT /api/tasks/:id`

**Headers**:
```
Authorization: Bearer <token>
```

**Request Body**: Same as create task

### Delete Task

**Endpoint**: `DELETE /api/tasks/:id`

**Headers**:
```
Authorization: Bearer <token>
```

## Team Endpoints

### Get All Teams

**Endpoint**: `GET /api/teams`

**Headers**:
```
Authorization: Bearer <token>
```

### Create Team

**Endpoint**: `POST /api/teams`

**Headers**:
```
Authorization: Bearer <token>
```

**Request Body**:
```json
{
  "name": "Development Team",
  "description": "Software development team",
  "teamIcon": "computer",
  "teamColor": "#2E90FA"
}
```

### Add Team Member

**Endpoint**: `POST /api/teams/:teamId/members`

**Headers**:
```
Authorization: Bearer <token>
```

**Request Body**:
```json
{
  "userId": "user-456"
}
```

## Notification Endpoints

### Get All Notifications

**Endpoint**: `GET /api/notifications`

**Headers**:
```
Authorization: Bearer <token>
```

**Query Parameters**:
- `unread` (optional): Set to "true" to get only unread notifications

### Mark Notification as Read

**Endpoint**: `PATCH /api/notifications/:id`

**Headers**:
```
Authorization: Bearer <token>
```

**Request Body**:
```json
{
  "isRead": true
}
```

### Send Notification

**Endpoint**: `POST /api/notifications`

**Headers**:
```
Authorization: Bearer <token>
```

**Request Body**:
```json
{
  "type": "task_assigned",
  "title": "New Task Assigned",
  "message": "You've been assigned a new task",
  "taskId": "task-123",
  "userId": "user-456"
}
```

## Authentication Flow

### 1. App Startup (Splash Screen)

```
1. Check if token exists in SharedPreferences
2. Check if token has expired
3. If expired:
   - Clear token and user data
   - Redirect to login page
4. If valid:
   - Try to fetch current user from API
   - If successful, redirect to home
   - If failed, redirect to login page
```

### 2. User Registration

```
1. User fills registration form
2. Validate input (email, username, password)
3. Call POST /api/auth/register
4. On success:
   - Store token and expiresAt in SharedPreferences
   - Store user data locally
   - Show success message
   - Auto-login and redirect to home
5. On failure:
   - Show error message (e.g., "Email or username already exists")
```

### 3. User Login

```
1. User enters username/email and password
2. Call POST /api/auth/login
3. On success:
   - Store token and expiresAt in SharedPreferences
   - Store user data locally
   - Show success message
   - Redirect to home
4. On failure:
   - Show error message
```

### 4. Token Management

```
- Token stored in: SharedPreferences with key 'auth_token'
- Expiry stored in: SharedPreferences with key 'auth_token_expiry'
- All API requests include: Authorization: Bearer <token>
- On 401 Unauthorized:
  - Clear token
  - Redirect to login page
```

## Implementation Details

### Services Created

1. **ApiConfig** (`lib/core/constants/api_config.dart`)
   - Contains API base URL and endpoint paths
   - Token expiry checking utility

2. **TaskFlowApiService** (`lib/core/services/task_flow_api_service.dart`)
   - Low-level HTTP service for API calls
   - Handles token management
   - Provides GET, POST, PUT, DELETE, PATCH methods

3. **AuthService** (`lib/core/services/auth_service.dart`)
   - Handles login, registration, forgot password
   - Token management
   - User authentication state

4. **ApiTaskService** (`lib/core/services/api_task_service.dart`)
   - Task CRUD operations with API
   - Falls back to local storage on failure

5. **ApiTeamService** (`lib/core/services/api_team_service.dart`)
   - Team CRUD operations with API
   - Team member management

6. **ApiNotificationService** (`lib/core/services/api_notification_service.dart`)
   - Notification fetching and management
   - Mark as read functionality

### State Management Updates

**UserState** (`lib/app_state/user_state/user_state.dart`)
- Updated to use AuthService for API calls
- Falls back to local UserService for offline support
- Handles token-based authentication

## Testing the Integration

### Manual Testing Steps

#### 1. Test Registration
```bash
# Open the app
# Click "Sign up"
# Fill in:
#   - Username: testuser
#   - First Name: Test
#   - Last Name: User
#   - Email: test@example.com
#   - Phone: +1234567890
#   - Password: Test123!
# Click "Sign Up"
# Expected: Success message and auto-login
```

#### 2. Test Login
```bash
# Log out from the app
# Enter credentials
# Click "Log In"
# Expected: Success message and redirect to home
```

#### 3. Test Token Expiration
```bash
# After logging in, manually change the expiry date in SharedPreferences
# Restart the app
# Expected: Auto-logout and redirect to login page
```

#### 4. Test Forgot Password
```bash
# On login page, click "Forgot password?"
# Enter email
# Click "Send Reset Link"
# Expected: Success message
```

### API Testing with cURL

#### Register User
```bash
curl -X 'POST' \
  'https://vmi2503861.contaboserver.net/task-flow-api/api/auth/register' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "email": "test@example.com",
  "password": "Test123!",
  "username": "testuser",
  "name": "Test User",
  "phoneNumber": "+1234567890"
}'
```

#### Login
```bash
curl -X 'POST' \
  'https://vmi2503861.contaboserver.net/task-flow-api/api/auth/login' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "username": "testuser",
  "password": "Test123!"
}'
```

#### Get Current User
```bash
curl -X 'GET' \
  'https://vmi2503861.contaboserver.net/task-flow-api/api/users/me' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer YOUR_TOKEN_HERE'
```

## Error Handling

### Common Error Scenarios

1. **Network Error**
   - Falls back to local storage
   - Shows toast: "Working offline"

2. **401 Unauthorized**
   - Clears token
   - Redirects to login page
   - Shows toast: "Session expired, please login again"

3. **400 Bad Request**
   - Shows specific error message from API
   - Examples:
     - "Email or username already exists"
     - "Invalid password format"

4. **500 Server Error**
   - Shows toast: "Server error. Please try again later."
   - Falls back to local operations if available

## Security Considerations

1. **Token Storage**
   - Tokens stored in SharedPreferences
   - Consider using flutter_secure_storage for production

2. **HTTPS**
   - All API calls use HTTPS
   - Certificate validation enabled

3. **Password Handling**
   - Passwords never logged
   - Sent only over HTTPS
   - Not stored in plain text

4. **Token Expiry**
   - Tokens expire after 7 days (604800 seconds)
   - Checked on app startup
   - Automatic logout on expiry

## Next Steps

1. Test all authentication flows
2. Test task CRUD operations
3. Test team operations
4. Test notification system
5. Add comprehensive error handling
6. Implement refresh token functionality
7. Add loading states for all API calls
8. Consider adding flutter_secure_storage for token storage
9. Implement WebSocket for real-time notifications
10. Add comprehensive logging for debugging
