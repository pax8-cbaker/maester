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
            $testResultMarkdown = "Well done. Your tenant has security defaults enabled:`n`n%TestResult%"
        } else {
            $testResultMarkdown = "Your tenant has security defaults disabled:`n`n%TestResult%"
        }
        $resultMd = "| Display Name | Group Public |`n"
        $resultMd += "| --- | --- |`n"
        foreach ($item in $result) {
            $itemCount += 1
            $itemResult = '❌ Fail'
            # We are restricting the table output to 50 below as it could be extremely large
            if ($itemCount -lt 51) {
                $resultMd += "| $($item.displayName) | $($itemResult) |`n"
            }
        }
        # Add a limited results message if more than 6 results are returned
        if ($itemCount -gt 50) {
            $resultMd += "Results limited to 50`n"
        }

        $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $resultMd

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $testResult
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}