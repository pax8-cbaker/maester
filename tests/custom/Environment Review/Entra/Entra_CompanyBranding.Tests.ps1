Describe "Entra" -Tag "Entra" {
    It "Entra: Check for Branding - Banner Logo" -Tag 'Severity:Low' {

        $result = (Get-MgOrganizationBranding -OrganizationId (Get-MgOrganization).Id).bannerlogoRelativeUrl

        if ($null -ne $result) {
            $result | Should -Be $true -Because "Branding logo has been applied."
        }
    }
}