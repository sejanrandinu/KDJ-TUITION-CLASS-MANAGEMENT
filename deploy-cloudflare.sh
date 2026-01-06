#!/bin/bash

echo "================================"
echo "ClassMaster - Cloudflare Deploy"
echo "================================"
echo ""

echo "[1/3] Installing dependencies..."
npm install
if [ $? -ne 0 ]; then
    echo "Error: Failed to install dependencies"
    exit 1
fi

echo ""
echo "[2/3] Building application..."
npm run build
if [ $? -ne 0 ]; then
    echo "Error: Build failed"
    exit 1
fi

echo ""
echo "[3/3] Deploying to Cloudflare Pages..."
wrangler pages deploy dist/spa --project-name=classmaster
if [ $? -ne 0 ]; then
    echo "Error: Deployment failed"
    exit 1
fi

echo ""
echo "================================"
echo "Deployment Complete!"
echo "================================"
echo ""
echo "Your app should be live at:"
echo "https://classmaster.pages.dev"
echo ""
echo "Don't forget to:"
echo "1. Add environment variables in Cloudflare Dashboard"
echo "2. Add your domain to Firebase authorized domains"
echo ""
