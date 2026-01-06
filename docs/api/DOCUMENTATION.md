# Task Flow - Complete Documentation

**Version:** 1.0.0  
**Last Updated:** January 2026

---

## Table of Contents

1. [Overview](#1-overview)
2. [Features](#2-features)
3. [Getting Started](#3-getting-started)
4. [Architecture](#4-architecture)
5. [Authentication](#5-authentication)
6. [Database Schema](#6-database-schema)
7. [API Specification](#7-api-specification)
8. [Contributing](#8-contributing)
9. [Roadmap](#9-roadmap)
10. [API Hosting Guide](#10-api-hosting-guide)

---

# 1. Overview

## 🎯 What is Task Flow?

Task Flow is a modern, collaborative task management application built with Flutter that helps teams and individuals organize, track, and complete their work efficiently. Designed with a beautiful dark theme and intuitive interface, Task Flow brings together task management, team collaboration, and real-time notifications in one powerful application.

## 💡 Why Task Flow?

### For Teams
- **Centralized Task Management**: Keep all your team's tasks in one place with clear assignments and priorities
- **Real-Time Collaboration**: Work together seamlessly with instant notifications and updates
- **Team Workspaces**: Create and manage multiple teams with custom workflows and task statuses
- **Offline Support**: Continue working even without internet connection with ObjectBox local database

### For Individuals
- **Personal Task Organization**: Manage your personal tasks with categories, priorities, and due dates
- **Progress Tracking**: Monitor your task completion with built-in progress indicators
- **Smart Notifications**: Stay on top of your work with intelligent notification system
- **Cross-Platform**: Available on iOS, Android, Web, Windows, macOS, and Linux

### For Developers
- **Modern Architecture**: Built with Flutter using Provider state management and clean architecture
- **Extensible API**: RESTful API integration ready for backend services
- **Local-First Design**: ObjectBox database ensures data persistence and offline capabilities
- **Type-Safe**: Leveraging Dart's strong typing for robust code

## 🌟 Key Features

### Task Management
- ✅ Create, edit, and delete tasks
- 📋 Multiple task statuses (Pending, In Progress, Completed)
- 🎯 Priority levels (Low, Medium, High)
- 📁 Task categories and tags
- 📎 File attachments support
- 📅 Due date tracking
- 📊 Progress tracking (0-100%)
- ✨ Subtasks support
- 🔔 Task reminders
- 🔍 Advanced search and filtering

### Team Collaboration
- 👥 Create and manage teams
- �� Add/remove team members
- 🎨 Custom team icons and colors
- 📝 Team-specific task statuses
- 👁️ Team task visibility
- 📊 Team statistics and insights
- ⚙️ Team settings and preferences

### Notifications & Alerts
- 🔔 Real-time notifications
- 📱 Task assignments notifications
- 👥 Team invites and updates
- ✅ Task completion alerts
- 💬 Mention notifications
- 🔕 Notification preferences
- 📂 Notification grouping (Recent/Earlier)
- 🔍 Filter notifications by type

### User Management
- 🔐 Secure authentication
- 👤 User profiles
- 📧 Email-based account creation
- 🔒 Password management
- 💾 Local user data persistence
- 🔄 User synchronization

### Settings & Preferences
- 🌙 Dark mode UI (default)
- 🔔 Notification preferences
- 📧 Email notifications toggle
- 🌐 Language preferences
- 📱 App information display
- 🔒 Privacy settings
- 📞 Contact and support options

## 🏗️ Technical Stack

### Frontend
- **Framework**: Flutter 3.10.4+
- **State Management**: Provider
- **UI Design**: Material Design 3 with custom dark theme
- **Navigation**: Flutter Navigator 2.0

### Data Layer
- **Local Database**: ObjectBox (NoSQL)
- **Offline Storage**: Flutter Secure Storage
- **Preferences**: Shared Preferences
- **File System**: Path Provider

### Backend Integration
- **HTTP Client**: http package
- **API Support**: DHIS2 integration (extensible)
- **Email Service**: Mailer package
- **Authentication**: Token-based (extensible)

## 📱 Platform Support

Task Flow is built with Flutter and supports:
- ✅ iOS (iPhone/iPad)
- ✅ Android (Phone/Tablet)
- ✅ Web (Chrome, Firefox, Safari, Edge)
- ✅ Windows (Desktop)
- ✅ macOS (Desktop)
- ✅ Linux (Desktop)

## 🔒 Security Features

- Secure local storage using Flutter Secure Storage
- Password encryption
- Secure API communication (HTTPS ready)
- User session management
- Data validation and sanitization

## 🌍 Use Cases

### Software Development Teams
- Sprint planning and task tracking
- Bug tracking and feature development
- Code review assignments
- Release planning

### Project Management
- Project milestone tracking
- Resource allocation
- Deadline management
- Team coordination

### Personal Productivity
- Daily task organization
- Goal tracking
- Time management
- Personal project management

### Remote Teams
- Distributed team collaboration
- Asynchronous communication
- Cross-timezone coordination
- Remote work management

---


---

# 5. Authentication


---

# 9. Roadmap


---

# 3. Getting Started


---

# 8. Contributing


---

# 7. API Specification


---

# 6. Database Schema


---

# 4. Architecture


This roadmap outlines planned features, improvements, and the future direction of Task Flow.

## 🎯 Vision

Task Flow aims to become the leading collaborative task management solution for modern teams and individuals, offering seamless offline-first functionality, powerful collaboration tools, and intelligent productivity features.

## 📅 Release Timeline

### ✅ Version 1.0.0 (Current - January 2026)

**Status**: Released

#### Core Features
- ✅ Task CRUD operations with ObjectBox persistence
- ✅ Team management and collaboration
- ✅ Real-time notifications system
- ✅ User authentication and management
- ✅ Offline-first architecture
- ✅ Dark theme UI
- ✅ Multi-platform support (iOS, Android, Web, Desktop)

#### Technical Foundation
- ✅ Flutter 3.10.4+ framework
- ✅ ObjectBox local database
- ✅ Provider state management
- ✅ DHIS2 API integration support
- ✅ Email service integration

---

### 🚧 Version 1.1.0 (Q1 2026 - In Progress)

**Focus**: Enhanced Authentication & API Integration

#### Authentication Enhancements
- 🔄 **Google OAuth Integration**
  - One-tap Google sign-in
  - Google account linking
  - Seamless authentication flow
  
- 🔄 **Apple Sign-In Integration**
  - Native Apple authentication
  - Privacy-first approach
  - iOS/macOS optimization

- 🔄 **Social Authentication**
  - Facebook login support
  - GitHub authentication (for developers)
  - LinkedIn integration

#### API Improvements
- 🔄 Complete RESTful API implementation
- 🔄 Enhanced CRUD endpoints for all entities
- 🔄 Improved sync mechanisms
- 🔄 API documentation and OpenAPI spec
- 🔄 Rate limiting and security enhancements

#### Security Features
- 🔄 Two-factor authentication (2FA)
- 🔄 Biometric authentication (fingerprint, Face ID)
- 🔄 Session management improvements
- 🔄 Enhanced encryption

**Estimated Release**: March 2026

---

### 📋 Version 1.2.0 (Q2 2026)

**Focus**: Enhanced User Experience & Collaboration

#### UI/UX Improvements
- 📱 Light theme option
- 🎨 Custom theme builder
- 🌈 Accent color customization
- 📐 Layout customization options
- ✨ Micro-interactions and animations

#### Collaboration Features
- 💬 **In-app Comments**
  - Task comments
  - @mentions in comments
  - Comment threads
  - Rich text formatting

- 📎 **Enhanced Attachments**
  - Image uploads
  - Document attachments
  - File preview
  - Cloud storage integration

- 🔔 **Advanced Notifications**
  - Custom notification rules
  - Notification scheduling
  - Do Not Disturb mode
  - Smart notification grouping

#### Task Enhancements
- 📅 **Calendar View**
  - Monthly/weekly/daily views
  - Drag-and-drop scheduling
  - Calendar integration (Google, Apple)
  - iCal sync

- 🔁 **Recurring Tasks**
  - Daily/weekly/monthly recurrence
  - Custom recurrence patterns
  - Skip and reschedule options

- 📊 **Custom Fields**
  - User-defined task fields
  - Field templates
  - Conditional fields

**Estimated Release**: June 2026

---

### 🎯 Version 1.3.0 (Q3 2026)

**Focus**: Analytics & Productivity Tools

#### Analytics Dashboard
- 📊 **Task Analytics**
  - Completion rates
  - Time tracking
  - Productivity trends
  - Burndown charts
  - Velocity tracking

- 👥 **Team Analytics**
  - Team performance metrics
  - Workload distribution
  - Response times
  - Collaboration patterns

- 📈 **Personal Insights**
  - Productivity score
  - Time management insights
  - Goal achievement tracking
  - Focus time analysis

#### Productivity Features
- ⏱️ **Time Tracking**
  - Built-in timer
  - Manual time entry
  - Time reports
  - Billable hours tracking

- 🎯 **Goals & Milestones**
  - Project milestones
  - Personal goals
  - Progress visualization
  - Achievement badges

- 🤖 **Smart Suggestions**
  - AI-powered task suggestions
  - Priority recommendations
  - Due date predictions
  - Team member suggestions

#### Integration Features
- 🔗 **Third-party Integrations**
  - Slack integration
  - Microsoft Teams
  - Trello import/export
  - Asana import
  - Jira synchronization

**Estimated Release**: September 2026

---

### 🚀 Version 2.0.0 (Q4 2026)

**Focus**: Advanced Features & Enterprise Support

#### Enterprise Features
- 🏢 **Organization Management**
  - Multi-organization support
  - Organization hierarchies
  - Department management
  - Role-based access control (RBAC)

- 👥 **Advanced Team Features**
  - Team hierarchies
  - Cross-team projects
  - Resource allocation
  - Capacity planning

- 📊 **Advanced Reporting**
  - Custom report builder
  - Export to PDF/Excel
  - Scheduled reports
  - Report sharing

#### Advanced Functionality
- 🔄 **Workflow Automation**
  - Custom workflows
  - Automated task creation
  - Conditional actions
  - Webhook integration

- 🎨 **Customization**
  - Custom task types
  - Custom workflows
  - Branded workspaces
  - White-label options

- 💼 **Project Management**
  - Gantt charts
  - Dependencies management
  - Critical path analysis
  - Resource management

#### AI & Machine Learning
- 🤖 **AI Assistant**
  - Natural language task creation
  - Smart scheduling
  - Workload balancing
  - Predictive analytics

- 📝 **Smart Forms**
  - Auto-fill suggestions
  - Template recommendations
  - Duplicate detection

**Estimated Release**: December 2026

---

## 🔮 Future Considerations (2027+)

### Mobile-Specific Features
- 📱 Widget support (iOS/Android)
- 🎙️ Voice commands and Siri/Google Assistant
- 📸 Document scanning
- 📍 Location-based reminders
- ⌚ Smartwatch apps (Apple Watch, Wear OS)

### Collaboration Enhancements
- 🎥 Video call integration
- 📞 Voice notes
- 🖼️ Whiteboard collaboration
- 📺 Screen sharing
- 💬 Real-time chat

### Advanced Analytics
- 📊 Predictive analytics
- 🧠 Machine learning insights
- 📈 Business intelligence
- 🎯 Performance forecasting
- 💡 Optimization suggestions

### Platform Expansion
- 🌐 Progressive Web App (PWA)
- 📧 Email app integration
- 💻 Browser extensions
- 🔌 VS Code extension
- 📱 iPad-optimized interface

### Security & Compliance
- 🔒 SOC 2 compliance
- 🛡️ GDPR full compliance
- 📜 HIPAA compliance (healthcare)
- 🏛️ Government cloud support
- 🔐 End-to-end encryption

### Developer Features
- 🔧 Public API with SDKs
- 📚 GraphQL API
- 🔌 Webhook system
- 🛠️ Plugin system
- 📦 Marketplace for extensions

## 🎨 Design & UX Roadmap

### Accessibility
- ♿ WCAG 2.1 AAA compliance
- 🎤 Enhanced screen reader support
- 🎨 High contrast themes
- ⌨️ Full keyboard navigation
- 🔤 Font size customization

### Localization
- 🌍 Multi-language support (20+ languages)
- 🗣️ Right-to-left (RTL) language support
- 🌐 Regional date/time formats
- 💱 Currency localization
- 🎌 Cultural customization

### Performance
- ⚡ Sub-second load times
- 🚀 Lazy loading optimization
- 💾 Reduced memory footprint
- 📦 Smaller app size
- 🔄 Improved sync performance

## 📊 Success Metrics

### User Engagement
- 👥 Monthly Active Users (MAU)
- 📈 Daily Active Users (DAU)
- ⏱️ Average session duration
- 🔁 Retention rates
- ⭐ User satisfaction score

### Product Metrics
- ✅ Task completion rate
- 🏃 Time to complete tasks
- 👥 Team collaboration index
- 📱 Cross-platform usage
- 🔄 Sync reliability

### Technical Metrics
- ⚡ App performance (load time, FPS)
- 🐛 Bug fix rate
- 📉 Crash rate
- 🔄 Sync success rate
- 🛡️ Security incident rate

## 🤝 Community & Open Source

### Open Source Contributions
- 📚 Comprehensive documentation
- 🐛 Bug bounty program
- 🎓 Developer tutorials
- 🏆 Contributor recognition
- 💬 Community forum

### Community Features
- 📦 Template marketplace
- 🎨 Theme sharing
- 🔌 Plugin ecosystem
- 📖 Knowledge base
- 🎯 Feature voting system

## 💡 Innovation Areas

### Emerging Technologies
- 🧠 AI-powered productivity coaching
- 🔮 Predictive task management
- 🎮 Gamification elements
- 🌐 Blockchain for task verification
- 🤖 Chatbot integration

### Research & Development
- 🧪 A/B testing framework
- 📊 User behavior analytics
- 🎯 Personalization engine
- 🔬 Performance optimization
- 🌟 Innovation lab projects

## 📝 How to Contribute to Roadmap

We welcome community input on our roadmap!

### Suggest Features
1. Open a GitHub Discussion
2. Describe your use case
3. Explain expected benefits
4. Provide mockups/examples if possible

### Vote on Features
- 👍 Upvote features you want
- 💬 Comment with additional context
- 🔔 Subscribe to feature updates

### Join Beta Testing
- 🧪 Early access to new features
- 💬 Direct feedback channel
- 🏆 Beta tester recognition

## 📞 Stay Updated

- 📧 Subscribe to our newsletter
- 🐦 Follow us on Twitter
- 💬 Join our Discord community
- 📱 Enable in-app announcements
- 🔔 Watch GitHub repository

---

**Note**: This roadmap is subject to change based on user feedback, technical constraints, and business priorities. Dates are estimates and may be adjusted.

**Last Updated**: January 2026  
**Next Review**: April 2026

For more information, see:
- [Features Documentation](FEATURES.md)
- [API Specification](API_SPECIFICATION.md)
- [Contributing Guidelines](CONTRIBUTING.md)

## 🎯 Core Features

### 1. Task Management

#### Task CRUD Operations
- ✅ **Create Tasks**: Add new tasks with rich details
- ✅ **View Tasks**: See all your tasks in organized lists
- ✅ **Edit Tasks**: Update task details anytime
- ✅ **Delete Tasks**: Remove completed or cancelled tasks

#### Task Properties
- **Title & Description**: Clear task naming and detailed descriptions
- **Status Tracking**: 
  - Pending 📋
  - In Progress 🔄
  - Completed ✅
- **Priority Levels**:
  - Low (Blue) 🔵
  - Medium (Yellow) 🟡
  - High (Red) 🔴
- **Categories**: Organize tasks by custom categories
- **Due Dates**: Set deadlines with calendar picker
- **Progress Tracking**: Track completion percentage (0-100%)
- **Tags**: Add multiple tags for better organization
- **Attachments**: Attach files and links to tasks

#### Advanced Task Features
- **Subtasks**: Break down complex tasks into smaller steps
  - Track individual subtask completion
  - View subtask progress in parent task
- **Multiple Assignees**: Assign tasks to multiple team members
- **Team Assignment**: Assign tasks to entire teams
- **Project Association**: Link tasks to projects
- **Reminders**: Set reminder notifications
- **Completion Timestamps**: Track when tasks were completed

#### Task Views & Filters
- **List View**: See all tasks in a scrollable list
- **Status Filtering**: Filter by pending, in progress, or completed
- **Priority Filtering**: Filter by priority level
- **Category Filtering**: Filter by task category
- **Search**: Quick search across all task fields
- **Sorting Options**:
  - By due date
  - By priority
  - By creation date
  - By last updated

#### Task Statistics
- 📊 Total tasks count
- ⏳ Pending tasks count
- 🔄 In-progress tasks count
- ✅ Completed tasks count
- 📈 Completion percentage
- 🎯 Overdue tasks alert

### 2. Team Collaboration

#### Team Management
- ✅ **Create Teams**: Set up new teams with custom details
- ✅ **View Teams**: Browse all your teams
- ✅ **Edit Teams**: Update team information
- ✅ **Delete Teams**: Remove teams when no longer needed

#### Team Properties
- **Team Name**: Clear team identification
- **Description**: Detailed team purpose and goals
- **Custom Icons**: Choose from predefined icons (rocket, computer, etc.)
- **Custom Colors**: Brand teams with hex colors
- **Member Management**: Add/remove team members
- **Task Association**: Link tasks to teams

#### Team Features
- **Member List**: View all team members with details
- **Member Count**: Quick member count display
- **Team Statistics**:
  - Total members
  - Total tasks
  - Task completion rate
- **Custom Task Statuses**: Define team-specific workflow statuses
  - Custom status names
  - Custom status colors
  - Reorder statuses

#### Team Settings
- ⚙️ Update team details
- 👥 Manage members
- 📝 Configure custom statuses
- 🎨 Customize appearance
- 🗑️ Delete team

#### Team Collaboration
- **Shared Task Visibility**: All team members see team tasks
- **Collaborative Editing**: Team members can update tasks
- **Activity Tracking**: See who made changes
- **Team Notifications**: Automatic notifications for team events

### 3. Notifications & Alerts

#### Notification Types
- 📬 **Task Assigned**: When you're assigned to a task
- 👥 **Team Invite**: When added to a team
- ✅ **Task Completed**: When a task is marked complete
- 💬 **Mentions**: When someone mentions you
- 🔔 **System Notifications**: App updates and announcements
- 📊 **Status Changes**: When task status changes
- ⏰ **Due Date Reminders**: Approaching deadlines
- 🎯 **Priority Changes**: When task priority is updated

#### Notification Features
- **Real-time Updates**: Instant notification delivery
- **Read/Unread Status**: Track which notifications you've seen
- **Unread Badge**: Visual indicator of unread count
- **Time Grouping**:
  - Recent (< 24 hours)
  - Earlier (≥ 24 hours)
- **Rich Content**:
  - Actor information (who triggered it)
  - Related entity details
  - Action buttons
  - Timestamp display

#### Notification Filters
- 📋 **All**: Show all notifications
- 🔴 **Unread**: Only unread notifications
- 💬 **Mentions**: Only @mentions
- 📌 **Assigned to Me**: Task assignments
- ⚙️ **System**: System announcements

#### Notification Actions
- ✅ Mark as read/unread
- 🗑️ Delete notification
- 📱 Tap to view related item
- 🔕 Mark all as read
- 🔔 Notification preferences

#### Notification Settings
- 📧 Email notifications toggle
- 🔔 Push notifications toggle
- 🎵 Notification sound
- 📲 Notification frequency

### 4. User Management

#### Authentication
- 🔐 **Email/Password Login**: Traditional authentication
- 📱 **Google Sign-In**: Quick login with Google account (Planned)
- 🍎 **Apple Sign-In**: Sign in with Apple (Planned)
- 📧 **Email-based Registration**: Create account with email
- 🔑 **Password Management**: Change password securely
- 🔒 **Secure Storage**: Encrypted credential storage

#### User Profile
- 👤 **Username**: Unique identifier
- 📧 **Email Address**: Contact email
- 📱 **Phone Number**: Optional phone contact
- 🏷️ **Display Name**: Full name display
- 🎨 **Avatar/Initials**: Visual user representation
- 📅 **Account Creation Date**: Track account age

#### User Actions
- ✏️ Update profile information
- 🔑 Change password
- 🚪 Logout
- 🗑️ Account management

#### User Directory
- 📋 View all users in system
- 🔍 Search users by name/username
- 📊 User statistics
- 👥 See user teams and tasks

### 5. Settings & Preferences

#### Account Settings
- 👤 **Profile Information**: View and edit profile
  - Display name
  - Email address
  - Phone number
  - Username (read-only)
- 🔑 **Password**: Change password
- 📧 **Email Verification**: Verify email address

#### Notification Preferences
- 🔔 **Enable/Disable Notifications**: Master toggle
- 📧 **Email Notifications**: Control email alerts
- 🔊 **Sound**: Notification sound toggle
- 📱 **Badge Count**: Show unread count on app icon

#### App Settings
- 🌙 **Theme**: Dark mode (default, light mode planned)
- 🌐 **Language**: Language selection (planned)
- 📊 **Data Sync**: Sync settings and status
- 💾 **Storage**: View storage usage
- 🔄 **Auto-sync**: Background sync toggle

#### Privacy & Security
- 🔒 **Privacy Policy**: View privacy policy
- 📜 **Terms of Service**: View terms
- 🛡️ **Data Protection**: GDPR compliance info
- 🔐 **Security Settings**: Additional security options

#### App Information
- ℹ️ **App Version**: Current version number
- 📦 **Package Name**: App identifier
- 🏗️ **Build Number**: Build version
- 📅 **Last Updated**: Update information

#### Support & Help
- 📞 **Contact Us**: Reach support team
- 📧 **Email Support**: Direct email support
- 📱 **Phone Support**: Call support
- 💬 **Feedback**: Send feedback
- ⭐ **Rate App**: Rate on store

### 6. Onboarding Experience

#### First Launch
- 🎨 **Beautiful Illustrations**: Custom-designed onboarding graphics
- 📱 **Responsive Design**: Works on all screen sizes
- ⏭️ **Skip Option**: Skip to login anytime
- 🎯 **Value Proposition**: Clear benefit communication

#### Onboarding Screens
1. **Welcome Screen**
   - App introduction
   - Key value proposition
   - Brand identity

2. **Task Management**
   - Showcase task features
   - Visual examples
   - Use case scenarios

3. **Team Collaboration**
   - Team features highlight
   - Collaboration benefits
   - Team workflows

4. **Get Started**
   - Call to action
   - Sign up prompt
   - Quick start guide

### 7. Data Management

#### Offline Support
- 💾 **Local Database**: ObjectBox NoSQL database
- 📴 **Offline Mode**: Full functionality without internet
- 🔄 **Background Sync**: Automatic sync when online
- 💿 **Data Persistence**: Never lose your data
- ⚡ **Fast Queries**: Optimized local queries

#### Data Synchronization
- 🔄 **Auto-sync**: Automatic background sync
- 🔃 **Manual Sync**: Pull to refresh
- 📊 **Sync Status**: Visual sync indicators
- ⏱️ **Incremental Sync**: Only sync changes
- ✅ **Conflict Resolution**: Smart conflict handling

#### Data Security
- 🔐 **Encrypted Storage**: Secure local storage
- 🛡️ **Data Validation**: Input validation
- 🔒 **Secure Transmission**: HTTPS/SSL
- 🗑️ **Data Deletion**: Complete data removal
- 📝 **Audit Logs**: Track data changes

### 8. User Interface

#### Design System
- 🌙 **Dark Theme**: Modern dark UI (default)
- 🎨 **Consistent Colors**: Unified color palette
  - Primary Blue: #2E90FA
  - Success Green: #10B981
  - Warning Orange: #F59E0B
  - Error Red: #EF4444
  - Pink Accent: #FF6B9D
- 📐 **Spacing System**: Consistent spacing (4, 8, 12, 16, 20, 24, 32, 48, 64)
- 🔲 **Border Radius**: Rounded corners (8, 12, 16, 24)

#### UI Components
- 📇 **Cards**: Consistent card design
- 🔘 **Buttons**: Primary, secondary, text buttons
- 📝 **Input Fields**: Modern input styling
- 🎚️ **Toggles**: Switch components
- 📊 **Progress Bars**: Visual progress
- 🏷️ **Chips**: Filter and tag chips
- 🔔 **Badges**: Notification badges
- 🎭 **Avatars**: User avatars with initials

#### Navigation
- 📱 **Bottom Navigation**: 4-tab navigation
  - My Tasks
  - Teams
  - Alerts
  - Settings
- 🔙 **Back Navigation**: Intuitive back buttons
- 🏠 **Home**: Quick access to home
- 📄 **Page Transitions**: Smooth animations

#### Responsive Design
- 📱 **Mobile First**: Optimized for mobile
- 💻 **Desktop Support**: Full desktop layouts
- 📊 **Tablet Optimization**: Adaptive layouts
- 🔄 **Orientation Support**: Portrait and landscape
- 📐 **Dynamic Sizing**: Adapts to screen size

## 🚀 Advanced Features

### Search & Discovery
- 🔍 **Global Search**: Search across all entities
- 🎯 **Smart Filters**: Intelligent filtering
- 📊 **Search Results**: Organized results
- 🏷️ **Tag-based Search**: Search by tags

### Performance
- ⚡ **Fast Load Times**: Optimized startup
- 🎯 **Lazy Loading**: Load on demand
- 💾 **Efficient Caching**: Smart caching
- 🔄 **Smooth Animations**: 60 FPS rendering

### Accessibility
- 📱 **Screen Reader Support**: VoiceOver/TalkBack
- 🎨 **High Contrast**: Sufficient color contrast
- 📐 **Touch Targets**: Adequate tap areas
- ⌨️ **Keyboard Navigation**: Full keyboard support

## 📈 Analytics & Insights

### Task Analytics
- 📊 Completion rates
- ⏱️ Average completion time
- 📈 Productivity trends
- 🎯 Goal tracking

### Team Analytics
- 👥 Team performance metrics
- 📊 Task distribution
- ⏰ Response times
- 🏆 Top contributors

## 🔮 Upcoming Features

See [ROADMAP.md](ROADMAP.md) for planned features including:
- 📱 Google OAuth integration
- 🍎 Apple Sign-In integration
- 🌐 Multi-language support
- 📊 Advanced analytics dashboard
- 📅 Calendar integration
- 🔗 Third-party integrations
- 🤖 Smart suggestions
- 📸 Image attachments
- 🎙️ Voice notes
- 📍 Location-based tasks

---

For more information, see:
- [Getting Started Guide](GETTING_STARTED.md)
- [API Specification](API_SPECIFICATION.md)
- [Architecture Overview](ARCHITECTURE.md)

First off, thank you for considering contributing to Task Flow! It's people like you that make Task Flow such a great tool.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Workflow](#development-workflow)
- [Style Guidelines](#style-guidelines)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)
- [Community](#community)

## 📜 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have:
- Flutter SDK 3.10.4 or higher installed
- Git installed
- A GitHub account
- Basic knowledge of Flutter and Dart

### Setting Up Development Environment

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/task-flow.git
   cd task-flow
   ```

3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/chingalo-family/task-flow.git
   ```

4. **Install dependencies**:
   ```bash
   flutter pub get
   ```

5. **Generate ObjectBox code**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run the app**:
   ```bash
   flutter run
   ```

## 🤝 How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates.

**When submitting a bug report, include**:
- A clear and descriptive title
- Steps to reproduce the behavior
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Device/platform information
- Flutter and Dart version

**Bug Report Template**:
```markdown
## Description
A clear description of the bug.

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

## Expected Behavior
What you expected to happen.

## Actual Behavior
What actually happened.

## Screenshots
If applicable, add screenshots.

## Environment
- Device: [e.g. iPhone 14, Pixel 7]
- OS: [e.g. iOS 16, Android 13]
- App Version: [e.g. 1.0.0]
- Flutter Version: [e.g. 3.10.4]
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues.

**When suggesting an enhancement, include**:
- A clear and descriptive title
- Detailed description of the proposed feature
- Why this enhancement would be useful
- Examples of how it would be used
- Mockups or wireframes (if applicable)

**Enhancement Template**:
```markdown
## Feature Description
A clear description of the feature.

## Use Case
Why this feature would be useful.

## Proposed Solution
How you think this should work.

## Alternatives Considered
Other solutions you've thought about.

## Additional Context
Any other context, screenshots, or mockups.
```

### Your First Code Contribution

Unsure where to begin? Look for issues labeled:
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `beginner friendly` - Easy to tackle

### Pull Requests

1. **Create a new branch** for your feature/fix:
   ```bash
   git checkout -b feature/amazing-feature
   # or
   git checkout -b fix/bug-fix
   ```

2. **Make your changes** following our style guidelines

3. **Test your changes** thoroughly

4. **Commit your changes** with clear commit messages

5. **Push to your fork**:
   ```bash
   git push origin feature/amazing-feature
   ```

6. **Open a Pull Request** on GitHub

## 🔄 Development Workflow

### Branch Naming Convention

- Feature branches: `feature/feature-name`
- Bug fixes: `fix/bug-description`
- Documentation: `docs/doc-description`
- Refactoring: `refactor/refactor-description`
- Performance: `perf/performance-improvement`

### Keeping Your Fork Updated

```bash
# Fetch upstream changes
git fetch upstream

# Merge upstream changes into your main branch
git checkout main
git merge upstream/main

# Push updated main to your fork
git push origin main
```

### Working on Your Branch

```bash
# Create and switch to new branch
git checkout -b feature/new-feature

# Make changes, then stage them
git add .

# Commit changes
git commit -m "feat: add new feature"

# Push to your fork
git push origin feature/new-feature
```

## 🎨 Style Guidelines

### Dart Code Style

Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).

**Key points**:
- Use `lowerCamelCase` for variables, functions, and parameters
- Use `UpperCamelCase` for classes and enums
- Use `lowercase_with_underscores` for library and file names
- Use 2 spaces for indentation
- Max line length: 80 characters (100 acceptable)
- Use trailing commas for better formatting

**Good Example**:
```dart
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description ?? ''),
        onTap: onTap,
      ),
    );
  }
}
```

### Code Organization

**File Structure**:
```dart
// 1. Imports (ordered: dart, flutter, package, relative)
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_constant.dart';

import '../components/task_card.dart';

// 2. Class definition
class TasksPage extends StatefulWidget {
  // ...
}

// 3. State class
class _TasksPageState extends State<TasksPage> {
  // 3.1 Fields
  // 3.2 Lifecycle methods
  // 3.3 Custom methods
  // 3.4 Build method
}
```

### Widget Best Practices

1. **Prefer const constructors** when possible:
   ```dart
   const Text('Hello')  // Good
   Text('Hello')        // Not ideal if value is constant
   ```

2. **Extract complex widgets**:
   ```dart
   // Bad: Large build method
   Widget build(BuildContext context) {
     return Column(
       children: [
         // 100 lines of widgets...
       ],
     );
   }

   // Good: Extracted widgets
   Widget build(BuildContext context) {
     return Column(
       children: [
         _buildHeader(),
         _buildBody(),
         _buildFooter(),
       ],
     );
   }
   ```

3. **Use Provider.of vs Consumer appropriately**:
   ```dart
   // Use Provider.of when not rebuilding
   void _handleTap() {
     Provider.of<TaskState>(context, listen: false).addTask(task);
   }

   // Use Consumer when rebuilding UI
   Consumer<TaskState>(
     builder: (context, taskState, child) {
       return Text('${taskState.tasks.length} tasks');
     },
   )
   ```

### Comments

- Write self-documenting code when possible
- Add comments for complex logic
- Use dartdoc comments for public APIs

```dart
/// Calculates the completion percentage of a task.
///
/// Returns a value between 0.0 and 1.0 representing the
/// percentage of completed subtasks.
///
/// Returns 0.0 if there are no subtasks.
double calculateCompletionPercentage(Task task) {
  if (task.subtasks.isEmpty) return 0.0;
  final completed = task.subtasks.where((s) => s.completed).length;
  return completed / task.subtasks.length;
}
```

### Naming Conventions

**Variables**:
```dart
final userName = 'John';        // Good
final user_name = 'John';       // Bad
```

**Private members**:
```dart
String _privateField;           // Good
void _privateMethod() {}        // Good
```

**Boolean variables**:
```dart
bool isLoading = true;          // Good
bool hasData = false;           // Good
bool loading = true;            // Not ideal
```

## 📝 Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `build`: Build system changes
- `ci`: CI configuration changes

### Examples

```bash
# Simple feature
git commit -m "feat: add task priority filter"

# Bug fix with scope
git commit -m "fix(tasks): correct due date calculation"

# Documentation update
git commit -m "docs: update API specification"

# Breaking change
git commit -m "feat!: redesign task entity schema

BREAKING CHANGE: TaskEntity now uses teamId instead of teamName"
```

## 🔍 Pull Request Process

### Before Submitting

1. ✅ Ensure your code follows the style guidelines
2. ✅ Run `flutter analyze` and fix any issues
3. ✅ Run `flutter test` and ensure all tests pass
4. ✅ Generate ObjectBox code if you modified entities
5. ✅ Update documentation if needed
6. ✅ Test on multiple platforms if possible

### PR Template

```markdown
## Description
Brief description of the changes.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Related Issue
Closes #123

## How Has This Been Tested?
Describe the tests you ran.

## Screenshots (if applicable)
Add screenshots to demonstrate the changes.

## Checklist
- [ ] My code follows the style guidelines
- [ ] I have performed a self-review
- [ ] I have commented my code where necessary
- [ ] I have updated the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing unit tests pass locally
- [ ] ObjectBox code has been regenerated (if entities changed)
```

### Review Process

1. At least one maintainer will review your PR
2. Address any feedback or requested changes
3. Once approved, a maintainer will merge your PR
4. Your contribution will be included in the next release!

## 🧪 Testing Guidelines

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/task_service_test.dart

# Run with coverage
flutter test --coverage
```

### Writing Tests

**Unit Test Example**:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/core/utils/date_utils.dart';

void main() {
  group('DateUtils', () {
    test('should format date correctly', () {
      final date = DateTime(2026, 1, 5);
      final formatted = DateUtils.formatDate(date);
      expect(formatted, equals('Jan 5, 2026'));
    });
  });
}
```

**Widget Test Example**:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/modules/tasks/components/task_card.dart';

void main() {
  testWidgets('TaskCard displays task title', (tester) async {
    final task = Task(title: 'Test Task');
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(task: task),
        ),
      ),
    );

    expect(find.text('Test Task'), findsOneWidget);
  });
}
```

## 📚 Documentation

### Code Documentation

Use dartdoc comments for public APIs:

```dart
/// Represents a task in the task management system.
///
/// Tasks can be assigned to users, associated with teams,
/// and tracked through various statuses.
class Task {
  /// Creates a new task with the given [title].
  ///
  /// The [title] must not be empty.
  Task({required this.title});

  /// The task's title.
  final String title;
}
```

### Updating Documentation

When adding new features:
1. Update relevant .md files in `docs/`
2. Add code examples if applicable
3. Update README.md if needed
4. Update API_SPECIFICATION.md for API changes

## 🏗️ ObjectBox Changes

When modifying entities:

1. **Make changes to entity files**:
   ```dart
   @Entity()
   class TaskEntity {
     // Add new field
     String? newField;
   }
   ```

2. **Regenerate ObjectBox code**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Update documentation** in `docs/OBJECTBOX_BUILD_REQUIRED.md`

4. **Test thoroughly** to ensure schema migration works

## 🌟 Recognition

Contributors are recognized in:
- GitHub contributors page
- Release notes
- Special thanks in documentation

Outstanding contributors may be invited to join the core team!

## 💬 Community

### Getting Help

- 💬 GitHub Discussions for questions
- 🐛 GitHub Issues for bugs
- 📧 Email for private matters

### Communication Channels

- GitHub Discussions: General discussions, Q&A
- GitHub Issues: Bug reports, feature requests
- Pull Requests: Code reviews, technical discussions

## 📜 License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## ❓ Questions?

Don't hesitate to ask questions! We're here to help:
- Open a GitHub Discussion
- Comment on an existing issue
- Reach out to maintainers

---

**Thank you for contributing to Task Flow!** 🎉

Your efforts help make Task Flow better for everyone.

This guide will help you get Task Flow up and running on your local machine for development and testing purposes.

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

### Required
- **Flutter SDK**: Version 3.10.4 or higher
  - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
- **Dart SDK**: Comes bundled with Flutter
- **Git**: For version control

### Platform-Specific Requirements

#### For iOS Development
- macOS with Xcode 14.0 or higher
- CocoaPods (installed via `sudo gem install cocoapods`)
- iOS Simulator or physical iOS device

#### For Android Development
- Android Studio or Android SDK
- Android SDK Build-Tools
- Android Emulator or physical Android device

#### For Web Development
- Chrome browser (recommended for debugging)

#### For Desktop Development
- **Windows**: Visual Studio 2022 with C++ development tools
- **macOS**: Xcode Command Line Tools
- **Linux**: clang, cmake, ninja-build, libgtk-3-dev

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/chingalo-family/task-flow.git
cd task-flow
```

### 2. Install Dependencies

```bash
flutter pub get
```

This will download all required packages defined in `pubspec.yaml`.

### 3. Generate ObjectBox Code

Task Flow uses ObjectBox for local data persistence. Generate the required ObjectBox code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or using dart directly:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates:
- `lib/objectbox.g.dart` - ObjectBox entity bindings
- `objectbox-model.json` - Database schema definition

> **Note:** This step is required whenever you modify entity classes (UserEntity, TaskEntity, TeamEntity, NotificationEntity).

### 4. Configure Environment (Optional)

If you plan to use email features or DHIS2 integration:

#### Email Configuration
```bash
# Copy the example file
cp lib/core/constants/email_connection.example.dart lib/core/constants/email_connection.dart

# Edit with your credentials (DO NOT commit real credentials)
nano lib/core/constants/email_connection.dart
```

#### DHIS2 Configuration
```bash
# Copy the example file
cp lib/core/constants/dhis2_connection.example.dart lib/core/constants/dhis2_connection.dart

# Edit with your DHIS2 instance details
nano lib/core/constants/dhis2_connection.dart
```

> **Security Warning**: Never commit real credentials to version control. These files are in `.gitignore` for security.

## 🏃 Running the App

### Run on All Platforms

```bash
# For web
flutter run -d chrome

# For iOS (macOS only)
flutter run -d ios

# For Android
flutter run -d android

# For Windows
flutter run -d windows

# For macOS
flutter run -d macos

# For Linux
flutter run -d linux
```

### Select Device

List available devices:
```bash
flutter devices
```

Run on specific device:
```bash
flutter run -d <device-id>
```

### Development Mode

For hot reload during development:
```bash
flutter run
# Press 'r' to hot reload
# Press 'R' to hot restart
# Press 'q' to quit
```

## 🔧 Development Workflow

### 1. First-Time Setup

When you first run the app:
1. The app will show a splash screen
2. Then the onboarding screens (on first launch)
3. Finally, the login page

### 2. Create an Account

On the login page:
- Click "Sign Up" or "Request Account"
- Fill in your details:
  - Username
  - Email
  - Password
  - First Name
  - Surname
  - Phone Number
- Submit to create account

> **Note**: If DHIS2 backend is not configured, you can still use the app with local-only data.

### 3. Explore the App

After logging in, you'll see the main home screen with tabs:
- **My Tasks**: View and manage your tasks
- **Teams**: Create and collaborate with teams
- **Alerts**: View notifications
- **Settings**: Manage preferences and account

## 📁 Project Structure

```
task-flow/
├── android/              # Android platform code
├── ios/                  # iOS platform code
├── web/                  # Web platform code
├── windows/              # Windows platform code
├── macos/                # macOS platform code
├── linux/                # Linux platform code
├── lib/
│   ├── app_state/        # State management (Provider)
│   │   ├── user_state/
│   │   ├── task_state/
│   │   ├── team_state/
│   │   ├── notification_state/
│   │   └── ...
│   ├── core/
│   │   ├── components/   # Reusable UI components
│   │   ├── constants/    # App constants and configuration
│   │   ├── entities/     # ObjectBox entities
│   │   ├── models/       # Data models
│   │   ├── services/     # Business logic services
│   │   ├── utils/        # Utility functions
│   │   └── offline_db/   # Database providers
│   ├── modules/
│   │   ├── splash/       # Splash screen
│   │   ├── onboarding/   # Onboarding screens
│   │   ├── login/        # Authentication
│   │   ├── home/         # Main app shell
│   │   ├── tasks/        # Task management
│   │   ├── teams/        # Team management
│   │   ├── notifications/# Notifications
│   │   └── settings/     # Settings
│   ├── main.dart         # App entry point
│   └── my_app.dart       # App configuration
├── assets/
│   └── icons/            # App icons
├── test/                 # Test files
├── docs/                 # Documentation
├── pubspec.yaml          # Dependencies
└── README.md             # Project overview
```

## 🧪 Testing

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/path/to/test_file.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

## 🔍 Debugging

### Enable Debug Logging

The app includes debug prints for ObjectBox initialization and other operations. Check the console for:
- ✅ ObjectBox initialized successfully
- ⚠️ Warning messages
- ❌ Error messages

### Flutter DevTools

Launch DevTools for advanced debugging:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

Then run your app and open DevTools in browser.

### Common Issues

#### Issue: ObjectBox initialization failed
**Solution**: Make sure you've run the build runner to generate ObjectBox code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Issue: Build errors after pulling latest code
**Solution**: Clean and rebuild:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

#### Issue: Gradle build failed (Android)
**Solution**: Ensure Android SDK is properly installed and configured:
```bash
flutter doctor -v
```

#### Issue: Pod install failed (iOS)
**Solution**: Update CocoaPods and try again:
```bash
cd ios
pod repo update
pod install
cd ..
```

## 🏗️ Building for Production

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS

```bash
# Build for iOS
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode to archive and upload to App Store.

### Web

```bash
# Build for web
flutter build web --release
```

Output: `build/web/`

Deploy the contents to any web server.

### Desktop

```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 📦 State Management

Task Flow uses **Provider** for state management:

```dart
// Accessing state
final taskState = Provider.of<TaskState>(context);
final tasks = taskState.tasks;

// Using Consumer
Consumer<TaskState>(
  builder: (context, taskState, child) {
    return ListView.builder(
      itemCount: taskState.tasks.length,
      itemBuilder: (context, index) {
        final task = taskState.tasks[index];
        return TaskCard(task: task);
      },
    );
  },
)
```

Available State Providers:
- `UserState` - User authentication and profile
- `TaskState` - Task management
- `TeamState` - Team management
- `NotificationState` - Notifications
- `UserListState` - User directory
- `AppInfoState` - App information

## 💾 Working with ObjectBox

### Adding/Updating Entities

After modifying entity files in `lib/core/entities/`:

```bash
# Regenerate ObjectBox code
flutter pub run build_runner build --delete-conflicting-outputs
```

### Querying Data

```dart
// Example: Get all pending tasks
final dbService = DBService();
final taskBox = dbService.store?.box<TaskEntity>();
final pendingTasks = taskBox
    ?.query(TaskEntity_.status.equals('pending'))
    .build()
    .find();
```

### Database Location

- **Android**: `/data/data/com.example.task_flow/databases/objectbox`
- **iOS**: `<App Library>/databases/objectbox`
- **Desktop**: User's app data directory

## 🎨 Customizing the Theme

Theme configuration is in `lib/my_app.dart`:

```dart
ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppConstant.darkBackground,
  colorScheme: ColorScheme.dark(
    primary: AppConstant.primaryBlue,
    // ... customize colors
  ),
)
```

Color constants are defined in `lib/core/constants/app_constant.dart`.

## 🔌 Adding New Features

### 1. Create Entity (if needed)
```dart
// lib/core/entities/new_entity.dart
@Entity()
class NewEntity {
  @Id()
  int id = 0;
  String name;
  // ... other fields
}
```

### 2. Generate ObjectBox Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Create Service
```dart
// lib/core/services/new_service.dart
class NewService {
  // Business logic
}
```

### 4. Create State Provider
```dart
// lib/app_state/new_state/new_state.dart
class NewState extends ChangeNotifier {
  // State management
}
```

### 5. Create UI Module
```dart
// lib/modules/new_module/new_page.dart
class NewPage extends StatefulWidget {
  // UI implementation
}
```

## 📚 Learning Resources

### Flutter
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)

### ObjectBox
- [ObjectBox Flutter Documentation](https://docs.objectbox.io/flutter)
- [ObjectBox Queries](https://docs.objectbox.io/queries)

### State Management
- [Provider Package](https://pub.dev/packages/provider)
- [Provider Documentation](https://pub.dev/documentation/provider/latest/)

## 🆘 Getting Help

- **Documentation**: Check the [docs](../docs/) directory
- **Issues**: Open an issue on GitHub
- **Discussions**: Join GitHub Discussions
- **Code Review**: Submit a PR for review

## ✅ Next Steps

Now that you have Task Flow running:

1. ✅ Explore the app features
2. ✅ Read the [Features Documentation](FEATURES.md)
3. ✅ Check out the [API Specification](API_SPECIFICATION.md)
4. ✅ Review the [Architecture Overview](ARCHITECTURE.md)
5. ✅ Start contributing! See [Contributing Guidelines](CONTRIBUTING.md)

---

**Happy Coding!** 🚀

If you encounter any issues, please check the [Common Issues](#common-issues) section or open an issue on GitHub.

This document provides comprehensive information about authentication and authorization in Task Flow.

## 🔐 Overview

Task Flow supports multiple authentication methods to provide flexible and secure user access:

1. **Email/Password Authentication** (Current)
2. **Google OAuth** (Planned - v1.1.0)
3. **Apple Sign-In** (Planned - v1.1.0)

## 📋 Current Implementation

### Email/Password Authentication

The current version uses traditional email/password authentication with the following features:

#### User Registration

**Process**:
1. User provides registration details
2. System validates input
3. Account created in backend (DHIS2 or custom API)
4. User automatically logged in
5. User credentials stored locally (encrypted)

**Required Fields**:
- Username (unique)
- Email address
- Password (minimum 8 characters)
- First name
- Surname
- Phone number

**Implementation**:
```dart
// User registration
final user = await UserService().signUpUser(
  username: 'johndoe',
  email: 'john@example.com',
  password: 'SecurePass123!',
  firstName: 'John',
  surname: 'Doe',
  phoneNumber: '+1234567890',
);
```

#### User Login

**Process**:
1. User enters username and password
2. Credentials validated against backend
3. On success, user data fetched from API
4. User entity stored in ObjectBox
5. User marked as logged in
6. Session maintained locally

**Implementation**:
```dart
// User login
final user = await UserService().login(
  'johndoe',
  'SecurePass123!',
);

if (user != null) {
  // Login successful
  await UserState().setCurrentUser(user);
} else {
  // Login failed
  showError('Invalid credentials');
}
```

#### Password Management

**Change Password**:
```dart
await UserService().changeCurrentUserPassword(
  currentPassword: 'OldPass123!',
  newPassword: 'NewSecurePass456!',
);
```

### Local Storage

#### User Data Storage

User data is persisted using **ObjectBox** with the following entity:

```dart
@Entity()
class UserEntity {
  int id;                    // ObjectBox ID
  String apiUserId;          // API user ID
  String username;           // Unique username
  String? fullName;          // Display name
  String? password;          // Encrypted password
  String? email;             // Email address
  String? phoneNumber;       // Phone number
  bool isLogin;              // Login status
  DateTime createdAt;        // Account creation
  DateTime updatedAt;        // Last update
}
```

#### Secure Credentials Storage

Sensitive data is stored using **Flutter Secure Storage**:

```dart
// Store credentials securely
await FlutterSecureStorage().write(
  key: 'user_token',
  value: token,
);

// Retrieve credentials
final token = await FlutterSecureStorage().read(
  key: 'user_token',
);
```

### Session Management

#### Current User State

The app maintains current user state using **Provider**:

```dart
class UserState extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<void> initialize() async {
    _currentUser = await UserService().getCurrentUser();
    notifyListeners();
  }

  Future<void> setCurrentUser(User user) async {
    _currentUser = user;
    await UserService().setCurrentUser(user);
    notifyListeners();
  }

  Future<void> logout() async {
    await UserService().logout();
    _currentUser = null;
    notifyListeners();
  }
}
```

#### Session Persistence

Sessions persist across app restarts:
1. User credentials stored in ObjectBox
2. Login status maintained
3. Auto-login on app launch
4. Manual logout clears session

### Logout

**Process**:
1. User initiates logout
2. Current user marked as logged out
3. Local session cleared
4. User redirected to login screen

**Implementation**:
```dart
await UserService().logout();
// Optionally clear local data
await UserService().clearAllLocalData();
```

## 🚀 Planned Authentication Methods

### Google OAuth (v1.1.0)

**Features**:
- One-tap sign-in
- No password required
- Faster registration
- Trusted authentication

**Flow**:
```
1. User taps "Sign in with Google"
   ↓
2. Google OAuth consent screen
   ↓
3. User grants permissions
   ↓
4. App receives ID token
   ↓
5. Backend validates token
   ↓
6. User account created/retrieved
   ↓
7. User logged in
```

**Implementation (Planned)**:
```dart
// Google Sign-In
final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
if (googleUser != null) {
  final GoogleSignInAuthentication auth = await googleUser.authentication;
  final user = await AuthService().authenticateWithGoogle(
    idToken: auth.idToken!,
  );
}
```

### Apple Sign-In (v1.1.0)

**Features**:
- Privacy-focused
- Hide email option
- Native iOS/macOS integration
- Secure authentication

**Flow**:
```
1. User taps "Sign in with Apple"
   ↓
2. Apple ID authentication
   ↓
3. User approves (Face ID/Touch ID)
   ↓
4. App receives identity token
   ↓
5. Backend validates token
   ↓
6. User account created/retrieved
   ↓
7. User logged in
```

**Implementation (Planned)**:
```dart
// Apple Sign-In
final credential = await SignInWithApple.getAppleIDCredential(
  scopes: [
    AppleIDAuthorizationScopes.email,
    AppleIDAuthorizationScopes.fullName,
  ],
);
final user = await AuthService().authenticateWithApple(
  identityToken: credential.identityToken!,
  authorizationCode: credential.authorizationCode!,
);
```

## 🔒 Security Best Practices

### Password Requirements

**Current Requirements**:
- Minimum 8 characters
- No maximum length enforced (API dependent)

**Recommended Requirements** (for backend implementation):
- Minimum 12 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one number
- At least one special character
- Not in common password list
- Different from username

**Validation Example**:
```dart
bool isPasswordStrong(String password) {
  if (password.length < 12) return false;
  if (!password.contains(RegExp(r'[A-Z]'))) return false;
  if (!password.contains(RegExp(r'[a-z]'))) return false;
  if (!password.contains(RegExp(r'[0-9]'))) return false;
  if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
  return true;
}
```

### Password Storage

**Never store passwords in plain text!**

**Client-side**:
- Passwords temporarily stored in memory only
- Encrypted when stored locally (if needed)
- Cleared after successful authentication

**Server-side** (Recommended):
- Use bcrypt, Argon2, or PBKDF2
- Salt passwords before hashing
- Use appropriate work factor
- Never log passwords

### Token Security

**JWT Tokens** (for API authentication):

**Best Practices**:
- Short expiration time (1 hour recommended)
- Use refresh tokens for extended sessions
- Rotate refresh tokens
- Revoke tokens on logout
- Store tokens securely (Flutter Secure Storage)

**Example Token Structure**:
```json
{
  "header": {
    "alg": "HS256",
    "typ": "JWT"
  },
  "payload": {
    "sub": "usr_123abc",
    "username": "johndoe",
    "iat": 1704632400,
    "exp": 1704636000
  }
}
```

### Secure Communication

**HTTPS/TLS**:
- All API calls must use HTTPS
- Certificate validation enabled
- Certificate pinning (planned)

**Request Validation**:
- Validate all inputs
- Sanitize user data
- Check for SQL injection
- Prevent XSS attacks

## 🔑 Authorization

### User Roles (Planned)

**Role Types**:
- `user` - Standard user (default)
- `admin` - Administrator
- `team_lead` - Team leader
- `manager` - Project manager

**Permissions**:
```dart
enum Permission {
  createTask,
  editTask,
  deleteTask,
  createTeam,
  editTeam,
  deleteTeam,
  manageUsers,
  viewAnalytics,
}

class Role {
  final String name;
  final List<Permission> permissions;
  
  const Role(this.name, this.permissions);
}
```

### Access Control

**Current Implementation**:
- Users can only modify their own data
- Team members can view team data
- Task assignees can edit their tasks

**Planned Implementation**:
- Role-based access control (RBAC)
- Fine-grained permissions
- Team-level permissions
- Organization-level permissions

## 🔄 Session Management

### Token Lifecycle

**Access Token**:
- Short-lived (1 hour)
- Used for API authentication
- Included in request headers
- Refreshed automatically

**Refresh Token**:
- Long-lived (30 days)
- Used to obtain new access tokens
- Stored securely
- Rotated on use

### Auto-Login

**Current Behavior**:
1. App checks for stored user on launch
2. If found and isLogin=true, auto-login
3. User taken directly to home screen

**Implementation**:
```dart
class SplashScreen extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final user = await UserService().getCurrentUser();
    
    if (user != null && user.isLogin) {
      // User is logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Home()),
      );
    } else {
      // User not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
      );
    }
  }
}
```

### Logout Behavior

**Actions on Logout**:
1. Mark user as logged out in ObjectBox
2. Clear secure storage tokens
3. Clear sensitive in-memory data
4. Optionally clear all local data
5. Navigate to login screen

## 🛡️ Security Features

### Current Security Measures

1. **Encrypted Storage**
   - Flutter Secure Storage for tokens
   - ObjectBox for user data

2. **Secure Communication**
   - HTTPS ready
   - Basic authentication for API

3. **Input Validation**
   - Email format validation
   - Password strength check
   - Username validation

### Planned Security Enhancements

1. **Two-Factor Authentication (2FA)**
   - TOTP (Time-based One-Time Password)
   - SMS verification
   - Email verification

2. **Biometric Authentication**
   - Fingerprint
   - Face ID / Touch ID
   - Device biometrics

3. **Advanced Security**
   - Certificate pinning
   - API request signing
   - Anomaly detection
   - Rate limiting

## 📱 Platform-Specific Considerations

### iOS
- Keychain for secure storage
- Face ID / Touch ID integration
- Sign in with Apple

### Android
- Keystore for secure storage
- Fingerprint authentication
- Google Play Integrity

### Web
- LocalStorage encryption
- CORS handling
- Session cookies (HttpOnly, Secure)

### Desktop
- OS credential manager
- Hardware security modules

## 🧪 Testing Authentication

### Unit Tests

```dart
test('should login successfully with valid credentials', () async {
  final user = await UserService().login('testuser', 'password123');
  expect(user, isNotNull);
  expect(user!.username, equals('testuser'));
});

test('should return null with invalid credentials', () async {
  final user = await UserService().login('testuser', 'wrongpassword');
  expect(user, isNull);
});
```

### Integration Tests

```dart
testWidgets('should navigate to home after successful login', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Enter credentials
  await tester.enterText(find.byKey(Key('username')), 'testuser');
  await tester.enterText(find.byKey(Key('password')), 'password123');
  
  // Tap login button
  await tester.tap(find.byKey(Key('loginButton')));
  await tester.pumpAndSettle();
  
  // Should be on home screen
  expect(find.byType(Home), findsOneWidget);
});
```

## 🔍 Troubleshooting

### Common Issues

**Issue**: Login fails with valid credentials
- Check network connection
- Verify API endpoint configuration
- Check backend logs
- Ensure password is correct

**Issue**: Auto-login not working
- Check if user entity exists in ObjectBox
- Verify isLogin flag is true
- Check secure storage permissions

**Issue**: Token expired
- Implement token refresh
- Check token expiration time
- Verify system time is correct

## 📚 Additional Resources

- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [ObjectBox Documentation](https://docs.objectbox.io/flutter)
- [OAuth 2.0 Specification](https://oauth.net/2/)
- [JWT.io](https://jwt.io/)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)

---

For more information, see:
- [API Specification](API_SPECIFICATION.md)
- [Architecture Overview](ARCHITECTURE.md)
- [Security Best Practices](#security-best-practices)

This document describes the ObjectBox database schema used in Task Flow for local data persistence.

## 📋 Overview

Task Flow uses **ObjectBox**, a high-performance NoSQL database, for local data storage. ObjectBox provides:
- ⚡ Fast query performance
- 📴 Full offline support
- 💾 Efficient storage
- 🔄 Easy synchronization
- 🎯 Type-safe Dart integration

## 🗄️ Database Entities

### 1. UserEntity

Stores user account information and authentication data.

```dart
@Entity()
class UserEntity {
  @Id()
  int id;                    // ObjectBox auto-incremented ID
  String apiUserId;          // External API user ID
  String username;           // Unique username
  String? fullName;          // User's full name
  String? password;          // Encrypted password (for offline login)
  String? email;             // Email address
  String? phoneNumber;       // Phone number
  bool isLogin;              // Current login status
  DateTime createdAt;        // Account creation timestamp
  DateTime updatedAt;        // Last modification timestamp
}
```

**Indexes**: None currently (consider adding index on `apiUserId`)

**Relationships**: 
- One user → Many tasks (as assignee)
- One user → Many teams (as member)
- One user → Many notifications

**Usage**:
```dart
// Create user
final user = UserEntity(
  apiUserId: 'usr_123',
  username: 'johndoe',
  fullName: 'John Doe',
  email: 'john@example.com',
  isLogin: true,
);
await userBox.put(user);

