# Future Enhancements UI Guide

This document provides a visual guide to the newly implemented features.

## 1. Team-Specific Notification Preferences

### Location
**Team Settings → Team Notification Preferences Section**

### Navigation Path
1. Go to Teams page
2. Select a team
3. Click on "Team Settings" (gear icon or settings button)
4. Scroll down to see "Team Notification Preferences" section

### Features
The team notification preferences section appears below the Task Statuses section in the team settings page. It includes:

- **Section Header**: "Team Notification Preferences"
- **Description**: "Override global notification settings for this team"

**Task Notifications** (4 toggles):
- ✅ Task Assigned
- ✅ Task Completed  
- ✅ Status Changes
- ✅ Priority Changes

**Team Notifications** (2 toggles):
- ✅ Member Added
- ✅ Member Removed

**Deadlines** (2 toggles):
- ✅ Deadline Reminders
- ✅ Overdue Tasks

Each toggle:
- Has an icon with color coding
- Shows the preference name
- Can be toggled on/off
- Saves automatically to SharedPreferences

### Key Points
- These preferences are team-specific and override global settings
- Each team can have different notification preferences
- Perfect for teams with different notification needs
- Preferences persist across app restarts

---

## 2. Advanced Notification Settings Page

### Location
**Settings → Advanced Notifications**

### Navigation Path
1. Go to Settings
2. Click on "Advanced Notifications" (below "Notification Preferences")

### Features

#### Email Notifications Section

**Toggle**: Email Notifications
- Enable/disable email notifications for critical events
- When enabled, shows:
  - Email address input field
  - "Save Email" button
  - Help text: "Critical notifications (task assignments, deadlines, team invites) will be sent to this email"

**Critical notification types that trigger emails**:
- Task assignments
- Deadline reminders
- Overdue tasks
- Team invites
- System notifications

**Email Features**:
- Professional HTML templates
- Color-coded notification types
- Actor information included
- Timestamp included
- Professional footer with instructions

#### Scheduled Checks Section

**Toggle**: Scheduled Checks
- Enable/disable daily automated checks
- When enabled, shows:

**Preferred Check Time Slider**:
- Large time display (e.g., "9:00")
- Slider to select hour (0-23)
- Visual clock icon
- Help text: "Notifications will be checked daily at this time"

**Last Check Information**:
- Info box showing last check timestamp
- Format: "Last check: DD/MM/YYYY HH:MM"

**Manual Trigger Button**:
- "Run Check Now" button with play icon
- Allows immediate testing of notification generation
- Updates last check timestamp
- Shows success message after completion

#### Info Section

Blue information box explaining:
- What scheduled checks do
- Tasks due within 24 hours (deadline reminders)
- Tasks past due date (overdue alerts)
- Recommendation to enable background tasks in device settings

### Key Points
- All settings save automatically
- Email validation before saving
- Manual trigger for testing
- Clear visual feedback
- Professional UI consistent with app design

---

## 3. Settings Page Updates

### New Menu Items

The Settings page now has two notification-related menu items:

1. **Notification Preferences** (existing, enhanced)
   - Icon: tune (settings/sliders icon)
   - Title: "Notification Preferences"
   - Subtitle: "Customize notification types"
   - Opens: Global notification preferences page

2. **Advanced Notifications** (NEW)
   - Icon: settings_applications
   - Title: "Advanced Notifications"  
   - Subtitle: "Email & scheduled checks"
   - Opens: Advanced notification settings page

### Layout
Both items appear in the "Preferences" section, below the main Notifications toggle and above the Offline Access toggle.

---

## 4. Email Notification Templates

When a critical notification is sent, users receive a professionally formatted HTML email:

### Email Structure

**Header** (Blue background):
- Large notification title
- Clean typography

**Content Area** (Light gray background):
- Notification type badge (color-coded)
- Notification message body
- Actor information (if applicable): "From: [username]"
- Timestamp: "Created: DD/MM/YYYY HH:MM"

**Footer**:
- Separator line
- "This is an automated notification from Task Flow."
- "To manage your notification preferences, please visit the app settings."
- Small, subtle text

### Color Coding
- **Blue**: Task assignments, team invites, general
- **Red**: Deadlines, overdue tasks
- **Gray**: System notifications

### Email Subject Lines
- "New Task Assigned - [Title]"
- "Team Invitation - [Title]"
- "Task Deadline Reminder"
- "Overdue Task Alert"
- "System Notification - [Title]"

---

## 5. Background Scheduler

### How It Works

The scheduler service provides:

1. **Automatic Daily Checks** (when integrated with platform background tasks)
   - Checks for tasks due within 24 hours
   - Checks for overdue tasks
   - Creates appropriate notifications
   - Runs at user's preferred time

2. **Manual Testing**
   - "Run Check Now" button for immediate testing
   - No need to wait for scheduled time
   - Perfect for development and testing

3. **Statistics & Monitoring**
   - Last check timestamp
   - Next scheduled check time
   - Preferred check hour
   - Enable/disable status

### Platform Integration Required

For production use, integrate with:
- **workmanager** package (recommended for Android/iOS)
- **flutter_local_notifications** (alternative for simpler scheduling)

Full integration guide available in `docs/FUTURE_ENHANCEMENTS.md`

---

## Testing Checklist

### Team Preferences
- [ ] Navigate to team settings
- [ ] Toggle team notification preferences
- [ ] Create team task and verify notification respects preferences
- [ ] Disable a preference and verify no notification is created
- [ ] Re-enable and verify notifications resume

### Email Notifications
- [ ] Go to Advanced Notifications
- [ ] Enable email notifications
- [ ] Enter your email address
- [ ] Click "Save Email"
- [ ] Create a critical notification (assign task to yourself)
- [ ] Check your email inbox
- [ ] Verify email formatting and content

### Background Scheduler
- [ ] Go to Advanced Notifications
- [ ] Enable scheduled checks
- [ ] Set preferred check time
- [ ] Click "Run Check Now"
- [ ] Verify notifications created for:
  - Tasks due within 24 hours
  - Tasks past their due date
- [ ] Check last check timestamp updated

---

## Common Use Cases

### Use Case 1: Different Teams, Different Preferences
**Scenario**: Marketing team wants all notifications, Dev team only wants critical ones

**Solution**:
1. Go to Marketing team settings
2. Enable all notification types
3. Go to Dev team settings
4. Disable task comments, mentions, etc.
5. Keep only task assigned and deadlines enabled

### Use Case 2: Email for Critical Only
**Scenario**: User wants in-app notifications but emails only for urgent items

**Solution**:
1. Keep global notifications enabled
2. Enable email notifications
3. Set up email address
4. Email service automatically sends only critical types (deadlines, assignments, overdue)

### Use Case 3: Daily Morning Review
**Scenario**: User wants to check for overdue tasks every morning at 8 AM

**Solution**:
1. Enable scheduled checks
2. Set preferred time to 8 (8:00 AM)
3. Integrate with workmanager (production)
4. Or use "Run Check Now" button each morning

---

## Summary

All three future enhancements are now fully implemented and accessible:

✅ **Team Preferences**: In each team's settings page
✅ **Email Notifications**: In Advanced Notifications settings
✅ **Background Scheduler**: In Advanced Notifications settings

Each feature is:
- Fully functional
- Well documented
- Easy to use
- Properly integrated
- Production ready (with platform integration for scheduler)

Navigate to Settings to explore these new features!
