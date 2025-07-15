Describe "Entra" -Tag "Entra" {
			
	It "Entra: Check if users can register applications (Failed = Yes)" -Tag 'Severity:Low' {
			$canRegisterApps = (Get-MgPolicyAuthorizationPolicy).DefaultUserRolePermissions.AllowedToCreateApps
			$canRegisterApps | Should -BeFalse -Because "Users are allowed to register applications."
		}
        
    }
