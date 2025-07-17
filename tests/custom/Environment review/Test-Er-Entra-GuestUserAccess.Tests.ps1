Describe "Environment Review" -Tag "Environment Review", "Entra ID", "Security" {
    It "ER.Entra.1.2.4: Ensure that guest user access is not same as members" -Tag "Severity:Medium" {

        $result = Test-Er-Entra-GuestUserAccess

        if ($null -ne $result) {
            $result | Should -Be $true -Because "Guest user access is not the same as members"
        }
    }
}