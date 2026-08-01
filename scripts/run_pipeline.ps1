<#
===========================================
ANTHOLOGY ATELIER — BATCH PIPELINE SKELETON
Ingestion → Extraction → Hugo → Deploy
===========================================

This script processes a batch of emails, extracts content,
converts to Hugo-ready Markdown, builds the site locally,
and pushes updates to GitHub for Cloudflare deployment.

Replace placeholder paths and script names with your actual ones.
#>

# -----------------------------
# CONFIGURATION
# -----------------------------

# Root working directory
$Root = "C:\Anthology_PoC"

# Input/output directories
$InputDir      = "$Root\input"
$ExtractDir    = "$Root\output"
$TWStageDir    = "$Root\tw_stage"
$HugoStageDir  = "$Root\hugo_stage"
$LogDir        = "$Root\logs"

# Script locations (replace with your actual scripts)
$ExtractorScript = "$Root\scripts\extract_moly.ps1"
$TWExportScript  = "$Root\scripts\tw_export.ps1"
$HugoConvertScript = "$Root\scripts\convert_to_hugo.ps1"

# Hugo project directory
$HugoDir = "C:\Sites\anthology4tech"

# GitHub repo directory (same as HugoDir if combined)
$RepoDir = $HugoDir

# -----------------------------
# START PIPELINE
# -----------------------------

Write-Host "=== Anthology Atelier Pipeline Starting ===" -ForegroundColor Cyan
Write-Host "Timestamp: $(Get-Date)" -ForegroundColor DarkGray

# -----------------------------
# STEP 1 — INGESTION
# -----------------------------

Write-Host "`n[1/6] Ingestion: Scanning input folder..." -ForegroundColor Yellow

$EmailFiles = Get-ChildItem -Path $InputDir -Filter *.eml

if ($EmailFiles.Count -eq 0) {
    Write-Host "No .eml files found. Exiting." -ForegroundColor Red
    exit
}

Write-Host "Found $($EmailFiles.Count) email files." -ForegroundColor Green

# -----------------------------
# STEP 2 — EXTRACTION (MOLY)
# -----------------------------

Write-Host "`n[2/6] Extraction: Running Moly extractor..." -ForegroundColor Yellow

try {
    & $ExtractorScript -Input $InputDir -Output $ExtractDir -Log $LogDir
    Write-Host "Extraction complete." -ForegroundColor Green
}
catch {
    Write-Host "Extraction failed: $_" -ForegroundColor Red
    exit
}

# -----------------------------
# STEP 3 — TW+R STAGING
# -----------------------------

Write-Host "`n[3/6] TW+R Staging: Creating tiddlers..." -ForegroundColor Yellow

try {
    & $TWExportScript -Input $ExtractDir -Output $TWStageDir -Log $LogDir
    Write-Host "TW+R staging complete." -ForegroundColor Green
}
catch {
    Write-Host "TW+R staging failed: $_" -ForegroundColor Red
    exit
}

# -----------------------------
# STEP 4 — HUGO CONVERSION
# -----------------------------

Write-Host "`n[4/6] Hugo Conversion: Generating Markdown..." -ForegroundColor Yellow

try {
    & $HugoConvertScript -Input $TWStageDir -Output $HugoStageDir -Log $LogDir
    Write-Host "Hugo conversion complete." -ForegroundColor Green
}
catch {
    Write-Host "Hugo conversion failed: $_" -ForegroundColor Red
    exit
}

# -----------------------------
# STEP 5 — HUGO BUILD & LOCAL VALIDATION
# -----------------------------

Write-Host "`n[5/6] Hugo Build: Copying files + building site..." -ForegroundColor Yellow

# Copy generated Markdown into Hugo repo
Copy-Item -Path "$HugoStageDir\*" -Destination "$HugoDir\content\entries\poc" -Recurse -Force

# Build Hugo locally
try {
    Set-Location $HugoDir
    hugo -D
    Write-Host "Hugo build successful." -ForegroundColor Green
}
catch {
    Write-Host "Hugo build failed: $_" -ForegroundColor Red
    exit
}

# -----------------------------
# STEP 6 — GITHUB PUSH (Triggers Cloudflare Deploy)
# -----------------------------

Write-Host "`n[6/6] Deployment: Pushing to GitHub..." -ForegroundColor Yellow

try {
    Set-Location $RepoDir
    git add .
    git commit -m "PoC batch update: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push
    Write-Host "GitHub push complete. Cloudflare redeploy triggered." -ForegroundColor Green
}
catch {
    Write-Host "GitHub push failed: $_" -ForegroundColor Red
    exit
}

# -----------------------------
# DONE
# -----------------------------

Write-Host "`n=== Pipeline Complete ===" -ForegroundColor Cyan
Write-Host "All steps finished successfully." -ForegroundColor Green