// Query by username
final query = userBox
    .query(UserEntity_.username.equals('johndoe'))
    .build();
final user = query.findFirst();
```

### 2. TaskEntity

Stores task information including assignments, deadlines, and progress.

```dart
@Entity()
class TaskEntity {
  @Id()
  int id;                         // ObjectBox auto-incremented ID
  
  @Index()
  String taskId;                  // External API task ID
  
  String title;                   // Task title (required)
  String? description;            // Detailed description
  
  String status;                  // 'pending' | 'in_progress' | 'completed'
  String priority;                // 'low' | 'medium' | 'high'
  String? category;               // Task category
  
  // Assignment fields
  String? assignedToUserId;       // Primary assignee API ID
  String? assignedToUsername;     // Primary assignee username
  String? assignedUserIdsJson;    // JSON array of multiple assignees
  
  // Team fields
  String? teamId;                 // Associated team API ID
  String? teamName;               // Team name (denormalized)
  
  // Date fields
  @Property(type: PropertyType.date)
  DateTime? dueDate;              // Task deadline
  
  @Property(type: PropertyType.date)
  DateTime? completedAt;          // Completion timestamp
  
  // Project fields
  String? projectId;              // Project API ID
  String? projectName;            // Project name (denormalized)
  
  // Complex data (stored as JSON)
  String? tagsJson;               // JSON array of tags
  String? attachmentsJson;        // JSON array of attachment URLs
  String? subtasksJson;           // JSON array of subtasks
  
