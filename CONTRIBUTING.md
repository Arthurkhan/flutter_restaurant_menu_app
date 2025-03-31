# Contributing to Flutter Restaurant Menu App

Thank you for considering contributing to the Flutter Restaurant Menu App! This document outlines the guidelines and processes for contributing to this project.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for everyone.

## How Can I Contribute?

### Reporting Bugs

If you find a bug, please create an issue with the following information:

- A clear and descriptive title
- Steps to reproduce the behavior
- Expected behavior
- Actual behavior
- Screenshots if applicable
- Device/environment information

### Suggesting Enhancements

If you have an idea for an enhancement or new feature, please create an issue with:

- A clear and descriptive title
- A detailed description of the proposed functionality
- Explanation of why this enhancement would be useful
- Mock-ups or sketches if applicable

### Pull Requests

1. Fork the repository
2. Create a new branch for your feature or bugfix (`git checkout -b feature/your-feature-name`)
3. Make your changes
4. Run tests to ensure your changes don't break existing functionality
5. Commit your changes with clear commit messages
6. Push to your branch
7. Submit a pull request

## Development Setup

1. Install Flutter SDK (version 2.17.0 or higher)
2. Clone the repository
3. Install dependencies with `flutter pub get`
4. Run the app with `flutter run`

## Coding Style Guidelines

### Dart Code Style

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use proper naming conventions (camelCase for variables and methods, PascalCase for classes)
- Include documentation comments for public APIs

### Project Structure

- Keep the existing project structure organized
- Place new models in the `/lib/data/models` directory
- Place new screens in the appropriate directory under `/lib/presentation/screens`
- Place new widgets in the `/lib/presentation/widgets` directory
- Follow the BLoC pattern for state management

### Commit Guidelines

- Use clear and descriptive commit messages
- Reference issue numbers in commit messages when applicable
- Keep commits focused on a single change or feature

## Testing

- Write tests for new features
- Ensure existing tests pass with your changes
- Test on multiple device sizes, especially tablet layouts

## Documentation

- Update documentation for any new features or changes to existing functionality
- Document any complex algorithms or non-obvious code
- Update the README.md if necessary

## Review Process

Pull requests will be reviewed by project maintainers. The review process checks for:

- Code quality and style
- Test coverage
- Documentation
- Adherence to architecture patterns
- Performance considerations

## License

By contributing to this project, you agree that your contributions will be licensed under the same MIT License that covers the project.
