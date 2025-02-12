# Assigning variables to use in the script
$HtmlHeader = "<!DOCTYPE html>

<html lang='en' dir='ltr'>
    <head>
        <title>$($ComputerName) Triage Data</title>

        <meta charset='utf-8' />
        <meta name='viewport' content='width=device-width, initial-scale=1.0' />
        <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1' />

        <script src='https://unpkg.com/ionicons@5.1.2/dist/ionicons.js'></script>
        <link
          href='https://fonts.googleapis.com/css2?family=DM+Sans:wght@400; 500&display=swap'
          rel='stylesheet'
        />
        <link
          href='https://unpkg.com/ionicons@4.5.10-0/dist/css/ionicons.min.css'
          rel='stylesheet'
        />

        <link rel='stylesheet' type='text/css' href='..\..\css\allstyle.css' />

        <link rel='shortcut icon' type='img/png' href='..\..\images\page_icon.png' />

        <script>
            window.console = window.console || function (t) { };
        </script>

        <script>
            if (document.location.search.match(/type=embed/gi)) {
                window.parent.postMessage('resize', '*');
            }
        </script>

    </head>

    <body class='data_body' translate='no'>
"

$HtmlFooter = "
    </body>
</html>"


# Variable to ass the "Return to Top" link next to each header
$ReturnHtmlSnippet = "<a href='#top' class='top'>(Return to Top)</a>"


function Write-HtmlHomePage {

    [CmdletBinding()]

    param (
        [string]$FilePath
    )

    $ReportHomePage = "
<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Frameset//EN' 'http://www.w3.org/TR/html4/frameset.dtd'>

<html lang='en' dir='ltr'>

    <head>

        <title>Triage Report</title>

        <link
          rel='shortcut icon'
          type='img/png'
          href='..\images\page_icon.png'
        />

    </head>

    <frameset cols='20%,80%' frameborder='1' border='1' framespacing='1'>

        <frame name='menu' src='Resources\static\nav.html' marginheight='0' marginwidth='0' scrolling='no'>

        <frame name='content' src='Resources\static\main.html' marginheight='0' marginwidth='0' scrolling='auto'>

        <!-- <frame name='content' src='Resources\front.html' marginheight='0' marginwidth='0' scrolling='auto'> -->

        <noframes>

            <p>A browser that supports HTML frames is required to view this report.</p>

        </noframes>

    </frameset>

</html>"


    Add-Content -Path $FilePath -Value $ReportHomePage -Encoding UTF8
}


function Write-HtmlNavPage {

    [CmdletBinding()]

    param (
        [string]$FilePath
    )

    $NavReportPage = "<!DOCTYPE html>

<html lang='en' dir='ltr'>
    <head>
        <title>nav.html</title>

        <meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <meta http-equiv='X-UA-Compatible' content='ie-edge'>

        <link\
          href='https://fonts.googleapis.com/css?family=Roboto&display=swap'
          rel='stylesheet'
        />
        <link
          href='https://fonts.googleapis.com/css?family=Cinzel&display=swap'
          rel='stylesheet'
          type='text/css'
        />

        <link rel='stylesheet' type='text/css' href='..\css\allstyle.css' />

        <link
          rel='shortcut icon'
          type='img/png'
          href='..\images\page_icon.png'
        />

        <script>
            window.console = window.console || function (t) { };
        </script>

        <script>
            if (document.location.search.match(/type=embed/gi)) {
                window.parent.postMessage('resize', '*');
            }
        </script>

    </head>

    <body class='nav_background'>

        <div class='center'>
            <img src='../images/customLogo.png' class='nav_image' />
        </div>

        <div>

            <div class='heading'>Triage Report</div>

            <div class='report_section'>

                <a class='nav_list_item' href='.\front.html' target='_blank'>
                    Cover Page
                </a>

                <a class='nav_list_item' href='.\main.html' target='_blank'>
                    Main Page
                </a>

                <a class='nav_list_item' href='.\readme.html' target='_blank'>
                    Read Me First
                </a>

            </div>

            <div class='heading'>Category Reports</div>

            <div class='dropdown'>

                <button class='dropbtn'>Choose a Category</button>

                <div class='dropdown-content'>

                    <a href='../webpages/001_DeviceInfo.html' target='_blank'>Device Information</a>

                    <a href='../webpages/002_UserInfo.html' target='_blank'>User Data</a>

                    <a href='../webpages/003_NetworkInfo.html' target='_blank'>Network Information</a>

                    <a href='../webpages/004_ProcessInfo.html' target='_blank'>Processes Information</a>

                    <a href='../webpages/005_SystemInfo.html' target='_blank'>System Information</a>

                    <a href='../webpages/006_PrefetchInfo.html' target='_blank'>Prefetch File Data</a>

                    <a href='../webpages/007_EventLogInfo.html' target='_blank'>Event Log Data</a>

                    <a href='../webpages/008_FirewallInfo.html' target='_blank'>Firewall Data/Settings</a>

                    <a href='../webpages/009_BitLockerInfo.html' target='_blank'>BitLocker Data</a>

                    <a href='../webpages/010_FileKeywordMatches.html' target='_blank'>File Keyword Search Results</a>

                </div>

            </div>

        </div>

    </body>

</html>"


    Add-Content -Path $FilePath -Value $NavReportPage -Encoding UTF8
}