  // Additional fields
  bool? remindMe;                 // Reminder flag
  int progress;                   // Progress percentage (0-100)
  
  // Sync status
  bool isSynced;                  // Has been synced with server
  
  // Timestamps
  @Property(type: PropertyType.date)
  DateTime createdAt;             // Creation timestamp
  
  @Property(type: PropertyType.date)
  DateTime updatedAt;             // Last modification timestamp
}
```

**Indexes**: 
- `taskId` - For fast lookup by API ID

**Recommended Additional Indexes**:
```dart
@Index()
String status;                    // Filter by status

@Index()
String priority;                  // Filter by priority

@Index()
bool isSynced;                    // Find unsynced tasks
```

**JSON Fields Structure**:

```dart
// tagsJson
["feature", "bug", "urgent"]

// attachmentsJson
["https://example.com/file1.pdf", "https://example.com/file2.png"]

// subtasksJson
[
  {"title": "Subtask 1", "completed": true},
  {"title": "Subtask 2", "completed": false}
]

// assignedUserIdsJson
["usr_123", "usr_456", "usr_789"]
```

**Usage**:
```dart
// Create task
final task = TaskEntity(
  taskId: 'task_abc123',
  title: 'Implement feature',
  status: TaskConstants.statusPending,
  priority: TaskConstants.priorityHigh,
  dueDate: DateTime.now().add(Duration(days: 7)),
  progress: 0,
  isSynced: false,
);
await taskBox.put(task);

