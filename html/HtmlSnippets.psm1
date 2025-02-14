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

        <link rel='stylesheet' type='text/css' href='..\..\Resources\css\allstyle.css' />

        <link rel='shortcut icon' type='img/png' href='..\..\Resources\images\page_icon.png' />

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
LyogYWxsc3R5bGUuY3NzICovDQoNCiosICo6OmJlZm9yZSwgKjo6YWZ0ZXIgew0KICAgIGJveC1zaXppbmc6IGJvcmRlci1ib3g7DQogICAgbWFyZ2luOiAwOw0KICAgIHBhZGRpbmc6IDA7DQogICAgLXdlYmtpdC1mb250LXNtb290aGluZzogYW50aWFsaWFzZWQ7DQogICAgdGV4dC1yZW5kZXJpbmc6IG9wdGltaXplTGVnaWJpbGl0eTsNCn0NCg0KaHRtbCB7DQogICAgZm9udC1mYW1pbHk6ICdTZWdvZSBVSScsIEZydXRpZ2VyLCAnRnJ1dGlnZXIgTGlub3R5cGUnLCAnRGVqYXZ1IFNhbnMnLCAnSGVsdmV0aWNhIE5ldWUnLCBBcmlhbCwgc2Fucy1zZXJpZjsNCiAgICBmb250LXdlaWdodDogMzAwOw0KfQ0KDQpib2R5IHsNCiAgICBiYWNrZ3JvdW5kOiAjZmZmOw0KICAgIGZvbnQtc2l6ZTogMWVtOw0KICAgIGNvbG9yOiAjMTgxQjIwOw0KICAgIC0tZHJvcEJ0bkNvbG9yOiAjMUU4NDQ5Ow0KICAgIC0tbmF2QnRuUGFkZGluZzogMXB4IDBweCAxcHggMTBweDsNCiAgICAtLW5hdkJ0bkNvbG9ySG92ZXI6ICMyODc0QTY7DQogICAgLS1uYXZCdG5Ib3ZlclRleHRDb2xvcjogI0ZGRkZGRjsNCiAgICAtLW5hdkJ0bkhvdmVyQm9yZGVyOiAxcHggZGFzaGVkICNGRkZGRkY7DQogICAgLS1uYXZCdG5Ib3ZlclJhZGl1czogNXB4Ow0KICAgIC0tbmF2QnRuSGVpZ2h0OiAyLjI1ZW07DQogICAgLS1uYXZCdG5XaWR0aDogOTAlOw0KICAgIC0tbmF2QnRuRm9udEZhbWlseTogJ1JvYm90byBMaWdodCc7DQogICAgLS1uYXZCdG5Gb250U2l6ZTogMS4wNWVtOw0KICAgIG1hcmdpbjogMDsNCiAgICBwYWRkaW5nOiAwOw0KfQ0KDQphIHsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCnAgew0KICAgIHdoaXRlLXNwYWNlOiBwcmUtd3JhcDsNCn0NCg0KLmJvbGRfcmVkIHsNCiAgICBjb2xvcjogI0ZGOTEwMDsNCiAgICBmb250LXdlaWdodDogNzAwOw0KfQ0KDQouYnRuX2xhYmVsIHsNCiAgICBjb2xvcjogI0ZGRjsNCiAgICBmb250LXNpemU6IDEuMWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgbWFyZ2luLXRvcDogMC41ZW07DQp9DQoNCi5jZW50ZXIgew0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLnJpZ2h0IHsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCn0NCg0KLmZyb250X2JhY2tncm91bmQsDQoubmF2X2JhY2tncm91bmQsDQoucmVhZG1lX2JhY2tncm91bmQgew0KICAgIGJhY2tncm91bmQ6ICMyMjMxM2Y7DQogICAgY29sb3I6ICNEREQ7DQp9DQoNCi5uYXZfaW1hZ2Ugew0KICAgIGhlaWdodDogMTAwcHg7DQogICAgbWFyZ2luOiAyNHB4IDBweDsNCiAgICB3aWR0aDogMTAwcHg7DQp9DQoNCi5jYXNlX2luZm8gew0KICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNEREQ7DQogICAgY29sb3I6ICNEREQ7DQogICAgZGlzcGxheTogZmxleDsNCiAgICBmbGV4LWRpcmVjdGlvbjogY29sdW1uOw0KICAgIGp1c3RpZnktY29udGVudDogY2VudGVyOw0KICAgIG1hcmdpbjogMmVtIDJlbSAxZW0gMmVtOw0KICAgIHBhZGRpbmctYm90dG9tOiAxZW07DQp9DQoNCi5pdGVtX3RhYmxlIHsNCiAgICBhbGlnbi1jb250ZW50OiBjZW50ZXI7DQogICAgYWxpZ24taXRlbXM6IGNlbnRlcjsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI0RERDsNCiAgICBkaXNwbGF5OiBmbGV4Ow0KICAgIGZsZXgtZGlyZWN0aW9uOiByb3c7DQogICAgZmxleC13cmFwOiB3cmFwOw0KICAgIGp1c3RpZnktY29udGVudDogc3BhY2UtZXZlbmx5Ow0KICAgIHBhZGRpbmc6IDAuNzVlbTsNCn0NCg0KLmNhc2VfaW5mb19kZXRhaWxzIHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMC41ZW0gMC4zZW0gMGVtOw0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KfQ0KDQouY2FzZV9pbmZvX3RleHQgew0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCiAgICBwYWRkaW5nOiAwLjNlbSAwZW0gMC4zZW0gMC41ZW07DQogICAgdGV4dC1hbGlnbjogcmlnaHQ7DQp9DQoNCi50b3BfaGVhZGluZyB7DQogICAgY29sb3I6ICNDQjQzMzU7DQogICAgZm9udC1zaXplOiAyLjRlbTsNCiAgICBtYXJnaW46IDAuMjVlbSAwZW0gMC4yNWVtIDBlbTsNCiAgICBwYWRkaW5nOiAwOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5maXJzdF9saW5lIHsNCiAgICBmb250LXNpemU6IDEuNWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luOiAxcmVtIDAgMC41cmVtIDA7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KfQ0KDQouc2Vjb25kX2xpbmUgew0KICAgIGZvbnQtc2l6ZTogMS4zNWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luOiAtMC4yNXJlbSAwIDJyZW0gMDsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQp9DQoNCi5udW1iZXJfbGlzdCB7DQogICAgZm9udC1mYW1pbHk6IFJvYm90bzsNCiAgICBmb250LXNpemU6IDEuMTVlbTsNCiAgICBsaW5lLWhlaWdodDogMS4zNTsNCiAgICBtYXJnaW4tbGVmdDogMTAlOw0KICAgIG1hcmdpbi1yaWdodDogMTAlOw0KfQ0KDQouaGVhZGluZyB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogI2FhYTsNCiAgICBjb2xvcjogI0NCNDMzNTsNCiAgICBmb250LXNpemU6IDEuMmVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luOiAwZW0gMC4zNWVtOw0KICAgIG1heC13aWR0aDogYXV0bzsNCiAgICBwYWRkaW5nOiA1cHggMHB4IDVweCAwcHg7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHRleHQtdHJhbnNmb3JtOiB1cHBlcmNhc2U7DQp9DQoNCi5yZXBvcnRfc2VjdGlvbiB7DQogICAgZGlzcGxheTogZmxleDsNCiAgICBmbGV4LWRpcmVjdGlvbjogY29sdW1uOw0KICAgIG1heC13aWR0aDogYXV0bzsNCn0NCg0KLm5hdl9saXN0X2l0ZW0gew0KICAgIGJhY2tncm91bmQtY29sb3I6IHRyYW5zcGFyZW50Ow0KICAgIGNvbG9yOiAjQ0I0MzM1Ow0KICAgIGZvbnQtZmFtaWx5OiB2YXIoLS1uYXZCdG5Gb250RmFtaWx5KTsNCiAgICBmb250LXNpemU6IHZhcigtLW5hdkJ0bkZvbnRTaXplKTsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIGhlaWdodDogdmFyKC0tbmF2QnRuSGVpZ2h0KTsNCiAgICBtYXJnaW46IDAuMTVlbSAwLjM1ZW07DQogICAgbWF4LXdpZHRoOiBhdXRvOw0KICAgIHBhZGRpbmc6IDdweCAwcHg7DQogICAgdGV4dC1hbGlnbjogcmlnaHQ7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQp9DQoNCi5uYXZfbGlzdF9pdGVtOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjMWY2MThkOw0KICAgIGNvbG9yOiAjREREOw0KICAgIGN1cnNvcjogcG9pbnRlcjsNCiAgICBmb250LXNpemU6IHZhcigtLW5hdkJ0bkZvbnRTaXplKTsNCiAgICBmb250LXdlaWdodDogNjAwOw0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCn0NCg0KLmZyb250cGFnZV90YWJsZSB7DQogICAgYm9yZGVyLWNvbGxhcHNlOiBjb2xsYXBzZTsNCiAgICBjb2xvcjogI0RERDsNCiAgICB0YWJsZS1sYXlvdXQ6IGZpeGVkOw0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQouY2FzZV9pbmZvX2RldGFpbHMgew0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCiAgICBwYWRkaW5nOiAwLjNlbSAwLjVlbSAwLjNlbSAwZW07DQogICAgdGV4dC1hbGlnbjogcmlnaHQ7DQp9DQoNCi5jYXNlX2luZm9fdGV4dCB7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KICAgIHBhZGRpbmc6IDAuM2VtIDBlbSAwLjNlbSAwLjVlbTsNCiAgICB0ZXh0LWFsaWduOiBsZWZ0Ow0KfQ0KDQouZGF0YV9ib2R5IHsNCiAgICBiYWNrZ3JvdW5kOiAjMjIzMTNmOw0KICAgIGNvbG9yOiAjREREOw0KICAgIG1hcmdpbi10b3A6IDJlbTsNCiAgICBtYXJnaW4tcmlnaHQ6IDUlOw0KICAgIG1hcmdpbi1ib3R0b206IDJlbTsNCiAgICBtYXJnaW4tbGVmdDogNSU7DQp9DQoNCi8qIFN0eWxlIHRoZSBidXR0b24gdGhhdCBpcyB1c2VkIHRvIG9wZW4gYW5kIGNsb3NlIHRoZSBjb2xsYXBzaWJsZSBjb250ZW50ICovDQouY29sbGFwc2libGUgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICM3Nzc7DQogICAgYm9yZGVyOiA0cHggc29saWQgdHJhbnNwYXJlbnQ7DQogICAgYm9yZGVyLXJhZGl1czogMC4zNzVlbTsNCiAgICBjb2xvcjogI0RERDsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgZm9udC1zaXplOiAwLjk1ZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IDBlbTsNCiAgICBvdXRsaW5lOiBub25lOw0KICAgIHBhZGRpbmc6IDE4cHg7DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLyogQWRkIGEgYmFja2dyb3VuZCBjb2xvciB0byB0aGUgYnV0dG9uIGlmIGl0IGlzIGNsaWNrZWQgb24gKGFkZCB0aGUgLmFjdGl2ZSBjbGFzcyB3aXRoIEpTKSwgYW5kIHdoZW4geW91IG1vdmUgdGhlIG1vdXNlIG92ZXIgaXQgKGhvdmVyKSAqLw0KLmNvbGxhcHNpYmxlOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjNzc3Ow0KICAgIGJvcmRlcjogNHB4IGRhc2hlZCAjZGMzNTQ1Ow0KICAgIGNvbG9yOiAjREREOw0KICAgIGZvbnQtc2l6ZTogMC45NWVtOw0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCn0NCg0KLmJ0biB7DQogICAgaGVpZ2h0OiAxMDAlOw0KICAgIHdpZHRoOiAxMDAlOw0KICAgIC0tYnMtYnRuLXBhZGRpbmcteDogMC43NXJlbTsNCiAgICAtLWJzLWJ0bi1wYWRkaW5nLXk6IDAuMzc1cmVtOw0KICAgIC0tYnMtYnRuLWZvbnQtZmFtaWx5OiA7DQogICAgLS1icy1idG4tZm9udC1zaXplOiAxcmVtOw0KICAgIC0tYnMtYnRuLWZvbnQtd2VpZ2h0OiA0MDA7DQogICAgLS1icy1idG4tbGluZS1oZWlnaHQ6IDEuNTsNCiAgICAtLWJzLWJ0bi1jb2xvcjogdmFyKC0tYnMtYm9keS1jb2xvcik7DQogICAgLS1icy1idG4tYmc6IHRyYW5zcGFyZW50Ow0KICAgIC0tYnMtYnRuLWJvcmRlci13aWR0aDogMnB4Ow0KICAgIC0tYnMtYnRuLWJvcmRlci1jb2xvcjogdHJhbnNwYXJlbnQ7DQogICAgLS1icy1idG4tYm9yZGVyLXJhZGl1czogMC4zNzVyZW07DQogICAgLS1icy1idG4taG92ZXItYm9yZGVyLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICAtLWJzLWJ0bi1ib3gtc2hhZG93OiBpbnNldCAwIDFweCAwIHJnYmEoMjU1LCAyNTUsIDI1NSwgMC4xNSksIDAgMXB4IDFweCByZ2JhKDAsIDAsIDAsIDAuMDc1KTsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1vcGFjaXR5OiAwLjY1Ow0KICAgIC0tYnMtYnRuLWZvY3VzLWJveC1zaGFkb3c6IDAgMCAwIDAuMjVyZW0gcmdiYSh2YXIoLS1icy1idG4tZm9jdXMtc2hhZG93LXJnYiksIC41KTsNCiAgICBkaXNwbGF5OiBpbmxpbmUtYmxvY2s7DQogICAgcGFkZGluZzogdmFyKC0tYnMtYnRuLXBhZGRpbmcteSkgdmFyKC0tYnMtYnRuLXBhZGRpbmcteCk7DQogICAgZm9udC1mYW1pbHk6IHZhcigtLWJzLWJ0bi1mb250LWZhbWlseSk7DQogICAgZm9udC1zaXplOiB2YXIoLS1icy1idG4tZm9udC1zaXplKTsNCiAgICBmb250LXdlaWdodDogdmFyKC0tYnMtYnRuLWZvbnQtd2VpZ2h0KTsNCiAgICBsaW5lLWhlaWdodDogdmFyKC0tYnMtYnRuLWxpbmUtaGVpZ2h0KTsNCiAgICBjb2xvcjogdmFyKC0tYnMtYnRuLWNvbG9yKTsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KICAgIHZlcnRpY2FsLWFsaWduOiBtaWRkbGU7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIC13ZWJraXQtdXNlci1zZWxlY3Q6IG5vbmU7DQogICAgLW1vei11c2VyLXNlbGVjdDogbm9uZTsNCiAgICB1c2VyLXNlbGVjdDogbm9uZTsNCiAgICBib3JkZXI6IHZhcigtLWJzLWJ0bi1ib3JkZXItd2lkdGgpIHNvbGlkIHZhcigtLWJzLWJ0bi1ib3JkZXItY29sb3IpOw0KICAgIGJvcmRlci1yYWRpdXM6IHZhcigtLWJzLWJ0bi1ib3JkZXItcmFkaXVzKTsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiB2YXIoLS1icy1idG4tYmcpOw0KICAgIHRyYW5zaXRpb246IGNvbG9yIDAuMTVzIGVhc2UtaW4tb3V0LCBiYWNrZ3JvdW5kLWNvbG9yIDAuMTVzIGVhc2UtaW4tb3V0LCBib3JkZXItY29sb3IgMC4xNXMgZWFzZS1pbi1vdXQsIGJveC1zaGFkb3cgMC4xNXMgZWFzZS1pbi1vdXQ7DQp9DQoNCi5idG4tcHJpbWFyeSB7DQogICAgLS1icy1idG4tY29sb3I6ICNmZmY7DQogICAgLS1icy1idG4tYmc6ICMwZDZlZmQ7DQogICAgLS1icy1idG4tYm9yZGVyLWNvbG9yOiAjMGQ2ZWZkOw0KICAgIC0tYnMtYnRuLWhvdmVyLWNvbG9yOiAjZmZmOw0KICAgIC0tYnMtYnRuLWhvdmVyLWJnOiAjMGI1ZWQ3Ow0KICAgIC0tYnMtYnRuLWhvdmVyLWJvcmRlci1jb2xvcjogIzBhNThjYTsNCiAgICAtLWJzLWJ0bi1mb2N1cy1zaGFkb3ctcmdiOiA0OSwgMTMyLCAyNTM7DQogICAgLS1icy1idG4tYWN0aXZlLWNvbG9yOiAjZmZmOw0KICAgIC0tYnMtYnRuLWFjdGl2ZS1iZzogIzBhNThjYTsNCiAgICAtLWJzLWJ0bi1hY3RpdmUtYm9yZGVyLWNvbG9yOiAjMGE1M2JlOw0KICAgIC0tYnMtYnRuLWFjdGl2ZS1zaGFkb3c6IGluc2V0IDAgM3B4IDVweCByZ2JhKDAsIDAsIDAsIDAuMTI1KTsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1jb2xvcjogI2ZmZjsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1iZzogIzBkNmVmZDsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1ib3JkZXItY29sb3I6ICMwZDZlZmQ7DQp9DQoNCi5idG4tcmVhZG1lIHsNCiAgICBiYWNrZ3JvdW5kOiAjZGMzNTQ1Ow0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjZGMzNTQ1Ow0KICAgIGNvbG9yOiAjZGRkOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQp9DQoNCi5idG4tcmVhZG1lOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjYmIyZDNiOw0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjZGRkOw0KICAgIGNvbG9yOiAjZGRkOw0KfQ0KDQouYnRuLXByaW1hcnk6aG92ZXIgew0KICAgIGNvbG9yOiB2YXIoLS1icy1idG4taG92ZXItY29sb3IpOw0KICAgIGJhY2tncm91bmQtY29sb3I6IHZhcigtLWJzLWJ0bi1ob3Zlci1iZyk7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNGOEY4Rjg7DQp9DQoNCi5maWxlX2J0biwNCi5pdGVtX2J0biwNCi5ub19pbmZvX2J0biB7DQogICAgYm9yZGVyLXJhZGl1czogMC4zNzVlbTsNCiAgICBjb2xvcjogI2NjYzsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgZGlzcGxheTogaW5saW5lLWJsb2NrOw0KICAgIGZvbnQtc2l6ZTogMC45NWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luOiAwLjVlbSAwLjVlbSAwLjVlbSAwLjVlbTsNCiAgICBvdXRsaW5lOiBub25lOw0KICAgIHBhZGRpbmc6IDEuMjVlbTsNCiAgICB0ZXh0LWFsaWduOiBsZWZ0Ow0KICAgIHdpZHRoOiBhdXRvOw0KfQ0KDQouZmlsZV9idG4gew0KICAgIGJhY2tncm91bmQ6ICMxOTg3NTQ7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICMxOTg3NTQ7DQp9DQoNCi5pdGVtX2J0biB7DQogICAgYmFja2dyb3VuZDogIzBkNmVmZDsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgIzBkNmVmZDsNCn0NCg0KLm5vX2luZm9fYnRuIHsNCiAgICBiYWNrZ3JvdW5kOiAjNmM3NTdkOw0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjNmM3NTdkOw0KfQ0KDQouZmlsZV9idG46aG92ZXIsDQouaXRlbV9idG46aG92ZXIsDQoubm9faW5mb19idG46aG92ZXIgew0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjY2NjOw0KfQ0KDQouZmlsZV9idG46aG92ZXIgew0KICAgIGJhY2tncm91bmQ6ICMxNTczNDc7DQp9DQoNCi5pdGVtX2J0bjpob3ZlciB7DQogICAgYmFja2dyb3VuZDogIzBiNWVkNzsNCn0NCg0KLm5vX2luZm9fYnRuOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kOiAjNWM2MzZhOw0KfQ0KDQouZmlsZV9idG5fbGFiZWwsDQouaXRlbV9idG5fbGFiZWwgew0KICAgIGNvbG9yOiAjY2NjOw0KICAgIGZvbnQtc2l6ZTogMS4xZW07DQogICAgZm9udC13ZWlnaHQ6IG5vcm1hbDsNCiAgICBtYXJnaW4tdG9wOiAwLjVlbTsNCn0NCg0KLmZpbGVfYnRuX3RleHQsDQouaXRlbV9idG5fdGV4dCwNCi5ub19pbmZvX2J0bl90ZXh0IHsNCiAgICBjb2xvcjogI2Y4ZjhmODsNCiAgICBkaXNwbGF5OiBibG9jazsNCiAgICBtYXJnaW46IDBlbTsNCiAgICBwb3NpdGlvbjogcmVsYXRpdmU7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICBmb250LXNpemU6IDEuMWVtOw0KICAgIHdpZHRoOiBhdXRvOw0KfQ0KDQouYnRuVGV4dCB7DQogICAgY29sb3I6ICNmOGY4Zjg7DQogICAgZGlzcGxheTogaW5saW5lOw0KICAgIG1hcmdpbjogMHJlbSAxcmVtIDByZW0gMXJlbTsNCiAgICBwb3NpdGlvbjogcmVsYXRpdmU7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICBmb250LXNpemU6IDEuMjVyZW07DQogICAgd2lkdGg6IGF1dG87DQp9DQoNCi5idG5UZXh0OjphZnRlciB7DQogICAgYmFja2dyb3VuZDogI2Y4ZjhmODsNCiAgICBib3R0b206IC0ycHg7DQogICAgY29udGVudDogIiI7DQogICAgaGVpZ2h0OiAycHg7DQogICAgbGVmdDogMDsNCiAgICBwb3NpdGlvbjogYWJzb2x1dGU7DQogICAgdHJhbnNmb3JtOiBzY2FsZVgoMCk7DQogICAgdHJhbnNmb3JtLW9yaWdpbjogcmlnaHQ7DQogICAgdHJhbnNpdGlvbjogdHJhbnNmb3JtIDAuMnMgZWFzZS1pbjsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLm1lbnVJdGVtOmhvdmVyIC5idG5UZXh0OjphZnRlciB7DQogICAgdHJhbnNmb3JtOiBzY2FsZVgoMSk7DQogICAgdHJhbnNmb3JtLW9yaWdpbjogbGVmdDsNCn0NCg0KYnV0dG9uIHsNCiAgICB3aWR0aDogMTAwJTsNCiAgICBoZWlnaHQ6IDEwMCU7DQp9DQoNCnRhYmxlLA0KdHIsDQp0ZCB7DQogICAgYm9yZGVyOiAxcHggc29saWQgdHJhbnNwYXJlbnQ7DQogICAgYm9yZGVyLWNvbGxhcHNlOiBjb2xsYXBzZTsNCiAgICBoZWlnaHQ6IDEwMCU7DQp9DQoNCi5tZW51VGFibGUgew0KICAgIGJvcmRlci1jb2xsYXBzZTogc2VwYXJhdGU7DQogICAgYm9yZGVyLXNwYWNpbmc6IDFlbTsNCiAgICBtYXJnaW4tdG9wOiAxZW07DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5tZW51VGFibGUgYnV0dG9uIHsNCiAgICBib3JkZXI6IDFweCBzb2xpZCB0cmFuc3BhcmVudDsNCiAgICBwYWRkaW5nOiAycmVtOw0KICAgIHdpZHRoOiAxMDAlOw0KICAgIGhlaWdodDogMTAwJTsNCn0NCg0KLm1lbnVJdGVtIHsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgdHJhbnNwYXJlbnQ7DQogICAgd2lkdGg6IDIwJTsNCn0NCg0KQHBhZ2Ugew0KICAgIHNpemU6IEE0Ow0KDQogICAgQGJvdHRvbS1jZW50ZXIgew0KICAgICAgICBjb250ZW50OiAiUGFnZSAiY291bnRlcihwYWdlKTsNCiAgICB9DQp9DQoNCkBtZWRpYSBwcmludCB7DQogICAgLm5vLXByaW50LCAubm8tcHJpbnQgKiB7DQogICAgICAgIGRpc3BsYXk6IG5vbmU7DQogICAgfQ0KDQogICAgaHRtbCwgYm9keSB7DQogICAgICAgIG1hcmdpbjogMHJlbTsNCiAgICAgICAgYmFja2dyb3VuZDogdHJhbnNwYXJlbnQ7DQogICAgfQ0KDQogICAgLmRhdGFfYm9keSB7DQogICAgICAgIGJhY2tncm91bmQtY29sb3I6IHRyYW5zcGFyZW50Ow0KICAgICAgICBjb2xvcjogIzAwMDsNCiAgICB9DQp9
"


Export-ModuleMember -Function Write-HtmlHomePage, Write-HtmlNavPage, Write-HtmlFrontPage, Write-HtmlReadMePage, Write-MainHtmlPage -Variable HtmlHeader, HtmlFooter, ReturnHtmlSnippet, AllStyleCssEncodedText
