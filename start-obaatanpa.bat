@echo off
echo ========================================
echo    🤱 Starting Obaatanpa Platform
echo ========================================
echo.

echo 🎨 Setting up Frontend...
cd obaa-new-frontend

echo Installing frontend dependencies...
call npm install

echo Starting frontend server...
start "Obaatanpa Frontend" cmd /k "npm run dev"

echo.
echo 📱 Starting Mobile App...
cd ..\obaatanpa_mobile

echo Starting Flutter mobile app...
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
