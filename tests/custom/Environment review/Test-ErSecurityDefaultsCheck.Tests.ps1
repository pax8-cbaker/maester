Describe "Environment Review" -Tag "Environment Review", "Entra ID", "Security" {
    It "ER 0.0.1: Check for security defaults" -Tag "Severity:Medium" {

        $result = Test-ErSecurityDefaultsCheck

        if ($null -ne $result) {
            $result | Should -Be $true -Because "Security defaults are enabled"
        }
    }
}