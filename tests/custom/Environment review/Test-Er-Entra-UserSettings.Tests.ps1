Describe "Environment Review" -Tag "Environment Review", "Entra ID", "Security" {
    It "ER.Entra.1.2.2: Ensure user settings are not default" -Tag "Severity:Low" {

        $result = Test-Er-Entra-UserSettings

        if ($null -ne $result) {
            $result | Should -Be $true -Because "User settings are not set to default"
        }
    }
}