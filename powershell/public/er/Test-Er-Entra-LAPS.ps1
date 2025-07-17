<#
.SYNOPSIS
    Checks device settings in Microsoft Entra ID.

.DESCRIPTION
    Checks to see if LAPS is enabled for device settings in Microsoft Entra ID.

.EXAMPLE
    Test-Er-Entra-LAPS

    Returns true if LAPS is enabled for device settings.

#>
function Test-Er-Entra-LAPS {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (!(Test-MtConnection Graph)) {
        Add-MtTestResultDetail -SkippedBecause NotConnectedGraph
        return $null
    }

    try {
        Write-Verbose 'Getting device settings from Microsoft Entra ID'
        $deviceSettings = Invoke-MtGraphRequest -RelativeUri 'policies/deviceRegistrationPolicy?$select=localAdminPassword' -ApiVersion beta

        Write-Verbose 'Determining if LAPS is enabled'
        $testResult = $deviceSettings.localAdminPassword.isEnabled

        if ($testResult) {
            $testResultMarkdown = "LAPS is enabled for Windows devices.`n`n%TestResult%"
        } else {
            $testResultMarkdown = "Your tenant does not have LAPS enabled for Windows devices.`n`n%TestResult%"
        }

        $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $resultMd

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $testResult
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}