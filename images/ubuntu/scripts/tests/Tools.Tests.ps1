Import-Module "$PSScriptRoot/../helpers/Common.Helpers.psm1"
Describe "azcopy" {
    It "azcopy" {
        "azcopy --version" | Should -ReturnZeroExitCode
    }

    It "azcopy10 link exists" {
        "azcopy10 --version" | Should -ReturnZeroExitCode
    }
}

Describe "Bicep" {
    It "Bicep" {
        "bicep --version" | Should -ReturnZeroExitCode
    }
}

Describe "Docker" {
    It "docker client" {
        $version=(Get-ToolsetContent).docker.components | Where-Object { $_.package -eq 'docker-ce-cli' } | Select-Object -ExpandProperty version
        If ($version -ne "latest") {
            $(sudo docker version --format '{{.Client.Version}}') | Should -BeLike "*$version*"
        }else{
            "sudo docker version --format '{{.Client.Version}}'" | Should -ReturnZeroExitCode
        }
    }

    It "docker server" {
        $version=(Get-ToolsetContent).docker.components | Where-Object { $_.package -eq 'docker-ce' } | Select-Object -ExpandProperty version
        If ($version -ne "latest") {
            $(sudo docker version --format '{{.Server.Version}}') | Should -BeLike "*$version*"
        }else{
            "sudo docker version --format '{{.Server.Version}}'" | Should -ReturnZeroExitCode
        }
    }

    It "docker client/server versions match" {
        $clientVersion = $(sudo docker version --format '{{.Client.Version}}')
        $serverVersion = $(sudo docker version --format '{{.Server.Version}}')
        $clientVersion | Should -Be $serverVersion
    }

    It "docker buildx" {
        $version=(Get-ToolsetContent).docker.plugins | Where-Object { $_.plugin -eq 'buildx' } | Select-Object -ExpandProperty version
        If ($version -ne "latest") {
            $(docker buildx version) | Should -BeLike "*$version*"
        }else{
            "docker buildx" | Should -ReturnZeroExitCode
        }
    }

    It "docker compose v2" {
        $version=(Get-ToolsetContent).docker.plugins | Where-Object { $_.plugin -eq 'compose' } | Select-Object -ExpandProperty version
        If ($version -ne "latest") {
            $(docker compose version --short) | Should -BeLike "*$version*"
        }else{
            "docker compose version --short" | Should -ReturnZeroExitCode
        }
    }
}

Describe "Bazel" {
    It "<ToolName>" -TestCases @(
        @{ ToolName = "bazel" }
        @{ ToolName = "bazelisk" }
    ) {
        "$ToolName --version"| Should -ReturnZeroExitCode
    }
}

Describe "clang" {
    $testCases = (Get-ToolsetContent).clang.Versions | ForEach-Object { @{ClangVersion = $_} }

    It "clang <ClangVersion>" -TestCases $testCases {
        "clang-$ClangVersion --version" | Should -ReturnZeroExitCode
        "clang++-$ClangVersion --version" | Should -ReturnZeroExitCode
        "clang-format-$ClangVersion --version" | Should -ReturnZeroExitCode
        "clang-tidy-$ClangVersion --version" | Should -ReturnZeroExitCode
        "run-clang-tidy-$ClangVersion --help" | Should -ReturnZeroExitCode
    }
}

Describe "Cmake" {
    It "cmake" {
        "cmake --version" | Should -ReturnZeroExitCode
    }
}

Describe "gcc" {
    $testCases = (Get-ToolsetContent).gcc.Versions | ForEach-Object { @{GccVersion = $_} }

    It "gcc <GccVersion>" -TestCases $testCases {
        "$GccVersion --version" | Should -ReturnZeroExitCode
    }
}

Describe "Mono" -Skip:(Test-IsUbuntu24) {
    It "mono" {
        "mono --version" | Should -ReturnZeroExitCode
    }

    It "msbuild" {
        "msbuild -version" | Should -ReturnZeroExitCode
    }

    It "nuget" {
        "nuget" | Should -ReturnZeroExitCode
    }
}

Describe "Zstd" {
    It "zstd" {
        "zstd --version" | Should -ReturnZeroExitCode
    }

    It "pzstd" {
        "pzstd --version" | Should -ReturnZeroExitCode
    }
}

Describe "Vcpkg" {
    It "vcpkg" {
        "vcpkg version" | Should -ReturnZeroExitCode
    }
}

Describe "Git" {
    It "git" {
        "git --version" | Should -ReturnZeroExitCode
    }

    It "git-ftp" {
        "git-ftp --version" | Should -ReturnZeroExitCode
    }
}

Describe "Git-lfs" {
    It "git-lfs" {
        "git-lfs --version" | Should -ReturnZeroExitCode
    }
}

Describe "Homebrew" {
    It "homebrew" {
        "/home/linuxbrew/.linuxbrew/bin/brew --version" | Should -ReturnZeroExitCode
    }
}

Describe "Conda" {
    It "conda" {
        "conda --version" | Should -ReturnZeroExitCode
    }
}

Describe "Packer" {
    It "packer" {
        "packer --version" | Should -ReturnZeroExitCode
    }
}

Describe "nvm" {
    It "nvm" {
        "source /etc/skel/.nvm/nvm.sh && nvm --version" | Should -ReturnZeroExitCode
    }
}

Describe "Python" {
    $testCases = @("python", "pip", "python3", "pip3") | ForEach-Object { @{PythonCommand = $_} }

    It "<PythonCommand>" -TestCases $testCases {
        "$PythonCommand --version" | Should -ReturnZeroExitCode
    }
}

Describe "Ruby" {
    $testCases = @("ruby", "gem") | ForEach-Object { @{RubyCommand = $_} }

    It "<RubyCommand>" -TestCases $testCases {
        "$RubyCommand --version" | Should -ReturnZeroExitCode
    }
}

Describe "yq" {
    It "yq" {
        "yq -V" | Should -ReturnZeroExitCode
    }
}
