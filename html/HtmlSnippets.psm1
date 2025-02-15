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

        <link rel='stylesheet' type='text/css' href='..\..\..\Resources\css\allstyle.css' />

        <link rel='shortcut icon' type='img/png' href='..\..\..\Resources\images\page_icon.png' />

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
        [string]$Ipv6,
        [string]$Sec1_001
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
                        <a href='Resources\static\readme.html' target='_blank'>
                            <button class='btn btn-readme'>
                                <div class='btnText'>Read Me First</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='results\webpages\001_DeviceInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>Device Information</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='results\webpages\002_UserInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>User Data</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='results\webpages\003_NetworkInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>Network Information</div>
                            </button>
                        </a>
                    </td>
                </tr>

                <tr>
                    <td class='menuItem'>
                        <a href='results\webpages\004_ProcessInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>Processes Information</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='results\webpages\005_SystemInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>System Information</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='results\webpages\006_PrefetchInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>Prefetch File Data</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='results\webpages\007_EventLogInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>Event Log Data</div>
                            </button>
                        </a>
                    </td>
                </tr>

                <tr>
                    <td class='menuItem'>
                        <a href='results\webpages\008_FirewallInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>Firewall Data Settings</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='results\webpages\009_BitLockerInfo.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>BitLocker Data</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='results\webpages\010_FileKeywordMatches.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>Keywork File Matches</div>
                            </button>
                        </a>
                    </td>

                    <td class='menuItem'>
                        <a href='results\webpages\011_OtherData.html' target='_blank'>
                            <button class='btn btn-primary'>
                                <div class='btnText'>Other Data</div>
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
LyogYWxsc3R5bGUuY3NzICovDQoNCiosICo6OmJlZm9yZSwgKjo6YWZ0ZXIgew0KICAgIGJveC1zaXppbmc6IGJvcmRlci1ib3g7DQogICAgbWFyZ2luOiAwOw0KICAgIHBhZGRpbmc6IDA7DQogICAgLXdlYmtpdC1mb250LXNtb290aGluZzogYW50aWFsaWFzZWQ7DQogICAgdGV4dC1yZW5kZXJpbmc6IG9wdGltaXplTGVnaWJpbGl0eTsNCn0NCg0KaHRtbCB7DQogICAgZm9udC1mYW1pbHk6ICdTZWdvZSBVSScsIEZydXRpZ2VyLCAnRnJ1dGlnZXIgTGlub3R5cGUnLCAnRGVqYXZ1IFNhbnMnLCAnSGVsdmV0aWNhIE5ldWUnLCBBcmlhbCwgc2Fucy1zZXJpZjsNCiAgICBmb250LXdlaWdodDogMzAwOw0KfQ0KDQpib2R5IHsNCiAgICBiYWNrZ3JvdW5kOiAjZmZmOw0KICAgIGZvbnQtc2l6ZTogMWVtOw0KICAgIGNvbG9yOiAjMTgxQjIwOw0KICAgIC0tZHJvcEJ0bkNvbG9yOiAjMUU4NDQ5Ow0KICAgIC0tbmF2QnRuUGFkZGluZzogMXB4IDBweCAxcHggMTBweDsNCiAgICAtLW5hdkJ0bkNvbG9ySG92ZXI6ICMyODc0QTY7DQogICAgLS1uYXZCdG5Ib3ZlclRleHRDb2xvcjogI0ZGRkZGRjsNCiAgICAtLW5hdkJ0bkhvdmVyQm9yZGVyOiAxcHggZGFzaGVkICNGRkZGRkY7DQogICAgLS1uYXZCdG5Ib3ZlclJhZGl1czogNXB4Ow0KICAgIC0tbmF2QnRuSGVpZ2h0OiAyLjI1ZW07DQogICAgLS1uYXZCdG5XaWR0aDogOTAlOw0KICAgIC0tbmF2QnRuRm9udEZhbWlseTogJ1JvYm90byBMaWdodCc7DQogICAgLS1uYXZCdG5Gb250U2l6ZTogMS4wNWVtOw0KICAgIG1hcmdpbjogMDsNCiAgICBwYWRkaW5nOiAwOw0KfQ0KDQphIHsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCnAgew0KICAgIHdoaXRlLXNwYWNlOiBwcmUtd3JhcDsNCn0NCg0KLmJvbGRfcmVkIHsNCiAgICBjb2xvcjogI0ZGOTEwMDsNCiAgICBmb250LXdlaWdodDogNzAwOw0KfQ0KDQouYnRuX2xhYmVsIHsNCiAgICBjb2xvcjogI0ZGRjsNCiAgICBmb250LXNpemU6IDEuMWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgbWFyZ2luLXRvcDogMC41ZW07DQp9DQoNCi5jZW50ZXIgew0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLnJpZ2h0IHsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCn0NCg0KLmZyb250X2JhY2tncm91bmQsDQoubmF2X2JhY2tncm91bmQsDQoucmVhZG1lX2JhY2tncm91bmQgew0KICAgIC8qIGJhY2tncm91bmQ6ICMyMjMxM2Y7ICovDQogICAgYmFja2dyb3VuZDogIzIyMjsNCiAgICBjb2xvcjogI0RERDsNCn0NCg0KLm5hdl9pbWFnZSB7DQogICAgaGVpZ2h0OiAxMDBweDsNCiAgICBtYXJnaW46IDI0cHggMHB4Ow0KICAgIHdpZHRoOiAxMDBweDsNCn0NCg0KLm1haW4gew0KICAgIG1hcmdpbjogMmVtIDJlbSAxZW0gMmVtOw0KDQp9DQoNCi5zZWN0aW9uX2hlYWRlciB7DQogICAgZm9udC1zaXplOiAwLjllbTsNCiAgICBtYXJnaW46IDFlbSAwZW07DQp9DQoNCi5jYXNlX2luZm8gew0KICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNEREQ7DQogICAgY29sb3I6ICNEREQ7DQogICAgZGlzcGxheTogZmxleDsNCiAgICBmbGV4LWRpcmVjdGlvbjogY29sdW1uOw0KICAgIGp1c3RpZnktY29udGVudDogY2VudGVyOw0KICAgIG1hcmdpbi1ib3R0b206IDFlbTsNCiAgICBwYWRkaW5nLWJvdHRvbTogMWVtOw0KfQ0KDQouaXRlbV90YWJsZSB7DQogICAgYWxpZ24tY29udGVudDogY2VudGVyOw0KICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNEREQ7DQogICAgZGlzcGxheTogZmxleDsNCiAgICBmbGV4LWRpcmVjdGlvbjogcm93Ow0KICAgIGZsZXgtd3JhcDogd3JhcDsNCiAgICBqdXN0aWZ5LWNvbnRlbnQ6IHNwYWNlLWV2ZW5seTsNCiAgICBwYWRkaW5nOiAwLjc1ZW07DQp9DQoNCi5jYXNlX2luZm9fZGV0YWlscyB7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KICAgIHBhZGRpbmc6IDAuM2VtIDAuNWVtIDAuM2VtIDBlbTsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCn0NCg0KLmNhc2VfaW5mb190ZXh0IHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMGVtIDAuM2VtIDAuNWVtOw0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KfQ0KDQoudG9wX2hlYWRpbmcgew0KICAgIGNvbG9yOiAjQ0I0MzM1Ow0KICAgIGZvbnQtc2l6ZTogMi40ZW07DQogICAgbWFyZ2luOiAwLjI1ZW0gMGVtIDAuMjVlbSAwZW07DQogICAgcGFkZGluZzogMDsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHRleHQtdHJhbnNmb3JtOiB1cHBlcmNhc2U7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQouZmlyc3RfbGluZSB7DQogICAgZm9udC1zaXplOiAxLjVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMXJlbSAwIDAuNXJlbSAwOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLnNlY29uZF9saW5lIHsNCiAgICBmb250LXNpemU6IDEuMzVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogLTAuMjVyZW0gMCAycmVtIDA7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KfQ0KDQoubnVtYmVyX2xpc3Qgew0KICAgIGZvbnQtZmFtaWx5OiBSb2JvdG87DQogICAgZm9udC1zaXplOiAwLjllbTsNCiAgICBtYXJnaW4tbGVmdDogMWVtOw0KfQ0KDQoubnVtYmVyX2xpc3QgYSB7DQogICAgY29sb3I6IGRvZGdlcmJsdWU7DQogICAgZGlzcGxheTogYmxvY2s7DQogICAgcGFkZGluZy1ib3R0b206IDAuNWVtOw0KfQ0KDQoubnVtYmVyX2xpc3QgYTpob3ZlciB7DQogICAgYmFja2dyb3VuZDogIzQ0NDsNCiAgICBib3JkZXI6IDFweCBkYXNoZWQgd2hpdGU7DQp9DQoNCi5oZWFkaW5nIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjYWFhOw0KICAgIGNvbG9yOiAjQ0I0MzM1Ow0KICAgIGZvbnQtc2l6ZTogMS4yZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IDBlbSAwLjM1ZW07DQogICAgbWF4LXdpZHRoOiBhdXRvOw0KICAgIHBhZGRpbmc6IDVweCAwcHggNXB4IDBweDsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsNCn0NCg0KLnJlcG9ydF9zZWN0aW9uIHsNCiAgICBkaXNwbGF5OiBmbGV4Ow0KICAgIGZsZXgtZGlyZWN0aW9uOiBjb2x1bW47DQogICAgbWF4LXdpZHRoOiBhdXRvOw0KfQ0KDQoubmF2X2xpc3RfaXRlbSB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogdHJhbnNwYXJlbnQ7DQogICAgY29sb3I6ICNDQjQzMzU7DQogICAgZm9udC1mYW1pbHk6IHZhcigtLW5hdkJ0bkZvbnRGYW1pbHkpOw0KICAgIGZvbnQtc2l6ZTogdmFyKC0tbmF2QnRuRm9udFNpemUpOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgaGVpZ2h0OiB2YXIoLS1uYXZCdG5IZWlnaHQpOw0KICAgIG1hcmdpbjogMC4xNWVtIDAuMzVlbTsNCiAgICBtYXgtd2lkdGg6IGF1dG87DQogICAgcGFkZGluZzogN3B4IDBweDsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCn0NCg0KLm5hdl9saXN0X2l0ZW06aG92ZXIgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICMxZjYxOGQ7DQogICAgY29sb3I6ICNEREQ7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIGZvbnQtc2l6ZTogdmFyKC0tbmF2QnRuRm9udFNpemUpOw0KICAgIGZvbnQtd2VpZ2h0OiA2MDA7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KfQ0KDQouZnJvbnRwYWdlX3RhYmxlIHsNCiAgICBib3JkZXItY29sbGFwc2U6IGNvbGxhcHNlOw0KICAgIGNvbG9yOiAjREREOw0KICAgIHRhYmxlLWxheW91dDogZml4ZWQ7DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5jYXNlX2luZm9fZGV0YWlscyB7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KICAgIHBhZGRpbmc6IDAuM2VtIDAuNWVtIDAuM2VtIDBlbTsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCn0NCg0KLmNhc2VfaW5mb190ZXh0IHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMGVtIDAuM2VtIDAuNWVtOw0KICAgIHRleHQtYWxpZ246IGxlZnQ7DQp9DQoNCi5kYXRhX2JvZHkgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICMyMjI7DQogICAgY29sb3I6ICNEREQ7DQogICAgbWFyZ2luLXRvcDogMmVtOw0KICAgIG1hcmdpbi1yaWdodDogNSU7DQogICAgbWFyZ2luLWJvdHRvbTogMmVtOw0KICAgIG1hcmdpbi1sZWZ0OiA1JTsNCn0NCg0KLyogU3R5bGUgdGhlIGJ1dHRvbiB0aGF0IGlzIHVzZWQgdG8gb3BlbiBhbmQgY2xvc2UgdGhlIGNvbGxhcHNpYmxlIGNvbnRlbnQgKi8NCi5jb2xsYXBzaWJsZSB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzc3NzsNCiAgICBib3JkZXI6IDRweCBzb2xpZCB0cmFuc3BhcmVudDsNCiAgICBib3JkZXItcmFkaXVzOiAwLjM3NWVtOw0KICAgIGNvbG9yOiAjREREOw0KICAgIGN1cnNvcjogcG9pbnRlcjsNCiAgICBmb250LXNpemU6IDAuOTVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMGVtOw0KICAgIG91dGxpbmU6IG5vbmU7DQogICAgcGFkZGluZzogMThweDsNCiAgICB0ZXh0LWFsaWduOiBsZWZ0Ow0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQovKiBBZGQgYSBiYWNrZ3JvdW5kIGNvbG9yIHRvIHRoZSBidXR0b24gaWYgaXQgaXMgY2xpY2tlZCBvbiAoYWRkIHRoZSAuYWN0aXZlIGNsYXNzIHdpdGggSlMpLCBhbmQgd2hlbiB5b3UgbW92ZSB0aGUgbW91c2Ugb3ZlciBpdCAoaG92ZXIpICovDQouY29sbGFwc2libGU6aG92ZXIgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICM3Nzc7DQogICAgYm9yZGVyOiA0cHggZGFzaGVkICNkYzM1NDU7DQogICAgY29sb3I6ICNEREQ7DQogICAgZm9udC1zaXplOiAwLjk1ZW07DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KfQ0KDQouYnRuIHsNCiAgICBoZWlnaHQ6IDEwMCU7DQogICAgd2lkdGg6IDEwMCU7DQogICAgLS1icy1idG4tcGFkZGluZy14OiAwLjc1cmVtOw0KICAgIC0tYnMtYnRuLXBhZGRpbmcteTogMC4zNzVyZW07DQogICAgLS1icy1idG4tZm9udC1mYW1pbHk6IDsNCiAgICAtLWJzLWJ0bi1mb250LXNpemU6IDFyZW07DQogICAgLS1icy1idG4tZm9udC13ZWlnaHQ6IDQwMDsNCiAgICAtLWJzLWJ0bi1saW5lLWhlaWdodDogMS41Ow0KICAgIC0tYnMtYnRuLWNvbG9yOiB2YXIoLS1icy1ib2R5LWNvbG9yKTsNCiAgICAtLWJzLWJ0bi1iZzogdHJhbnNwYXJlbnQ7DQogICAgLS1icy1idG4tYm9yZGVyLXdpZHRoOiAycHg7DQogICAgLS1icy1idG4tYm9yZGVyLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICAtLWJzLWJ0bi1ib3JkZXItcmFkaXVzOiAwLjM3NXJlbTsNCiAgICAtLWJzLWJ0bi1ob3Zlci1ib3JkZXItY29sb3I6IHRyYW5zcGFyZW50Ow0KICAgIC0tYnMtYnRuLWJveC1zaGFkb3c6IGluc2V0IDAgMXB4IDAgcmdiYSgyNTUsIDI1NSwgMjU1LCAwLjE1KSwgMCAxcHggMXB4IHJnYmEoMCwgMCwgMCwgMC4wNzUpOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLW9wYWNpdHk6IDAuNjU7DQogICAgLS1icy1idG4tZm9jdXMtYm94LXNoYWRvdzogMCAwIDAgMC4yNXJlbSByZ2JhKHZhcigtLWJzLWJ0bi1mb2N1cy1zaGFkb3ctcmdiKSwgLjUpOw0KICAgIGRpc3BsYXk6IGlubGluZS1ibG9jazsNCiAgICBwYWRkaW5nOiB2YXIoLS1icy1idG4tcGFkZGluZy15KSB2YXIoLS1icy1idG4tcGFkZGluZy14KTsNCiAgICBmb250LWZhbWlseTogdmFyKC0tYnMtYnRuLWZvbnQtZmFtaWx5KTsNCiAgICBmb250LXNpemU6IHZhcigtLWJzLWJ0bi1mb250LXNpemUpOw0KICAgIGZvbnQtd2VpZ2h0OiB2YXIoLS1icy1idG4tZm9udC13ZWlnaHQpOw0KICAgIGxpbmUtaGVpZ2h0OiB2YXIoLS1icy1idG4tbGluZS1oZWlnaHQpOw0KICAgIGNvbG9yOiB2YXIoLS1icy1idG4tY29sb3IpOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQogICAgdmVydGljYWwtYWxpZ246IG1pZGRsZTsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgLXdlYmtpdC11c2VyLXNlbGVjdDogbm9uZTsNCiAgICAtbW96LXVzZXItc2VsZWN0OiBub25lOw0KICAgIHVzZXItc2VsZWN0OiBub25lOw0KICAgIGJvcmRlcjogdmFyKC0tYnMtYnRuLWJvcmRlci13aWR0aCkgc29saWQgdmFyKC0tYnMtYnRuLWJvcmRlci1jb2xvcik7DQogICAgYm9yZGVyLXJhZGl1czogdmFyKC0tYnMtYnRuLWJvcmRlci1yYWRpdXMpOw0KICAgIGJhY2tncm91bmQtY29sb3I6IHZhcigtLWJzLWJ0bi1iZyk7DQogICAgdHJhbnNpdGlvbjogY29sb3IgMC4xNXMgZWFzZS1pbi1vdXQsIGJhY2tncm91bmQtY29sb3IgMC4xNXMgZWFzZS1pbi1vdXQsIGJvcmRlci1jb2xvciAwLjE1cyBlYXNlLWluLW91dCwgYm94LXNoYWRvdyAwLjE1cyBlYXNlLWluLW91dDsNCn0NCg0KLmJ0bi1wcmltYXJ5IHsNCiAgICAtLWJzLWJ0bi1jb2xvcjogI2ZmZjsNCiAgICAtLWJzLWJ0bi1iZzogIzBkNmVmZDsNCiAgICAtLWJzLWJ0bi1ib3JkZXItY29sb3I6ICMwZDZlZmQ7DQogICAgLS1icy1idG4taG92ZXItY29sb3I6ICNmZmY7DQogICAgLS1icy1idG4taG92ZXItYmc6ICMwYjVlZDc7DQogICAgLS1icy1idG4taG92ZXItYm9yZGVyLWNvbG9yOiAjMGE1OGNhOw0KICAgIC0tYnMtYnRuLWZvY3VzLXNoYWRvdy1yZ2I6IDQ5LCAxMzIsIDI1MzsNCiAgICAtLWJzLWJ0bi1hY3RpdmUtY29sb3I6ICNmZmY7DQogICAgLS1icy1idG4tYWN0aXZlLWJnOiAjMGE1OGNhOw0KICAgIC0tYnMtYnRuLWFjdGl2ZS1ib3JkZXItY29sb3I6ICMwYTUzYmU7DQogICAgLS1icy1idG4tYWN0aXZlLXNoYWRvdzogaW5zZXQgMCAzcHggNXB4IHJnYmEoMCwgMCwgMCwgMC4xMjUpOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLWNvbG9yOiAjZmZmOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLWJnOiAjMGQ2ZWZkOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLWJvcmRlci1jb2xvcjogIzBkNmVmZDsNCn0NCg0KLmJ0bi1yZWFkbWUgew0KICAgIGJhY2tncm91bmQ6ICNkYzM1NDU7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNkYzM1NDU7DQogICAgY29sb3I6ICNkZGQ7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCn0NCg0KLmJ0bi1yZWFkbWU6aG92ZXIgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICNiYjJkM2I7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNkZGQ7DQogICAgY29sb3I6ICNkZGQ7DQp9DQoNCi5idG4tcHJpbWFyeTpob3ZlciB7DQogICAgY29sb3I6IHZhcigtLWJzLWJ0bi1ob3Zlci1jb2xvcik7DQogICAgYmFja2dyb3VuZC1jb2xvcjogdmFyKC0tYnMtYnRuLWhvdmVyLWJnKTsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI0Y4RjhGODsNCn0NCg0KLmZpbGVfYnRuLA0KLml0ZW1fYnRuLA0KLm5vX2luZm9fYnRuIHsNCiAgICBib3JkZXItcmFkaXVzOiAwLjM3NWVtOw0KICAgIGNvbG9yOiAjY2NjOw0KICAgIGN1cnNvcjogcG9pbnRlcjsNCiAgICBkaXNwbGF5OiBpbmxpbmUtYmxvY2s7DQogICAgZm9udC1zaXplOiAwLjk1ZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IDAuNWVtIDAuNWVtIDAuNWVtIDAuNWVtOw0KICAgIG91dGxpbmU6IG5vbmU7DQogICAgcGFkZGluZzogMS4yNWVtOw0KICAgIHRleHQtYWxpZ246IGxlZnQ7DQogICAgd2lkdGg6IGF1dG87DQp9DQoNCi5maWxlX2J0biB7DQogICAgYmFja2dyb3VuZDogIzE5ODc1NDsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgIzE5ODc1NDsNCn0NCg0KLml0ZW1fYnRuIHsNCiAgICBiYWNrZ3JvdW5kOiAjMGQ2ZWZkOw0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjMGQ2ZWZkOw0KfQ0KDQoubm9faW5mb19idG4gew0KICAgIGJhY2tncm91bmQ6ICM2Yzc1N2Q7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICM2Yzc1N2Q7DQp9DQoNCi5maWxlX2J0bjpob3ZlciwNCi5pdGVtX2J0bjpob3ZlciwNCi5ub19pbmZvX2J0bjpob3ZlciB7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNjY2M7DQp9DQoNCi5maWxlX2J0bjpob3ZlciB7DQogICAgYmFja2dyb3VuZDogIzE1NzM0NzsNCn0NCg0KLml0ZW1fYnRuOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kOiAjMGI1ZWQ3Ow0KfQ0KDQoubm9faW5mb19idG46aG92ZXIgew0KICAgIGJhY2tncm91bmQ6ICM1YzYzNmE7DQp9DQoNCi5maWxlX2J0bl9sYWJlbCwNCi5pdGVtX2J0bl9sYWJlbCB7DQogICAgY29sb3I6ICNjY2M7DQogICAgZm9udC1zaXplOiAxLjFlbTsNCiAgICBmb250LXdlaWdodDogbm9ybWFsOw0KICAgIG1hcmdpbi10b3A6IDAuNWVtOw0KfQ0KDQouZmlsZV9idG5fdGV4dCwNCi5pdGVtX2J0bl90ZXh0LA0KLm5vX2luZm9fYnRuX3RleHQgew0KICAgIGNvbG9yOiAjZjhmOGY4Ow0KICAgIGRpc3BsYXk6IGJsb2NrOw0KICAgIG1hcmdpbjogMGVtOw0KICAgIHBvc2l0aW9uOiByZWxhdGl2ZTsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KICAgIGZvbnQtc2l6ZTogMS4xZW07DQogICAgd2lkdGg6IGF1dG87DQp9DQoNCi5idG5UZXh0IHsNCiAgICBjb2xvcjogI2Y4ZjhmODsNCiAgICBkaXNwbGF5OiBpbmxpbmU7DQogICAgbWFyZ2luOiAwcmVtIDFyZW0gMHJlbSAxcmVtOw0KICAgIHBvc2l0aW9uOiByZWxhdGl2ZTsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KICAgIGZvbnQtc2l6ZTogMS4yNXJlbTsNCiAgICB3aWR0aDogYXV0bzsNCn0NCg0KLmJ0blRleHQ6OmFmdGVyIHsNCiAgICBiYWNrZ3JvdW5kOiAjZjhmOGY4Ow0KICAgIGJvdHRvbTogLTJweDsNCiAgICBjb250ZW50OiAiIjsNCiAgICBoZWlnaHQ6IDJweDsNCiAgICBsZWZ0OiAwOw0KICAgIHBvc2l0aW9uOiBhYnNvbHV0ZTsNCiAgICB0cmFuc2Zvcm06IHNjYWxlWCgwKTsNCiAgICB0cmFuc2Zvcm0tb3JpZ2luOiByaWdodDsNCiAgICB0cmFuc2l0aW9uOiB0cmFuc2Zvcm0gMC4ycyBlYXNlLWluOw0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQoubWVudUl0ZW06aG92ZXIgLmJ0blRleHQ6OmFmdGVyIHsNCiAgICB0cmFuc2Zvcm06IHNjYWxlWCgxKTsNCiAgICB0cmFuc2Zvcm0tb3JpZ2luOiBsZWZ0Ow0KfQ0KDQpidXR0b24gew0KICAgIHdpZHRoOiAxMDAlOw0KICAgIGhlaWdodDogMTAwJTsNCn0NCg0KdGFibGUsDQp0ciwNCnRkIHsNCiAgICBib3JkZXI6IDFweCBzb2xpZCB0cmFuc3BhcmVudDsNCiAgICBib3JkZXItY29sbGFwc2U6IGNvbGxhcHNlOw0KICAgIGhlaWdodDogMTAwJTsNCn0NCg0KLm1lbnVUYWJsZSB7DQogICAgYm9yZGVyLWNvbGxhcHNlOiBzZXBhcmF0ZTsNCiAgICBib3JkZXItc3BhY2luZzogMWVtOw0KICAgIG1hcmdpbi10b3A6IDFlbTsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLm1lbnVUYWJsZSBidXR0b24gew0KICAgIGJvcmRlcjogMXB4IHNvbGlkIHRyYW5zcGFyZW50Ow0KICAgIHBhZGRpbmc6IDJyZW07DQogICAgd2lkdGg6IDEwMCU7DQogICAgaGVpZ2h0OiAxMDAlOw0KfQ0KDQoubWVudUl0ZW0gew0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCB0cmFuc3BhcmVudDsNCiAgICB3aWR0aDogMjAlOw0KfQ0KDQpAcGFnZSB7DQogICAgc2l6ZTogQTQ7DQoNCiAgICBAYm90dG9tLWNlbnRlciB7DQogICAgICAgIGNvbnRlbnQ6ICJQYWdlICJjb3VudGVyKHBhZ2UpOw0KICAgIH0NCn0NCg0KQG1lZGlhIHByaW50IHsNCiAgICAubm8tcHJpbnQsIC5uby1wcmludCAqIHsNCiAgICAgICAgZGlzcGxheTogbm9uZTsNCiAgICB9DQoNCiAgICBodG1sLCBib2R5IHsNCiAgICAgICAgbWFyZ2luOiAwcmVtOw0KICAgICAgICBiYWNrZ3JvdW5kOiB0cmFuc3BhcmVudDsNCiAgICB9DQoNCiAgICAuZGF0YV9ib2R5IHsNCiAgICAgICAgYmFja2dyb3VuZC1jb2xvcjogdHJhbnNwYXJlbnQ7DQogICAgICAgIGNvbG9yOiAjMDAwOw0KICAgIH0NCn0NCg0KLyogYWxsc3R5bGUuY3NzICovDQoNCiosICo6OmJlZm9yZSwgKjo6YWZ0ZXIgew0KICAgIGJveC1zaXppbmc6IGJvcmRlci1ib3g7DQogICAgbWFyZ2luOiAwOw0KICAgIHBhZGRpbmc6IDA7DQogICAgLXdlYmtpdC1mb250LXNtb290aGluZzogYW50aWFsaWFzZWQ7DQogICAgdGV4dC1yZW5kZXJpbmc6IG9wdGltaXplTGVnaWJpbGl0eTsNCn0NCg0KaHRtbCB7DQogICAgZm9udC1mYW1pbHk6ICdTZWdvZSBVSScsIEZydXRpZ2VyLCAnRnJ1dGlnZXIgTGlub3R5cGUnLCAnRGVqYXZ1IFNhbnMnLCAnSGVsdmV0aWNhIE5ldWUnLCBBcmlhbCwgc2Fucy1zZXJpZjsNCiAgICBmb250LXdlaWdodDogMzAwOw0KfQ0KDQpib2R5IHsNCiAgICBiYWNrZ3JvdW5kOiAjZmZmOw0KICAgIGZvbnQtc2l6ZTogMWVtOw0KICAgIGNvbG9yOiAjMTgxQjIwOw0KICAgIC0tZHJvcEJ0bkNvbG9yOiAjMUU4NDQ5Ow0KICAgIC0tbmF2QnRuUGFkZGluZzogMXB4IDBweCAxcHggMTBweDsNCiAgICAtLW5hdkJ0bkNvbG9ySG92ZXI6ICMyODc0QTY7DQogICAgLS1uYXZCdG5Ib3ZlclRleHRDb2xvcjogI0ZGRkZGRjsNCiAgICAtLW5hdkJ0bkhvdmVyQm9yZGVyOiAxcHggZGFzaGVkICNGRkZGRkY7DQogICAgLS1uYXZCdG5Ib3ZlclJhZGl1czogNXB4Ow0KICAgIC0tbmF2QnRuSGVpZ2h0OiAyLjI1ZW07DQogICAgLS1uYXZCdG5XaWR0aDogOTAlOw0KICAgIC0tbmF2QnRuRm9udEZhbWlseTogJ1JvYm90byBMaWdodCc7DQogICAgLS1uYXZCdG5Gb250U2l6ZTogMS4wNWVtOw0KICAgIG1hcmdpbjogMDsNCiAgICBwYWRkaW5nOiAwOw0KfQ0KDQphIHsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCnAgew0KICAgIHdoaXRlLXNwYWNlOiBwcmUtd3JhcDsNCn0NCg0KLmJvbGRfcmVkIHsNCiAgICBjb2xvcjogI0ZGOTEwMDsNCiAgICBmb250LXdlaWdodDogNzAwOw0KfQ0KDQouYnRuX2xhYmVsIHsNCiAgICBjb2xvcjogI0ZGRjsNCiAgICBmb250LXNpemU6IDEuMWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgbWFyZ2luLXRvcDogMC41ZW07DQp9DQoNCi5jZW50ZXIgew0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLnJpZ2h0IHsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCn0NCg0KLmZyb250X2JhY2tncm91bmQsDQoubmF2X2JhY2tncm91bmQsDQoucmVhZG1lX2JhY2tncm91bmQgew0KICAgIC8qIGJhY2tncm91bmQ6ICMyMjMxM2Y7ICovDQogICAgYmFja2dyb3VuZDogIzIyMjsNCiAgICBjb2xvcjogI0RERDsNCn0NCg0KLm5hdl9pbWFnZSB7DQogICAgaGVpZ2h0OiAxMDBweDsNCiAgICBtYXJnaW46IDI0cHggMHB4Ow0KICAgIHdpZHRoOiAxMDBweDsNCn0NCg0KLm1haW4gew0KICAgIG1hcmdpbjogMmVtIDJlbSAxZW0gMmVtOw0KDQp9DQoNCi5zZWN0aW9uX2hlYWRlciB7DQogICAgZm9udC1zaXplOiAwLjllbTsNCiAgICBtYXJnaW4tYm90dG9tOiAxZW07DQp9DQoNCi5jYXNlX2luZm8gew0KICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNEREQ7DQogICAgY29sb3I6ICNEREQ7DQogICAgZGlzcGxheTogZmxleDsNCiAgICBmbGV4LWRpcmVjdGlvbjogY29sdW1uOw0KICAgIGp1c3RpZnktY29udGVudDogY2VudGVyOw0KICAgIG1hcmdpbi1ib3R0b206IDFlbTsNCiAgICBwYWRkaW5nLWJvdHRvbTogMWVtOw0KfQ0KDQouaXRlbV90YWJsZSB7DQogICAgYWxpZ24tY29udGVudDogY2VudGVyOw0KICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNEREQ7DQogICAgZGlzcGxheTogZmxleDsNCiAgICBmbGV4LWRpcmVjdGlvbjogcm93Ow0KICAgIGZsZXgtd3JhcDogd3JhcDsNCiAgICBqdXN0aWZ5LWNvbnRlbnQ6IHNwYWNlLWV2ZW5seTsNCiAgICBwYWRkaW5nOiAwLjc1ZW07DQp9DQoNCi5jYXNlX2luZm9fZGV0YWlscyB7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KICAgIHBhZGRpbmc6IDAuM2VtIDAuNWVtIDAuM2VtIDBlbTsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCn0NCg0KLmNhc2VfaW5mb190ZXh0IHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMGVtIDAuM2VtIDAuNWVtOw0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KfQ0KDQoudG9wX2hlYWRpbmcgew0KICAgIGNvbG9yOiAjQ0I0MzM1Ow0KICAgIGZvbnQtc2l6ZTogMi40ZW07DQogICAgbWFyZ2luOiAwLjI1ZW0gMGVtIDAuMjVlbSAwZW07DQogICAgcGFkZGluZzogMDsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHRleHQtdHJhbnNmb3JtOiB1cHBlcmNhc2U7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQouZmlyc3RfbGluZSB7DQogICAgZm9udC1zaXplOiAxLjVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMXJlbSAwIDAuNXJlbSAwOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLnNlY29uZF9saW5lIHsNCiAgICBmb250LXNpemU6IDEuMzVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogLTAuMjVyZW0gMCAycmVtIDA7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KfQ0KDQoubnVtYmVyX2xpc3Qgew0KICAgIGZvbnQtZmFtaWx5OiBSb2JvdG87DQogICAgZm9udC1zaXplOiAwLjllbTsNCiAgICBtYXJnaW4tbGVmdDogMWVtOw0KfQ0KDQoubnVtYmVyX2xpc3QgYSB7DQogICAgY29sb3I6IGRvZGdlcmJsdWU7DQogICAgZGlzcGxheTogYmxvY2s7DQogICAgcGFkZGluZy1ib3R0b206IDAuNWVtOw0KfQ0KDQoubnVtYmVyX2xpc3QgYTpob3ZlciB7DQogICAgYmFja2dyb3VuZDogIzQ0NDsNCiAgICBib3JkZXI6IDFweCBkYXNoZWQgd2hpdGU7DQp9DQoNCi5oZWFkaW5nIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjYWFhOw0KICAgIGNvbG9yOiAjQ0I0MzM1Ow0KICAgIGZvbnQtc2l6ZTogMS4yZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IDBlbSAwLjM1ZW07DQogICAgbWF4LXdpZHRoOiBhdXRvOw0KICAgIHBhZGRpbmc6IDVweCAwcHggNXB4IDBweDsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsNCn0NCg0KLnJlcG9ydF9zZWN0aW9uIHsNCiAgICBkaXNwbGF5OiBmbGV4Ow0KICAgIGZsZXgtZGlyZWN0aW9uOiBjb2x1bW47DQogICAgbWF4LXdpZHRoOiBhdXRvOw0KfQ0KDQoubmF2X2xpc3RfaXRlbSB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogdHJhbnNwYXJlbnQ7DQogICAgY29sb3I6ICNDQjQzMzU7DQogICAgZm9udC1mYW1pbHk6IHZhcigtLW5hdkJ0bkZvbnRGYW1pbHkpOw0KICAgIGZvbnQtc2l6ZTogdmFyKC0tbmF2QnRuRm9udFNpemUpOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgaGVpZ2h0OiB2YXIoLS1uYXZCdG5IZWlnaHQpOw0KICAgIG1hcmdpbjogMC4xNWVtIDAuMzVlbTsNCiAgICBtYXgtd2lkdGg6IGF1dG87DQogICAgcGFkZGluZzogN3B4IDBweDsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCn0NCg0KLm5hdl9saXN0X2l0ZW06aG92ZXIgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICMxZjYxOGQ7DQogICAgY29sb3I6ICNEREQ7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIGZvbnQtc2l6ZTogdmFyKC0tbmF2QnRuRm9udFNpemUpOw0KICAgIGZvbnQtd2VpZ2h0OiA2MDA7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KfQ0KDQouZnJvbnRwYWdlX3RhYmxlIHsNCiAgICBib3JkZXItY29sbGFwc2U6IGNvbGxhcHNlOw0KICAgIGNvbG9yOiAjREREOw0KICAgIHRhYmxlLWxheW91dDogZml4ZWQ7DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5jYXNlX2luZm9fZGV0YWlscyB7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KICAgIHBhZGRpbmc6IDAuM2VtIDAuNWVtIDAuM2VtIDBlbTsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCn0NCg0KLmNhc2VfaW5mb190ZXh0IHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMGVtIDAuM2VtIDAuNWVtOw0KICAgIHRleHQtYWxpZ246IGxlZnQ7DQp9DQoNCi5kYXRhX2JvZHkgew0KICAgIC8qIGJhY2tncm91bmQ6ICMyMjMxM2Y7ICovDQogICAgYmFja2dyb3VuZDogIzIyMjsNCiAgICBjb2xvcjogI0RERDsNCiAgICBtYXJnaW4tdG9wOiAyZW07DQogICAgbWFyZ2luLXJpZ2h0OiA1JTsNCiAgICBtYXJnaW4tYm90dG9tOiAyZW07DQogICAgbWFyZ2luLWxlZnQ6IDUlOw0KfQ0KDQovKiBTdHlsZSB0aGUgYnV0dG9uIHRoYXQgaXMgdXNlZCB0byBvcGVuIGFuZCBjbG9zZSB0aGUgY29sbGFwc2libGUgY29udGVudCAqLw0KLmNvbGxhcHNpYmxlIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjNzc3Ow0KICAgIGJvcmRlcjogNHB4IHNvbGlkIHRyYW5zcGFyZW50Ow0KICAgIGJvcmRlci1yYWRpdXM6IDAuMzc1ZW07DQogICAgY29sb3I6ICNEREQ7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIGZvbnQtc2l6ZTogMC45NWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luOiAwZW07DQogICAgb3V0bGluZTogbm9uZTsNCiAgICBwYWRkaW5nOiAxOHB4Ow0KICAgIHRleHQtYWxpZ246IGxlZnQ7DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi8qIEFkZCBhIGJhY2tncm91bmQgY29sb3IgdG8gdGhlIGJ1dHRvbiBpZiBpdCBpcyBjbGlja2VkIG9uIChhZGQgdGhlIC5hY3RpdmUgY2xhc3Mgd2l0aCBKUyksIGFuZCB3aGVuIHlvdSBtb3ZlIHRoZSBtb3VzZSBvdmVyIGl0IChob3ZlcikgKi8NCi5jb2xsYXBzaWJsZTpob3ZlciB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzc3NzsNCiAgICBib3JkZXI6IDRweCBkYXNoZWQgI2RjMzU0NTsNCiAgICBjb2xvcjogI0RERDsNCiAgICBmb250LXNpemU6IDAuOTVlbTsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCi5idG4gew0KICAgIGhlaWdodDogMTAwJTsNCiAgICB3aWR0aDogMTAwJTsNCiAgICAtLWJzLWJ0bi1wYWRkaW5nLXg6IDAuNzVyZW07DQogICAgLS1icy1idG4tcGFkZGluZy15OiAwLjM3NXJlbTsNCiAgICAtLWJzLWJ0bi1mb250LWZhbWlseTogOw0KICAgIC0tYnMtYnRuLWZvbnQtc2l6ZTogMXJlbTsNCiAgICAtLWJzLWJ0bi1mb250LXdlaWdodDogNDAwOw0KICAgIC0tYnMtYnRuLWxpbmUtaGVpZ2h0OiAxLjU7DQogICAgLS1icy1idG4tY29sb3I6IHZhcigtLWJzLWJvZHktY29sb3IpOw0KICAgIC0tYnMtYnRuLWJnOiB0cmFuc3BhcmVudDsNCiAgICAtLWJzLWJ0bi1ib3JkZXItd2lkdGg6IDJweDsNCiAgICAtLWJzLWJ0bi1ib3JkZXItY29sb3I6IHRyYW5zcGFyZW50Ow0KICAgIC0tYnMtYnRuLWJvcmRlci1yYWRpdXM6IDAuMzc1cmVtOw0KICAgIC0tYnMtYnRuLWhvdmVyLWJvcmRlci1jb2xvcjogdHJhbnNwYXJlbnQ7DQogICAgLS1icy1idG4tYm94LXNoYWRvdzogaW5zZXQgMCAxcHggMCByZ2JhKDI1NSwgMjU1LCAyNTUsIDAuMTUpLCAwIDFweCAxcHggcmdiYSgwLCAwLCAwLCAwLjA3NSk7DQogICAgLS1icy1idG4tZGlzYWJsZWQtb3BhY2l0eTogMC42NTsNCiAgICAtLWJzLWJ0bi1mb2N1cy1ib3gtc2hhZG93OiAwIDAgMCAwLjI1cmVtIHJnYmEodmFyKC0tYnMtYnRuLWZvY3VzLXNoYWRvdy1yZ2IpLCAuNSk7DQogICAgZGlzcGxheTogaW5saW5lLWJsb2NrOw0KICAgIHBhZGRpbmc6IHZhcigtLWJzLWJ0bi1wYWRkaW5nLXkpIHZhcigtLWJzLWJ0bi1wYWRkaW5nLXgpOw0KICAgIGZvbnQtZmFtaWx5OiB2YXIoLS1icy1idG4tZm9udC1mYW1pbHkpOw0KICAgIGZvbnQtc2l6ZTogdmFyKC0tYnMtYnRuLWZvbnQtc2l6ZSk7DQogICAgZm9udC13ZWlnaHQ6IHZhcigtLWJzLWJ0bi1mb250LXdlaWdodCk7DQogICAgbGluZS1oZWlnaHQ6IHZhcigtLWJzLWJ0bi1saW5lLWhlaWdodCk7DQogICAgY29sb3I6IHZhcigtLWJzLWJ0bi1jb2xvcik7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogbWlkZGxlOw0KICAgIGN1cnNvcjogcG9pbnRlcjsNCiAgICAtd2Via2l0LXVzZXItc2VsZWN0OiBub25lOw0KICAgIC1tb3otdXNlci1zZWxlY3Q6IG5vbmU7DQogICAgdXNlci1zZWxlY3Q6IG5vbmU7DQogICAgYm9yZGVyOiB2YXIoLS1icy1idG4tYm9yZGVyLXdpZHRoKSBzb2xpZCB2YXIoLS1icy1idG4tYm9yZGVyLWNvbG9yKTsNCiAgICBib3JkZXItcmFkaXVzOiB2YXIoLS1icy1idG4tYm9yZGVyLXJhZGl1cyk7DQogICAgYmFja2dyb3VuZC1jb2xvcjogdmFyKC0tYnMtYnRuLWJnKTsNCiAgICB0cmFuc2l0aW9uOiBjb2xvciAwLjE1cyBlYXNlLWluLW91dCwgYmFja2dyb3VuZC1jb2xvciAwLjE1cyBlYXNlLWluLW91dCwgYm9yZGVyLWNvbG9yIDAuMTVzIGVhc2UtaW4tb3V0LCBib3gtc2hhZG93IDAuMTVzIGVhc2UtaW4tb3V0Ow0KfQ0KDQouYnRuLXByaW1hcnkgew0KICAgIC0tYnMtYnRuLWNvbG9yOiAjZmZmOw0KICAgIC0tYnMtYnRuLWJnOiAjMGQ2ZWZkOw0KICAgIC0tYnMtYnRuLWJvcmRlci1jb2xvcjogIzBkNmVmZDsNCiAgICAtLWJzLWJ0bi1ob3Zlci1jb2xvcjogI2ZmZjsNCiAgICAtLWJzLWJ0bi1ob3Zlci1iZzogIzBiNWVkNzsNCiAgICAtLWJzLWJ0bi1ob3Zlci1ib3JkZXItY29sb3I6ICMwYTU4Y2E7DQogICAgLS1icy1idG4tZm9jdXMtc2hhZG93LXJnYjogNDksIDEzMiwgMjUzOw0KICAgIC0tYnMtYnRuLWFjdGl2ZS1jb2xvcjogI2ZmZjsNCiAgICAtLWJzLWJ0bi1hY3RpdmUtYmc6ICMwYTU4Y2E7DQogICAgLS1icy1idG4tYWN0aXZlLWJvcmRlci1jb2xvcjogIzBhNTNiZTsNCiAgICAtLWJzLWJ0bi1hY3RpdmUtc2hhZG93OiBpbnNldCAwIDNweCA1cHggcmdiYSgwLCAwLCAwLCAwLjEyNSk7DQogICAgLS1icy1idG4tZGlzYWJsZWQtY29sb3I6ICNmZmY7DQogICAgLS1icy1idG4tZGlzYWJsZWQtYmc6ICMwZDZlZmQ7DQogICAgLS1icy1idG4tZGlzYWJsZWQtYm9yZGVyLWNvbG9yOiAjMGQ2ZWZkOw0KfQ0KDQouYnRuLXJlYWRtZSB7DQogICAgYmFja2dyb3VuZDogI2RjMzU0NTsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI2RjMzU0NTsNCiAgICBjb2xvcjogI2RkZDsNCiAgICBmb250LXdlaWdodDogNDAwOw0KfQ0KDQouYnRuLXJlYWRtZTpob3ZlciB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogI2JiMmQzYjsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI2RkZDsNCiAgICBjb2xvcjogI2RkZDsNCn0NCg0KLmJ0bi1wcmltYXJ5OmhvdmVyIHsNCiAgICBjb2xvcjogdmFyKC0tYnMtYnRuLWhvdmVyLWNvbG9yKTsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiB2YXIoLS1icy1idG4taG92ZXItYmcpOw0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjRjhGOEY4Ow0KfQ0KDQouZmlsZV9idG4sDQouaXRlbV9idG4sDQoubm9faW5mb19idG4gew0KICAgIGJvcmRlci1yYWRpdXM6IDAuMzc1ZW07DQogICAgY29sb3I6ICNjY2M7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIGRpc3BsYXk6IGlubGluZS1ibG9jazsNCiAgICBmb250LXNpemU6IDAuOTVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMC41ZW0gMC41ZW0gMC41ZW0gMC41ZW07DQogICAgb3V0bGluZTogbm9uZTsNCiAgICBwYWRkaW5nOiAxLjI1ZW07DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCiAgICB3aWR0aDogYXV0bzsNCn0NCg0KLmZpbGVfYnRuIHsNCiAgICBiYWNrZ3JvdW5kOiAjMTk4NzU0Ow0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjMTk4NzU0Ow0KfQ0KDQouaXRlbV9idG4gew0KICAgIGJhY2tncm91bmQ6ICMwZDZlZmQ7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICMwZDZlZmQ7DQp9DQoNCi5ub19pbmZvX2J0biB7DQogICAgYmFja2dyb3VuZDogIzZjNzU3ZDsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgIzZjNzU3ZDsNCn0NCg0KLmZpbGVfYnRuOmhvdmVyLA0KLml0ZW1fYnRuOmhvdmVyLA0KLm5vX2luZm9fYnRuOmhvdmVyIHsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI2NjYzsNCn0NCg0KLmZpbGVfYnRuOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kOiAjMTU3MzQ3Ow0KfQ0KDQouaXRlbV9idG46aG92ZXIgew0KICAgIGJhY2tncm91bmQ6ICMwYjVlZDc7DQp9DQoNCi5ub19pbmZvX2J0bjpob3ZlciB7DQogICAgYmFja2dyb3VuZDogIzVjNjM2YTsNCn0NCg0KLmZpbGVfYnRuX2xhYmVsLA0KLml0ZW1fYnRuX2xhYmVsIHsNCiAgICBjb2xvcjogI2NjYzsNCiAgICBmb250LXNpemU6IDEuMWVtOw0KICAgIGZvbnQtd2VpZ2h0OiBub3JtYWw7DQogICAgbWFyZ2luLXRvcDogMC41ZW07DQp9DQoNCi5maWxlX2J0bl90ZXh0LA0KLml0ZW1fYnRuX3RleHQsDQoubm9faW5mb19idG5fdGV4dCB7DQogICAgY29sb3I6ICNmOGY4Zjg7DQogICAgZGlzcGxheTogYmxvY2s7DQogICAgbWFyZ2luOiAwZW07DQogICAgcG9zaXRpb246IHJlbGF0aXZlOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQogICAgZm9udC1zaXplOiAxLjFlbTsNCiAgICB3aWR0aDogYXV0bzsNCn0NCg0KLmJ0blRleHQgew0KICAgIGNvbG9yOiAjZjhmOGY4Ow0KICAgIGRpc3BsYXk6IGlubGluZTsNCiAgICBtYXJnaW46IDByZW0gMXJlbSAwcmVtIDFyZW07DQogICAgcG9zaXRpb246IHJlbGF0aXZlOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQogICAgZm9udC1zaXplOiAxLjI1cmVtOw0KICAgIHdpZHRoOiBhdXRvOw0KfQ0KDQouYnRuVGV4dDo6YWZ0ZXIgew0KICAgIGJhY2tncm91bmQ6ICNmOGY4Zjg7DQogICAgYm90dG9tOiAtMnB4Ow0KICAgIGNvbnRlbnQ6ICIiOw0KICAgIGhlaWdodDogMnB4Ow0KICAgIGxlZnQ6IDA7DQogICAgcG9zaXRpb246IGFic29sdXRlOw0KICAgIHRyYW5zZm9ybTogc2NhbGVYKDApOw0KICAgIHRyYW5zZm9ybS1vcmlnaW46IHJpZ2h0Ow0KICAgIHRyYW5zaXRpb246IHRyYW5zZm9ybSAwLjJzIGVhc2UtaW47DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5tZW51SXRlbTpob3ZlciAuYnRuVGV4dDo6YWZ0ZXIgew0KICAgIHRyYW5zZm9ybTogc2NhbGVYKDEpOw0KICAgIHRyYW5zZm9ybS1vcmlnaW46IGxlZnQ7DQp9DQoNCmJ1dHRvbiB7DQogICAgd2lkdGg6IDEwMCU7DQogICAgaGVpZ2h0OiAxMDAlOw0KfQ0KDQp0YWJsZSwNCnRyLA0KdGQgew0KICAgIGJvcmRlcjogMXB4IHNvbGlkIHRyYW5zcGFyZW50Ow0KICAgIGJvcmRlci1jb2xsYXBzZTogY29sbGFwc2U7DQogICAgaGVpZ2h0OiAxMDAlOw0KfQ0KDQoubWVudVRhYmxlIHsNCiAgICBib3JkZXItY29sbGFwc2U6IHNlcGFyYXRlOw0KICAgIGJvcmRlci1zcGFjaW5nOiAxZW07DQogICAgbWFyZ2luLXRvcDogMWVtOw0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQoubWVudVRhYmxlIGJ1dHRvbiB7DQogICAgYm9yZGVyOiAxcHggc29saWQgdHJhbnNwYXJlbnQ7DQogICAgcGFkZGluZzogMnJlbTsNCiAgICB3aWR0aDogMTAwJTsNCiAgICBoZWlnaHQ6IDEwMCU7DQp9DQoNCi5tZW51SXRlbSB7DQogICAgYm9yZGVyOiAycHggZGFzaGVkIHRyYW5zcGFyZW50Ow0KICAgIHdpZHRoOiAyMCU7DQp9DQoNCkBwYWdlIHsNCiAgICBzaXplOiBBNDsNCg0KICAgIEBib3R0b20tY2VudGVyIHsNCiAgICAgICAgY29udGVudDogIlBhZ2UgImNvdW50ZXIocGFnZSk7DQogICAgfQ0KfQ0KDQpAbWVkaWEgcHJpbnQgew0KICAgIC5uby1wcmludCwgLm5vLXByaW50ICogew0KICAgICAgICBkaXNwbGF5OiBub25lOw0KICAgIH0NCg0KICAgIGh0bWwsIGJvZHkgew0KICAgICAgICBtYXJnaW46IDByZW07DQogICAgICAgIGJhY2tncm91bmQ6IHRyYW5zcGFyZW50Ow0KICAgIH0NCg0KICAgIC5kYXRhX2JvZHkgew0KICAgICAgICBiYWNrZ3JvdW5kLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICAgICAgY29sb3I6ICMwMDA7DQogICAgfQ0KfQ0K
"


function Write-MainHtmlPage2 {

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
        [string]$Ipv6,
        [string]$Sec1_001
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
        <div class='main'>
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
            </div>
"

    Add-Content -Path $FilePath -Value $MainReportPage -Encoding UTF8
}

function Write-MainHtmlPage2End {

    param (
        [string]$FilePath
    )

    $MainHtmlPage2End = "
    </body>
</html>"

    Add-Content -Path $FilePath -Value $MainHtmlPage2End -Encoding UTF8

}


Export-ModuleMember -Function Write-HtmlHomePage, Write-HtmlNavPage, Write-HtmlFrontPage, Write-HtmlReadMePage, Write-MainHtmlPage, Write-MainHtmlPage2, Write-MainHtmlPage2End -Variable HtmlHeader, HtmlFooter, ReturnHtmlSnippet, AllStyleCssEncodedText