// Query pending tasks
final query = taskBox
    .query(TaskEntity_.status.equals('pending'))
    .order(TaskEntity_.dueDate)
    .build();
final tasks = query.find();

// Query tasks by team
final teamQuery = taskBox
    .query(TaskEntity_.teamId.equals('team_789'))
    .build();
final teamTasks = teamQuery.find();
```

### 3. TeamEntity

Stores team information, members, and custom configurations.

```dart
@Entity()
class TeamEntity {
  @Id()
  int id;                         // ObjectBox auto-incremented ID
  
  @Index()
  String teamId;                  // External API team ID
  
  @Index()
  String name;                    // Team name
  
  String? description;            // Team description
  String? avatarUrl;              // Team avatar URL
  
  int memberCount;                // Number of members
  String? createdByUserId;        // Creator API ID
  String? createdByUsername;      // Creator username
  
  // Timestamps
  @Property(type: PropertyType.date)
  DateTime createdAt;             // Creation timestamp
  
  @Property(type: PropertyType.date)
  DateTime updatedAt;             // Last modification timestamp
  
  // Sync status
  @Index()
  bool isSynced;                  // Has been synced with server
  
  // Complex data (stored as JSON)
  String? memberIdsJson;          // JSON array of member user IDs
  String? taskIdsJson;            // JSON array of task IDs
  String? customTaskStatusesJson; // JSON array of custom statuses
  
