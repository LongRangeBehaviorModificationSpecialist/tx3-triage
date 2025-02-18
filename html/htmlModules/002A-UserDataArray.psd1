[ordered]@{

    "2-001_WhoAmI"                          = ("Who Am I",
                                              "whoami /ALL /FO LIST | Out-String",
                                              "String")
    "2-002_Win32_User_Profile"              = ("Win32_UserProfile",
                                              "Get-CimInstance -ClassName Win32_UserProfile | Select-Object -Property * | Out-String",
                                              "String")
    "2-003_Win32_User_Account"              = ("Win32_UserAccount",
                                              "Get-CimInstance -ClassName Win32_UserAccount | Select-Object -Property * | Out-String",
                                              "String")
    "2-004_Local_User_Data"                 = ("LocalUser",
                                              "Get-LocalUser | Format-List | Out-String",
                                              "String")
    "2-005_Win32_LogonSession"              = ("Win32_LogonSession",
                                              "Get-CimInstance -ClassName Win32_LogonSession | Select-Object -Property * | Out-String",
                                              "String")
    "2-006_Win_Event_Security_4624_or_4648" = ("Security Events (4624 or 4648)",
                                              "Get-WinEvent -LogName 'Security' -FilterXPath '*[System[EventID=4624 or EventID=4648]]' | Out-String",
                                              "String")
}