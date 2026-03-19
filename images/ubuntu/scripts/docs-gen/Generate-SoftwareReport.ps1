using module ./software-report-base/SoftwareReport.psm1
using module ./software-report-base/SoftwareReport.Nodes.psm1

param (
    [Parameter(Mandatory)]
    [string] $OutputDirectory
)

$global:ErrorActionPreference = "Stop"
$global:ErrorView = "NormalView"
Set-StrictMode -Version Latest

Import-Module (Join-Path $PSScriptRoot "SoftwareReport.CachedTools.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Common.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Helpers.psm1") -DisableNameChecking
Import-Module "$PSScriptRoot/../helpers/Common.Helpers.psm1" -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Tools.psm1") -DisableNameChecking

# Restore file owner in user profile
sudo chown -R ${env:USER}: $env:HOME

# Software report
$softwareReport = [SoftwareReport]::new("Ubuntu $(Get-OSVersionShort)")
$softwareReport.Root.AddToolVersion("OS Version:", $(Get-OSVersionFull))
$softwareReport.Root.AddToolVersion("Kernel Version:", $(Get-KernelVersion))
$softwareReport.Root.AddToolVersion("Image Version:", $env:IMAGE_VERSION)
$softwareReport.Root.AddToolVersion("Systemd version:", $(Get-SystemdVersion))

$installedSoftware = $softwareReport.Root.AddHeader("Installed Software")

# Language and Runtime
$languageAndRuntime = $installedSoftware.AddHeader("Language and Runtime")
$languageAndRuntime.AddToolVersion("Bash", $(Get-BashVersion))
$languageAndRuntime.AddToolVersionsListInline("Clang", $(Get-ClangToolVersions -ToolName "clang"), "^\d+")
$languageAndRuntime.AddToolVersionsListInline("Clang-format", $(Get-ClangToolVersions -ToolName "clang-format"), "^\d+")
$languageAndRuntime.AddToolVersionsListInline("Clang-tidy", $(Get-ClangTidyVersions), "^\d+")
$languageAndRuntime.AddToolVersion("Dash", $(Get-DashVersion))
$languageAndRuntime.AddToolVersionsListInline("GNU C++", $(Get-CPPVersions), "^\d+")
if (-not $(Test-IsUbuntu24)) {
    $languageAndRuntime.AddToolVersion("Mono", $(Get-MonoVersion))
    $languageAndRuntime.AddToolVersion("MSBuild", $(Get-MsbuildVersion))
}
$languageAndRuntime.AddToolVersion("Node.js", $(Get-NodeVersion))
$languageAndRuntime.AddToolVersion("Perl", $(Get-PerlVersion))
$languageAndRuntime.AddToolVersion("Python", $(Get-PythonVersion))
$languageAndRuntime.AddToolVersion("Ruby", $(Get-RubyVersion))

