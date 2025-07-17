<#
.SYNOPSIS
    Checks guest user access settings in Microsoft Entra ID.

.DESCRIPTION
    Checks to see if the guest user access settings in Microsoft Entra ID are not set to most inclusive value.

.EXAMPLE
    Test-Er-Entra-GuestUserAccess

    Returns true if the guest user access settings are not set to most inclusive value.

#>
function Test-Er-Entra-GuestUserAccess {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (!(Test-MtConnection Graph)) {
        Add-MtTestResultDetail -SkippedBecause NotConnectedGraph
        return $null
    }

    try {
        Write-Verbose 'Obtaining guest user access settings from Microsoft Entra ID'
        $guestSettings = Invoke-MtGraphRequest -RelativeUri 'policies/authorizationPolicy' -ApiVersion v1.0

        Write-Verbose 'Determining if guest user access settings are not set to most inclusive value'
        if ($guestSettings.guestUserRoleId -eq 'a0b1b346-4d3e-4e8b-98f8-753987be4970') {
            $testResult = $false  # Guest user access settings are set to most inclusive value
        } else {
            $testResult = $true  # Guest user access settings are not set to most inclusive value
        }

        if ($testResult) {
            $testResultMarkdown = "Nice! Guest user access settings are not set to most inclusive value.`n`n%TestResult%"
        } else {
            $testResultMarkdown = "Your tenant allows guest users to have the same permissions as members.`n`n%TestResult%"
        }

        $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $resultMd

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $testResult
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}