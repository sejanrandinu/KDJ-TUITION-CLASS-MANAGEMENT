# 🚀 ClassMaster - Cloudflare Pages Deployment Guide

This guide will help you deploy your ClassMaster application to Cloudflare Pages.

## 📋 Prerequisites

1. **Cloudflare Account** - [Sign up here](https://dash.cloudflare.com/sign-up)
2. **Git Repository** - Your code should be in GitHub, GitLab, or Bitbucket
3. **Supabase Project** - Already configured
4. **Firebase Project** - Already configured

## 🔧 Step 1: Prepare Your Repository

### 1.1 Commit All Changes

```bash
git add .
git commit -m "Prepare for Cloudflare Pages deployment"
git push origin main
```

### 1.2 Verify Build Configuration

The following files are already configured:
- ✅ `wrangler.toml` - Cloudflare configuration (minimal - build settings go in Dashboard)
- ✅ `.node-version` - Node.js version (20)
- ✅ `_headers` - Security headers
- ✅ `_redirects` - SPA routing support

**Important:** Cloudflare Pages uses the Dashboard for build configuration, not `wrangler.toml`!

## 🌐 Step 2: Deploy to Cloudflare Pages

### Option A: Using Cloudflare Dashboard (Recommended for First Time)

1. **Go to Cloudflare Dashboard**
   - Visit: https://dash.cloudflare.com/
   - Navigate to **Pages** → **Create a project**

2. **Connect Your Git Repository**
   - Click **Connect to Git**
   - Authorize Cloudflare to access your repository
   - Select your `classmaster01` repository

3. **Configure Build Settings**
   ```
   Project name: classmaster
   Production branch: main
   
   Build settings:
   Framework preset: None (or Vue)
   Build command: npm run build
   Build output directory: dist/spa
   Root directory: /
   
   Environment variables:
   VITE_SUPABASE_URL = your_supabase_url
   VITE_SUPABASE_KEY = your_supabase_anon_key
   NODE_VERSION = 20
   ```

4. **Add Environment Variables**
   - Click **Add variable** for each:
     - `VITE_SUPABASE_URL`
     - `VITE_SUPABASE_KEY`
   - Get these from your Supabase project settings

5. **Deploy**
   - Click **Save and Deploy**
   - Wait for the build to complete (usually 2-5 minutes)

### Option B: Using Wrangler CLI

1. **Install Wrangler**
   ```bash
   npm install -g wrangler
   ```

2. **Login to Cloudflare**
   ```bash
   wrangler login
   ```

3. **Deploy**
   ```bash
   npm run build
   wrangler pages deploy dist/spa --project-name=classmaster
   ```

## 🔐 Step 3: Configure Environment Variables

After deployment, add environment variables in Cloudflare Dashboard:

1. Go to **Pages** → **Your Project** → **Settings** → **Environment variables**
2. Add the following variables:

### Production Variables
```
VITE_SUPABASE_URL = https://your-project.supabase.co
VITE_SUPABASE_KEY = your_anon_key_here
NODE_VERSION = 20
```

### Preview Variables (Optional)
Same as production, or use different Supabase project for testing.

## 🔥 Step 4: Configure Firebase for Your Domain

1. **Get Your Cloudflare Pages URL**
   - After deployment, you'll get a URL like: `https://classmaster.pages.dev`

2. **Add Domain to Firebase**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select your project: `classmaster-e1117`
   - Navigate to **Authentication** → **Settings** → **Authorized domains**
   - Click **Add domain**
   - Add your Cloudflare Pages URL: `classmaster.pages.dev`
   - Also add any custom domain you plan to use

## 🌍 Step 5: Add Custom Domain (Optional)

1. **In Cloudflare Pages Dashboard**
   - Go to your project → **Custom domains**
   - Click **Set up a custom domain**
   - Enter your domain (e.g., `classmaster.com`)
   - Follow the DNS configuration instructions

2. **Update Firebase**
   - Add your custom domain to Firebase authorized domains (Step 4)

## 🔍 Step 6: Verify Deployment

1. **Visit Your Site**
   - Open your Cloudflare Pages URL
   - Test the following:
     - ✅ Login page loads
     - ✅ Registration page loads
     - ✅ Google Sign-In works
     - ✅ Email/Password login works
     - ✅ Dashboard loads after login

2. **Check Browser Console**
   - Press F12 → Console
   - Look for any errors
   - Verify Supabase connection

## 🐛 Troubleshooting

### Build Fails

**Error: "Module not found"**
```bash
# Solution: Clear cache and rebuild
rm -rf node_modules package-lock.json
npm install
npm run build
```

**Error: "Node version mismatch"**
- Ensure `.node-version` file contains `20`
- Set `NODE_VERSION=20` in environment variables

### Google Sign-In Not Working

**Error: "auth/unauthorized-domain"**
- Add your Cloudflare Pages domain to Firebase authorized domains
- Wait 5-10 minutes for changes to propagate

### Routing Issues (404 on refresh)

**Problem: Page refreshes show 404**
- Verify `_redirects` file is in the root directory
- Content should be: `/*    /index.html   200`
- Rebuild and redeploy

### Environment Variables Not Working

**Problem: Supabase connection fails**
- Check variable names start with `VITE_`
- Verify values are correct (no quotes needed)
- Redeploy after adding variables

### Wrangler.toml Configuration Error

**Error: "Configuration file for Pages projects does not support 'build'"**

**Solution:**
- This error has been fixed! ✅
- The `[build]` section has been removed from `wrangler.toml`
- Build configuration must be set in Cloudflare Dashboard, not in `wrangler.toml`
- Push the fix to Git and redeploy:
  ```bash
  git add .
  git commit -m "Fix wrangler.toml configuration"
  git push origin main
  ```

## 📊 Build Output Structure

After running `npm run build`, your `dist/spa` folder should contain:
```
dist/spa/
├── index.html
├── assets/
│   ├── *.js
│   ├── *.css
│   └── *.svg
├── favicon.svg
├── _headers
└── _redirects
```

## 🔄 Continuous Deployment

Cloudflare Pages automatically deploys when you push to your repository:

1. **Make Changes**
   ```bash
   # Edit your code
   git add .
   git commit -m "Update feature"
   git push origin main
   ```

2. **Automatic Deployment**
   - Cloudflare detects the push
   - Builds your project
   - Deploys automatically
   - You get a notification when complete

## 📈 Monitoring

### View Deployment Logs
1. Go to **Pages** → **Your Project** → **Deployments**
2. Click on any deployment to see logs
3. Check for build errors or warnings

### Analytics
1. Go to **Pages** → **Your Project** → **Analytics**
2. View traffic, performance, and errors

## 🎯 Post-Deployment Checklist

- [ ] Site loads correctly
- [ ] Google Sign-In works
- [ ] Email/Password authentication works
- [ ] All pages are accessible
- [ ] Images and assets load
- [ ] Mobile responsive design works
- [ ] Firebase domain is authorized
- [ ] Environment variables are set
- [ ] Custom domain configured (if applicable)
- [ ] SSL certificate is active (automatic with Cloudflare)

## 🆘 Support

If you encounter issues:

1. **Check Cloudflare Logs**
   - Pages → Your Project → Deployments → View logs

2. **Check Browser Console**
   - F12 → Console tab

3. **Verify Environment Variables**
   - Pages → Settings → Environment variables

4. **Firebase Configuration**
   - Ensure domain is authorized
   - Check API keys are correct

## 🎉 Success!

Your ClassMaster application should now be live on Cloudflare Pages!

**Your URLs:**
- Production: `https://classmaster.pages.dev` (or your custom domain)
- Preview: Automatic preview URLs for each branch/PR

**Next Steps:**
- Share your app with users
- Monitor analytics
- Set up custom domain
- Configure email notifications for deployments

---

**Need Help?** 
- Cloudflare Docs: https://developers.cloudflare.com/pages/
- Firebase Docs: https://firebase.google.com/docs/auth
- Supabase Docs: https://supabase.com/docs