  // Customization
  String? teamIcon;               // Icon key (e.g., 'rocket', 'computer')
  String? teamColor;              // Hex color (e.g., '#2E90FA')
}
```

**Indexes**:
- `teamId` - For fast lookup by API ID
- `name` - For search by team name
- `isSynced` - Filter synced/unsynced teams

**JSON Fields Structure**:

```dart
// memberIdsJson
["usr_123", "usr_456", "usr_789"]

// taskIdsJson
["task_abc", "task_def", "task_ghi"]

// customTaskStatusesJson
[
  {"key": "code_review", "label": "Code Review", "color": "#F59E0B"},
  {"key": "testing", "label": "Testing", "color": "#10B981"}
]
```

**Usage**:
```dart
// Create team
final team = TeamEntity(
  teamId: 'team_789',
  name: 'Development Team',
  description: 'Core dev team',
  memberCount: 5,
  teamIcon: 'rocket',
  teamColor: '#2E90FA',
  isSynced: false,
);
await teamBox.put(team);

// Query teams by name
final query = teamBox
    .query(TeamEntity_.name.contains('Dev'))
    .build();
final teams = query.find();

// Get all unsynced teams
final unsyncedQuery = teamBox
    .query(TeamEntity_.isSynced.equals(false))
    .build();
final unsyncedTeams = unsyncedQuery.find();
```

### 4. NotificationEntity

Stores notifications and alerts for users.

```dart
@Entity()
class NotificationEntity {
  @Id()
  int id;                         // ObjectBox auto-incremented ID
  
  @Index()
  String notificationId;          // External API notification ID
  
  String title;                   // Notification title
  String? body;                   // Notification message
  
  String type;                    // Notification type
                                  // 'task_assigned' | 'team_invite' | 
                                  // 'task_completed' | 'mention' | 'system'
  
  bool isRead;                    // Read status
  
  // Related entity information
  String? relatedEntityId;        // ID of related task/team/user
  String? relatedEntityType;      // 'task' | 'team' | 'user'
  
  // Actor information
  String? actorUserId;            // User who triggered notification
  String? actorUsername;          // Actor username
  String? actorAvatarUrl;         // Actor avatar URL
  
  // Timestamp
  @Property(type: PropertyType.date)
  DateTime createdAt;             // Notification timestamp
  
  // Additional data
  String? metadataJson;           // Additional metadata (JSON)
  
  // Sync status
  bool isSynced;                  // Has been synced with server
}
```

**Indexes**:
- `notificationId` - For fast lookup by API ID

**Recommended Additional Indexes**:
```dart
@Index()
bool isRead;                      // Filter by read status

@Index()
String type;                      // Filter by notification type
```

**Metadata JSON Structure**:

```dart
// Task notification metadata
{
  "taskTitle": "Implement feature",
  "taskPriority": "high",
  "teamName": "Development Team"
}

// Team invite metadata
{
  "teamName": "Marketing Team",
  "inviterName": "John Doe"
}
```

**Usage**:
```dart
// Create notification
final notification = NotificationEntity(
  notificationId: 'notif_abc',
  title: 'New task assigned',
  body: 'You have been assigned to "Implement feature"',
  type: 'task_assigned',
  isRead: false,
  relatedEntityId: 'task_123',
  relatedEntityType: 'task',
  actorUserId: 'usr_456',
  actorUsername: 'janedoe',
  isSynced: false,
);
await notificationBox.put(notification);

