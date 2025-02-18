[ordered]@{

    "8-001_FirewallRules"         = ("Net Firewall Rules",
                                    "Get-NetFirewallRule -all | Out-String",
                                    "String")
    "8-002_AdvancedFirewallRules" = ("Advanced Firewall Rules",
                                    "netsh advfirewall firewall show rule name=all verbose | Out-String",
                                    "String")
    "8-003_DefenderExclusions"    = ("Defender Exclusions",
                                    "Get-MpPreference | Out-String",
                                    "String")
}