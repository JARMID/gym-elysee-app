Write-Host "Starting Gym Elysee App..."
Write-Host "1. Cleaning project..."
flutter clean
flutter pub get

Write-Host "2. Regenerating code..."
flutter pub run build_runner build --delete-conflicting-outputs

Write-Host "3. Launching App on Chrome..."
Write-Host "NOTE: Make sure 'php artisan serve' is running in another terminal!"
flutter run -d chrome
