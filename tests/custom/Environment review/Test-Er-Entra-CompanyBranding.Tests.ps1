Describe "Environment Review" -Tag "Environment Review", "Entra ID", "Security" {
    It "ER.Entra.1.0.2: Ensure company branding is configured" -Tag "Severity:Low" {

        $result = Test-Er-Entra-CompanyBranding

        if ($null -ne $result) {
            $result | Should -Be $true -Because "Company Branding is configured"
        }
    }
}