# Package Management
$packageManagement = $installedSoftware.AddHeader("Package Management")
$packageManagement.AddToolVersion("cpan", $(Get-CpanVersion))
$packageManagement.AddToolVersion("Homebrew", $(Get-HomebrewVersion))
$packageManagement.AddToolVersion("Npm", $(Get-NpmVersion))
if (-not $(Test-IsUbuntu24)) {
    $packageManagement.AddToolVersion("NuGet", $(Get-NuGetVersion))
}
$packageManagement.AddToolVersion("Pip", $(Get-PipVersion))
$packageManagement.AddToolVersion("Pip3", $(Get-Pip3Version))
$packageManagement.AddToolVersion("Pipx", $(Get-PipxVersion))
$packageManagement.AddToolVersion("Vcpkg", $(Get-VcpkgVersion))
$packageManagement.AddToolVersion("Yarn", $(Get-YarnVersion))
$packageManagement.AddHeader("Environment variables").AddTable($(Build-PackageManagementEnvironmentTable))
$packageManagement.AddHeader("Homebrew note").AddNote(@'
Location: /home/linuxbrew
Note: Homebrew is pre-installed on image but not added to PATH.
run the eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" command
to accomplish this.
'@)

# Tools
$tools = $installedSoftware.AddHeader("Tools")
$tools.AddToolVersion("Ansible", $(Get-AnsibleVersion))
if (Test-IsUbuntu22) {
    $tools.AddToolVersion("apt-fast", $(Get-AptFastVersion))
}
$tools.AddToolVersion("AzCopy", $(Get-AzCopyVersion))
$tools.AddToolVersion("Bazel", $(Get-BazelVersion))
$tools.AddToolVersion("Bazelisk", $(Get-BazeliskVersion))
$tools.AddToolVersion("Bicep", $(Get-BicepVersion))
$tools.AddToolVersion("CMake", $(Get-CMakeVersion))
$tools.AddToolVersion("CodeQL Action Bundle", $(Get-CodeQLBundleVersion))
$tools.AddToolVersion("Docker Compose v2", $(Get-DockerComposeV2Version))
$tools.AddToolVersion("Docker-Buildx", $(Get-DockerBuildxVersion))
$tools.AddToolVersion("Docker Client", $(Get-DockerClientVersion))
$tools.AddToolVersion("Docker Server", $(Get-DockerServerVersion))
$tools.AddToolVersion("Git", $(Get-GitVersion))
$tools.AddToolVersion("Git LFS", $(Get-GitLFSVersion))
$tools.AddToolVersion("Git-ftp", $(Get-GitFTPVersion))
$tools.AddToolVersion("Haveged", $(Get-HavegedVersion))
$tools.AddToolVersion("jq", $(Get-JqVersion))
$tools.AddToolVersion("MediaInfo", $(Get-MediainfoVersion))
$tools.AddToolVersion("n", $(Get-NVersion))
$tools.AddToolVersion("Newman", $(Get-NewmanVersion))
$tools.AddToolVersion("nvm", $(Get-NvmVersion))
$tools.AddToolVersion("OpenSSL", $(Get-OpensslVersion))
$tools.AddToolVersion("Packer", $(Get-PackerVersion))
$tools.AddToolVersion("Parcel", $(Get-ParcelVersion))
$tools.AddToolVersion("Sphinx Open Source Search Server", $(Get-SphinxVersion))
$tools.AddToolVersion("yamllint", $(Get-YamllintVersion))
$tools.AddToolVersion("yq", $(Get-YqVersion))
$tools.AddToolVersion("zstd", $(Get-ZstdVersion))

# CLI Tools
$cliTools = $installedSoftware.AddHeader("CLI Tools")
$cliTools.AddToolVersion("Azure CLI", $(Get-AzureCliVersion))
$cliTools.AddToolVersion("Azure CLI (azure-devops)", $(Get-AzureDevopsVersion))
$cliTools.AddToolVersion("GitHub CLI", $(Get-GitHubCliVersion))

# .NET Tools
$netCoreTools = $installedSoftware.AddHeader(".NET Tools")
$netCoreTools.AddToolVersionsListInline(".NET Core SDK", $(Get-DotNetCoreSdkVersions), "^\d+\.\d+\.\d")
$netCoreTools.AddNodes($(Get-DotnetTools))

# Cached Tools
$cachedTools = $installedSoftware.AddHeader("Cached Tools")
$cachedTools.AddToolVersionsList("Go", $(Get-ToolcacheGoVersions), "^\d+\.\d+")
$cachedTools.AddToolVersionsList("Node.js", $(Get-ToolcacheNodeVersions), "^\d+")
$cachedTools.AddToolVersionsList("Python", $(Get-ToolcachePythonVersions), "^\d+\.\d+")
$cachedTools.AddToolVersionsList("PyPy", $(Get-ToolcachePyPyVersions), "^\d+\.\d+")
$cachedTools.AddToolVersionsList("Ruby", $(Get-ToolcacheRubyVersions), "^\d+\.\d+")


# PowerShell Tools
$powerShellTools = $installedSoftware.AddHeader("PowerShell Tools")
$powerShellTools.AddToolVersion("PowerShell", $(Get-PowershellVersion))
$powerShellTools.AddHeader("PowerShell Modules").AddNodes($(Get-PowerShellModules))

$installedSoftware.AddHeader("Installed apt packages").AddTable($(Get-AptPackages))

$softwareReport.ToJson() | Out-File -FilePath "${OutputDirectory}/software-report.json" -Encoding UTF8NoBOM
$softwareReport.ToMarkdown() | Out-File -FilePath "${OutputDirectory}/software-report.md" -Encoding UTF8NoBOM