function Write-HtmlFrontPage {

    [CmdletBinding()]

    param (
        [string]$FilePath,
        [string]$User,
        [string]$Agency,
        [string]$CaseNumber,
        [string]$ComputerName,
        [string]$Ipv4,
        [string]$Ipv6
    )

    [datetime]$ReportGenTime = Get-Date -UFormat "%A %B %d, %Y %H:%M:%S %Z"
    # (Get-Date).ToString("dddd MM-dd-yyyy HH:mm:ss K")

    $FrontReportPage = "<!DOCTYPE html>

<html lang='en'>
    <head>
        <title>front.html</title>

        <meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <meta http-equiv='X-UA-Compatible' content='ie-edge'>

        <link
          href='https://fonts.googleapis.com/css?family=Roboto&display=swap'
          rel='stylesheet'
        />
        <link
          href='https://fonts.googleapis.com/css?family=Cinzel&display=swap'
          rel='stylesheet'
          type='text/css'
        />

        <link rel='stylesheet' type='text/css' href='..\css\allstyle.css' />

        <link
          rel='shortcut icon'
          type='img/png'
          href='..\images\page_icon.png'
        />

        <script>
            window.console = window.console || function (t) { };
        </script>

        <script>
            if (document.location.search.match(/type=embed/gi)) {
                window.parent.postMessage('resize', '*');
            }
        </script>

    </head>

    <body class='front_background'>
        <div class='case_info'>
            <h1 class='top_heading'>Triage Report</h1>

            <br>

            <table class='frontpage_table'>
                <tr>
                    <td class='case_info_details'>Examiner <strong>:</strong></td>
                    <td class='case_info_text'>$($User)</td>
                    <td></td>
                    <td class='case_info_details'>Agency Name<strong>:</strong></td>
                    <td class='case_info_text'>$($Agency)</td>
                </tr>

                <tr>
                    <td class='case_info_details'>Case Number<strong>:</strong></td>
                    <td class='case_info_text'>$($CaseNumber)</td>
                    <td></td>
                    <td class='case_info_details'>Report Generated <strong>:</strong></td>
                    <td class='case_info_text'>$($ReportGenTime) ET</td>
                </tr>

                <tr>
                    <td class='case_info_details'>Computer Name <strong>:</strong></td>
                    <td class='case_info_text'>$($ComputerName)</td>
                    <td></td>
                    <td class='case_info_details'>IPv4 Address <strong>:</strong></td>
                    <td class='case_info_text'>$($Ipv4)</td>
                </tr>

                <tr>
                    <td class='case_info_details'>IPv6 Address <strong>:</strong></td>
                    <td class='case_info_text'>$($Ipv6)</td>
                </tr>
             </table>
        </div>
    </body>
</html>"


    Add-Content -Path $FilePath -Value $FrontReportPage -Encoding UTF8
}


function Write-HtmlReadMePage {

    [CmdletBinding()]

    param (
        [string]$FilePath
    )

    $ReadMeReportPage = "<!DOCTYPE html>

<html lang='en' dir='ltr'>
    <head>
        <title>Read Me</title>

        <meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <meta http-equiv='X-UA-Compatible' content='ie-edge'>

        <link
          href='https://fonts.googleapis.com/css?family=Roboto&display=swap'
          rel='stylesheet'
        />
        <link
          href='https://fonts.googleapis.com/css?family=Cinzel&display=swap'
          rel='stylesheet'
          type='text/css'
        />

        <link rel='stylesheet' type='text/css' href='..\css\allstyle.css' />

        <link
          rel='shortcut icon'
          type='img/png'
          href='..\images\page_icon.png'
        />

        <script>
            window.console = window.console || function (t) { };
        </script>

        <script>
            if (document.location.search.match(/type=embed/gi)) {
                window.parent.postMessage('resize', '*');
            }
        </script>

    </head>

    <body class='readme_background'>

        <div class='case_info'>

            <div class='top_heading'>&mdash; WARNING &mdash;</div>

            <h3 class='first_line'>CRIMINAL REPORT PRODUCT</h3>
            <h3 class='second_line'>DIGITAL COPY</h3>

            <div class='number_list'>

                <ol type='1'>

                    <li>Enclosed is a digital copy of a criminal report by the High Tech Crimes Division (HTCD) of the Virginia State Police provided for investigator and prosecutor review.&ensp;Maintain security of this report and do not make copies.&ensp;Third party dissemination is strictly forbidden unless ordered by the Court.&ensp;The original case report is maintained by the examining agent.</li>

                    <br />

                    <li>This report should be viewed on a computer that is not connected to the Internet or other networks as certain files within this report when viewed may attempt to access online resources.</li>

                    <br />

                    <li>Any references to file dates and times that may be contained in this report are based upon the accuracy of the examined system when events occurred.&ensp;No representation can be made as to their accuracy at any other time than when noted during the examination.&ensp;Any prosecutorial decisions made regarding dates and times of evidentiary data should be discussed with the examiner beforehand.</li>

                    <br />

                    <li>This report may contain images, movies, descriptions and depictions that are of a sexual nature and may involve individuals who may be under the age of eighteen.&ensp;Such items may be considered contraband for which distribution is illegal.&ensp;The digital copy of the report has been designed to minimize local storage of items viewed within this report; however, accessing such images may cause local storage of these images.</li>

                    <br />

                    <li>It is strongly suggested that you consult with the examiner who prepared this report as you make further investigative and prosecutive decisions.&ensp;Often as the information in the report is processed, additional questions or avenues of investigation may need to be addressed and/or additional information may be available.</li>

                    <br />

                </ol>
            </div>
        </div>
    </body>
</html>"


    Add-Content -Path $FilePath -Value $ReadMeReportPage -Encoding UTF8
}


function Write-MainHtmlPage {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$FilePath,
        [Parameter(Mandatory, Position = 1)]
        [string]$User,
        [Parameter(Mandatory, Position = 2)]
        [string]$Agency,
        [Parameter(Mandatory, Position = 3)]
        [string]$CaseNumber,
        [Parameter(Mandatory, Position = 4)]
        [string]$ComputerName,
        [Parameter(Mandatory, Position = 5)]
        [string]$Ipv4,
        [Parameter(Mandatory, Position = 6)]
        [string]$Ipv6
    )

    [datetime]$ReportGenTime = Get-Date -UFormat "%A %B %d, %Y %H:%M:%S %Z"

    $MainReportPage = "<!DOCTYPE html>

