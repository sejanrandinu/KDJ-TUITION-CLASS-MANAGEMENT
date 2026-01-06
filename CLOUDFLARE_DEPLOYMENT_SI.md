# 🚀 ClassMaster - Cloudflare Pages Deploy කරන්නේ කොහොමද

## 📋 මුලින්ම අවශ්‍ය දේවල්

1. **Cloudflare Account එකක්** - [මෙතනින් Sign up කරන්න](https://dash.cloudflare.com/sign-up)
2. **Git Repository එකක්** - ඔයාගේ code එක GitHub, GitLab, හෝ Bitbucket එකේ තියෙන්න ඕන
3. **Supabase Project එක** - දැනටමත් configure කරලා තියෙනවා ✅
4. **Firebase Project එක** - දැනටමත් configure කරලා තියෙනවා ✅

## 🎯 ක්‍රමය 1: Cloudflare Dashboard එකෙන් (පළමු වතාවට හොඳම)

### පියවර 1: Cloudflare Dashboard එකට යන්න

1. මෙම website එකට යන්න: https://dash.cloudflare.com/
2. **Pages** → **Create a project** click කරන්න

### පියවර 2: Git Repository එක Connect කරන්න

1. **Connect to Git** click කරන්න
2. Cloudflare එකට ඔයාගේ repository access කරන්න permission දෙන්න
3. `classmaster01` repository එක select කරන්න

### පියවර 3: Build Settings Configure කරන්න

```
Project name: classmaster
Production branch: main

Build settings:
Framework preset: None (හෝ Vue)
Build command: npm run build
Build output directory: dist/spa
Root directory: /

Environment variables:
VITE_SUPABASE_URL = ඔයාගේ_supabase_url
VITE_SUPABASE_KEY = ඔයාගේ_supabase_anon_key
NODE_VERSION = 20
```

### පියවර 4: Environment Variables Add කරන්න

**Supabase URL සහ Key එක හොයාගන්නේ කොහොමද:**

1. https://supabase.com/dashboard/project/_/settings/api වෙත යන්න
2. **Project URL** copy කරන්න → `VITE_SUPABASE_URL` එකට paste කරන්න
3. **anon public** key එක copy කරන්න → `VITE_SUPABASE_KEY` එකට paste කරන්න

Cloudflare එකේ:
- **Add variable** click කරලා මේ variables add කරන්න:
  - `VITE_SUPABASE_URL` = ඔයාගේ Supabase URL
  - `VITE_SUPABASE_KEY` = ඔයාගේ Supabase anon key
  - `NODE_VERSION` = 20

### පියවර 5: Deploy කරන්න

1. **Save and Deploy** click කරන්න
2. Build එක complete වෙනකම් wait කරන්න (මිනිත්තු 2-5ක් විතර)
3. Deploy එක success වුනාම, ඔයාට URL එකක් ලැබෙනවා: `https://classmaster.pages.dev`

## 🔥 පියවර 6: Firebase Configure කරන්න

**ඔයාගේ domain එක Firebase එකට add කරන්න:**

1. [Firebase Console](https://console.firebase.google.com/) එකට යන්න
2. ඔයාගේ project එක select කරන්න: `classmaster-e1117`
3. **Authentication** → **Settings** → **Authorized domains** වෙත යන්න
4. **Add domain** click කරන්න
5. ඔයාගේ Cloudflare Pages URL එක add කරන්න: `classmaster.pages.dev`

**මේක නැතිව Google Sign-In වැඩ කරන්නේ නෑ!** ⚠️

## 🎯 ක්‍රමය 2: Command Line එකෙන් (Advanced Users)

### පියවර 1: Wrangler Install කරන්න

PowerShell එක Administrator විදියට open කරලා:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
npm install -g wrangler
```

### පියවර 2: Cloudflare එකට Login වෙන්න

```bash
wrangler login
```

Browser එකක් open වෙයි. Login කරන්න.

### පියවර 3: Deploy කරන්න

**Option A: Automated Script Use කරන්න (Easy)**

```bash
cd "d:\SER Tech\KDJ AI TRAINING\classmaster01"
.\deploy-cloudflare.bat
```

**Option B: Manual Commands**

```bash
cd "d:\SER Tech\KDJ AI TRAINING\classmaster01"
npm install
npm run build
wrangler pages deploy dist/spa --project-name=classmaster
```

## ✅ පරීක්ෂා කරන්න (Testing)

Deploy එක complete වුනාම:

1. **Website එකට යන්න**
   - ඔයාගේ URL එක open කරන්න: `https://classmaster.pages.dev`

2. **මේවා test කරන්න:**
   - ✅ Login page එක load වෙනවද?
   - ✅ Google Sign-In වැඩ කරනවද?
   - ✅ Email/Password login වැඩ කරනවද?
   - ✅ Registration වැඩ කරනවද?
   - ✅ Dashboard එක load වෙනවද?

3. **Errors Check කරන්න**
   - F12 press කරන්න → Console tab එක බලන්න
   - Errors තියෙනවද කියලා බලන්න

## 🐛 Problems හා විසඳුම්

### Google Sign-In වැඩ කරන්නේ නෑ

**Error: "auth/unauthorized-domain"**

**විසඳුම:**
1. Firebase Console එකට යන්න
2. ඔයාගේ Cloudflare domain එක authorized domains වලට add කරන්න
3. මිනිත්තු 5-10ක් wait කරන්න
4. Browser cache එක clear කරන්න
5. නැවත try කරන්න

### Page Refresh කරද්දී 404 Error එනවා

**විසඳුම:**
- `public/_redirects` file එක තියෙනවද check කරන්න
- නැවත build කරලා deploy කරන්න

### Build එක Fail වෙනවා

**Error: "Module not found"**

```bash
# Dependencies නැවත install කරන්න
cd "d:\SER Tech\KDJ AI TRAINING\classmaster01"
rmdir /s /q node_modules
del package-lock.json
npm install
npm run build
```

### Environment Variables වැඩ කරන්නේ නෑ

**විසඳුම:**
1. Cloudflare Dashboard → Pages → ඔයාගේ Project → Settings → Environment variables
2. Variables නිවැරදිව add කරලා තියෙනවද check කරන්න
3. Variable names `VITE_` එකෙන් start වෙනවද check කරන්න
4. Redeploy කරන්න

## 🔄 Automatic Deployment

Git එකට push කරද්දී automatic deploy වෙනවා:

```bash
# Code එක edit කරන්න
git add .
git commit -m "New feature added"
git push origin main
```

Cloudflare automatically:
- ✅ Changes detect කරනවා
- ✅ Build කරනවා
- ✅ Deploy කරනවා
- ✅ Notification එකක් දෙනවා

## 📱 Custom Domain එකක් Add කරන්න (Optional)

1. **Cloudflare Pages Dashboard එකේ:**
   - ඔයාගේ project → **Custom domains**
   - **Set up a custom domain** click කරන්න
   - ඔයාගේ domain එක enter කරන්න (උදා: `classmaster.lk`)
   - DNS instructions follow කරන්න

2. **Firebase එකට Domain එක Add කරන්න:**
   - Firebase Console → Authentication → Authorized domains
   - ඔයාගේ custom domain එක add කරන්න

## 🎉 ජයග්‍රහණය!

ඔයාගේ ClassMaster application එක දැන් live!

**ඔයාගේ URLs:**
- Production: `https://classmaster.pages.dev`
- Custom domain: `https://your-domain.com` (if configured)

## 📊 Deployment Status බලන්න

1. **Cloudflare Dashboard:**
   - Pages → ඔයාගේ Project → Deployments
   - සෑම deployment එකක්ම status එක බලන්න

2. **Logs බලන්න:**
   - Deployment එකක් click කරන්න
   - Build logs සහ errors බලන්න

## 🆘 උදව් අවශ්‍යද?

**Common Issues:**

1. **PowerShell Scripts Disabled:**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Wrangler Not Found:**
   ```bash
   npm install -g wrangler
   ```

3. **Build Fails:**
   - Node version 20 use කරනවද check කරන්න
   - Dependencies නැවත install කරන්න

## 📞 Support

- Cloudflare Docs: https://developers.cloudflare.com/pages/
- Firebase Docs: https://firebase.google.com/docs/auth
- Supabase Docs: https://supabase.com/docs

---

**සටහන:** මේ guide එක follow කරලා problems තියෙනවනම්, error message එක copy කරලා Google එකේ search කරන්න හෝ මගෙන් අහන්න! 😊
