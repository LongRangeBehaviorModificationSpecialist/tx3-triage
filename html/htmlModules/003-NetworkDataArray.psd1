[ordered]@{

    "3-001_Win32_Network_Adapter_Config" = ("Win32 Network Adapter Configuration",
                                           "Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Select-Object Index, InterfaceIndex, Description, Caption, ServiceName, DatabasePath, DHCPEnabled, @{ N = 'IpAddress'; E = { $_.IpAddress -join '; ' } }, @{ N = 'DefaultIPgateway'; E = { $_.DefaultIPgateway -join '; ' } }, DNSDomain, DNSHostName, DNSDomainSuffixSearchOrder, CimClass | Out-String",
                                           "String")
    "3-002_Estab_Network_Connections"    = ("Established NetTCPConnection",
                                           "Get-NetTCPConnection -State Established | Format-List | Out-String",
                                           "String")
    "3-003_Netstat_Connections_Basic"    = ("netstat (Basic)",
                                           "netstat -nao | Out-String",
                                           "String")
    "3-004_Net_TCP_Connections_Txt"      = ("Net TCP Connection (Txt)",
                                           "Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, AppliedSetting, Status, CreationTime | Sort-Object LocalAddress -Descending | Out-String",
                                           "String")
    "3-005_Network_Adapter"              = ("Net Adapter",
                                           "Get-NetAdapter | Select-Object -Property * | Out-String",
                                           "String")
    "3-006_NetIP_Configuration"          = ("Net IP Configuration",
                                           "Get-NetIPConfiguration | Select-Object -Property * | Out-String",
                                           "String")
    "3-007_route_PRINT"                  = ("route Info",
                                           "route PRINT | Out-String",
                                           "String")
    "3-008_ipconfig_all"                 = ("ipconfig /all",
                                           "ipconfig /all | Out-String",
                                           "String")
    "3-009_Dns_Cache_Txt"                = ("ipconfig /displaydns",
                                           "ipconfig /displaydns | Out-String",
                                           "String")
    "3-010_NetNeighbor"                  = ("Net Neighbor",
                                           "Get-NetNeighbor | Select-Object -Property * | Sort-Object -Property IPAddress | Out-String",
                                           "String")
    "3-011_NetIP_Address"                = ("Net IP Address",
                                           "Get-NetIPAddress | Sort-Object -Property IPAddress | Out-String",
                                           "String")
    "3-012_Hosts_File"                   = ("hosts File",
                                           "Get-Content 'C:\Windows\system32\drivers\etc\hosts' -Raw",
                                           "String")
    "3-013_Networks_File"                = ("networks File",
                                           "Get-Content 'C:\Windows\system32\drivers\etc\networks' -Raw",
                                           "String")
    "3-014_Protocol_File"                = ("protocol File",
                                           "Get-Content 'C:\Windows\system32\drivers\etc\protocol' -Raw",
                                           "String")
    "3-015_Services_File"                = ("services File",
                                           "Get-Content 'C:\Windows\system32\drivers\etc\services' -Raw",
                                           "String")
    "3-016_Smb_Share"                    = ("SmbShare",
                                           "Get-SmbShare | Out-String",
                                           "String")
    "3-017_NetIP_Interface"              = ("Net IP Interface",
                                           "Get-NetIPInterface | Select-Object -Property * | Out-String",
                                           "String")
    "3-018_NetRoute_All"                 = ("Net Route",
                                           "Get-NetRoute | Select-Object -Property * | Out-String",
                                           "String")
    "3-019_Ip_Info"                      = ("IP Address",
                                           "powershell -nop irm ipinfo.io | Out-String",
                                           "String")
    "3-020_Ip_Info_Cont"                 = ("IP Address (2)",
                                           "nslookup myip.opendns.com resolver1.opendns.com",
                                           "String")
    "3-021_NetstatAndExeName"            = ("Netstat & Exe Name",
                                           "netstat -nabo | Out-String",
                                           "String")
}