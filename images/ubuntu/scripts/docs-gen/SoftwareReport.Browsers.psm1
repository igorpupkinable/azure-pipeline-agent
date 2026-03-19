function Get-ChromeVersion {
    $googleChromeVersion = google-chrome --version | Get-StringPart -Part 2
    return $googleChromeVersion
}

function Get-ChromeDriverVersion {
    $chromeDriverVersion = chromedriver --version | Get-StringPart -Part 1
    return $chromeDriverVersion
}

function Get-FirefoxVersion {
    $firefoxVersion = $(firefox --version) | Get-StringPart -Part 2
    return $firefoxVersion
}

function Get-GeckodriverVersion {
    $geckodriverVersion = geckodriver --version | Select-Object -First 1 | Get-StringPart -Part 1
    return $geckodriverVersion
}

function Get-ChromiumVersion {
    $chromiumVersion = chromium-browser --version | Get-StringPart -Part 1
    return $chromiumVersion
}

function Get-EdgeVersion {
    $edgeVersion = (microsoft-edge --version).Trim() | Get-StringPart -Part 2
    return $edgeVersion
}

function Get-EdgeDriverVersion {
    $edgeDriverVersion = msedgedriver --version | Get-StringPart -Part 3
    return $edgeDriverVersion
}
