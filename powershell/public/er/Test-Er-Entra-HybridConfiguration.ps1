<#
.SYNOPSIS
    Checks for Entra ID hybrid configurations.

.DESCRIPTION
    Checks to see if the hybrid configurations in Microsoft Entra ID are set.

.EXAMPLE
    Test-Er-Entra-HybridConfiguration

    Returns false if Entra Connect/Entra Cloud Sync are configured.

#>
function Test-Er-Entra-HybridConfiguration {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (!(Test-MtConnection Graph)) {
        Add-MtTestResultDetail -SkippedBecause NotConnectedGraph
        return $null
    }

    try {
        Write-Verbose 'Obtaining hybrid configuration settings from Microsoft Entra ID'
        $hybridId = Invoke-MtGraphRequest -RelativeUri 'directory/onPremisesSynchronization' -ApiVersion v1.0
        $hybridSettings = Invoke-MtGraphRequest -RelativeUri "directory/onPremisesSynchronization/$($hybridId.id)/features" -ApiVersion v1.0
        $testResult = $true
        foreach ($setting in $hybridSettings.PSObject.Properties) {
            if ($setting.Name -ne '@odata.context' -and $setting.Value) {
                $testResult = $false
                break # Exit the loop if any setting is enabled
            }
        }

        if ($testResult) {
            $testResultMarkdown = "Your tenant is cloud-only. Nice job!`n`n%TestResult%"
        } else {
            $testResultMarkdown = "This tenant is hybrid.`n`n%TestResult%"
        }

        $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $resultMd

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $testResult
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}