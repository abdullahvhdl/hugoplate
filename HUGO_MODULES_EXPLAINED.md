# How Hugo Modules Work with Static Generated Files

This document explains how Hugo modules are integrated into the static site generation process.

## Overview

Hugo modules are **external packages** that provide reusable components (layouts, shortcodes, partials, assets) for your Hugo site. They work at **build time** to generate static HTML files, not at runtime.

## How Hugo Modules Work

### 1. Module Configuration

Modules are declared in `config/_default/module.toml`:

```toml
[[imports]]
path = "github.com/gethugothemes/hugo-modules/search"

[[imports]]
path = "github.com/gethugothemes/hugo-modules/images"

[[imports]]
path = "github.com/gethugothemes/hugo-modules/shortcodes/button"
```

### 2. Go Module System

Hugo uses **Go's module system** to manage dependencies:

- **`go.mod`**: Lists all module dependencies
- **`go.sum`**: Contains checksums for module integrity
- Modules are downloaded via `go get` or `hugo mod get`

### 3. Module Resolution at Build Time

When you run `hugo build`, Hugo:

1. **Downloads modules** (if not already cached)
   ```bash
   hugo mod get -u ./...
   ```

2. **Resolves module paths** and merges them into your site structure
   - Module layouts → merged with your layouts
   - Module partials → available via `{{ partial }}`
   - Module shortcodes → available via `{{< shortcode >}}`
   - Module assets → processed and bundled

3. **Processes templates** using module components
   - Resolves `{{ partial "logo" }}` from modules
   - Processes `{{< button >}}` shortcodes
   - Includes module CSS/JS in the build

4. **Generates static HTML** files
   - All module code is **compiled into HTML**
   - No runtime module resolution needed
   - Output is pure static HTML/CSS/JS

## Module Types in This Project

### 1. **Component Modules**
Provide reusable UI components:

- **`images`**: Logo partial (`{{ partial "logo" }}`)
- **`search`**: Search functionality
- **`pwa`**: Progressive Web App features
- **`preloader`**: Loading screen component
- **`cookie-consent`**: Cookie consent banner
- **`announcement`**: Announcement bar
- **`social-share`**: Social sharing buttons

### 2. **Shortcode Modules**
Provide markdown shortcodes:

- **`button`**: `{{< button label="Click" link="/" >}}`
- **`notice`**: `{{< notice "info" >}}Text{{< /notice >}}`
- **`accordion`**: `{{< accordion "Title" >}}Content{{< /accordion >}}`
- **`tab`**: `{{< tabs >}}{{< tab "Tab 1" >}}Content{{< /tab >}}{{< /tabs >}}`
- **`modal`**: Modal dialogs
- **`table-of-contents`**: `{{< toc >}}`

### 3. **Asset Modules**
Provide CSS/JS assets:

- **`icons/font-awesome`**: Font Awesome icons
- **`gallery-slider`**: Gallery slider functionality
- **`gzip-caching`**: Caching optimization

### 4. **SEO Modules**
Provide SEO features:

- **`basic-seo`**: Basic SEO tags
- **`site-verifications`**: Site verification tags
- **`google-tag-manager`**: GTM integration

### 5. **Video Modules**
Provide video functionality:

- **`videos`**: Video embedding
- **`mermaid`**: Mermaid diagrams

## Module Resolution Order

Hugo resolves modules in this order (highest priority first):

1. **Project files** (your site)
2. **Theme files** (`themes/hugoplate/`)
3. **Module files** (imported modules)

This means:
- Your files can **override** module files
- Theme files can **override** module files
- Modules provide **default** implementations

## Example: How the Logo Module Works

### 1. Module Declaration
```toml
# config/_default/module.toml
[[imports]]
path = "github.com/gethugothemes/hugo-modules/images"
```

### 2. Module Provides Partial
The `images` module provides a `logo.html` partial template.

### 3. Usage in Template
```html
<!-- themes/hugoplate/layouts/partials/essentials/header.html -->
{{ partial "logo" }}
```

### 4. Configuration
```toml
# config/_default/params.toml
logo = "images/logo.png"
logo_darkmode = "images/logo-darkmode.png"
logo_width = "160px"
```

### 5. Build Time Processing
When Hugo builds:
1. Resolves `{{ partial "logo" }}` to the module's logo partial
2. Reads logo configuration from `params.toml`
3. Generates HTML with logo image
4. Outputs static HTML to `public/index.html`

### 6. Static Output
The final HTML contains:
```html
<a class="navbar-brand" href="/">
  <img src="/images/logo.png" alt="Logo" width="160px">
</a>
```

**No module code remains** - it's all compiled into static HTML!

