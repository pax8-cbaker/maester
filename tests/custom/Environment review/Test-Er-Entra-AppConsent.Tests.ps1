Describe "Environment Review" -Tag "Environment Review", "Entra ID", "Security" {
    It "ER.Entra.1.0.3: Users restricted from consenting to applications" -Tag "Severity:High" {

        $result = Test-Er-Entra-AppConsent

        if ($null -ne $result) {
            $result | Should -Be $true -Because "User App Consent is disabled"
        }
    }
}