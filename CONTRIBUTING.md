# Contributing to UniSphere

Thank you for your interest in contributing to UniSphere! This document provides guidelines and instructions for contributing to this Flutter + Firebase project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Making Changes](#making-changes)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)

## Code of Conduct

This project adheres to a Code of Conduct that all contributors are expected to follow. Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before contributing.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.11.0 or higher)
- **Dart SDK** (comes with Flutter)
- **Git** for version control
- **VS Code** or **Android Studio** (recommended IDEs)
- **Chrome** or a mobile emulator for testing

### Verify Your Environment

```bash
flutter doctor
```

Ensure all checks pass before proceeding.

## Development Setup

1. **Fork the repository** on GitHub

2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/S84-0226-TheVanguard-Flutter-Firebase-UniSphere.git
   cd S84-0226-TheVanguard-Flutter-Firebase-UniSphere
   ```

3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/kalviumcommunity/S84-0226-TheVanguard-Flutter-Firebase-UniSphere.git
   ```

4. **Install dependencies**:
   ```bash
   flutter pub get
   ```

5. **Set up environment variables**:
   ```bash
   cp .env.example .env
   # Edit .env with your Firebase configuration
   ```

6. **Configure Firebase**:
   - Follow the Firebase setup guide in `docs/FIREBASE_SETUP.md`
   - Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are configured

7. **Run the app**:
   ```bash
   flutter run -d chrome
   ```

## Project Structure

```
lib/
├── app/              # App-level configuration (router, theme)
├── core/             # Core utilities, constants, and config
├── models/           # Data models
├── providers/        # State management (Provider pattern)
├── repositories/     # Data layer and API interactions
├── screens/          # UI screens/pages
├── services/         # Business logic and services
└── widgets/          # Reusable UI components
```

For detailed architecture, see [ARCHITECTURE.md](ARCHITECTURE.md).

## Making Changes

1. **Create a new branch** from `main`:
   ```bash
   git checkout main
   git pull upstream main
   git checkout -b feature/your-feature-name
   ```

2. **Branch naming conventions**:
   - `feature/` - New features
   - `fix/` - Bug fixes
   - `docs/` - Documentation changes
   - `style/` - Code style/formatting
   - `refactor/` - Code refactoring
   - `test/` - Test additions/changes
   - `chore/` - Maintenance tasks
   - `ci/` - CI/CD changes

3. **Make your changes** following the coding standards

4. **Test your changes** thoroughly

## Coding Standards

### Dart/Flutter Guidelines

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Keep functions small and focused (single responsibility)
- Add comments for complex logic
- Use `const` constructors where possible for performance

### Code Formatting

Run the formatter before committing:

```bash
flutter format .
```

### Linting

Ensure no lint errors:

```bash
flutter analyze
```

Fix any issues before submitting a PR.

### Import Organization

Organize imports in this order:
1. Dart/Flutter SDK imports
2. Package imports
3. Relative imports

```dart
// SDK imports
import 'package:flutter/material.dart';

// Package imports
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// Relative imports
import '../models/user_model.dart';
import '../widgets/custom_button.dart';
```

## Commit Guidelines

We follow **Conventional Commits** specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Commit Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes
- `perf`: Performance improvements

### Examples

```bash
feat(auth): add email verification flow
fix(events): resolve null pointer in event list
docs(readme): update Firebase setup instructions
style(widgets): format button widget code
refactor(providers): simplify auth provider logic
test(models): add unit tests for user model
chore(deps): update firebase dependencies
ci(workflow): add automated testing workflow
```

### Commit Message Best Practices

- Use present tense ("add feature" not "added feature")
- Use imperative mood ("move cursor to..." not "moves cursor to...")
- First line should be 50 characters or less
- Reference issues/PRs when applicable: `fixes #123`

## Pull Request Process

1. **Update your branch** with latest upstream changes:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Push your changes**:
   ```bash
   git push origin feature/your-feature-name
   ```

3. **Create a Pull Request** on GitHub:
   - Use a clear, descriptive title
   - Fill out the PR template completely
   - Reference related issues
   - Add screenshots for UI changes
   - Ensure all CI checks pass

4. **Code Review**:
   - Address reviewer feedback promptly
   - Keep discussions focused and professional
   - Make requested changes in new commits
   - Once approved, a maintainer will merge your PR

### PR Checklist

Before submitting, ensure:

- [ ] Code follows project style guidelines
- [ ] `flutter analyze` passes with no errors
- [ ] `flutter format .` has been run
- [ ] All tests pass (`flutter test`)
- [ ] New code has appropriate test coverage
- [ ] Documentation has been updated (if needed)
- [ ] No sensitive data (API keys, credentials) is committed
- [ ] Commit messages follow conventional commit format
- [ ] PR description clearly explains the changes

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/models/user_model_test.dart
```

### Writing Tests

- Write unit tests for models and business logic
- Write widget tests for UI components
- Write integration tests for critical user flows
- Aim for meaningful test coverage, not just high percentages

### Test Location

```
test/
├── models/           # Unit tests for models
├── providers/        # Unit tests for providers
├── repositories/     # Unit tests for repositories
├── widgets/          # Widget tests
└── integration/      # Integration tests
```

## Questions or Issues?

- Check existing [Issues](https://github.com/kalviumcommunity/S84-0226-TheVanguard-Flutter-Firebase-UniSphere/issues)
- Create a new issue if your question isn't answered
- Join our community discussions

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to UniSphere! 🚀
