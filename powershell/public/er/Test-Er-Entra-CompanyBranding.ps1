<#
.SYNOPSIS
    Checks if company branding is applied

.DESCRIPTION
    Checks if company branding is applied in the tenant.

.EXAMPLE
    Test-Er-Entra-CompanyBranding

    Returns true if any form of company branding is applied (logos, colors, etc.)

#>
function Test-Er-Entra-CompanyBranding {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (!(Test-MtConnection Graph)) {
        Add-MtTestResultDetail -SkippedBecause NotConnectedGraph
        return $null
    }

    try {
        Write-Verbose 'Getting status of company branding'
        $response = Invoke-MtGraphRequest -RelativeUri 'organization' -ApiVersion v1.0

        Write-Verbose 'Determining if branding is applied'
        $tenantId = $response.id
        $result = Invoke-MtGraphRequest -RelativeUri "organization/$tenantId/branding/localizations" -ApiVersion v1.0
        $testResult = $result.value.Count -gt 0 # If the array is empty(technically not null because empty arrays are still objects), then company branding is not applied

        if ($testResult) {
            $testResultMarkdown = "Well done. Your tenant has company branding applied.`n`n%TestResult%"
        } else {
            $testResultMarkdown = "Your tenant does not have company branding applied.`n`n%TestResult%"
        }

        $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $resultMd

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $testResult
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}