// Query unread notifications
final query = notificationBox
    .query(NotificationEntity_.isRead.equals(false))
    .order(NotificationEntity_.createdAt, flags: Order.descending)
    .build();
final unread = query.find();

// Query notifications by type
final typeQuery = notificationBox
    .query(NotificationEntity_.type.equals('task_assigned'))
    .build();
final taskNotifications = typeQuery.find();
```

## 🔗 Relationships

### Implicit Relationships

ObjectBox entities use foreign keys stored as strings (API IDs) rather than ObjectBox relations:

```dart
// Task → User (assignee)
TaskEntity.assignedToUserId → UserEntity.apiUserId

// Task → Team
TaskEntity.teamId → TeamEntity.teamId

// Notification → User (actor)
NotificationEntity.actorUserId → UserEntity.apiUserId

// Notification → Task (related entity)
NotificationEntity.relatedEntityId → TaskEntity.taskId
```

**Rationale**: 
- Simplifies synchronization with remote API
- Avoids ObjectBox relation complexity
- Matches REST API structure

### Querying Related Data

```dart
// Get user's tasks
final user = getUserById('usr_123');
final tasksQuery = taskBox
    .query(TaskEntity_.assignedToUserId.equals(user.apiUserId))
    .build();
final userTasks = tasksQuery.find();

// Get team members (requires additional query)
final team = getTeamById('team_789');
final memberIds = jsonDecode(team.memberIdsJson ?? '[]');
final members = memberIds.map((id) => getUserByApiId(id)).toList();
```

## 📊 Query Examples

### Common Queries

**Get all pending tasks**:
```dart
final query = taskBox
    .query(TaskEntity_.status.equals('pending'))
    .build();
final tasks = query.find();
```

**Get high priority tasks due this week**:
```dart
final now = DateTime.now();
final weekEnd = now.add(Duration(days: 7));

final query = taskBox
    .query(
      TaskEntity_.priority.equals('high') &
      TaskEntity_.dueDate.between(now.millisecondsSinceEpoch, weekEnd.millisecondsSinceEpoch)
    )
    .order(TaskEntity_.dueDate)
    .build();
final tasks = query.find();
```

**Get unsynced entities**:
```dart
final unsyncedTasks = taskBox
    .query(TaskEntity_.isSynced.equals(false))
    .build()
    .find();

final unsyncedTeams = teamBox
    .query(TeamEntity_.isSynced.equals(false))
    .build()
    .find();
```

**Search tasks by title**:
```dart
final query = taskBox
    .query(TaskEntity_.title.contains('feature', caseSensitive: false))
    .build();
final tasks = query.find();
```

**Get recently created notifications**:
```dart
final yesterday = DateTime.now().subtract(Duration(days: 1));

final query = notificationBox
    .query(NotificationEntity_.createdAt.greaterThan(yesterday.millisecondsSinceEpoch))
    .order(NotificationEntity_.createdAt, flags: Order.descending)
    .build();
final recent = query.find();
```

## 🔄 Data Synchronization

### Sync Status Tracking

All entities have an `isSynced` boolean field:
- `true` - Data matches server
- `false` - Local changes not yet synced

### Sync Workflow

```dart
// 1. Mark as unsynced on local change
task.isSynced = false;
await taskBox.put(task);

// 2. Get unsynced items for upload
final unsynced = taskBox
    .query(TaskEntity_.isSynced.equals(false))
    .build()
    .find();

// 3. Upload to server
for (final task in unsynced) {
  await apiClient.uploadTask(task);
  task.isSynced = true;
  await taskBox.put(task);
}

// 4. Download server changes
final serverTasks = await apiClient.fetchTasks();
for (final task in serverTasks) {
  task.isSynced = true;
  await taskBox.put(task);
}
```

## 🗑️ Data Management

### Clearing Data

```dart
// Clear all tasks
taskBox.removeAll();

// Clear all data
store.close();
await Directory(dbPath).delete(recursive: true);
```

### Database Backup

```dart
// Backup database directory
final dbDir = await getApplicationDocumentsDirectory();
final backupDir = Directory('${dbDir.path}/backup');
await dbDir.copy(backupDir.path);
```

## 📈 Performance Optimization

### Index Usage

Add indexes to frequently queried fields:

```dart
@Index()
String status;    // Frequently filtered

@Index()
bool isSynced;    // Sync queries
```

### Query Limits

Limit results for large datasets:

```dart
final query = taskBox
    .query(TaskEntity_.status.equals('pending'))
    .build();
query.limit = 50;  // Limit to 50 results
final tasks = query.find();
```

### Lazy Queries

Use lazy queries for large result sets:

```dart
final query = taskBox.query().build();
final stream = query.findStream();
await for (final tasks in stream) {
  // Process tasks
}
```

## 🔧 Migrations

### Adding New Fields

1. Add field to entity:
```dart
@Entity()
class TaskEntity {
  // Existing fields...
  
  String? newField;  // New field
}
```

2. Regenerate ObjectBox code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. ObjectBox automatically handles schema migration

### Removing Fields

Similar process - ObjectBox handles automatically.

## 📝 Best Practices

1. **Always regenerate** after entity changes
2. **Use indexes** for frequently queried fields
3. **Limit query results** for better performance
4. **Clean up old data** periodically
5. **Handle null values** appropriately
6. **Use JSON** for complex/nested data
7. **Track sync status** with isSynced flag
8. **Close store** properly on app exit

## 🐛 Troubleshooting

**Issue**: Build errors after entity changes  
**Solution**: Run build_runner with `--delete-conflicting-outputs`

**Issue**: Query returns no results  
**Solution**: Check if data exists, verify query conditions

**Issue**: Slow queries  
**Solution**: Add indexes to queried fields

**Issue**: Database corruption  
**Solution**: Clear and rebuild database

---

For more information, see:
- [ObjectBox Flutter Documentation](https://docs.objectbox.io/flutter)
- [Architecture Overview](ARCHITECTURE.md)
- [API Specification](API_SPECIFICATION.md)

This document provides a comprehensive overview of Task Flow's architecture, design patterns, and technical implementation.

## 🏗️ System Architecture

Task Flow follows a **layered architecture** pattern with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation Layer                      │
│  (UI Components, Pages, Widgets, State Consumers)           │
└─────────────────────────────────────────────────────────────┘
                            ↓↑
┌─────────────────────────────────────────────────────────────┐
│                    State Management Layer                    │
│        (Provider, ChangeNotifier, State Classes)            │
└─────────────────────────────────────────────────────────────┘
                            ↓↑
┌─────────────────────────────────────────────────────────────┐
│                      Business Logic Layer                    │
│           (Services, Use Cases, Validators)                 │
└─────────────────────────────────────────────────────────────┘
                            ↓↑
┌─────────────────────────────────────────────────────────────┐
│                        Data Layer                           │
│  (Repository Pattern, Data Sources, API Clients)            │
└─────────────────────────────────────────────────────────────┘
                            ↓↑
┌──────────────────────┬──────────────────────────────────────┐
│   Local Database     │        Remote API                    │
│   (ObjectBox)        │        (REST/DHIS2)                  │
└──────────────────────┴──────────────────────────────────────┘
```

## 📂 Project Structure

### High-Level Directory Layout

```
lib/
├── app_state/           # State management (Provider)
├── core/               # Core functionality
│   ├── components/     # Reusable UI components
│   ├── constants/      # App-wide constants
│   ├── entities/       # ObjectBox entities
│   ├── models/         # Data models
│   ├── services/       # Business logic services
│   ├── utils/          # Utility functions
│   └── offline_db/     # Database providers
├── modules/            # Feature modules
│   ├── splash/
│   ├── onboarding/
│   ├── login/
│   ├── home/
│   ├── tasks/
│   ├── teams/
│   ├── notifications/
│   └── settings/
├── main.dart          # App entry point
└── my_app.dart        # App configuration
```

### Detailed Structure

#### Core Layer (`lib/core/`)

**Components** (`components/`)
- Reusable UI widgets
- Shared components across modules
- Custom widgets

**Constants** (`constants/`)
- `app_constant.dart` - UI constants, colors, spacing
- `task_constants.dart` - Task-related constants
- `*_connection.dart` - API/service configurations

**Entities** (`entities/`)
- ObjectBox annotated classes
- Database schema definitions
- Entity models: `UserEntity`, `TaskEntity`, `TeamEntity`, `NotificationEntity`

**Models** (`models/`)
- Plain Dart classes for data transfer
- API response models
- UI models

**Services** (`services/`)
- Business logic implementations
- API integrations
- Core functionality services

**Utils** (`utils/`)
- Helper functions
- Utility classes
- Mappers and converters

**Offline DB** (`offline_db/`)
- Database providers for each entity
- CRUD operations on ObjectBox
- Query builders

#### Modules Layer (`lib/modules/`)

Each module follows a consistent structure:

```
module_name/
├── pages/              # Page-level widgets
├── components/         # Module-specific components
├── models/            # Module-specific models
├── dialogs/           # Dialog widgets
├── utils/             # Module utilities
└── module_page.dart   # Main module entry
```

## 🔄 Data Flow

### 1. User Interaction Flow

```
User Action
    ↓
UI Widget (e.g., TaskCard)
    ↓
State Provider (e.g., TaskState)
    ↓
Service Layer (e.g., TaskService)
    ↓
Offline Provider (e.g., TaskOfflineProvider)
    ↓
ObjectBox Database
    ↓
State Update (notifyListeners)
    ↓
UI Update (Consumer/Provider.of)
```

### 2. Data Synchronization Flow

```
Background Sync Triggered
    ↓
Service fetches from API
    ↓
Compare with local data
    ↓
Merge changes (conflict resolution)
    ↓
Update ObjectBox
    ↓
Update State
    ↓
UI reflects changes
```

## 🎯 Design Patterns

### 1. State Management Pattern

**Provider + ChangeNotifier**

```dart
class TaskState extends ChangeNotifier {
  List<Task> _tasks = [];
  
  List<Task> get tasks => _tasks;
  
  Future<void> loadTasks() async {
    _tasks = await _taskService.getTasks();
    notifyListeners(); // Notify UI to rebuild
  }
  
  Future<void> addTask(Task task) async {
    await _taskService.createTask(task);
    _tasks.add(task);
    notifyListeners();
  }
}
```

Usage in UI:
```dart
Consumer<TaskState>(
  builder: (context, taskState, child) {
    return ListView.builder(
      itemCount: taskState.tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(task: taskState.tasks[index]);
      },
    );
  },
)
```

### 2. Repository Pattern

Abstracts data sources from business logic:

```dart
// Offline Provider (Repository)
class TaskOfflineProvider {
  final Box<TaskEntity>? _box;
  
  Future<void> addTask(TaskEntity task) async {
    await _box?.put(task);
  }
  
  List<TaskEntity> getAllTasks() {
    return _box?.getAll() ?? [];
  }
}

// Service Layer
class TaskService {
  final _offline = TaskOfflineProvider();
  
  Future<List<Task>> getTasks() async {
    final entities = _offline.getAllTasks();
    return entities.map((e) => Task.fromEntity(e)).toList();
  }
}
```

### 3. Singleton Pattern

Used for services to ensure single instance:

```dart
class UserService {
  UserService._();
  static final UserService _instance = UserService._();
  factory UserService() => _instance;
  
  // Service methods...
}

// Usage
final userService = UserService(); // Always returns same instance
```

### 4. Factory Pattern

Used for model creation:

```dart
class User {
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      // ...
    );
  }
}
```

### 5. Observer Pattern

Implemented through ChangeNotifier:

```dart
class NotificationState extends ChangeNotifier {
  int _unreadCount = 0;
  
  void updateUnreadCount(int count) {
    _unreadCount = count;
    notifyListeners(); // Observers (UI) get notified
  }
}
```

## 💾 Data Persistence Strategy

### ObjectBox Architecture

**Why ObjectBox?**
- ⚡ Extremely fast NoSQL database
- 📴 Perfect for offline-first apps
- 🔄 Efficient sync capabilities
- 💾 Low memory footprint
- 🎯 Native Dart support

**Entity Definition**

```dart
@Entity()
class TaskEntity {
  @Id()
  int id = 0;  // Auto-incremented by ObjectBox
  
  @Index()
  String taskId;  // External API ID
  
  String title;
  
  @Property(type: PropertyType.date)
  DateTime createdAt;
  
  // JSON fields for complex data
  String? tagsJson;
  String? subtasksJson;
}
```

**Query Optimization**

```dart
// Indexed queries for fast lookup
final query = taskBox
    .query(TaskEntity_.status.equals('pending'))
    .order(TaskEntity_.dueDate)
    .build();
final results = query.find();
```

### Sync Strategy

**Offline-First Approach**:
1. All operations work on local data first
2. Changes are queued for sync
3. Background sync when online
4. Conflict resolution on server

**Sync Flow**:
```
Local Change
    ↓
Mark as unsynced (isSynced = false)
    ↓
Queue for sync
    ↓
When online: Send to API
    ↓
API Response
    ↓
Update local with server data
    ↓
Mark as synced (isSynced = true)
```