<html lang='en' dir='ltr'>
    <head>
        <title>$($ComputerName) Triage Report</title>

        <meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0' />
        <meta http-equiv='X-UA-Compatible' content='IE-Edge,chrome=1' />

        <link
          href='https://fonts.googleapis.com/css?family=Roboto&display=swap'
          rel='stylesheet'
        />
        <link
          href='https://fonts.googleapis.com/css?family=Cinzel&display=swap'
          rel='stylesheet'
          type='text/css'
        />

        <link rel='stylesheet' type='text/css' href='Resources\css\allstyle.css' />

        <link
          rel='shortcut icon'
          type='img/png'
          href='Resources\images\page_icon.png'
        />

        <script>
            window.console = window.console || function (t) { };
        </script>

        <script>
            if (document.location.search.match(/type=embed/gi)) {
                window.parent.postMessage('resize', '*');
            }
        </script>
    </head>

    <body class='readme_background'>
        <div class='case_info'>
            <p class='top_heading'>Triage Report</p>

            <table class='frontpage_table'>
                <tr>
                    <td class='case_info_details'>Examiner <strong>:</strong></td>
                    <td class='case_info_text'>$($User)</td>

                    <td class='case_info_details'>Agency Name <strong>:</strong></td>
                    <td class='case_info_text'>$($Agency)</td>

                    <td class='case_info_details'>Case Number <strong>:</strong></td>
                    <td class='case_info_text'>$($CaseNumber)</td>
                </tr>

                <tr>
                    <td class='case_info_details'>Report Generated <strong>:</strong></td>
                    <td class='case_info_text'>$($ReportGenTime)</td>

                    <td class='case_info_details'>IPv6 Address <strong>:</strong></td>
                    <td class='case_info_text'>$($Ipv6)</td>

                    <td class='case_info_details'>IPv4 Address <strong>:</strong></td>
                    <td class='case_info_text'>$($Ipv4)</td>
                </tr>

                <tr>
                    <td class='case_info_details'>Computer Name <strong>:</strong></td>
                    <td class='case_info_text'>$($ComputerName)</td>
                </tr>
             </table>

            <table class='menuTable'>
                <tr>
                    <td class='menuItem'>
                        <a href='Resources\results\webpages\001_DeviceInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>Device Information</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='Resources\results\webpages\002_UserInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>User Data</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='Resources\results\webpages\003_NetworkInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>Network Information</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='Resources\results\webpages\004_ProcessInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>Processes Information</div>
                            </button>
                        </a>
                    </td>
                </tr>

                <tr>
                    <td class='menuItem'>
                        <a href='Resources\results\webpages\005_SystemInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>System Information</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='Resources\results\webpages\006_PrefetchInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>Prefetch File Data</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='Resources\results\webpages\007_EventLogInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>Event Log Data</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='Resources\results\webpages\008_FirewallInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>Firewall Data Settings</div>
                            </button>
                        </a>
                    </td>
                </tr>

                <tr>
                    <td class='menuItem'>
                        <a href='Resources\results\webpages\009_BitLockerInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>BitLocker Data</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='Resources\static\readme.html' target='_blank'>
                            <button class='btn btn-readme'>
                                <div class='btnText'>Read Me First</div>
                            </button>
                        </a>
                    </td>
                </tr>
            </table>
        </div>
    </body>
</html>"

    Add-Content -Path $FilePath -Value $MainReportPage -Encoding UTF8
}


