#!/bin/bash

# Flutter Boilerplate Setup Script
echo "🚀 Setting up Flutter Boilerplate..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed"

# Check Flutter version
echo "📋 Flutter version:"
flutter --version

# Install dependencies
echo "📦 Installing dependencies..."
flutter pub get

# Generate code
echo "🔧 Generating code..."
dart run build_runner build --delete-conflicting-outputs

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📄 Creating .env file..."
    cp .env.example .env
    echo "⚠️  Please edit .env file and configure your API endpoints and OAuth credentials"
else
    echo "✅ .env file already exists"
fi

# Run analyzer
echo "🔍 Running analyzer..."
flutter analyze

# Run tests
echo "🧪 Running tests..."
flutter test

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env file with your configuration"
echo "2. Set up Google Sign-In credentials"
echo "3. Run: flutter run --dart-define-from-file=.env"
echo ""
echo "For more information, see README.md"