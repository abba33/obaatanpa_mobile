@echo off
echo ========================================
echo    📱 Starting Obaatanpa Mobile App
echo    (Standalone - No Backend Required)
echo ========================================
echo.

echo 📱 Starting Flutter App...
echo.

echo Installing Flutter dependencies...
call flutter pub get

echo.
echo Starting Flutter app on Chrome...
call flutter run -d chrome --web-port=8080

echo.
echo ========================================
echo    ✅ Flutter App Started!
echo ========================================
echo.
echo 📱 Flutter App: http://localhost:8080
echo.
echo 🎯 Demo Login Credentials:
echo    Email: demo@obaatanpa.com
echo    Password: demo123
echo.
echo 👥 User Types (use in email):
echo    pregnant@obaatanpa.com - Pregnant Mother
echo    newmother@obaatanpa.com - New Mother
echo    doctor@obaatanpa.com - Health Practitioner
echo.
echo Press any key to exit...
pause > nul
