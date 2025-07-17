<#
.SYNOPSIS
    Checks guest user invite settings in Microsoft Entra ID.

.DESCRIPTION
    Checks to see if the guest user invite settings in Microsoft Entra ID are not set to everyone or adminsGuestInvitersAndAllMembers.
    https://learn.microsoft.com/en-us/graph/api/resources/authorizationpolicy?view=graph-rest-1.0&preserve-view=true#properties

.EXAMPLE
    Test-Er-Entra-GuestUserInvites

    Returns true if the guest user invite settings are not set to everyone or adminsGuestInvitersAndAllMembers.

#>
function Test-Er-Entra-GuestUserInvites {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (!(Test-MtConnection Graph)) {
        Add-MtTestResultDetail -SkippedBecause NotConnectedGraph
        return $null
    }

    try {
        Write-Verbose 'Obtaining guest user invite settings from Microsoft Entra ID'
        $guestSettings = Invoke-MtGraphRequest -RelativeUri 'policies/authorizationPolicy' -ApiVersion v1.0

        Write-Verbose 'Determining if guest user invite settings are not set to everyone or adminsGuestInvitersAndAllMembers'
        if ($guestSettings.allowInvitesFrom -eq 'everyone' -or $guestSettings.allowInvitesFrom -eq 'adminsGuestInvitersAndAllMembers') {
            $testResult = $false  # Guest user invite settings are set to most inclusive value
        } else {
            $testResult = $true  # Guest user invite settings are not set to most inclusive value
        }

        if ($testResult) {
            $testResultMarkdown = "Well done! Guest user invite settings are securely managed.`n`n%TestResult%"
        } else {
            $testResultMarkdown = "Your guest invite setting allows members and/or guest users to invite others into your tenant.`n`n%TestResult%"
        }

        $testResultMarkdown = $testResultMarkdown -replace '%TestResult%', $resultMd

        Add-MtTestResultDetail -Result $testResultMarkdown
        return $testResult
    } catch {
        Add-MtTestResultDetail -SkippedBecause Error -SkippedError $_
        return $null
    }
}