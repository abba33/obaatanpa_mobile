@echo off
echo ========================================
echo    🤱 Starting Obaatanpa Platform (Frontend Only)
echo ========================================
echo.

echo 🎨 Starting Frontend...
cd obaa-new-frontend
start "Obaatanpa Frontend" cmd /k "npm run dev"

echo.
echo 📱 Starting Mobile App...
cd ..\obaatanpa_mobile
start "Obaatanpa Mobile" cmd /k "flutter run"

echo.
echo ========================================
echo    ✅ Obaatanpa Platform Started!
echo ========================================
echo.
echo 🌐 Frontend: http://localhost:3000
echo 📱 Mobile App: Running on connected device/emulator
echo.
echo Press any key to exit...
pause > nul
