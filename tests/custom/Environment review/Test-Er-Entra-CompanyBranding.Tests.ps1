Describe "Environment Review" -Tag "Environment Review", "Entra ID", "Security" {
    It "ER.Entra.1.2.1: Ensure company branding is configured" -Tag "Severity:Low" {

        $result = Test-Er-Entra-CompanyBranding

        if ($null -ne $result) {
            $result | Should -Be $true -Because "Company Branding is configured"
        }
    }
}