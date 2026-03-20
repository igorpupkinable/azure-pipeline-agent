Import-Module "$PSScriptRoot/../helpers/Common.Helpers.psm1"

Describe "Apt" {
    $packages = (Get-ToolsetContent).apt.cmd_packages + (Get-ToolsetContent).apt.vital_packages
    $testCases = $packages | ForEach-Object { @{ toolName = $_ } }

    It "<toolName> is available" -TestCases $testCases {
        switch ($toolName) {
            "acl"               { $toolName = "getfacl"; break }
            "libnss3-tools"     { $toolName = "certutil"; break }
            "binutils"          { $toolName = "strings"; break }
            "coreutils"         { $toolName = "tr"; break }
            "net-tools"         { $toolName = "netstat"; break }
            "findutils"         { $toolName = "find"; break }
            "systemd-coredump"  { $toolName = "coredumpctl"; break }
        }

        (Get-Command -Name $toolName).CommandType | Should -BeExactly "Application"
    }
}
