<#
.SYNOPSIS
    Checks user settings in Microsoft Entra ID.

.DESCRIPTION
    Checks to see if the user settings in Microsoft Entra ID are not set to default values.

.EXAMPLE
    Test-Er-Entra-UserSettings

    Returns true if the user settings are not set to default values.

#>
function Test-Er-Entra-UserSettings {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (!(Test-MtConnection Graph)) {
        Add-MtTestResultDetail -SkippedBecause NotConnectedGraph
        return $null
    }

    try {
        Write-Verbose 'Getting users settings from Microsoft Entra ID'
        $userSettings = Invoke-MtGraphRequest -RelativeUri 'policies/authorizationPolicy' -ApiVersion v1.0

        Write-Verbose 'Comparing user settings to default values'
        if ($userSettings.defaultUserRolePermissions.allowedToCreateApps -eq $true -and
            $userSettings.defaultUserRolePermissions.allowedToCreateSecurityGroups -eq $true -and
            $userSettings.defaultUserRolePermissions.allowedToCreateTenants -eq $true) {
            $testResult = $false  # User settings are set to default
        } else {
            $testResult = $true  # User settings are not set to default
        }

        if ($testResult) {
            $testResultMarkdown = "Default user settings are not set to default values.`n`n%TestResult%"
        } else {
            $testResultMarkdown = "Your tenant has the default user settings.`n`n%TestResult%"
        }

        $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $resultMd

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $testResult
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}