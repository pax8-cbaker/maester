Describe "Environment Review" -Tag "Environment Review", "Entra ID", "Security" {
    It "ER.Entra.1.0.1: Check for security defaults" -Tag "Severity:Medium" {

        $result = Test-Er-Entra-SecurityDefaultsCheck

        if ($null -ne $result) {
            $result | Should -Be $true -Because "Security defaults are enabled"
        }
    }
}