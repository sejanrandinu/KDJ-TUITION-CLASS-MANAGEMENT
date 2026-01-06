@echo off
echo ================================
echo ClassMaster - Cloudflare Deploy
echo ================================
echo.

echo [1/3] Installing dependencies...
call npm install
if %errorlevel% neq 0 (
    echo Error: Failed to install dependencies
    exit /b 1
)

echo.
echo [2/3] Building application...
call npm run build
if %errorlevel% neq 0 (
    echo Error: Build failed
    exit /b 1
)

echo.
echo [3/3] Deploying to Cloudflare Pages...
call wrangler pages deploy dist/spa --project-name=classmaster
if %errorlevel% neq 0 (
    echo Error: Deployment failed
    exit /b 1
)

echo.
echo ================================
echo Deployment Complete!
echo ================================
echo.
echo Your app should be live at:
echo https://classmaster.pages.dev
echo.
echo Don't forget to:
echo 1. Add environment variables in Cloudflare Dashboard
echo 2. Add your domain to Firebase authorized domains
echo.

pause
