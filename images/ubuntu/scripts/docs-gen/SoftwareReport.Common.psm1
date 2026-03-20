function Get-BashVersion {
    $version = bash -c 'echo ${BASH_VERSION}'
    return $version
}

function Get-CPPVersions {
    $result = Get-CommandResult "apt list --installed" -Multiline
    $cppVersions = $result.Output | Where-Object { $_ -match "g\+\+-\d\d\/" } | ForEach-Object {
        & $_.Split("/")[0] --version | Select-Object -First 1 | Get-StringPart -Part 3
    } | Sort-Object {[Version] $_}
    return $cppVersions
}

function Get-OpensslVersion {
    $opensslVersion = $(dpkg-query -W -f '${Version}' openssl)
    return $opensslVersion
}

function Get-PerlVersion {
    $version = $(perl -e 'print substr($^V,1)')
    return $version
}

function Get-PowershellVersion {
    $pwshVersion = $(pwsh --version) | Get-StringPart -Part 1
    return $pwshVersion
}

function Get-GHCVersion {
    $(ghc --version) -match "version (?<version>\d+\.\d+\.\d+)" | Out-Null
    return $Matches.version
}

function Get-PowerShellModules {
    [Array] $result = @()

    [Array] $azureInstalledModules = Get-ChildItem -Path "/usr/share/az_*" -Directory | ForEach-Object { $_.Name.Split("_")[1] }
    if ($azureInstalledModules.Count -gt 0) {
        $result += [ToolVersionsListNode]::new("Az", $azureInstalledModules, "^\d+\.\d+", "Inline")
    }

    (Get-ToolsetContent).powershellModules.name | ForEach-Object {
        $moduleName = $_
        $moduleVersions = Get-Module -Name $moduleName -ListAvailable | Select-Object -ExpandProperty Version | Sort-Object -Unique
        $result += [ToolVersionsListNode]::new($moduleName, $moduleVersions, "^\d+", "Inline")
    }

    return $result
}

function Get-CachedDockerImages {
    $toolsetJson = Get-ToolsetContent
    $images = $toolsetJson.docker.images
    return $images
}

function Get-CachedDockerImagesTableData {
    $allImages = sudo docker images --digests --format "*{{.Repository}}:{{.Tag}}|{{.Digest}} |{{.CreatedAt}}"
    $allImages.Split("*") | Where-Object { $_ } | ForEach-Object {
        $parts = $_.Split("|")
        [PSCustomObject] @{
            "Repository:Tag" = $parts[0]
            "Digest"         = $parts[1]
            "Created"        = $parts[2].split(' ')[0]
        }
    } | Sort-Object -Property "Repository:Tag"
}

function Get-AptPackages {
    $apt = (Get-ToolsetContent).Apt
    $output = @()
    ForEach ($pkg in ($apt.vital_packages)) {
        $version = $(dpkg-query -W -f '${Version}' $pkg)
        if ($null -eq $version) {
            $version = $(dpkg-query -W -f '${Version}' "$pkg*")
        }

        $version = $version -replace '~','\~'

        $output += [PSCustomObject] @{
            Name    = $pkg
            Version = $version
        }
    }
    return ($output | Sort-Object Name)
}

function Get-SystemdVersion {
    $matchCollection = [regex]::Matches((systemctl --version | head -n 1), "\((.*?)\)")
    $result = foreach ($match in $matchCollection) {$match.Groups[1].Value}
    return $result
}
