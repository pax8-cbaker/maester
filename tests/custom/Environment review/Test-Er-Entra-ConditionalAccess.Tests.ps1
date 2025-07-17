Describe "Environment Review" -Tag "Environment Review", "Entra ID", "Security" {
    It "ER.Entra.1.1.1: Enabled Conditional Access policies in the tenant" -Tag "Severity:High" {

        $result = Test-Er-Entra-ConditionalAccess

        if ($null -ne $result) {
            $result | Should -Be $true -Because "Conditional Access policies are enabled"
        }
    }
}