## 🔐 Security Architecture

### Authentication Flow

```
1. User Login
    ↓
2. Credentials sent to API (HTTPS)
    ↓
3. Server validates & returns JWT token
    ↓
4. Token stored in Flutter Secure Storage
    ↓
5. Token included in subsequent requests
    ↓
6. Refresh token when expired
```

### Data Security

**Local Storage**:
- Flutter Secure Storage for sensitive data (tokens, passwords)
- ObjectBox for general app data
- Encryption at rest for sensitive fields

**Network Security**:
- HTTPS/TLS for all API calls
- Certificate pinning (planned)
- Request/response validation

## 🎨 UI Architecture

### Material Design 3

Task Flow uses Material Design 3 principles:
- Modern, clean aesthetics
- Consistent component system
- Accessible design
- Smooth animations

### Theme System

```dart
ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: AppConstant.primaryBlue,
    secondary: AppConstant.primaryBlue,
    // ...
  ),
)
```

### Component Architecture

**Atomic Design Principles**:
1. **Atoms**: Basic components (buttons, icons, text)
2. **Molecules**: Simple component groups (input fields with labels)
3. **Organisms**: Complex components (cards, forms)
4. **Templates**: Page layouts
5. **Pages**: Complete screens

### Responsive Design

```dart
// Responsive breakpoints
final size = MediaQuery.of(context).size;
final isSmallScreen = size.width < 600;
final isMediumScreen = size.width >= 600 && size.width < 1200;
final isLargeScreen = size.width >= 1200;
```

## 🔄 State Management Deep Dive

### Provider Tree Structure

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AppInfoState()),
    ChangeNotifierProvider(create: (_) => UserState()),
    ChangeNotifierProvider(create: (_) => TaskState()),
    ChangeNotifierProvider(create: (_) => TeamState()),
    ChangeNotifierProvider(create: (_) => NotificationState()),
    ChangeNotifierProvider(create: (_) => UserListState()),
  ],
  child: MaterialApp(...)
)
```

### State Lifecycle

1. **Creation**: Provider creates state on first access
2. **Updates**: State changes trigger `notifyListeners()`
3. **Consumption**: Widgets rebuild via `Consumer` or `Provider.of`
4. **Disposal**: State disposed when provider removed from tree

## 🧪 Testing Strategy

### Unit Tests
- Service layer testing
- Utility function testing
- Model validation testing

### Widget Tests
- Component rendering tests
- User interaction tests
- State changes tests

### Integration Tests
- End-to-end user flows
- API integration tests
- Database operations tests

## 📊 Performance Optimization

### Strategies

1. **Lazy Loading**: Load data on demand
2. **Pagination**: Fetch data in chunks
3. **Caching**: Cache frequently accessed data
4. **Debouncing**: Debounce search and input
5. **Virtual Scrolling**: Efficient list rendering

### ObjectBox Optimization

```dart
// Use indexes for frequent queries
@Index()
String status;

// Limit query results
final query = box.query().build();
query.limit = 50;

// Use relations 
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
  "message": "Password reset suefficiently
@Backlink()
final tasks = ToMany<TaskEntity>();
```

## 🔌 API Integration

### HTTP Client Architecture

```dart
class Dhis2HttpService {
  final String username;
  final String password;
  
  Future<http.Response> httpGet(String url) async {
    final auth = base64Encode(utf8.encode('$username:$password'));
    return await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Basic $auth'},
    );
  }
}
```

### Error Handling

```dart
try {
  final response = await httpService.get(url);
  if (response.statusCode == 200) {
    return parseData(response.body);
  } else {
    throw ApiException(response.statusCode);
  }
} catch (e) {
  // Handle errors
  logger.error(e);
  rethrow;
}
```

## 📱 Platform-Specific Considerations

### iOS
- Proper Info.plist configuration
- App Transport Security settings
- Background fetch capabilities

### Android
- Permissions in AndroidManifest.xml
- Proguard rules for ObjectBox
- Network security config

### Web
- CORS handling
- Web-specific storage APIs
- Progressive Web App features

### Desktop
- File system access
- Window management
- Native integrations

## 🚀 Deployment Architecture

### Build Process

```bash
# Development
flutter run

# Production builds
flutter build apk --release      # Android
flutter build ios --release      # iOS
flutter build web --release      # Web
flutter build windows --release  # Windows
flutter build macos --release    # macOS
flutter build linux --release    # Linux
```

### Environment Configuration

```dart
// Different configs for dev/staging/prod
const bool isDevelopment = bool.fromEnvironment('dev');
const apiUrl = isDevelopment 
    ? 'https://dev-api.taskflow.com'
    : 'https://api.taskflow.com';
```

## 📈 Scalability Considerations

### Current Scale
- Handles thousands of tasks per user
- Supports hundreds of teams
- Manages thousands of notifications

### Future Scalability
- Cloud database integration
- Horizontal scaling with load balancers
- CDN for static assets
- Microservices architecture (planned)

## 🔍 Monitoring & Logging

### Logging Strategy

```dart
debugPrint('✅ ObjectBox initialized successfully');
debugPrint('⚠️ Warning: Low storage space');
debugPrint('❌ Error: Failed to sync data');
```

### Analytics Integration (Planned)
- User behavior tracking
- Performance monitoring
- Crash reporting
- Feature usage analytics

---

For more information, see:
- [API Specification](API_SPECIFICATION.md)
- [Database Schema](DATABASE_SCHEMA.md)
- [Getting Started Guide](GETTING_STARTED.md)
ccessful"
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

---

# 10. API Hosting Guide

This guide provides comprehensive options for hosting the Task Flow backend API, including free hosting platforms and self-hosting on your Contabo server using LXD containers.

---

## Table of Contents

1. [Free Hosting Options](#1-free-hosting-options)
2. [Self-Hosting on Contabo with LXD](#2-self-hosting-on-contabo-with-lxd)
3. [Deployment Configurations](#3-deployment-configurations)
4. [Cost Comparison](#4-cost-comparison)
5. [Recommendations](#5-recommendations)

---

# 1. Free Hosting Options

## 1.1 Railway.app

**Best for:** Simple deployment with PostgreSQL database

**Features:**
- ✅ Free tier: $5 credit per month (enough for small apps)
- ✅ PostgreSQL database included
- ✅ Automatic HTTPS
- ✅ Git-based deployment
- ✅ Environment variables management
- ✅ Monitoring and logs
- ✅ Custom domains

**Tech Stack:**
- Node.js/Express or Python/FastAPI
- PostgreSQL for relational data
- Redis for caching (optional)

**Limitations:**
- $5/month credit (expires unused)
- Sleep after inactivity (can be prevented)
- Limited to 512MB RAM on free tier

**Setup:**
```bash
# 1. Install Railway CLI
npm install -g @railway/cli

# 2. Login
railway login

# 3. Initialize project
railway init

# 4. Add PostgreSQL
railway add postgresql

# 5. Deploy
railway up
```

**Deployment File (railway.json):**
```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "npm start",
    "restartPolicyType": "ON_FAILURE"
  }
}
```

**Cost:** Free (with $5/month credit)  
**Website:** https://railway.app

---

## 1.2 Render.com

**Best for:** Production-ready free hosting

**Features:**
- ✅ Always-on free tier (no sleep)
- ✅ PostgreSQL database (90-day retention)
- ✅ Automatic HTTPS
- ✅ Git-based deployment
- ✅ Environment variables
- ✅ Custom domains
- ✅ Background workers

**Tech Stack:**
- Node.js, Python, Ruby, Go, Rust
- PostgreSQL database
- Redis available on paid plans

**Limitations:**
- Free tier: 512MB RAM
- Slower cold starts
- 90-day database retention on free tier
- Limited bandwidth

**Setup:**
```bash
# 1. Create render.yaml
cat > render.yaml << EOF
services:
  - type: web
    name: taskflow-api
    env: node
    buildCommand: npm install
    startCommand: npm start
    envVars:
      - key: DATABASE_URL
        fromDatabase:
          name: taskflow-db
          property: connectionString
      - key: JWT_SECRET
        generateValue: true

databases:
  - name: taskflow-db
    databaseName: taskflow
    user: taskflow
EOF

# 2. Push to GitHub and connect to Render
```

**Cost:** Free (with limitations)  
**Website:** https://render.com

---

## 1.3 Fly.io

**Best for:** Global edge deployment

**Features:**
- ✅ Free tier: 3 shared VMs, 3GB storage
- ✅ Global distribution (multiple regions)
- ✅ PostgreSQL support
- ✅ Automatic HTTPS
- ✅ Docker-based deployment
- ✅ CLI deployment
- ✅ Monitoring included

**Tech Stack:**
- Any language (Docker-based)
- PostgreSQL or SQLite
- Global edge network

**Limitations:**
- Free tier: 3 VMs with shared CPU
- Outbound data transfer limits
- Requires credit card for free tier

**Setup:**
```bash
# 1. Install Fly CLI
curl -L https://fly.io/install.sh | sh

# 2. Login
fly auth login

# 3. Launch app
fly launch

# 4. Create Postgres
fly postgres create

# 5. Attach to app
fly postgres attach --app taskflow-api

# 6. Deploy
fly deploy
```

**Dockerfile:**
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --production
COPY . .
EXPOSE 8080
CMD ["npm", "start"]
```

**fly.toml:**
```toml
app = "taskflow-api"
primary_region = "fra"

[env]
  PORT = "8080"

[http_service]
  internal_port = 8080
  force_https = true
  auto_stop_machines = true
  auto_start_machines = true
  min_machines_running = 0

[[services]]
  internal_port = 8080
  protocol = "tcp"

  [[services.ports]]
    port = 80
    handlers = ["http"]

  [[services.ports]]
    port = 443
    handlers = ["tls", "http"]
```

**Cost:** Free (3 shared VMs + 3GB storage)  
**Website:** https://fly.io

---

## 1.4 Supabase (Backend-as-a-Service)

**Best for:** PostgreSQL + Auth + Storage + Realtime

**Features:**
- ✅ PostgreSQL database (500MB)
- ✅ Built-in authentication (email, OAuth)
- ✅ RESTful API auto-generated
- ✅ Real-time subscriptions
- ✅ File storage (1GB)
- ✅ Edge Functions (serverless)
- ✅ No credit card required

**Tech Stack:**
- PostgreSQL with PostgREST
- Built-in auth system
- Edge Functions (Deno)
- Storage for file uploads

**Limitations:**
- 500MB database on free tier
- 2GB bandwidth per month
- 50,000 monthly active users
- Paused after 1 week of inactivity

**Setup:**
```bash
# 1. Install Supabase CLI
npm install -g supabase

# 2. Login
supabase login

# 3. Initialize project
supabase init

# 4. Start local dev
supabase start

# 5. Create tables (SQL migrations)
# 6. Deploy
supabase db push
```

**Example Migration:**
```sql
-- Create users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Create tasks table
CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  title TEXT NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'pending',
  priority TEXT DEFAULT 'medium',
  due_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);
```

**Cost:** Free (500MB database + 1GB storage)  
**Website:** https://supabase.com

---

## 1.5 PocketBase (Self-hosted BaaS)

**Best for:** Single-file backend with SQLite

**Features:**
- ✅ Single executable file
- ✅ SQLite database (built-in)
- ✅ Authentication (email, OAuth)
- ✅ RESTful API auto-generated
- ✅ Real-time subscriptions
- ✅ File storage
- ✅ Admin dashboard
- ✅ Extremely lightweight

**Tech Stack:**
- Go (single binary)
- SQLite database
- Built-in admin UI

**Limitations:**
- SQLite limitations for high concurrency
- Single server (not distributed)
- Requires hosting (but very cheap)

**Setup:**
```bash
# 1. Download PocketBase
wget https://github.com/pocketbase/pocketbase/releases/download/v0.20.0/pocketbase_0.20.0_linux_amd64.zip
unzip pocketbase_0.20.0_linux_amd64.zip

# 2. Run
./pocketbase serve --http="0.0.0.0:8090"

# 3. Access admin UI
# http://localhost:8090/_/
```

**Schema Definition:**
```javascript
// Collections can be created via Admin UI or migrations
// Example: Tasks collection
{
  "name": "tasks",
  "type": "base",
  "schema": [
    {
      "name": "title",
      "type": "text",
      "required": true
    },
    {
      "name": "status",
      "type": "select",
      "options": {
        "values": ["pending", "in_progress", "completed"]
      }
    },
    {
      "name": "user",
      "type": "relation",
      "options": {
        "collectionId": "users"
      }
    }
  ]
}
```

**Deployment on Free Platforms:**
- Can be deployed to Fly.io (free tier)
- Can run on your Contabo server
- Very low resource requirements (10-50MB RAM)

**Cost:** Free (self-hosted) or $5/month on Fly.io  
**Website:** https://pocketbase.io

---

## 1.6 Appwrite (Self-hosted BaaS)

**Best for:** Complete backend platform with Docker

**Features:**
- ✅ PostgreSQL or MariaDB
- ✅ Authentication (30+ OAuth providers)
- ✅ Database (collections)
- ✅ Storage (file uploads)
- ✅ Functions (serverless)
- ✅ Real-time events
- ✅ Admin console

