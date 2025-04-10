# LinkedIn Post Writer

A Flutter web application that helps users write engaging LinkedIn posts using OpenAI's GPT-4. This application provides an intuitive chat interface where users can describe their topic, and the AI will help craft professional and engaging LinkedIn posts.

## Features

- 💬 **Chat Interface**: User-friendly chat UI for seamless interaction
- 🤖 **GPT-4 Integration**: Leverages OpenAI's powerful language model
- ⌨️ **Keyboard Shortcuts**:
  - `Enter`: Send message
  - `Shift + Enter`: New line
  - `Numpad Enter`: Also sends message
- 🎨 **LinkedIn-Inspired Design**: Familiar and professional look
- 📱 **Responsive Layout**: Works on both desktop and mobile browsers

## Getting Started

### Prerequisites

- Flutter SDK (^3.7.2)
- OpenAI API Key

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/ISL270/linkedin-post-writer.git
   cd linkedin-post-writer
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up your OpenAI API key:
   - Copy `lib/app/core/constants/api_key.template.dart` to `lib/app/core/constants/api_key.dart`
   - Replace `'your-api-key-here'` with your actual OpenAI API key

4. Run the application:
   ```bash
   flutter run -d chrome
   ```

## Tech Stack

- **Flutter**: UI framework
- **flutter_bloc**: State management
- **flutter_chat_ui**: Chat interface components
- **dart_openai**: OpenAI API integration
- **equatable**: Value equality

## Project Structure

```
lib/
├── app/
│   ├── core/                # Shared core functionality
│   │   ├── models/          # Base models
│   │   ├── utils/           # Utility functions
│   │   └── constants/       # App constants
│   ├── features/            # Application features
│   │   └── chat/           # Chat feature module
│   │       ├── data/       # Data layer (sources: local/remote)
│   │       ├── domain/     # Business logic (repositories/entities)
│   │       └── presentation/ # UI layer (bloc/pages/widgets)
│   └── widgets/            # Shared widgets
└── main.dart               # Application entry point
```

### Clean Architecture

The project follows clean architecture principles:

1. **Core Layer**: Contains shared functionality, models, and utilities used across features
2. **Feature Modules**: Each feature (like chat) is isolated and follows clean architecture:
   - **Data Layer**: Handles data operations and external services
   - **Domain Layer**: Contains business logic and entities
   - **Presentation Layer**: Manages UI components and state
3. **Dependency Rule**: Dependencies point inward, with the domain layer having no dependencies on outer layers

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.


A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
