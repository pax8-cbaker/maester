<#
.SYNOPSIS
    Checks if security defaults are enabled

.DESCRIPTION
    Checks if security defaults are enabled in the tenant.

.EXAMPLE
    Test-ErSecurityDefaultsCheck

    Returns true if security defaults are enabled

#>
function Test-ErSecurityDefaultsCheck {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (!(Test-MtConnection Graph)) {
        Add-MtTestResultDetail -SkippedBecause NotConnectedGraph
        return $null
    }

    try {
        Write-Verbose 'Getting status of security defaults'
        $securityDefaults = Invoke-MtGraphRequest -RelativeUri 'policies/identitySecurityDefaultsEnforcementPolicy' -ApiVersion v1.0

        Write-Verbose 'Determining if security defaults are enabled'
        $testResult = $securityDefaults.isEnabled

        if ($testResult) {
            $testResultMarkdown = "Well done. Your tenant has security defaults enabled.`n`n%TestResult%"
        } else {
            $testResultMarkdown = "Your tenant has security defaults disabled.`n`n%TestResult%"
        }

        $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $resultMd

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $testResult
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}