## Example: How Shortcodes Work

### 1. Module Declaration
```toml
[[imports]]
path = "github.com/gethugothemes/hugo-modules/shortcodes/button"
```

### 2. Usage in Content
```markdown
{{< button label="Get Started" link="/contact" style="solid" >}}
```

### 3. Build Time Processing
When Hugo builds:
1. Finds the `button` shortcode in the module
2. Processes the shortcode with parameters
3. Generates HTML button markup
4. Outputs static HTML to the page

### 4. Static Output
The final HTML contains:
```html
<a href="/contact" class="btn btn-primary">Get Started</a>
```

**No shortcode code remains** - it's all compiled into static HTML!

## Module Assets (CSS/JS)

### How Module Assets Are Processed

1. **Module provides CSS/JS files**
   - Modules can include CSS/JS assets
   - These are merged into your asset pipeline

2. **Hugo processes assets**
   - Combines module CSS with your CSS
   - Minifies and optimizes
   - Outputs to `public/css/style.css`

3. **Static output**
   - All CSS/JS is **bundled into static files**
   - No runtime module loading
   - Everything is pre-compiled

### Example: Font Awesome Icons

```toml
# Module declaration
[[imports]]
path = "github.com/gethugothemes/hugo-modules/icons/font-awesome"
```

The module provides Font Awesome CSS/JS files that are:
1. Downloaded during build
2. Processed by Hugo
3. Bundled into `public/css/style.css`
4. Referenced in HTML: `<link rel="stylesheet" href="/css/style.css">`

## Build Process Flow

```
1. Configuration
   ├── module.toml (module declarations)
   ├── go.mod (Go dependencies)
   └── params.toml (module configuration)

2. Module Resolution (Build Time)
   ├── Download modules via Go
   ├── Resolve module paths
   └── Merge into site structure

3. Template Processing (Build Time)
   ├── Process layouts (using module partials)
   ├── Process shortcodes (from modules)
   ├── Process assets (CSS/JS from modules)
   └── Generate HTML

4. Static Output
   ├── public/index.html (static HTML)
   ├── public/css/style.css (bundled CSS)
   ├── public/js/script.js (bundled JS)
   └── public/images/... (static images)

5. Deployment
   └── Upload public/ directory to hosting
```

## Key Points

### ✅ Modules Are Build-Time Only

- Modules are **resolved at build time**
- All module code is **compiled into static HTML**
- **No runtime module resolution** needed
- Final output is **pure static files**

### ✅ Modules Don't Exist in Output

- Module code is **not included** in `public/` directory
- Only the **generated HTML/CSS/JS** is output
- Modules are **development dependencies**, not runtime dependencies

### ✅ Modules Are Cached

- Hugo caches modules in `hugo_modules/` directory (usually in `.gitignore`)
- Modules are downloaded once and reused
- Updates require: `hugo mod get -u ./...`

### ✅ Modules Can Be Overridden

- You can override module files by placing files in the same location
- Your files take priority over module files
- Useful for customizing module behavior

## Module Management Commands

```bash
# Download/update modules
hugo mod get -u ./...

# Clean module cache
hugo mod clean

# Verify module integrity
hugo mod verify

# Tidy go.mod
hugo mod tidy

# Update all modules
npm run update-modules  # (custom script)
```

## Module Files Location

Modules are typically stored in:
- **Cache**: `hugo_modules/` (local cache, usually gitignored)
- **Go cache**: `~/go/pkg/mod/` (Go module cache)
- **Not in output**: Modules are **not** copied to `public/`

## Summary

**Hugo modules work by:**

1. **Declaring modules** in `module.toml`
2. **Downloading modules** via Go at build time
3. **Resolving module components** (partials, shortcodes, assets)
4. **Processing templates** using module components
5. **Generating static HTML** with all module code compiled in
6. **Outputting static files** to `public/` directory

**The final static site contains:**
- ✅ Static HTML files (with module code compiled in)
- ✅ Static CSS/JS files (with module assets bundled)
- ✅ Static images and assets
- ❌ No module source code
- ❌ No runtime module resolution
- ❌ No Go dependencies

**This makes Hugo sites:**
- ⚡ **Fast**: Pure static files, no server-side processing
- 🔒 **Secure**: No runtime code execution
- 📦 **Portable**: Just HTML/CSS/JS files
- 🚀 **Scalable**: Can be served from CDN

## Additional Resources

- [Hugo Modules Documentation](https://gohugo.io/hugo-modules/)
- [Go Modules Documentation](https://go.dev/ref/mod)
- [Hugo Module Imports](https://gohugo.io/hugo-modules/configuration/#module-configuration-imports)

