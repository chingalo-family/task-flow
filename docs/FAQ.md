# Frequently Asked Questions (FAQ)

Common questions and answers about Task Flow.

## 📱 General Questions

### What is Task Flow?

Task Flow is a cross-platform task management and team collaboration application built with Flutter. It helps individuals and teams organize, track, and complete tasks efficiently.

### What platforms does Task Flow support?

Task Flow works on:
- ✅ iOS (iPhone & iPad)
- ✅ Android (Phones & Tablets)
- ✅ Web (Chrome, Firefox, Safari, Edge)
- ✅ macOS (Desktop)
- ✅ Linux (Desktop)
- ✅ Windows (Desktop)

### Is Task Flow free?

Yes, Task Flow is currently free and open-source. Future premium features may be introduced.

### Can I use Task Flow offline?

Yes! Task Flow is built with an offline-first architecture. You can create, edit, and manage tasks without an internet connection. Changes will sync when you're back online (sync feature coming soon).

## 🔐 Account & Security

### How do I create an account?

1. Open Task Flow
2. Tap "Sign Up" on the login screen
3. Enter your details (username, email, password)
4. Tap "Create Account"

### Is my data secure?

Yes! Task Flow uses:
- Encrypted local storage (ObjectBox)
- Secure credential storage (flutter_secure_storage)
- No data transmitted without your consent
- Your data stays on your device

### Can I change my password?

Yes:
1. Go to Settings
2. Tap "Change Password"
3. Enter current and new password
4. Save changes

### What happens if I forget my password?

Password recovery is planned for a future release. Currently, ensure you remember your password or store it securely.

## ✅ Tasks

### How do I create a task?

1. Go to Tasks tab
2. Tap the "+" button
3. Enter task details
4. Tap "Create"

See the [User Guide](./USER_GUIDE.md) for detailed instructions.

### Can I assign a task to multiple people?

Yes! When creating or editing a task, you can select multiple assignees.

### How do I mark a task as complete?

1. Open the task
2. Change status to "Completed"
3. Or use the quick complete button

### Can I add subtasks?

Yes! Open a task and add subtasks in the Subtasks section. This helps break down complex tasks.

### What are task categories?

Categories help organize tasks by type:
- 🎨 Design
- 💻 Development
- 📢 Marketing
- 🔬 Research
- 🐛 Bug Fixes

You can filter tasks by category.

### How do task priorities work?

Three priority levels:
- **🔴 High**: Urgent and important
- **🟡 Medium**: Regular priority
- **🟢 Low**: Nice-to-have

High priority tasks appear at the top of lists.

### Can I set due dates?

Yes! When creating/editing a task, set a due date using the date picker. Overdue tasks are highlighted.

### How do I delete a task?

1. Open the task
2. Tap the Delete button (trash icon)
3. Confirm deletion

**Note**: Deletion is permanent.

## 👥 Teams

### How do I create a team?

1. Go to Teams tab
2. Tap the "+" button
3. Enter team name, description
4. Choose icon and color
5. Tap "Create Team"

### How do I add members to a team?

1. Open team details
2. Tap "Add Members"
3. Select users from the list
4. Members are added

### Can I customize team workflows?

Yes! Teams can define custom task statuses to match their workflow.

### How do I leave a team?

Team management features are being enhanced. Currently, contact the team creator.

### Can I be on multiple teams?

Yes! You can be a member of as many teams as you need.

## 🔔 Notifications

### What types of notifications do I receive?

- Task assignments
- Task updates
- Mentions (coming soon)
- Due date reminders
- System announcements

### How do I turn off notifications?

1. Go to Settings
2. Tap "Notifications"
3. Toggle notification types on/off

### Can I customize notification sounds?

This feature is planned for a future release.

### Why am I not receiving notifications?

Check:
- Notification settings in app
- Device notification permissions
- Do Not Disturb mode
- Background app refresh (mobile)

## 💾 Data & Storage

### Where is my data stored?

Your data is stored locally on your device using ObjectBox database. No cloud storage currently (cloud sync coming soon).

### How much storage does Task Flow use?

Task Flow is lightweight, typically using less than 50MB including the app itself. Data storage depends on your usage.

### Can I export my data?

Data export feature is planned for version 1.2.0. Currently, data is stored locally in the ObjectBox database.

### How do I back up my data?

Backup and restore features are coming in version 1.2.0.

### What happens to my data if I uninstall the app?

Uninstalling the app will delete all local data. Ensure you have backups (when feature is available).

## 🔄 Sync & Updates

### Does Task Flow sync across devices?

Real-time sync is planned for version 1.3.0. Currently, data is stored locally on each device.

### How do I update Task Flow?

- **Mobile**: Update through App Store or Google Play
- **Desktop**: Download latest version from website
- **Web**: Refresh the page (auto-updates)

### Will I lose data when updating?

No, your local data persists across updates.

## 🛠️ Troubleshooting

### The app won't open

