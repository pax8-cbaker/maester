<#
.SYNOPSIS
    Checks if users can consent to applications in the tenant.

.DESCRIPTION
    Checks if users can consent to applications in the tenant.

.EXAMPLE
    Test-Er-Entra-AppConsent

    Returns true if users can not consent to applications.

#>
function Test-Er-Entra-AppConsent {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (!(Test-MtConnection Graph)) {
        Add-MtTestResultDetail -SkippedBecause NotConnectedGraph
        return $null
    }

    try {
        Write-Verbose 'Getting status of user app consent'
        $response = Invoke-MtGraphRequest -RelativeUri 'policies/authorizationPolicy?$select=defaultUserRolePermissions' -ApiVersion v1.0

        Write-Verbose 'Determining if user app consent is disabled'
        $testResult = $response.defaultUserRolePermissions.permissionGrantPoliciesAssigned -notcontains 'ManagePermissionGrantsForSelf.microsoft-user-default-legacy'

        if ($testResult) {
            $testResultMarkdown = "Well done. Your tenant is managing user app consent.`n`n%TestResult%"
        } else {
            $testResultMarkdown = "Your tenant does not restrict users from consenting to applications permissions.`n`n%TestResult%"
        }

        $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $resultMd

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $testResult
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}