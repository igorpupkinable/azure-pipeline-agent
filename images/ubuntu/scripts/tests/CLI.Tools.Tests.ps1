Describe "Azure CLI" {
    It "Azure CLI" {
        "az --version" | Should -ReturnZeroExitCode
    }
}

Describe "Azure DevOps CLI" {
    It "az devops" {
        "az devops -h" | Should -ReturnZeroExitCode
    }
}

Describe "GitHub CLI" {
    It "gh cli" {
        "gh --version" | Should -ReturnZeroExitCode
    }
}

Describe "OC CLI" -Skip:((-not (Test-IsUbuntu22))) {
    It "OC CLI" {
        "oc version" | Should -ReturnZeroExitCode
    }
}
