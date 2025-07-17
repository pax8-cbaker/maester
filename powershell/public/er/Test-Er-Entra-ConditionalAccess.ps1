<#
.SYNOPSIS
    Discovers Conditional Access policies in Microsoft Entra ID.

.DESCRIPTION
    Checks if there are any enabled Conditional Access policies in Microsoft Entra ID.

.EXAMPLE
    Test-Er-Entra-ConditionalAccess

    Returns true if there are any enabled Conditional Access policies.

#>
function Test-Er-Entra-ConditionalAccess {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (!(Test-MtConnection Graph)) {
        Add-MtTestResultDetail -SkippedBecause NotConnectedGraph
        return $null
    }

    try {
        Write-Verbose 'Getting Conditional Access policies'
        $conditionalAccessPolicies = Invoke-MtGraphRequest -RelativeUri 'policies/conditionalAccessPolicies' -ApiVersion v1.0

        Write-Verbose 'Determining if there are any enabled Conditional Access policies'
        $enabledPolicies = $conditionalAccessPolicies | Where-Object { $_.state -eq 'enabled' }
        $testResult = $enabledPolicies.Count -gt 0

        if ($testResult) {
            $testResultMarkdown = "Your tenant has enabled Conditional Access policies.`n`n%TestResult%"
        } else {
            $testResultMarkdown = "Your tenant does not have any enabled Conditional Access policies.`n`n%TestResult%"
        }

        $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $resultMd

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $testResult
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}