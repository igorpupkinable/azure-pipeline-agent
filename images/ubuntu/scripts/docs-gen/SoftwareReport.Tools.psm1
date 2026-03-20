function Get-AzCopyVersion {
    $azcopyVersion = [string]$(azcopy --version) | Get-StringPart -Part 2
    return "$azcopyVersion - available by ``azcopy`` and ``azcopy10`` aliases"
}

function Get-GitVersion {
    $gitVersion = git --version | Get-StringPart -Part -1
    return $gitVersion
}

function Get-GitLFSVersion {
    $result = Get-CommandResult "git-lfs --version"
    $gitlfsversion = $result.Output | Get-StringPart -Part 0 | Get-StringPart -Part 1 -Delimiter "/"
    return $gitlfsversion
}

function Get-JqVersion {
    $jqVersion = jq --version | Get-StringPart -Part 1 -Delimiter "-"
    return $jqVersion
}

function Get-AzureCliVersion {
    $azcliVersion = (az version | ConvertFrom-Json).'azure-cli'
    return $azcliVersion
}

function Get-AzureDevopsVersion {
    $azdevopsVersion = (az version | ConvertFrom-Json).extensions.'azure-devops'
    return $azdevopsVersion
}
