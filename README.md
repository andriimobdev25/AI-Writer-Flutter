# AI Linkedin Writer

A Flutter web application that helps users write engaging LinkedIn posts using AI.

## Features

- 💬 **Chat Interface**: User-friendly chat UI for seamless interaction
- 🤖 **AI-Powered Writing**: Leverages OpenAI's latest language model
- 📊 **Token Usage Tracking**: Monitor your API usage
- 🔒 **Secure API Management**: Firebase Functions for secure API calls
- 📱 **Responsive Layout**: Works on both desktop and mobile browsers

## Prerequisites

- Flutter SDK (^3.7.2)
- Node.js (v18 or higher)
- Firebase CLI (`npm install -g firebase-tools`)
- OpenAI API key
- Firebase project

## Setup Instructions

### Sentry Error Tracking (Production)

This project uses [Sentry](https://sentry.io/) to track errors in production builds.

**Setup:**
1. Create a Sentry account and a new project for Flutter.
2. Copy your Sentry DSN.
3. Open `lib/app/core/config/sentry_config.dart` and replace `YOUR_SENTRY_DSN_HERE` with your actual DSN string.
   - **Do NOT commit real DSNs to public repositories.**
4. Sentry is automatically initialized in `main.dart` for production builds.

For more details, see the [Sentry Flutter docs](https://docs.sentry.io/platforms/flutter/).

### 1. Clone the Repository

```bash
git clone https://github.com/ISL270/ai-linkedin-writer.git
cd ai-linkedin-writer
```

### 2. Flutter Setup

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Create Firebase configuration:
```bash
flutterfire configure
```
This will generate `lib/firebase_options.dart` with your Firebase project settings.

### 3. Firebase Functions Setup

1. Navigate to the functions directory:
```bash
cd functions
```

2. Install Node.js dependencies:
```bash
npm install
```

3. Create a `.env` file in the `functions` directory:
```bash
echo "OPENAI_API_KEY=your_openai_api_key_here" > .env
```

4. Set up Firebase Functions environment:
```bash
firebase functions:secrets:set OPENAI_API_KEY
```
When prompted, enter your OpenAI API key.

5. Deploy the Firebase Function:
```bash
firebase deploy --only functions
```

### 4. Update Function URL

After deploying, you'll receive a Function URL. Update this URL in:
`lib/app/core/services/openai_service.dart`

Replace the `_functionUrl` value with your new function URL.

## Running the Application

```bash
flutter run -d chrome
```

## Project Structure

```
lib/
├── main.dart              # Application entry point
├── app/
│   ├── core/             # Shared core functionality
│   │   ├── models/       # Base models
│   │   ├── utils/        # Utility functions
│   │   └── constants/    # App constants
│   ├── features/         # Application features
│   │   ├── feature_name/ # Each feature module
│   │   │   ├── data/    # Data layer
│   │   │   ├── domain/  # Business logic
│   │   │   └── presentation/ # UI layer
│   └── widgets/         # Shared widgets
```

## Security Notes

- Never commit the `.env` file
- Keep `firebase_options.dart` in `.gitignore`
- Use environment variables for sensitive data

## Contributing

1. Create a new branch for your feature
2. Make your changes
3. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
