# Cloudflare Pages Deployment Guide

This guide explains how to deploy your Hugo site to Cloudflare Pages.

## Prerequisites

- A Cloudflare account
- Your site repository on GitHub, GitLab, or Bitbucket

## Deployment Steps

### Option 1: Using Cloudflare Pages Dashboard (Recommended)

#### Method A: Using Build Script (Recommended for this project)

1. **Login to Cloudflare Dashboard**
   - Go to [Cloudflare Dashboard](https://dash.cloudflare.com/)
   - Navigate to **Pages** from the sidebar

2. **Create a New Project**
   - Click **Create a project**
   - Connect your Git repository (GitHub, GitLab, or Bitbucket)
   - Select your repository and branch

3. **Configure Build Settings**
   - **Framework preset**: None
   - **Build command**: `bash cloudflare-build.sh`
   - **Build output directory**: `public`
   - **Root directory**: `/` (leave empty)

4. **Environment Variables** (Optional)
   - You can add environment variables if needed:
     - `HUGO_VERSION`: `0.151.0`
     - `NODE_VERSION`: `22` (or your preferred Node version)
     - `GO_VERSION`: `1.25.1`

5. **Deploy**
   - Click **Save and Deploy**
   - Cloudflare Pages will build and deploy your site

#### Method B: Using Hugo Framework Preset (Simpler, but may need adjustments)

1. **Login to Cloudflare Dashboard**
   - Go to [Cloudflare Dashboard](https://dash.cloudflare.com/)
   - Navigate to **Pages** from the sidebar

2. **Create a New Project**
   - Click **Create a project**
   - Connect your Git repository
   - Select your repository and branch

3. **Configure Build Settings**
   - **Framework preset**: Hugo
   - **Build command**: `npm install && npm run project-setup && hugo --gc --minify --templateMetrics --templateMetricsHints --forceSyncStatic`
   - **Build output directory**: `public`
   - **Root directory**: `/` (leave empty)

4. **Environment Variables**
   - Add `NODE_VERSION`: `22`
   - Add `GO_VERSION`: `1.25.1` (if using Hugo modules)

5. **Deploy**
   - Click **Save and Deploy**
   - Note: This method requires Hugo Extended 0.151.0, which may need to be installed via build script

### Option 2: Using Wrangler CLI

1. **Install Wrangler CLI**
   ```bash
   npm install -g wrangler
   ```

2. **Login to Cloudflare**
   ```bash
   wrangler login
   ```

3. **Create a Pages Project**
   ```bash
   wrangler pages project create hugoplate
   ```

4. **Deploy**
   ```bash
   npm run build
   wrangler pages deploy public --project-name=hugoplate
   ```

### Option 3: Using GitHub Actions (CI/CD)

You can set up GitHub Actions to automatically deploy to Cloudflare Pages on push.

1. Create `.github/workflows/cloudflare-pages.yml`:

```yaml
name: Deploy to Cloudflare Pages

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '22'
      
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: '0.151.0'
          extended: true
      
      - name: Setup Go
        uses: actions/setup-go@v4
        with:
          go-version: '1.25.1'
      
      - name: Install dependencies
        run: npm install
      
      - name: Build
        run: |
          npm run project-setup
          npm run build
      
      - name: Deploy to Cloudflare Pages
        uses: cloudflare/pages-action@v1
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          projectName: hugoplate
          directory: public
```

2. Add secrets to your GitHub repository:
   - `CLOUDFLARE_API_TOKEN`: Your Cloudflare API token
   - `CLOUDFLARE_ACCOUNT_ID`: Your Cloudflare account ID

## Build Configuration

### Build Script
The project includes `cloudflare-build.sh` which:
- Installs Node.js dependencies
- Installs Hugo Extended 0.151.0
- Installs Go 1.25.1
- Runs project setup
- Builds the site

### Build Command
```bash
bash cloudflare-build.sh
```

### Output Directory
```
public/
```

## Custom Domain

1. Go to your Cloudflare Pages project
2. Click **Custom domains**
3. Add your domain
4. Follow the DNS configuration instructions

## Environment Variables

You can set environment variables in the Cloudflare Pages dashboard:
- `HUGO_VERSION`: Hugo version (default: 0.151.0)
- `NODE_VERSION`: Node.js version (default: 22)
- `GO_VERSION`: Go version (default: 1.25.1)

## Troubleshooting

### Build Fails
- Check that all dependencies are installed
- Verify Hugo version matches (0.151.0 Extended)
- Ensure Go is installed for Hugo modules

### Site Not Loading
- Verify `baseURL` in `hugo.toml` is set correctly
- Check that `public/` directory contains built files
- Review Cloudflare Pages build logs

### 404 Errors
- Ensure your `_redirects` file is in the `public/` directory
- Check that routes are configured correctly

## Additional Resources

- [Cloudflare Pages Documentation](https://developers.cloudflare.com/pages/)
- [Hugo Documentation](https://gohugo.io/)
- [Cloudflare Pages Build Configuration](https://developers.cloudflare.com/pages/platform/build-configuration/)

