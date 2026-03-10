# ══════════════════════════════════════════════════════════════
# ☕ Coffee Theme — Auto Fix Script (Windows PowerShell)
# 
# USAGE: Open PowerShell in your theme folder and run:
#   .\fix-coffee-theme.ps1
# ══════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "☕ Coffee Theme — Auto Fix Script" -ForegroundColor Cyan
Write-Host "══════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Check we're in the right folder
if (-not (Test-Path ".\package.json")) {
    Write-Host "❌ ERROR: No package.json found. Run this inside your theme folder." -ForegroundColor Red
    exit 1
}
if (-not (Test-Path ".\twilight.json")) {
    Write-Host "❌ ERROR: No twilight.json found. This doesn't look like a Salla theme." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Found Salla theme: $(Split-Path (Get-Location) -Leaf)" -ForegroundColor Green
Write-Host ""

# ── Step 1: Backup originals ──
Write-Host "📁 Step 1: Backing up originals..." -ForegroundColor Yellow
if (Test-Path ".\src\views\pages\index.twig") {
    Copy-Item ".\src\views\pages\index.twig" ".\src\views\pages\index-backup.twig" -Force
    Write-Host "   ✅ Backed up index.twig" -ForegroundColor Green
}
if (Test-Path ".\src\views\components\home\testimonials.twig") {
    Copy-Item ".\src\views\components\home\testimonials.twig" ".\src\views\components\home\testimonials-backup.twig" -Force
    Write-Host "   ✅ Backed up testimonials.twig" -ForegroundColor Green
}

# ── Step 2: Move coffee .twig files from views/ to src/views/ ──
Write-Host ""
Write-Host "📁 Step 2: Moving coffee components to src/views/..." -ForegroundColor Yellow

$coffeeFiles = @('hero','categories','products','features','tools','subscription','newsletter','announcement-bar','divider-band','testimonials')
$movedCount = 0

foreach ($f in $coffeeFiles) {
    $source = ".\views\components\home\$f.twig"
    $dest = ".\src\views\components\home\$f.twig"
    if (Test-Path $source) {
        Move-Item $source $dest -Force
        Write-Host "   ✅ Moved $f.twig" -ForegroundColor Green
        $movedCount++
    }
}

# Move coffee index.twig
if (Test-Path ".\views\pages\index.twig") {
    Move-Item ".\views\pages\index.twig" ".\src\views\pages\index.twig" -Force
    Write-Host "   ✅ Moved index.twig" -ForegroundColor Green
    $movedCount++
}

if ($movedCount -eq 0) {
    Write-Host "   ⚠️  No files found in .\views\ — already moved or not present" -ForegroundColor DarkYellow
} else {
    Write-Host "   📋 Moved $movedCount files" -ForegroundColor Cyan
}

# Clean up empty views/ folder
if (Test-Path ".\views") {
    Remove-Item ".\views" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "   ✅ Cleaned up leftover views/ folder" -ForegroundColor Green
}

# ── Step 3: Check coffee-theme.css ──
Write-Host ""
Write-Host "🎨 Step 3: Checking coffee-theme.css..." -ForegroundColor Yellow

if (Test-Path ".\src\assets\styles\coffee-theme.css") {
    Write-Host "   ✅ coffee-theme.css found" -ForegroundColor Green
} else {
    Write-Host "   ❌ MISSING: coffee-theme.css" -ForegroundColor Red
    Write-Host "   → Copy it to: src\assets\styles\coffee-theme.css" -ForegroundColor Red
}

# Check if it's imported in app.scss
$appScss = ".\src\assets\styles\app.scss"
if (Test-Path $appScss) {
    $scssContent = Get-Content $appScss -Raw
    if ($scssContent -match "coffee-theme") {
        Write-Host "   ✅ coffee-theme.css already imported in app.scss" -ForegroundColor Green
    } else {
        Add-Content $appScss "`n/* ── Coffee Theme ── */`n@import './coffee-theme.css';"
        Write-Host "   $([char]0x2705) Added @import to app.scss" -ForegroundColor Green
    }
} else {
    Write-Host "   ❌ app.scss not found!" -ForegroundColor Red
}

# ── Step 4: Check coffee-theme.js ──
Write-Host ""
Write-Host "⚡ Step 4: Checking coffee-theme.js..." -ForegroundColor Yellow

if (Test-Path ".\src\assets\js\coffee-theme.js") {
    Write-Host "   ✅ coffee-theme.js found" -ForegroundColor Green
} else {
    Write-Host "   ❌ MISSING: coffee-theme.js" -ForegroundColor Red
    Write-Host "   → Copy it to: src\assets\js\coffee-theme.js" -ForegroundColor Red
}

# Check if it's imported in app.js
$appJs = ".\src\assets\js\app.js"
if (Test-Path $appJs) {
    $jsContent = Get-Content $appJs -Raw
    if ($jsContent -match "coffee-theme") {
        Write-Host "   ✅ coffee-theme.js already imported in app.js" -ForegroundColor Green
    } else {
        Add-Content $appJs "`n/* ── Coffee Theme JS ── */`nimport './coffee-theme';"
        Write-Host "   ✅ Added import to app.js" -ForegroundColor Green
    }
} else {
    Write-Host "   ❌ app.js not found!" -ForegroundColor Red
}

# ── Step 5: Check twilight.json components ──
Write-Host ""
Write-Host "⚙️  Step 5: Checking twilight.json..." -ForegroundColor Yellow

$twilightContent = Get-Content ".\twilight.json" -Raw
if ($twilightContent -match "home.hero") {
    Write-Host "   ✅ Coffee components already registered" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Coffee components NOT in twilight.json" -ForegroundColor Red
    Write-Host "   → You need to add them manually. See DIAGNOSIS-AND-FIX.md" -ForegroundColor Red
}

# ── Step 6: Check locales ──
Write-Host ""
Write-Host "🌐 Step 6: Checking translations..." -ForegroundColor Yellow

if (Test-Path ".\src\locales\ar.json") {
    $arContent = Get-Content ".\src\locales\ar.json" -Raw
    if ($arContent -match "hero_title") {
        Write-Host "   ✅ Arabic translations include coffee keys" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Arabic translations missing coffee keys" -ForegroundColor DarkYellow
        Write-Host "   → Merge coffee translations from salla-ready-theme.zip" -ForegroundColor DarkYellow
    }
}

# ── Summary ──
Write-Host ""
Write-Host "══════════════════════════════════" -ForegroundColor Cyan
Write-Host "☕ Fix complete! Remaining tasks:" -ForegroundColor Cyan
Write-Host ""

$remaining = 0

if (-not (Test-Path ".\src\assets\styles\coffee-theme.css")) {
    Write-Host "  1. Copy coffee-theme.css → src\assets\styles\" -ForegroundColor White
    $remaining++
}
if (-not (Test-Path ".\src\assets\js\coffee-theme.js")) {
    Write-Host "  2. Copy coffee-theme.js → src\assets\js\" -ForegroundColor White
    $remaining++
}
if (-not ($twilightContent -match "home.hero")) {
    Write-Host "  3. Add coffee components to twilight.json" -ForegroundColor White
    $remaining++
}

if ($remaining -eq 0) {
    Write-Host "  ✅ All good! Run: salla theme preview" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "  After fixing, run: salla theme preview" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "══════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
