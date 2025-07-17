Describe "Environment Review" -Tag "Environment Review", "Entra ID", "Security" {
    It "ER.Entra.1.2.5: Ensure guest invite settings are securely managed" -Tag "Severity:Medium" {

        $result = Test-Er-Entra-GuestUserInvites

        if ($null -ne $result) {
            $result | Should -Be $true -Because "Guest invite settings are securely managed"
        }
    }
}