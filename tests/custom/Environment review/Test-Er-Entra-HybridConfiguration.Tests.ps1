Describe "Environment Review" -Tag "Environment Review", "Entra ID", "Security" {
    It "ER.Entra.1.2.6: Check if tenant is cloud-only" -Tag "Severity:Low" {

        $result = Test-Er-Entra-HybridConfiguration

        if ($null -ne $result) {
            $result | Should -Be $true -Because "Tenant is cloud-only"
        }
    }
}