Try:
1. Force close and reopen
2. Restart your device
3. Reinstall the app
4. Check device compatibility

### Tasks aren't saving

Check:
- Device storage space
- App permissions
- Recent app updates
- Error messages

### App is slow or laggy

Try:
1. Close other apps
2. Restart the app
3. Clear app cache (settings)
4. Update to latest version
5. Check device resources

### I found a bug!

Please report it:
1. Go to [GitHub Issues](https://github.com/chingalo-family/task-flow/issues)
2. Search for existing reports
3. Create a new issue if not found
4. Include details and screenshots

### ObjectBox errors during setup

Run the code generation command:
```bash
dart run build_runner build --delete-conflicting-outputs
```

See [Getting Started](./GETTING_STARTED.md) for details.

### ObjectBox "Operation not permitted" error on macOS

If you see an error like "Storage error 'Operation not permitted'" when running on macOS, this is due to macOS app sandboxing restrictions with ObjectBox.

**Solution**: The app has been configured to disable sandboxing for non-App Store distribution, which resolves this issue. Ensure you:

1. Clean and rebuild the app:
   ```bash
   flutter clean
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   flutter run -d macos
   ```

2. For detailed information about macOS-specific setup and sandboxing, see the [macOS Setup Guide](./MACOS_SETUP.md).


## 🌐 Web & Desktop

### Can I use keyboard shortcuts?

Desktop keyboard shortcuts are planned for a future release.

### Does the web version work offline?

Progressive Web App (PWA) features with offline support are planned.

### Why does the desktop app need certain permissions?

Desktop apps may need:
- File system access (for data storage)
- Network access (for sync, when available)
- Notification permissions

## 🔮 Features

### When will feature X be available?

Check the [Roadmap](./ROADMAP.md) for planned features and timeline.

### Can I request a feature?

Yes! Please:
1. Check existing [feature requests](https://github.com/chingalo-family/task-flow/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)
2. Submit a new request if not found
3. Describe the feature and why it's useful

### Can I contribute code?

Absolutely! See the [Contributing Guide](./CONTRIBUTING.md) for how to get started.

## 💰 Pricing

### Is Task Flow really free?

Yes, Task Flow is currently completely free and open-source.

### Will there be a paid version?

We may introduce optional premium features in the future, but core functionality will remain free.

### Are there any limits?

Currently, no limits on:
- Number of tasks
- Number of teams
- Number of users
- Storage (limited by device)

## 🤝 Support & Community

### How do I get help?

1. Check this FAQ
2. Read the [User Guide](./USER_GUIDE.md)
3. Search [GitHub Issues](https://github.com/chingalo-family/task-flow/issues)
4. Ask in GitHub Discussions
5. Contact maintainers

### Where can I report bugs?

Create an issue on [GitHub Issues](https://github.com/chingalo-family/task-flow/issues) with:
- Bug description
- Steps to reproduce
- Screenshots
- Device/OS info

### How can I contribute?

See the [Contributing Guide](./CONTRIBUTING.md) for:
- Code contributions
- Documentation improvements
- Bug reports
- Feature suggestions

### Is there a community forum?

Use GitHub Discussions for:
- Questions
- Ideas
- Showcase
- General discussion

## 📚 Documentation

### Where can I find more documentation?

Check the [docs folder](./README.md):
- [Overview](./OVERVIEW.md)
- [Getting Started](./GETTING_STARTED.md)
- [Features](./FEATURES.md)
- [User Guide](./USER_GUIDE.md)
- [Architecture](./ARCHITECTURE.md)
- [Technology Stack](./TECH_STACK.md)

### The documentation is unclear

Help us improve! You can:
- Suggest improvements
- Submit documentation updates
- Ask for clarification

## 🔄 Migration

### Can I import from other apps?

Import features are planned for version 1.2.0, supporting:
- CSV files
- JSON exports
- Other task management apps

### How do I migrate to a new device?

Export/import features coming in version 1.2.0 will make this easy.

## 🌍 Languages

### What languages are supported?

Currently, Task Flow is in English. Multi-language support is on the roadmap.

### Can I help translate?

Yes! Translation support will be added in the future. Watch for announcements.

## ⚡ Performance

### Why is the app using battery?

Background services for notifications may use minimal battery. You can:
- Adjust notification settings
- Close the app when not in use
- Check for updates

### How can I improve performance?

- Keep the app updated
- Clear old completed tasks periodically
- Archive inactive teams
- Limit background processes

---

## 📧 Still Have Questions?

If your question isn't answered here:

1. Check the [User Guide](./USER_GUIDE.md) for detailed instructions
2. Browse [GitHub Issues](https://github.com/chingalo-family/task-flow/issues) for similar questions
3. Ask in [GitHub Discussions](https://github.com/chingalo-family/task-flow/discussions)
4. Contact the maintainers

**We're here to help!** Don't hesitate to reach out.

---

**Last Updated**: January 2026
