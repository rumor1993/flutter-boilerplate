#!/bin/bash

# Flutter Boilerplate Setup Script

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --rename <new_name>    Rename the project to <new_name>"
    echo "  --help, -h             Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./setup.sh                    # Normal setup"
    echo "  ./setup.sh --rename my_app   # Rename project to 'my_app'"
}

# Function to rename project
rename_project() {
    local new_name=$1
    local new_display_name=$2
    local new_package_id=$3

    if [ -z "$new_name" ]; then
        echo "❌ Project name cannot be empty"
        exit 1
    fi

    echo "🔄 Renaming project to: $new_name"

    # 현재 프로젝트명 추출
    current_name=$(grep "^name:" pubspec.yaml | cut -d' ' -f2)
    echo "📋 Current project name: $current_name"

    # Update pubspec.yaml
    echo "📝 Updating pubspec.yaml..."
    sed -i.bak "s/^name: .*/name: $new_name/" pubspec.yaml

    # Update Dart import statements - 동적으로 현재 이름 사용
    echo "📝 Updating import statements in Dart files..."
    find lib -name "*.dart" -exec sed -i.bak "s/package:$current_name/package:$new_name/g" {} \;
    find test -name "*.dart" -exec sed -i.bak "s/package:$current_name/package:$new_name/g" {} \;

    # Update Android files
    echo "📱 Updating Android configuration..."
    if [ -f "android/app/build.gradle.kts" ]; then
        sed -i.bak "s/namespace = \".*\"/namespace = \"$new_package_id\"/" android/app/build.gradle.kts
        sed -i.bak "s/applicationId = \".*\"/applicationId = \"$new_package_id\"/" android/app/build.gradle.kts
    fi

    # Update iOS files
    echo "🍎 Updating iOS configuration..."
    if [ -f "ios/Runner/Info.plist" ]; then
        sed -i.bak "s/<string>Meal Plan<\/string>/<string>$new_display_name<\/string>/" ios/Runner/Info.plist
        sed -i.bak "s/<string>meal_plan<\/string>/<string>$new_name<\/string>/" ios/Runner/Info.plist
    fi

    # Clean up backup files
    find . -name "*.bak" -delete

    echo "✅ Project renamed successfully!"
    echo "🧹 Cleaning project..."
    flutter clean
    flutter pub get

    # Rename project directory
    echo "📁 Renaming project directory..."
    cd ..
    if [ -d "flutter-boilerplate" ] && [ "$(basename "$PWD")" != "$new_name" ]; then
        mv "flutter-boilerplate" "$new_name"
        echo "✅ Project directory renamed to: $new_name"
        echo "📍 Project is now located at: $(pwd)/$new_name"
    else
        echo "ℹ️  Project directory is already named correctly or rename not needed"
    fi

    echo ""
    echo "🎉 Project '$new_name' is ready!"
    echo "Run: cd $new_name && flutter run"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --rename)
            if [ -z "$2" ]; then
                echo "❌ --rename requires a project name"
                show_usage
                exit 1
            fi

            # Convert to snake_case for package name
            new_name=$(echo "$2" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g' | sed 's/__*/_/g' | sed 's/^_//g' | sed 's/_$//g')
            # Convert to Title Case for display name
            new_display_name=$(echo "$2" | sed 's/_/ /g' | sed 's/\b\(.\)/\u\1/g')
            # Create package ID
            new_package_id="com.example.$new_name"

            rename_project "$new_name" "$new_display_name" "$new_package_id"
            exit 0
            ;;
        --help|-h)
            show_usage
            exit 0
            ;;
        *)
            echo "❌ Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

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