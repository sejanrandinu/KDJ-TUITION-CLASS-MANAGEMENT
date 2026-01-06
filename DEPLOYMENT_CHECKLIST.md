# 🚀 Cloudflare Pages Deployment Checklist

## Before Deployment

### Code Preparation
- [ ] All changes committed to Git
- [ ] Code tested locally
- [ ] No console errors
- [ ] All features working
- [ ] Environment variables documented

### Repository Setup
- [ ] Code pushed to GitHub/GitLab/Bitbucket
- [ ] Repository is accessible
- [ ] Main/master branch is up to date

### Configuration Files

- [x] `wrangler.toml` configured (minimal - build settings Cloudflare Dashboard එකේ)
- [x] `.node-version` file created (Node 20)
- [x] `_headers` file in public folder
- [x] `_redirects` file in public folder
- [x] `.env.example` created

**වැදගත්:** Build configuration `wrangler.toml` එකේ නෙමෙයි, Cloudflare Dashboard එකේ set කරන්න ඕන!

## Deployment Steps

### Cloudflare Setup
- [ ] Cloudflare account created
- [ ] Connected Git repository
- [ ] Project name set: `classmaster`
- [ ] Build command: `npm run build`
- [ ] Build output: `dist/spa`
- [ ] Node version: 20

### Environment Variables (Cloudflare Dashboard)
- [ ] `VITE_SUPABASE_URL` added
- [ ] `VITE_SUPABASE_KEY` added
- [ ] `NODE_VERSION` set to 20

### Firebase Configuration
- [ ] Firebase Console accessed
- [ ] Cloudflare Pages domain added to authorized domains
  - [ ] `classmaster.pages.dev` (or your URL)
  - [ ] Custom domain (if applicable)
- [ ] Changes saved and propagated (wait 5-10 minutes)

### Supabase Configuration
- [ ] Supabase project URL copied
- [ ] Anon key copied
- [ ] Both added to Cloudflare environment variables

## Post-Deployment Testing

### Basic Functionality
- [ ] Site loads without errors
- [ ] All pages accessible
- [ ] Images and assets load correctly
- [ ] Favicon displays correctly
- [ ] Mobile responsive design works

### Authentication
- [ ] Login page loads
- [ ] Email/Password login works
- [ ] Google Sign-In works
- [ ] Registration works
- [ ] Google Sign-Up works
- [ ] Logout works

### Database Connection
- [ ] Supabase connection successful
- [ ] Data loads from database
- [ ] Data can be created
- [ ] Data can be updated
- [ ] Data can be deleted

### Features
- [ ] Dashboard loads
- [ ] Students page works
- [ ] Fees page works
- [ ] SMS settings work
- [ ] All CRUD operations work
- [ ] Real-time updates work (if applicable)

### Security
- [ ] HTTPS enabled (automatic with Cloudflare)
- [ ] Security headers present
- [ ] Cloudflare Turnstile works
- [ ] RLS policies working (Supabase)

## Browser Testing

### Desktop
- [ ] Chrome/Edge
- [ ] Firefox
- [ ] Safari (if available)

### Mobile
- [ ] Mobile Chrome
- [ ] Mobile Safari
- [ ] Responsive design works

### Console Checks
- [ ] No JavaScript errors
- [ ] No 404 errors
- [ ] No CORS errors
- [ ] API calls successful

## Performance

- [ ] Page load time acceptable
- [ ] Images optimized
- [ ] No unnecessary console logs
- [ ] Build size reasonable

## Custom Domain (Optional)

- [ ] Custom domain purchased
- [ ] DNS configured in Cloudflare
- [ ] Domain added to Cloudflare Pages
- [ ] Domain added to Firebase authorized domains
- [ ] SSL certificate active
- [ ] Domain resolves correctly

## Continuous Deployment

- [ ] Auto-deployment enabled
- [ ] Test push to repository
- [ ] Verify auto-deployment works
- [ ] Check deployment notifications

## Monitoring

- [ ] Cloudflare Analytics enabled
- [ ] Deployment logs accessible
- [ ] Error tracking set up (optional)

## Documentation

- [ ] Deployment guide reviewed
- [ ] Environment variables documented
- [ ] Team members informed
- [ ] User documentation updated (if applicable)

## Final Checks

- [ ] All checklist items completed
- [ ] Site tested by multiple users
- [ ] Backup of configuration saved
- [ ] Deployment date recorded
- [ ] Success! 🎉

---

## Quick Reference

**Cloudflare Dashboard:**
https://dash.cloudflare.com/

**Your Project URL:**
https://classmaster.pages.dev

**Firebase Console:**
https://console.firebase.google.com/project/classmaster-e1117

**Supabase Dashboard:**
https://supabase.com/dashboard

**Build Command:**
```bash
npm run build
```

**Deploy Command:**
```bash
wrangler pages deploy dist/spa --project-name=classmaster
```

**Or use automated script:**
```bash
.\deploy-cloudflare.bat
```

---

## Troubleshooting Quick Links

- Build fails → Check Node version (should be 20)
- Google Sign-In fails → Check Firebase authorized domains
- 404 on refresh → Check `_redirects` file
- Environment variables not working → Check they start with `VITE_`
- Supabase connection fails → Check environment variables

---

**Date Deployed:** _______________
**Deployed By:** _______________
**Production URL:** _______________
**Custom Domain:** _______________

**Notes:**
_______________________________________________
_______________________________________________
_______________________________________________
