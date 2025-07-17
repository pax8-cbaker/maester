Describe "Environment Review" -Tag "Environment Review", "Entra ID", "Security" {
    It "ER.Entra.1.2.3: Ensure LAPS is enabled for Windows devices" -Tag "Severity:High" {

        $result = Test-Er-Entra-LAPS

        if ($null -ne $result) {
            $result | Should -Be $true -Because "LAPS is enabled for Windows devices"
        }
    }
}