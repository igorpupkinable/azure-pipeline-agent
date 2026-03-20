################################################################################
##  File:  Install-Toolset.ps1
##  Team:  CI-Build
##  Desc:  Install toolset
################################################################################

Import-Module "$env:HELPER_SCRIPTS/../helpers/Common.Helpers.psm1"

function Install-Asset {
    param(
        [Parameter(Mandatory = $true)]
        [object] $ReleaseAsset
    )

    Write-Host "Download $($ReleaseAsset.filename)"
    $assetArchivePath = Invoke-DownloadWithRetry $ReleaseAsset.download_url

    Write-Host "Extract $($ReleaseAsset.filename) content..."
    $assetFolderPath = Join-Path "/tmp" "$($ReleaseAsset.filename)-temp-dir"
    New-Item -ItemType Directory -Path $assetFolderPath | Out-Null
    tar -xzf $assetArchivePath -C $assetFolderPath

    Write-Host "Invoke installation script..."
    Push-Location -Path $assetFolderPath
    Invoke-Expression "bash ./setup.sh"
    Pop-Location
}

$ErrorActionPreference = "Stop"
