[ordered]@{

    "3-001_Estab_Network_Connections"    = ("Established NetTCPConnection",
                                           "Get-NetTCPConnection -State Established | Format-List | Out-String",
                                           "String")
    "3-002_Netstat_Connections_Basic"    = ("netstat (Basic)",
                                           "netstat -nao | Out-String",
                                           "String")
    "3-003_Net_TCP_Connections_Txt"      = ("Net TCP Connection (Txt)",
                                           "Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, AppliedSetting, Status, CreationTime | Sort-Object LocalAddress -Descending | Out-String",
                                           "String")
    "3-004_Network_Adapter"              = ("Net Adapter",
                                           "Get-NetAdapter | Select-Object -Property * | Out-String",
                                           "String")
    "3-005_NetIP_Configuration"          = ("Net IP Configuration",
                                           "Get-NetIPConfiguration | Select-Object -Property * | Out-String",
                                           "String")
    "3-006_route_PRINT"                  = ("route Info",
                                           "route PRINT | Out-String",
                                           "String")
    "3-007_ipconfig_all"                 = ("ipconfig /all",
                                           "ipconfig /all | Out-String",
                                           "String")
    "3-008_Dns_Cache_Txt"                = ("ipconfig /displaydns",
                                           "ipconfig /displaydns | Out-String",
                                           "String")
    "3-009_NetNeighbor"                  = ("Net Neighbor",
                                           "Get-NetNeighbor | Select-Object -Property * | Sort-Object -Property IPAddress | Out-String",
                                           "String")
    "3-010_NetIP_Address"                = ("Net IP Address",
                                           "Get-NetIPAddress | Sort-Object -Property IPAddress | Out-String",
                                           "String")
    "3-011_Hosts_File"                   = ("hosts File",
                                           "Get-Content 'C:\Windows\system32\drivers\etc\hosts' -Raw",
                                           "String")
    "3-012_Networks_File"                = ("networks File",
                                           "Get-Content 'C:\Windows\system32\drivers\etc\networks' -Raw",
                                           "String")
    "3-013_Protocol_File"                = ("protocol File",
                                           "Get-Content 'C:\Windows\system32\drivers\etc\protocol' -Raw",
                                           "String")
    "3-014_Services_File"                = ("services File",
                                           "Get-Content 'C:\Windows\system32\drivers\etc\services' -Raw",
                                           "String")
    "3-015_Smb_Share"                    = ("SmbShare",
                                           "Get-SmbShare | Out-String",
                                           "String")
    "3-016_NetIP_Interface"              = ("Net IP Interface",
                                           "Get-NetIPInterface | Select-Object -Property * | Out-String",
                                           "String")
    "3-017_NetRoute_All"                 = ("Net Route",
                                           "Get-NetRoute | Select-Object -Property * | Out-String",
                                           "String")
    "3-018_Ip_Info"                      = ("IP Address",
                                           "powershell -nop irm ipinfo.io | Out-String",
                                           "String")
    "3-019_Ip_Info_Cont"                 = ("IP Address (2)",
                                           "nslookup myip.opendns.com resolver1.opendns.com",
                                           "String")
    "3-020_NetstatAndExeName"            = ("Netstat & Exe Name",
                                           "netstat -nabo | Out-String",
                                           "String")
}