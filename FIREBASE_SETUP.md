# Firebase Google Authentication Setup Instructions

## Current Issue
Google Sign-In/Sign-Up is showing error: `auth/unauthorized-domain`

## Solution - Add Authorized Domain to Firebase

### Step-by-Step Instructions:

1. **Open Firebase Console**
   - Go to: https://console.firebase.google.com/
   - Select project: **classmaster-e1117**

2. **Navigate to Authentication Settings**
   - Click **Authentication** in left sidebar
   - Click **Settings** tab (top of page)
   - Click **Authorized domains** tab

3. **Add Your Domains**
   Add the following domains (if not already present):
   
   ✅ **Production Domain:**
   ```
   classmaster01.pages.dev
   ```
   
   ✅ **Local Development:**
   ```
   localhost
   ```
   
   ✅ **Alternative Local (if needed):**
   ```
   127.0.0.1
   ```

4. **Save Changes**
   - Click **Add domain** button
   - Enter each domain
   - Click **Add** to confirm
   - Wait 1-2 minutes for changes to propagate

5. **Test Google Login**
   - Refresh your application
   - Try Google Sign-In/Sign-Up
   - Should work without errors!

---

## Current Status

### ✅ What's Working:
- Google logo is now displaying (using local SVG)
- Google buttons are styled and visible
- Error messages are user-friendly
- Email/password login and registration work fine

### ⏳ What Needs Firebase Console Update:
- Google Sign-In functionality
- Google Sign-Up functionality

### Temporary Workaround:
Users can use email/password authentication until Firebase domain is authorized.

---

## Quick Link
Direct link to Firebase Authentication Settings:
https://console.firebase.google.com/project/classmaster-e1117/authentication/settings

---

## After Authorization
Once you add the domain, Google authentication will work for:
- ✅ Login with Google
- ✅ Register with Google
- ✅ Both on localhost and production (classmaster01.pages.dev)