$AllStyleCssEncodedText = "
LyogYWxsc3R5bGUuY3NzICovDQoNCiosICo6OmJlZm9yZSwgKjo6YWZ0ZXIgew0KICAgIGJveC1zaXppbmc6IGJvcmRlci1ib3g7DQogICAgbWFyZ2luOiAwOw0KICAgIHBhZGRpbmc6IDA7DQogICAgLXdlYmtpdC1mb250LXNtb290aGluZzogYW50aWFsaWFzZWQ7DQogICAgdGV4dC1yZW5kZXJpbmc6IG9wdGltaXplTGVnaWJpbGl0eTsNCn0NCg0KaHRtbCB7DQogICAgZm9udC1mYW1pbHk6ICdTZWdvZSBVSScsIEZydXRpZ2VyLCAnRnJ1dGlnZXIgTGlub3R5cGUnLCAnRGVqYXZ1IFNhbnMnLCAnSGVsdmV0aWNhIE5ldWUnLCBBcmlhbCwgc2Fucy1zZXJpZjsNCiAgICBmb250LXdlaWdodDogMzAwOw0KfQ0KDQpib2R5IHsNCiAgICBiYWNrZ3JvdW5kOiAjZmZmOw0KICAgIGZvbnQtc2l6ZTogMWVtOw0KICAgIGNvbG9yOiAjMTgxQjIwOw0KICAgIC0tZHJvcEJ0bkNvbG9yOiAjMUU4NDQ5Ow0KICAgIC0tbmF2QnRuUGFkZGluZzogMXB4IDBweCAxcHggMTBweDsNCiAgICAtLW5hdkJ0bkNvbG9ySG92ZXI6ICMyODc0QTY7DQogICAgLS1uYXZCdG5Ib3ZlclRleHRDb2xvcjogI0ZGRkZGRjsNCiAgICAtLW5hdkJ0bkhvdmVyQm9yZGVyOiAxcHggZGFzaGVkICNGRkZGRkY7DQogICAgLS1uYXZCdG5Ib3ZlclJhZGl1czogNXB4Ow0KICAgIC0tbmF2QnRuSGVpZ2h0OiAyLjI1ZW07DQogICAgLS1uYXZCdG5XaWR0aDogOTAlOw0KICAgIC0tbmF2QnRuRm9udEZhbWlseTogJ1JvYm90byBMaWdodCc7DQogICAgLS1uYXZCdG5Gb250U2l6ZTogMS4wNWVtOw0KICAgIG1hcmdpbjogMDsNCiAgICBwYWRkaW5nOiAwOw0KfQ0KDQphIHsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCnAgew0KICAgIHdoaXRlLXNwYWNlOiBwcmUtd3JhcDsNCn0NCg0KLmJvbGRfcmVkIHsNCiAgICBjb2xvcjogI0ZGOTEwMDsNCiAgICBmb250LXdlaWdodDogNzAwOw0KfQ0KDQouYnRuX2xhYmVsIHsNCiAgICBjb2xvcjogI0ZGRjsNCiAgICBmb250LXNpemU6IDEuMWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgbWFyZ2luLXRvcDogMC41ZW07DQp9DQoNCi5jZW50ZXIgew0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLnJpZ2h0IHsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCn0NCg0KLmZyb250X2JhY2tncm91bmQsDQoubmF2X2JhY2tncm91bmQsDQoucmVhZG1lX2JhY2tncm91bmQgew0KICAgIGJhY2tncm91bmQ6ICMyMjMxM2Y7DQogICAgY29sb3I6ICNEREQ7DQp9DQoNCi5uYXZfaW1hZ2Ugew0KICAgIGhlaWdodDogMTAwcHg7DQogICAgbWFyZ2luOiAyNHB4IDBweDsNCiAgICB3aWR0aDogMTAwcHg7DQp9DQoNCi5jYXNlX2luZm8gew0KICAgIGRpc3BsYXk6IGZsZXg7DQogICAgZmxleC1kaXJlY3Rpb246IGNvbHVtbjsNCiAgICBtYXJnaW46IDJlbSAyZW0gMWVtIDJlbTsNCiAgICBwYWRkaW5nLWJvdHRvbTogMWVtOw0KICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7DQogICAganVzdGlmeS1jb250ZW50OiBjZW50ZXI7DQogICAgY29sb3I6ICNEREQ7DQogICAgYm9yZGVyOiAxcHggZGFzaGVkICNEREQ7DQp9DQoNCi5jYXNlX2luZm9fZGV0YWlscyB7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KICAgIHBhZGRpbmc6IDAuM2VtIDAuNWVtIDAuM2VtIDBlbTsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCn0NCg0KLmNhc2VfaW5mb190ZXh0IHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMGVtIDAuM2VtIDAuNWVtOw0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KfQ0KDQoudG9wX2hlYWRpbmcgew0KICAgIGNvbG9yOiAjQ0I0MzM1Ow0KICAgIGZvbnQtc2l6ZTogMi40ZW07DQogICAgbWFyZ2luOiAwLjI1ZW0gMGVtIDAuMjVlbSAwZW07DQogICAgcGFkZGluZzogMDsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHRleHQtdHJhbnNmb3JtOiB1cHBlcmNhc2U7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQouZmlyc3RfbGluZSB7DQogICAgZm9udC1zaXplOiAxLjVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMXJlbSAwIDAuNXJlbSAwOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLnNlY29uZF9saW5lIHsNCiAgICBmb250LXNpemU6IDEuMzVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogLTAuMjVyZW0gMCAycmVtIDA7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KfQ0KDQoubnVtYmVyX2xpc3Qgew0KICAgIGZvbnQtZmFtaWx5OiBSb2JvdG87DQogICAgZm9udC1zaXplOiAxLjE1ZW07DQogICAgbGluZS1oZWlnaHQ6IDEuMzU7DQogICAgbWFyZ2luLWxlZnQ6IDEwJTsNCiAgICBtYXJnaW4tcmlnaHQ6IDEwJTsNCn0NCg0KLmhlYWRpbmcgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICNhYWE7DQogICAgY29sb3I6ICNDQjQzMzU7DQogICAgZm9udC1zaXplOiAxLjJlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMGVtIDAuMzVlbTsNCiAgICBtYXgtd2lkdGg6IGF1dG87DQogICAgcGFkZGluZzogNXB4IDBweCA1cHggMHB4Ow0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB0ZXh0LXRyYW5zZm9ybTogdXBwZXJjYXNlOw0KfQ0KDQoucmVwb3J0X3NlY3Rpb24gew0KICAgIGRpc3BsYXk6IGZsZXg7DQogICAgZmxleC1kaXJlY3Rpb246IGNvbHVtbjsNCiAgICBtYXgtd2lkdGg6IGF1dG87DQp9DQoNCi5uYXZfbGlzdF9pdGVtIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICBjb2xvcjogI0NCNDMzNTsNCiAgICBmb250LWZhbWlseTogdmFyKC0tbmF2QnRuRm9udEZhbWlseSk7DQogICAgZm9udC1zaXplOiB2YXIoLS1uYXZCdG5Gb250U2l6ZSk7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICBoZWlnaHQ6IHZhcigtLW5hdkJ0bkhlaWdodCk7DQogICAgbWFyZ2luOiAwLjE1ZW0gMC4zNWVtOw0KICAgIG1heC13aWR0aDogYXV0bzsNCiAgICBwYWRkaW5nOiA3cHggMHB4Ow0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KfQ0KDQoubmF2X2xpc3RfaXRlbTpob3ZlciB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzFmNjE4ZDsNCiAgICBjb2xvcjogI0RERDsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgZm9udC1zaXplOiB2YXIoLS1uYXZCdG5Gb250U2l6ZSk7DQogICAgZm9udC13ZWlnaHQ6IDYwMDsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCi5mcm9udHBhZ2VfdGFibGUgew0KICAgIGJvcmRlci1jb2xsYXBzZTogY29sbGFwc2U7DQogICAgY29sb3I6ICNEREQ7DQogICAgdGFibGUtbGF5b3V0OiBmaXhlZDsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLmNhc2VfaW5mb19kZXRhaWxzIHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMC41ZW0gMC4zZW0gMGVtOw0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KfQ0KDQouY2FzZV9pbmZvX3RleHQgew0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCiAgICBwYWRkaW5nOiAwLjNlbSAwZW0gMC4zZW0gMC41ZW07DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCn0NCg0KLyogRHJvcGRvd24gQnV0dG9uICovDQouZHJvcGJ0biB7DQogICAgYm9yZGVyOiBub25lOw0KICAgIGJhY2tncm91bmQtY29sb3I6IGRvZGdlcmJsdWU7DQogICAgY29sb3I6ICNlZGU7DQogICAgZm9udC1zaXplOiAxNnB4Ow0KICAgIHBhZGRpbmc6IDE2cHg7DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5kcm9wYnRuOmhvdmVyIHsNCiAgICBib3JkZXI6IDFweCBkYXNoZWQgI0RERDsNCiAgICBjb2xvcjogI0RERDsNCiAgICBmb250LXdlaWdodDogNDAwOw0KfQ0KDQovKiBUaGUgY29udGFpbmVyIDxkaXY+IC0gbmVlZGVkIHRvIHBvc2l0aW9uIHRoZSBkcm9wZG93biBjb250ZW50ICovDQouZHJvcGRvd24gew0KICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7DQogICAgZGlzcGxheTogaW5saW5lLWJsb2NrOw0KICAgIGp1c3RpZnktY29udGVudDogY2VudGVyOw0KICAgIG1hcmdpbjogMS43NWVtIDAuMzVlbSAwZW0gMC4zNWVtOw0KICAgIG1heC13aWR0aDogYXV0bzsNCiAgICBwb3NpdGlvbjogcmVsYXRpdmU7DQogICAgd2lkdGg6IDk2JTsNCn0NCg0KLyogRHJvcGRvd24gQ29udGVudCAoSGlkZGVuIGJ5IERlZmF1bHQpICovDQouZHJvcGRvd24tY29udGVudCB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogI2YxZjFmMTsNCiAgICBib3gtc2hhZG93OiAwcHggOHB4IDE2cHggMHB4IHJnYmEoMCwgMCwgMCwgMC4yKTsNCiAgICBkaXNwbGF5OiBub25lOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgaGVpZ2h0OiAxNWVtOw0KICAgIG1pbi13aWR0aDogMTYwcHg7DQogICAgb3ZlcmZsb3cteTogc2Nyb2xsOw0KICAgIHBvc2l0aW9uOiBhYnNvbHV0ZTsNCiAgICB3aWR0aDogMTAwJTsNCiAgICB6LWluZGV4OiAxOw0KfQ0KDQovKiBMaW5rcyBpbnNpZGUgdGhlIGRyb3Bkb3duICovDQouZHJvcGRvd24tY29udGVudCBhIHsNCiAgICBjb2xvcjogYmxhY2s7DQogICAgZGlzcGxheTogYmxvY2s7DQogICAgbWFyZ2luLWxlZnQ6IDNweDsNCiAgICBtYXJnaW4tcmlnaHQ6IDNweDsNCiAgICBwYWRkaW5nOiAxMnB4IDE2cHg7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KfQ0KDQovKiBDaGFuZ2UgY29sb3Igb2YgZHJvcGRvd24gbGlua3Mgb24gaG92ZXIgKi8NCi5kcm9wZG93bi1jb250ZW50IGE6aG92ZXIgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICM1NDk5Qzc7DQogICAgY29sb3I6ICNEREQ7DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCn0NCg0KLmRyb3Bkb3duLWNvbnRlbnQgYTphY3RpdmUgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICMwMDdCRkY7DQogICAgY29sb3I6ICNEREQ7DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCn0NCg0KLyogU2hvdyB0aGUgZHJvcGRvd24gbWVudSBvbiBob3ZlciAqLw0KLmRyb3Bkb3duOmhvdmVyIC5kcm9wZG93bi1jb250ZW50IHsNCiAgICBkaXNwbGF5OiBibG9jazsNCn0NCg0KLyogQ2hhbmdlIHRoZSBiYWNrZ3JvdW5kIGNvbG9yIG9mIHRoZSBkcm9wZG93biBidXR0b24gd2hlbiB0aGUgZHJvcGRvd24gY29udGVudCBpcyBzaG93biAqLw0KLmRyb3Bkb3duOmhvdmVyIC5kcm9wYnRuIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiBkb2RnZXJibHVlOw0KfQ0KDQouZGF0YV9ib2R5IHsNCiAgICBiYWNrZ3JvdW5kOiAjMjIzMTNmOw0KICAgIGNvbG9yOiAjREREOw0KICAgIG1hcmdpbi10b3A6IDJlbTsNCiAgICBtYXJnaW4tcmlnaHQ6IDUlOw0KICAgIG1hcmdpbi1ib3R0b206IDJlbTsNCiAgICBtYXJnaW4tbGVmdDogNSU7DQp9DQoNCi5pdGVtVGFibGUgew0KICAgIGFsaWduLWNvbnRlbnQ6IGNlbnRlcjsNCiAgICBhbGlnbi1pdGVtczogY2VudGVyOw0KICAgIGRpc3BsYXk6IGZsZXg7DQogICAgZmxleC1kaXJlY3Rpb246IHJvdzsNCiAgICBmbGV4LXdyYXA6IHdyYXA7DQogICAganVzdGlmeS1jb250ZW50OiBzcGFjZS1ldmVubHk7DQp9DQoNCg0KLyogU3R5bGUgdGhlIGJ1dHRvbiB0aGF0IGlzIHVzZWQgdG8gb3BlbiBhbmQgY2xvc2UgdGhlIGNvbGxhcHNpYmxlIGNvbnRlbnQgKi8NCi5jb2xsYXBzaWJsZSB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzc3NzsNCiAgICBib3JkZXI6IDRweCBzb2xpZCB0cmFuc3BhcmVudDsNCiAgICBib3JkZXItcmFkaXVzOiAwLjM3NWVtOw0KICAgIGNvbG9yOiAjREREOw0KICAgIGN1cnNvcjogcG9pbnRlcjsNCiAgICBmb250LXNpemU6IDAuOTVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMGVtOw0KICAgIG91dGxpbmU6IG5vbmU7DQogICAgcGFkZGluZzogMThweDsNCiAgICB0ZXh0LWFsaWduOiBsZWZ0Ow0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQovKiBBZGQgYSBiYWNrZ3JvdW5kIGNvbG9yIHRvIHRoZSBidXR0b24gaWYgaXQgaXMgY2xpY2tlZCBvbiAoYWRkIHRoZSAuYWN0aXZlIGNsYXNzIHdpdGggSlMpLCBhbmQgd2hlbiB5b3UgbW92ZSB0aGUgbW91c2Ugb3ZlciBpdCAoaG92ZXIpICovDQouY29sbGFwc2libGU6aG92ZXIgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICM3Nzc7DQogICAgYm9yZGVyOiA0cHggZGFzaGVkICNkYzM1NDU7DQogICAgY29sb3I6ICNEREQ7DQogICAgZm9udC1zaXplOiAwLjk1ZW07DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KfQ0KDQovKiAuYWN0aXZlLCAuY29sbGFwc2libGU6aG92ZXIgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICM3Nzc7DQogICAgYm9yZGVyOiA0cHggZGFzaGVkICMxZjYxOGQ7DQogICAgY29sb3I6ICNEREQ7DQogICAgZm9udC1zaXplOiAwLjk1ZW07DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KfSAqLw0KDQovKiAuY29sbGFwc2libGU6YWZ0ZXIgeyAqLw0KLyogVW5pY29kZSBjaGFyYWN0ZXIgZm9yICJwbHVzIiBzaWduICgrKSAqLw0KLyogY29udGVudDogJ1wwMDJCJzsNCiAgICBmb250LXNpemU6IDE2cHg7DQogICAgZm9udC13ZWlnaHQ6IGJvbGQ7DQogICAgY29sb3I6ICNEREQ7DQogICAgZmxvYXQ6IHJpZ2h0Ow0KICAgIG1hcmdpbi1sZWZ0OiA1cHg7DQp9ICovDQoNCi8qIC5hY3RpdmU6YWZ0ZXIgeyAqLw0KLyogVW5pY29kZSBjaGFyYWN0ZXIgZm9yICJtaW51cyIgc2lnbiAoLSkgKi8NCi8qIGNvbnRlbnQ6ICdcMjAxMyc7DQogICAgZm9udC1zaXplOiAxNnB4Ow0KICAgIGZvbnQtd2VpZ2h0OiBib2xkOw0KICAgIGNvbG9yOiAjREREOw0KfSAqLw0KDQovKiBTdHlsZSB0aGUgY29sbGFwc2libGUgY29udGVudC4gTm90ZTogaGlkZGVuIGJ5IGRlZmF1bHQgKi8NCi8qIC5jb250ZW50IHsNCiAgICBjb2xvcjogIzAwMDsNCiAgICBwYWRkaW5nOiAxLjVlbSAxLjI1ZW07DQogICAgZGlzcGxheTogbm9uZTsNCiAgICBvdmVyZmxvdzogaGlkZGVuOw0KICAgIGJhY2tncm91bmQtY29sb3I6ICNCQkI7DQp9DQoNCi5jb250ZW50IGEgew0KICAgIGNvbG9yOiAjMWY2MThkOw0KfSAqLw0KDQouYnRuIHsNCiAgICBoZWlnaHQ6IDEwMCU7DQogICAgd2lkdGg6IDEwMCU7DQogICAgLS1icy1idG4tcGFkZGluZy14OiAwLjc1cmVtOw0KICAgIC0tYnMtYnRuLXBhZGRpbmcteTogMC4zNzVyZW07DQogICAgLS1icy1idG4tZm9udC1mYW1pbHk6IDsNCiAgICAtLWJzLWJ0bi1mb250LXNpemU6IDFyZW07DQogICAgLS1icy1idG4tZm9udC13ZWlnaHQ6IDQwMDsNCiAgICAtLWJzLWJ0bi1saW5lLWhlaWdodDogMS41Ow0KICAgIC0tYnMtYnRuLWNvbG9yOiB2YXIoLS1icy1ib2R5LWNvbG9yKTsNCiAgICAtLWJzLWJ0bi1iZzogdHJhbnNwYXJlbnQ7DQogICAgLS1icy1idG4tYm9yZGVyLXdpZHRoOiAycHg7DQogICAgLS1icy1idG4tYm9yZGVyLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICAtLWJzLWJ0bi1ib3JkZXItcmFkaXVzOiAwLjM3NXJlbTsNCiAgICAtLWJzLWJ0bi1ob3Zlci1ib3JkZXItY29sb3I6IHRyYW5zcGFyZW50Ow0KICAgIC0tYnMtYnRuLWJveC1zaGFkb3c6IGluc2V0IDAgMXB4IDAgcmdiYSgyNTUsIDI1NSwgMjU1LCAwLjE1KSwgMCAxcHggMXB4IHJnYmEoMCwgMCwgMCwgMC4wNzUpOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLW9wYWNpdHk6IDAuNjU7DQogICAgLS1icy1idG4tZm9jdXMtYm94LXNoYWRvdzogMCAwIDAgMC4yNXJlbSByZ2JhKHZhcigtLWJzLWJ0bi1mb2N1cy1zaGFkb3ctcmdiKSwgLjUpOw0KICAgIGRpc3BsYXk6IGlubGluZS1ibG9jazsNCiAgICBwYWRkaW5nOiB2YXIoLS1icy1idG4tcGFkZGluZy15KSB2YXIoLS1icy1idG4tcGFkZGluZy14KTsNCiAgICBmb250LWZhbWlseTogdmFyKC0tYnMtYnRuLWZvbnQtZmFtaWx5KTsNCiAgICBmb250LXNpemU6IHZhcigtLWJzLWJ0bi1mb250LXNpemUpOw0KICAgIGZvbnQtd2VpZ2h0OiB2YXIoLS1icy1idG4tZm9udC13ZWlnaHQpOw0KICAgIGxpbmUtaGVpZ2h0OiB2YXIoLS1icy1idG4tbGluZS1oZWlnaHQpOw0KICAgIGNvbG9yOiB2YXIoLS1icy1idG4tY29sb3IpOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQogICAgdmVydGljYWwtYWxpZ246IG1pZGRsZTsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgLXdlYmtpdC11c2VyLXNlbGVjdDogbm9uZTsNCiAgICAtbW96LXVzZXItc2VsZWN0OiBub25lOw0KICAgIHVzZXItc2VsZWN0OiBub25lOw0KICAgIGJvcmRlcjogdmFyKC0tYnMtYnRuLWJvcmRlci13aWR0aCkgc29saWQgdmFyKC0tYnMtYnRuLWJvcmRlci1jb2xvcik7DQogICAgYm9yZGVyLXJhZGl1czogdmFyKC0tYnMtYnRuLWJvcmRlci1yYWRpdXMpOw0KICAgIGJhY2tncm91bmQtY29sb3I6IHZhcigtLWJzLWJ0bi1iZyk7DQogICAgdHJhbnNpdGlvbjogY29sb3IgMC4xNXMgZWFzZS1pbi1vdXQsIGJhY2tncm91bmQtY29sb3IgMC4xNXMgZWFzZS1pbi1vdXQsIGJvcmRlci1jb2xvciAwLjE1cyBlYXNlLWluLW91dCwgYm94LXNoYWRvdyAwLjE1cyBlYXNlLWluLW91dDsNCn0NCg0KLmJ0bi1wcmltYXJ5IHsNCiAgICAtLWJzLWJ0bi1jb2xvcjogI2ZmZjsNCiAgICAtLWJzLWJ0bi1iZzogIzBkNmVmZDsNCiAgICAtLWJzLWJ0bi1ib3JkZXItY29sb3I6ICMwZDZlZmQ7DQogICAgLS1icy1idG4taG92ZXItY29sb3I6ICNmZmY7DQogICAgLS1icy1idG4taG92ZXItYmc6ICMwYjVlZDc7DQogICAgLS1icy1idG4taG92ZXItYm9yZGVyLWNvbG9yOiAjMGE1OGNhOw0KICAgIC0tYnMtYnRuLWZvY3VzLXNoYWRvdy1yZ2I6IDQ5LCAxMzIsIDI1MzsNCiAgICAtLWJzLWJ0bi1hY3RpdmUtY29sb3I6ICNmZmY7DQogICAgLS1icy1idG4tYWN0aXZlLWJnOiAjMGE1OGNhOw0KICAgIC0tYnMtYnRuLWFjdGl2ZS1ib3JkZXItY29sb3I6ICMwYTUzYmU7DQogICAgLS1icy1idG4tYWN0aXZlLXNoYWRvdzogaW5zZXQgMCAzcHggNXB4IHJnYmEoMCwgMCwgMCwgMC4xMjUpOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLWNvbG9yOiAjZmZmOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLWJnOiAjMGQ2ZWZkOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLWJvcmRlci1jb2xvcjogIzBkNmVmZDsNCn0NCg0KLmJ0bi1yZWFkbWUgew0KICAgIGJhY2tncm91bmQ6ICNkYzM1NDU7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNkYzM1NDU7DQogICAgY29sb3I6ICNkZGQ7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCn0NCg0KLmJ0bi1yZWFkbWU6aG92ZXIgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICNiYjJkM2I7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNkZGQ7DQogICAgY29sb3I6ICNkZGQ7DQp9DQoNCi5idG4tcHJpbWFyeTpob3ZlciB7DQogICAgY29sb3I6IHZhcigtLWJzLWJ0bi1ob3Zlci1jb2xvcik7DQogICAgYmFja2dyb3VuZC1jb2xvcjogdmFyKC0tYnMtYnRuLWhvdmVyLWJnKTsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI0Y4RjhGODsNCn0NCg0KLmZpbGVfYnRuLA0KLml0ZW1fYnRuLA0KLm5vX2luZm9fYnRuIHsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgdHJhbnNwYXJlbnQ7DQogICAgYm9yZGVyLXJhZGl1czogMC4zNzVlbTsNCiAgICBjb2xvcjogI2NjYzsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgZm9udC1zaXplOiAwLjk1ZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IDAuNWVtIDBlbSAwLjVlbSAwZW07DQogICAgb3V0bGluZTogbm9uZTsNCiAgICBwYWRkaW5nOiAxLjI1ZW07DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCiAgICB3aWR0aDogYXV0bzsNCn0NCg0KLmZpbGVfYnRuIHsNCiAgICBiYWNrZ3JvdW5kOiAjMTk4NzU0Ow0KfQ0KDQouaXRlbV9idG4gew0KICAgIGJhY2tncm91bmQ6ICMwZDZlZmQ7DQp9DQoNCi5ub19pbmZvX2J0biB7DQogICAgYmFja2dyb3VuZDogIzZjNzU3ZDsNCn0NCg0KLmZpbGVfYnRuOmhvdmVyLA0KLml0ZW1fYnRuOmhvdmVyLA0KLm5vX2luZm9fYnRuOmhvdmVyIHsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI2NjYzsNCiAgICBmb250LXdlaWdodDogNjAwOw0KfQ0KDQouZmlsZV9idG46aG92ZXIgew0KICAgIGJhY2tncm91bmQ6ICMxNTczNDc7DQp9DQoNCi5pdGVtX2J0bjpob3ZlciB7DQogICAgYmFja2dyb3VuZDogIzBiNWVkNzsNCn0NCg0KLm5vX2luZm9fYnRuOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kOiAjNWM2MzZhOw0KfQ0KDQouZmlsZV9idG5fbGFiZWwsDQouaXRlbV9idG5fbGFiZWwgew0KICAgIGNvbG9yOiAjY2NjOw0KICAgIGZvbnQtc2l6ZTogMS4xZW07DQogICAgZm9udC13ZWlnaHQ6IG5vcm1hbDsNCiAgICBtYXJnaW4tdG9wOiAwLjVlbTsNCn0NCg0KLmZpbGVfYnRuX3RleHQsDQouaXRlbV9idG5fdGV4dCwNCi5ub19pbmZvX2J0bl90ZXh0IHsNCiAgICBjb2xvcjogI2Y4ZjhmODsNCiAgICBkaXNwbGF5OiBibG9jazsNCiAgICBtYXJnaW46IDBlbTsNCiAgICBwb3NpdGlvbjogcmVsYXRpdmU7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICBmb250LXNpemU6IDEuMWVtOw0KICAgIHdpZHRoOiBhdXRvOw0KfQ0KDQouYnRuVGV4dCB7DQogICAgY29sb3I6ICNmOGY4Zjg7DQogICAgZGlzcGxheTogaW5saW5lOw0KICAgIG1hcmdpbjogMHJlbSAxcmVtIDByZW0gMXJlbTsNCiAgICBwb3NpdGlvbjogcmVsYXRpdmU7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICBmb250LXNpemU6IDEuMjVyZW07DQogICAgd2lkdGg6IGF1dG87DQp9DQoNCi5idG5UZXh0OjphZnRlciB7DQogICAgYmFja2dyb3VuZDogI2Y4ZjhmODsNCiAgICBib3R0b206IC0ycHg7DQogICAgY29udGVudDogIiI7DQogICAgaGVpZ2h0OiAycHg7DQogICAgbGVmdDogMDsNCiAgICBwb3NpdGlvbjogYWJzb2x1dGU7DQogICAgdHJhbnNmb3JtOiBzY2FsZVgoMCk7DQogICAgdHJhbnNmb3JtLW9yaWdpbjogcmlnaHQ7DQogICAgdHJhbnNpdGlvbjogdHJhbnNmb3JtIDAuMnMgZWFzZS1pbjsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLm1lbnVJdGVtOmhvdmVyIC5idG5UZXh0OjphZnRlciB7DQogICAgdHJhbnNmb3JtOiBzY2FsZVgoMSk7DQogICAgdHJhbnNmb3JtLW9yaWdpbjogbGVmdDsNCn0NCg0KYnV0dG9uIHsNCiAgICB3aWR0aDogMTAwJTsNCiAgICBoZWlnaHQ6IDEwMCU7DQp9DQoNCnRhYmxlLA0KdHIsDQp0ZCB7DQogICAgYm9yZGVyOiAxcHggc29saWQgdHJhbnNwYXJlbnQ7DQogICAgYm9yZGVyLWNvbGxhcHNlOiBjb2xsYXBzZTsNCiAgICBoZWlnaHQ6IDEwMCU7DQp9DQoNCi5tZW51VGFibGUgew0KICAgIGJvcmRlci1jb2xsYXBzZTogc2VwYXJhdGU7DQogICAgYm9yZGVyLXNwYWNpbmc6IDFlbTsNCiAgICBtYXJnaW4tdG9wOiAxZW07DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5tZW51VGFibGUgYnV0dG9uIHsNCiAgICBib3JkZXI6IDFweCBzb2xpZCB0cmFuc3BhcmVudDsNCiAgICBwYWRkaW5nOiAycmVtOw0KICAgIHdpZHRoOiAxMDAlOw0KICAgIGhlaWdodDogMTAwJTsNCn0NCg0KLm1lbnVJdGVtIHsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgdHJhbnNwYXJlbnQ7DQogICAgd2lkdGg6IDIwJTsNCn0NCg0KDQpAcGFnZSB7DQogICAgc2l6ZTogQTQ7DQoNCiAgICBAYm90dG9tLWNlbnRlciB7DQogICAgICAgIGNvbnRlbnQ6ICJQYWdlICJjb3VudGVyKHBhZ2UpOw0KICAgIH0NCn0NCg0KQG1lZGlhIHByaW50IHsNCiAgICAubm8tcHJpbnQsIC5uby1wcmludCAqIHsNCiAgICAgICAgZGlzcGxheTogbm9uZTsNCiAgICB9DQoNCiAgICBodG1sLCBib2R5IHsNCiAgICAgICAgbWFyZ2luOiAwcmVtOw0KICAgICAgICBiYWNrZ3JvdW5kOiB0cmFuc3BhcmVudDsNCiAgICB9DQoNCiAgICAuZGF0YV9ib2R5IHsNCiAgICAgICAgYmFja2dyb3VuZC1jb2xvcjogdHJhbnNwYXJlbnQ7DQogICAgICAgIGNvbG9yOiAjMDAwOw0KICAgIH0NCn0=
"


Export-ModuleMember -Function Write-HtmlHomePage, Write-HtmlNavPage, Write-HtmlFrontPage, Write-HtmlReadMePage, Write-MainHtmlPage -Variable HtmlHeader, HtmlFooter, ReturnHtmlSnippet, AllStyleCssEncodedText