**Tech Stack:**
- Docker-based deployment
- Multiple database options
- Microservices architecture

**Limitations:**
- Requires more resources (minimum 2GB RAM)
- Docker dependency
- More complex than PocketBase

**Setup:**
```bash
# 1. Install with Docker
docker run -it --rm \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume "$(pwd)"/appwrite:/usr/src/code/appwrite:rw \
  --entrypoint="install" \
  appwrite/appwrite:1.4.13

# 2. Start
cd appwrite
docker compose up -d
```

**Cost:** Free (self-hosted)  
**Website:** https://appwrite.io

---

## 1.7 Vercel (Serverless Functions)

**Best for:** API with serverless architecture

**Features:**
- ✅ Serverless functions (unlimited)
- ✅ Automatic HTTPS
- ✅ Git-based deployment
- ✅ Edge network (global CDN)
- ✅ Environment variables
- ✅ Zero configuration

**Tech Stack:**
- Node.js serverless functions
- External database (Supabase, PlanetScale)
- Redis optional (Upstash)

**Limitations:**
- Free tier: 100GB bandwidth
- Serverless function timeout (10s on free)
- No persistent file storage
- Cold starts

**Setup:**
```bash
# 1. Install Vercel CLI
npm i -g vercel

# 2. Project structure
/api
  /auth.js
  /tasks.js
  /teams.js

# 3. Deploy
vercel
```

**Example API Function:**
```javascript
// api/tasks.js
export default async function handler(req, res) {
  if (req.method === 'GET') {
    // Get tasks from database
    const tasks = await getTasks();
    res.status(200).json(tasks);
  } else if (req.method === 'POST') {
    // Create task
    const task = await createTask(req.body);
    res.status(201).json(task);
  }
}
```

**Cost:** Free (100GB bandwidth)  
**Website:** https://vercel.com

---

## 1.8 Cloudflare Workers

**Best for:** Edge computing with global distribution

**Features:**
- ✅ 100,000 requests/day (free)
- ✅ Global edge network
- ✅ KV storage included
- ✅ D1 database (SQLite on edge)
- ✅ R2 storage (S3-compatible)
- ✅ Sub-millisecond latency

**Tech Stack:**
- JavaScript/TypeScript workers
- D1 (SQLite) or external DB
- KV for caching
- R2 for file storage

**Limitations:**
- Free tier: 100,000 requests/day
- CPU time limits
- Learning curve

**Setup:**
```bash
# 1. Install Wrangler
npm install -g wrangler

# 2. Login
wrangler login

# 3. Create project
wrangler init taskflow-api

# 4. Create D1 database
wrangler d1 create taskflow-db

# 5. Deploy
wrangler publish
```

**Worker Example:**
```javascript
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    
    if (url.pathname === '/api/tasks' && request.method === 'GET') {
      const { results } = await env.DB.prepare(
        'SELECT * FROM tasks'
      ).all();
      return Response.json(results);
    }
    
    return new Response('Not found', { status: 404 });
  }
}
```

**Cost:** Free (100,000 requests/day)  
**Website:** https://workers.cloudflare.com

---

# 2. Self-Hosting on Contabo with LXD

## 2.1 Why LXD Containers?

**Benefits:**
- ✅ Lightweight (compared to VMs)
- ✅ Better isolation than Docker
- ✅ Full Linux environment
- ✅ Easy snapshots and backups
- ✅ Resource limits
- ✅ Multiple containers on one server

**Use Case:**
Perfect for running multiple isolated environments on your Contabo server.

---

## 2.2 LXD Setup on Contabo

### Step 1: Install LXD

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install LXD
sudo snap install lxd

# Initialize LXD
sudo lxd init
```

**LXD Init Configuration:**
```
Would you like to use LXD clustering? (yes/no) [default=no]: no
Do you want to configure a new storage pool? (yes/no) [default=yes]: yes
Name of the new storage pool [default=default]: default
Name of the storage backend to use (zfs, btrfs, dir, lvm) [default=zfs]: zfs
Create a new ZFS pool? (yes/no) [default=yes]: yes
Would you like to use an existing empty disk? (yes/no) [default=no]: no
Size in GB of the new loop device (1GB minimum) [default=30GB]: 50GB
Would you like to connect to a MAAS server? (yes/no) [default=no]: no
Would you like to create a new local network bridge? (yes/no) [default=yes]: yes
What should the new bridge be called? [default=lxdbr0]: lxdbr0
What IPv4 address should be used? [default=auto]: auto
What IPv6 address should be used? [default=auto]: auto
Would you like the LXD server to be available over the network? (yes/no) [default=no]: no
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]: yes
```

### Step 2: Create Container for API

```bash
# Launch Ubuntu container
lxc launch ubuntu:22.04 taskflow-api

# Access container
lxc exec taskflow-api -- bash
```

### Step 3: Install Dependencies in Container

```bash
# Inside container
apt update && apt upgrade -y

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# Install PostgreSQL
apt install -y postgresql postgresql-contrib

# Install nginx (reverse proxy)
apt install -y nginx

# Install certbot (SSL)
apt install -y certbot python3-certbot-nginx
```

### Step 4: Configure PostgreSQL

```bash
# Switch to postgres user
sudo -u postgres psql

# Create database and user
CREATE DATABASE taskflow;
CREATE USER taskflow WITH ENCRYPTED PASSWORD 'your_secure_password';
GRANT ALL PRIVILEGES ON DATABASE taskflow TO taskflow;
\q
```

### Step 5: Deploy API Application

```bash
# Create app directory
mkdir -p /opt/taskflow-api
cd /opt/taskflow-api

# Clone or upload your API code
git clone https://github.com/yourusername/taskflow-api.git .

# Install dependencies
npm install

# Create .env file
cat > .env << EOF
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://taskflow:your_secure_password@localhost:5432/taskflow
JWT_SECRET=$(openssl rand -hex 32)
EOF

# Install PM2 (process manager)
npm install -g pm2

# Start application
pm2 start npm --name "taskflow-api" -- start
pm2 save
pm2 startup
```

### Step 6: Configure Nginx Reverse Proxy

```bash
# Create nginx config
cat > /etc/nginx/sites-available/taskflow << EOF
server {
    listen 80;
    server_name api.taskflow.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable site
ln -s /etc/nginx/sites-available/taskflow /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx
```

### Step 7: Setup SSL with Let's Encrypt

```bash
# Get SSL certificate
certbot --nginx -d api.taskflow.com

# Auto-renewal is configured automatically
```

### Step 8: Configure Port Forwarding

```bash
# Exit container
exit

# Forward port 80 from host to container
lxc config device add taskflow-api http proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80

# Forward port 443 for HTTPS
lxc config device add taskflow-api https proxy listen=tcp:0.0.0.0:443 connect=tcp:127.0.0.1:443
```

---

## 2.3 Alternative: Docker in LXD

You can also run Docker inside an LXD container for more flexibility:

```bash
# Create container with Docker support
lxc launch ubuntu:22.04 taskflow-docker -c security.nesting=true

# Access container
lxc exec taskflow-docker -- bash

# Install Docker
curl -fsSL https://get.docker.com | sh

# Create docker-compose.yml
cat > docker-compose.yml << EOF
version: '3.8'

services:
  api:
    build: .
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgresql://taskflow:password@db:5432/taskflow
      JWT_SECRET: your-secret-key
    depends_on:
      - db
    restart: unless-stopped

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: taskflow
      POSTGRES_USER: taskflow
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    restart: unless-stopped

volumes:
  postgres_data:
EOF

# Start services
docker compose up -d
```

---

## 2.4 LXD Container Management

### Resource Limits

```bash
# Set CPU limit (2 cores)
lxc config set taskflow-api limits.cpu 2

# Set memory limit (2GB)
lxc config set taskflow-api limits.memory 2GB

# Set disk limit
lxc config device set taskflow-api root size 20GB
```

### Backup and Snapshots

```bash
# Create snapshot
lxc snapshot taskflow-api backup-2026-01-05

# List snapshots
lxc info taskflow-api

# Restore snapshot
lxc restore taskflow-api backup-2026-01-05

# Export container
lxc export taskflow-api taskflow-backup.tar.gz
```

### Monitoring

```bash
# View container stats
lxc list
lxc info taskflow-api

# View logs
lxc exec taskflow-api -- journalctl -u nginx
lxc exec taskflow-api -- pm2 logs
```

---

# 3. Deployment Configurations

## 3.1 Node.js/Express API Example

**Directory Structure:**
```
taskflow-api/
├── src/
│   ├── routes/
│   │   ├── auth.js
│   │   ├── tasks.js
│   │   ├── teams.js
│   │   └── notifications.js
│   ├── models/
│   ├── middleware/
│   └── index.js
├── package.json
└── .env
```

**index.js:**
```javascript
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
require('dotenv').config();

const app = express();

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/tasks', require('./routes/tasks'));
app.use('/api/teams', require('./routes/teams'));
app.use('/api/notifications', require('./routes/notifications'));

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date() });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`API server running on port ${PORT}`);
});
```

---

## 3.2 Environment Variables

```bash
# Production .env
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://user:pass@localhost:5432/taskflow
JWT_SECRET=your-secret-key-here
JWT_EXPIRES_IN=1h
REFRESH_TOKEN_SECRET=your-refresh-secret
REFRESH_TOKEN_EXPIRES_IN=7d
ALLOWED_ORIGINS=https://taskflow.com,https://app.taskflow.com
```

---

# 4. Cost Comparison

| Platform | Free Tier | Database | Storage | Bandwidth | Best For |
|----------|-----------|----------|---------|-----------|----------|
| **Railway** | $5/month credit | PostgreSQL ✅ | Included | Limited | Quick start |
| **Render** | Always-on | PostgreSQL (90d) ✅ | Limited | 100GB | Production |
| **Fly.io** | 3 VMs + 3GB | PostgreSQL ✅ | 3GB | Limited | Global edge |
| **Supabase** | 500MB DB | PostgreSQL ✅ | 1GB | 2GB/month | BaaS solution |
| **PocketBase** | Self-hosted | SQLite ✅ | Unlimited | Unlimited | Lightweight |
| **Vercel** | Unlimited functions | External | None | 100GB | Serverless |
| **Cloudflare** | 100k req/day | D1 (SQLite) ✅ | KV + R2 | Unlimited | Edge computing |
| **Contabo VPS** | ~$6/month | Self-hosted ✅ | 200-400GB | Unlimited | Full control |

---

# 5. Recommendations

## 5.1 For Development/Testing

**Recommended: Railway or Render**
- Easy to set up
- Free tier sufficient for testing
- PostgreSQL included
- Good for prototyping

```bash
# Quick start with Railway
railway login
railway init
railway add postgresql
railway up
```

## 5.2 For Production (Small Scale)

**Recommended: Fly.io or Contabo LXD**

**Fly.io Benefits:**
- Global distribution
- Free tier for small apps
- Easy scaling
- Automatic HTTPS

**Contabo LXD Benefits:**
- Full control
- Very cheap (~$6/month for VPS)
- Multiple containers
- No usage limits

## 5.3 For Production (Large Scale)

**Recommended: Contabo with LXD + Load Balancer**
- Multiple API containers
- PostgreSQL in separate container
- Redis for caching
- Nginx load balancer

**Architecture:**
```
Internet → Nginx LB → API Container 1
                   → API Container 2
                   → API Container 3
                   ↓
            PostgreSQL Container
                   ↓
            Redis Container
```

## 5.4 Best Overall Solution

**For Task Flow Specifically:**

1. **Start with:** Railway or Render (free tier)
   - Quick deployment
   - Test API with Flutter app
   - Validate functionality

2. **Move to:** Contabo VPS with LXD
   - Cost-effective for production
   - Full control
   - Scalable
   - Multiple environments (dev, staging, prod)

3. **Future:** Consider Fly.io for global distribution
   - When you have users worldwide
   - Need low latency everywhere
   - Can afford paid tier

---

## 5.5 Contabo Setup Summary

**Minimum Server Specs:**
- VPS S: 4 vCPU, 8GB RAM, 200GB SSD (~$6/month)
- VPS M: 6 vCPU, 16GB RAM, 400GB SSD (~$12/month)

**Containers Layout:**
```
Server (Contabo VPS)
├── taskflow-api-prod (Production API)
├── taskflow-api-staging (Staging API)
├── taskflow-db (PostgreSQL)
├── taskflow-redis (Redis Cache)
└── taskflow-nginx (Load Balancer)
```

**Monthly Cost Breakdown:**
- Contabo VPS S: $6/month
- Domain name: $10-15/year
- SSL Certificate: Free (Let's Encrypt)
- **Total: ~$6-7/month**

---

## Additional Resources

- **LXD Documentation:** https://linuxcontainers.org/lxd/docs/latest/
- **Railway Docs:** https://docs.railway.app/
- **Render Docs:** https://render.com/docs
- **Fly.io Docs:** https://fly.io/docs/
- **Supabase Docs:** https://supabase.com/docs
- **PocketBase Docs:** https://pocketbase.io/docs/
- **Cloudflare Workers:** https://developers.cloudflare.com/workers/

---

**Last Updated:** January 2026
