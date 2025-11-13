# Cloudflare Pages Quick Start Guide

## Quick Deployment Steps

1. **Go to Cloudflare Dashboard**
   - Visit [dash.cloudflare.com](https://dash.cloudflare.com)
   - Navigate to **Pages** → **Create a project**

2. **Connect Repository**
   - Connect your GitHub/GitLab/Bitbucket repository
   - Select your repository and branch (usually `main`)

3. **Configure Build Settings**
   - **Framework preset**: `None`
   - **Build command**: `bash cloudflare-build.sh`
   - **Build output directory**: `public`
   - **Root directory**: (leave empty)

4. **Deploy**
   - Click **Save and Deploy**
   - Wait for build to complete
   - Your site will be live at `https://your-project.pages.dev`

## Build Configuration Summary

```
Build command:     bash cloudflare-build.sh
Output directory:  public
Framework preset:  None
```

## Environment Variables (Optional)

Set these in Cloudflare Pages dashboard if needed:
- `HUGO_VERSION`: `0.151.0`
- `NODE_VERSION`: `22`
- `GO_VERSION`: `1.25.1`

## What the Build Script Does

1. Installs Node.js dependencies (`npm install`)
2. Installs Hugo Extended 0.151.0 (if not present)
3. Installs Go 1.25.1 (if not present, needed for Hugo modules)
4. Runs project setup (`npm run project-setup`)
5. Builds the site (`npm run build`)
6. Outputs to `public/` directory

## Custom Domain

1. In your Cloudflare Pages project, go to **Custom domains**
2. Click **Set up a custom domain**
3. Enter your domain name
4. Follow DNS configuration instructions

## Troubleshooting

- **Build fails**: Check build logs in Cloudflare Pages dashboard
- **404 errors**: Verify `baseURL` in `hugo.toml` is correct
- **Missing dependencies**: Ensure all required versions are installed

For detailed instructions, see [cloudflare-pages.md](./cloudflare-pages.md)

