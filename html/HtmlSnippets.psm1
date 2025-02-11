# Assigning variables to use in the script
$HtmlHeader = "<!DOCTYPE html>

<html lang='en' dir='ltr'>

    <head>

        <title>$($ComputerName) Triage Data</title>

        <meta charset='utf-8' />
        <meta name='viewport' content='width=device-width, initial-scale=1.0' />
        <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1' />

        <script src='https://unpkg.com/ionicons@5.1.2/dist/ionicons.js'></script>
        <link href='https://fonts.googleapis.com/css2?family=DM+Sans:wght@400; 500&display=swap' rel='stylesheet'>
        <link href='https://unpkg.com/ionicons@4.5.10-0/dist/css/ionicons.min.css' rel='stylesheet'>

        <link rel='stylesheet' type='text/css' href='../css/allstyle.css' />

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
        <script>
            var coll = document.getElementsByClassName('collapsible');
            var i;

            for (i = 0; i < coll.length; i++) {
                coll[i].addEventListener('click', function() {
                    this.classList.toggle('active');
                    var content = this.nextElementSibling;
                    if (content.style.display === 'block') {
                        content.style.display = 'none';
                    } else {
                        content.style.display = 'block';
                    }
                });
            }
        </script>
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

        <link rel='shortcut icon' type='img/png' href='Resources/images/binary.png'>

    </head>

    <frameset cols='20%,80%' frameborder='1' border='1' framespacing='1'>

        <frame name='menu' src='Resources/static/nav.html' marginheight='0' marginwidth='0' scrolling='no'>

        <frame name='content' src='Resources/static/main.html' marginheight='0' marginwidth='0' scrolling='auto'>

        <!-- <frame name='content' src='Resources/front.html' marginheight='0' marginwidth='0' scrolling='auto'> -->

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

        <link href='https://fonts.googleapis.com/css?family=Roboto&display=swap' rel='stylesheet'>
        <link href='https://fonts.googleapis.com/css?family=Cinzel&display=swap' rel='stylesheet' type='text/css'>

        <link rel='stylesheet' type='text/css' href='../css/allstyle.css' />

        <link rel='shortcut icon' type='img/png' href='../images/binary.png'>

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

                <a class='nav_list_item' href='./front.html' target='content'>
                    Cover Page
                </a>

                <a class='nav_list_item' href='./main.html' target='content'>
                    Main Page
                </a>

                <a class='nav_list_item' href='./readme.html' target='content'>
                    Read Me First
                </a>

            </div>

            <div class='heading'>Category Reports</div>

            <div class='dropdown'>

                <button class='dropbtn'>Choose a Category</button>

                <div class='dropdown-content'>

                    <a href='../webpages/001_DeviceInfo.html' target='content'>Device Information</a>

                    <a href='../webpages/002_UserInfo.html' target='content'>User Data</a>

                    <a href='../webpages/003_NetworkInfo.html' target='content'>Network Information</a>

                    <a href='../webpages/004_ProcessInfo.html' target='content'>Processes Information</a>

                    <a href='../webpages/005_SystemInfo.html' target='content'>System Information</a>

                    <a href='../webpages/006_PrefetchInfo.html' target='content'>Prefetch File Data</a>

                    <a href='../webpages/007_EventLogInfo.html' target='content'>Event Log Data</a>

                    <a href='../webpages/008_FirewallInfo.html' target='content'>Firewall Data/Settings</a>

                    <a href='../webpages/009_BitLockerInfo.html' target='content'>BitLocker Data</a>

                    <a href='../webpages/010_FileKeywordMatches.html' target='content'>File Keyword Search Results</a>

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

        <link href='https://fonts.googleapis.com/css?family=Roboto&display=swap' rel='stylesheet'>
        <link href='https://fonts.googleapis.com/css?family=Cinzel&display=swap' rel='stylesheet' type='text/css'>

        <link rel='stylesheet' type='text/css' href='../css/allstyle.css' />

        <link rel='shortcut icon' type='img/png' href='../images/binary.png'>

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

            <br>

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

        <link href='https://fonts.googleapis.com/css?family=Roboto&display=swap' rel='stylesheet'>
        <link href='https://fonts.googleapis.com/css?family=Cinzel&display=swap' rel='stylesheet' type='text/css'>

        <link rel='stylesheet' type='text/css' href='../css/allstyle.css' />

        <link rel='shortcut icon' type='img/png' href='../images/binary.png'>

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

    $MainReportPage = "<!DOCTYPE html>

<html lang='en' dir='ltr'>

    <head>

        <title>Main.html</title>

        <meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <meta http-equiv='X-UA-Compatible' content='ie-edge'>

        <link href='https://fonts.googleapis.com/css?family=Roboto&display=swap' rel='stylesheet'>
        <link href='https://fonts.googleapis.com/css?family=Cinzel&display=swap' rel='stylesheet' type='text/css'>

        <link rel='stylesheet' type='text/css' href='Resources\css\allstyle.css' />

        <link rel='shortcut icon' type='img/png' href='Resources\images\binary.png' />

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

        <div class='center'>
            <img src='Resources\images\customLogo.png' class='nav_image' />
        </div>

        <table class='frontpage_table'>

                <tr>
                    <td class='case_info_details'>Examiner<strong>:</strong></td>
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
                    <td class='case_info_text'>$($ReportGenTime)</td>
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

        <table class='menuTable greeting'>

            <tr>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <a href='../webpages/001_DeviceInfo.html' target='content'>
                        <button class='btn btn-primary'>
                            <div class='btnText'>Device Information</div>
                        </button>
                    </a>
                </td>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <a href='../webpages/002_UserInfo.html' target='content'>
                        <button class='btn btn-primary'>
                            <div class='btnText'>User Data</div>
                        </button>
                    </a>
                </td>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <a href='../webpages/003_NetworkInfo.html' target='content'>
                        <button class='btn btn-primary'>
                            <div class='btnText'>Network Information</div>
                        </button>
                    </a>
                </td>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <a href='../webpages/004_ProcessInfo.html' target='content'>
                        <button class='btn btn-primary'>
                            <div class='btnText'>Processes Information</div>
                        </button>
                    </a>
                </td>

                <td class='menuSpacing'></td>

            </tr>

            <tr>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <a href='../webpages/005_SystemInfo.html' target='content'>
                        <button class='btn btn-primary'>
                            <div class='btnText'>System Information</div>
                        </button>
                    </a>
                </td>

                   <td class='menuSpacing'></td>

                   <td class='menuItem'>
                    <a href='../webpages/006_PrefetchInfo.html' target='content'>
                        <button class='btn btn-primary'>
                            <div class='btnText'>Prefetch File Data</div>
                        </button>
                    </a>
                </td>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <a href='../webpages/007_EventLogInfo.html' target='content'>
                        <button class='btn btn-primary'>
                            <div class='btnText'>Event Log Data</div>
                        </button>
                    </a>
                </td>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <a href='../webpages/008_FirewallInfo.html' target='content'>
                        <button class='btn btn-primary'>
                            <div class='btnText'>Firewall Data Settings</div>
                        </button>
                    </a>
                </td>

                <td class='menuSpacing'></td>

            </tr>

            <tr>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <a href='../webpages/009_BitLockerInfo.html' target='content'>
                        <button class='btn btn-primary'>
                            <div class='btnText'>BitLocker Data</div>
                        </button>
                    </a>
                </td>

                <td class='menuSpacing'></td>

            </tr>

        </table>

    </body>

</html>"

    Add-Content -Path $FilePath -Value $MainReportPage -Encoding UTF8
}


$AllStyleCssEncodedText = "
LyogYWxsc3R5bGUuY3NzICovDQoNCiosICo6OmJlZm9yZSwgKjo6YWZ0ZXIgew0KICAgIGJveC1zaXppbmc6IGJvcmRlci1ib3g7DQogICAgbWFyZ2luOiAwOw0KICAgIHBhZGRpbmc6IDA7DQogICAgLXdlYmtpdC1mb250LXNtb290aGluZzogYW50aWFsaWFzZWQ7DQogICAgdGV4dC1yZW5kZXJpbmc6IG9wdGltaXplTGVnaWJpbGl0eTsNCn0NCg0KaHRtbCB7DQogICAgZm9udC1mYW1pbHk6ICdTZWdvZSBVSScsIEZydXRpZ2VyLCAnRnJ1dGlnZXIgTGlub3R5cGUnLCAnRGVqYXZ1IFNhbnMnLCAnSGVsdmV0aWNhIE5ldWUnLCBBcmlhbCwgc2Fucy1zZXJpZjsNCiAgICBmb250LXdlaWdodDogMzAwOw0KfQ0KDQpib2R5IHsNCiAgICBiYWNrZ3JvdW5kOiAjZmZmOw0KICAgIGZvbnQtc2l6ZTogMTZweDsNCiAgICBjb2xvcjogIzE4MUIyMDsNCiAgICAtLWRyb3BCdG5Db2xvcjogIzFFODQ0OTsNCiAgICAtLW5hdkJ0blBhZGRpbmc6IDFweCAwcHggMXB4IDEwcHg7DQogICAgLS1uYXZCdG5Db2xvckhvdmVyOiAjMjg3NEE2Ow0KICAgIC0tbmF2QnRuSG92ZXJUZXh0Q29sb3I6ICNGRkZGRkY7DQogICAgLS1uYXZCdG5Ib3ZlckJvcmRlcjogMXB4IGRhc2hlZCAjRkZGRkZGOw0KICAgIC0tbmF2QnRuSG92ZXJSYWRpdXM6IDVweDsNCiAgICAtLW5hdkJ0bkhlaWdodDogMi4yNWVtOw0KICAgIC0tbmF2QnRuV2lkdGg6IDkwJTsNCiAgICAtLW5hdkJ0bkZvbnRGYW1pbHk6ICdSb2JvdG8gTGlnaHQnOw0KICAgIC0tbmF2QnRuRm9udFNpemU6IDEuMDVlbTsNCiAgICBtYXJnaW46IDA7DQogICAgcGFkZGluZzogMDsNCn0NCg0KYSB7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KfQ0KDQpwIHsNCiAgICB3aGl0ZS1zcGFjZTogcHJlLXdyYXA7DQp9DQoNCi5ib2xkX3JlZCB7DQogICAgY29sb3I6ICNGRjkxMDA7DQogICAgZm9udC13ZWlnaHQ6IDcwMDsNCn0NCg0KLmJ0bl9sYWJlbCB7DQogICAgY29sb3I6ICNGRkY7DQogICAgZm9udC1zaXplOiAxLjFlbTsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIG1hcmdpbi10b3A6IDAuNWVtOw0KDQp9DQoNCi5jZW50ZXIgew0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLmZyb250X2JhY2tncm91bmQsDQoubmF2X2JhY2tncm91bmQsDQoucmVhZG1lX2JhY2tncm91bmQgew0KICAgIGJhY2tncm91bmQ6ICMyMjMxM2Y7DQogICAgY29sb3I6ICNEREQ7DQp9DQoNCi5uYXZfaW1hZ2Ugew0KICAgIGhlaWdodDogMTAwcHg7DQogICAgbWFyZ2luOiAyNHB4IDBweDsNCiAgICB3aWR0aDogMTAwcHg7DQp9DQoNCi5jYXNlX2luZm8gew0KICAgIGRpc3BsYXk6IGZsZXg7DQogICAgZmxleC1kaXJlY3Rpb246IGNvbHVtbjsNCiAgICBtYXJnaW46IDJlbSAyZW0gMWVtIDJlbTsNCiAgICBhbGlnbi1pdGVtczogY2VudGVyOw0KICAgIGp1c3RpZnktY29udGVudDogY2VudGVyOw0KICAgIGNvbG9yOiAjRkZGRkZGOw0KICAgIGJvcmRlcjogMXB4IGRhc2hlZCAjRkZGRkZGOw0KfQ0KDQouY2FzZV9pbmZvX2RldGFpbHMgew0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCiAgICBwYWRkaW5nOiAwLjNlbSAwLjVlbSAwLjNlbSAwZW07DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCn0NCg0KLmNhc2VfaW5mb190ZXh0IHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMGVtIDAuM2VtIDAuNWVtOw0KICAgIHRleHQtYWxpZ246IGxlZnQ7DQp9DQoNCi50b3BfaGVhZGluZyB7DQogICAgY29sb3I6ICNDQjQzMzU7DQogICAgZm9udC1zaXplOiAyLjRlbTsNCiAgICBtYXJnaW46IDAuNWVtIDBlbSAwZW0gMGVtOw0KICAgIHBhZGRpbmc6IDA7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICB0ZXh0LXRyYW5zZm9ybTogdXBwZXJjYXNlOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLmZpcnN0X2xpbmUgew0KICAgIGZvbnQtc2l6ZTogMS41ZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IDFyZW0gMCAwLjVyZW0gMDsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQp9DQoNCi5zZWNvbmRfbGluZSB7DQogICAgZm9udC1zaXplOiAxLjM1ZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IC0wLjI1cmVtIDAgMnJlbSAwOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLm51bWJlcl9saXN0IHsNCiAgICBmb250LWZhbWlseTogUm9ib3RvOw0KICAgIGZvbnQtc2l6ZTogMS4xNWVtOw0KICAgIGxpbmUtaGVpZ2h0OiAxLjM1Ow0KICAgIG1hcmdpbi1sZWZ0OiAxMCU7DQogICAgbWFyZ2luLXJpZ2h0OiAxMCU7DQp9DQoNCi5oZWFkaW5nIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjYWFhOw0KICAgIGNvbG9yOiAjQ0I0MzM1Ow0KICAgIGZvbnQtc2l6ZTogMS4yZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IDBlbSAwLjM1ZW07DQogICAgbWF4LXdpZHRoOiBhdXRvOw0KICAgIHBhZGRpbmc6IDVweCAwcHggNXB4IDBweDsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsNCn0NCg0KLnJlcG9ydF9zZWN0aW9uIHsNCiAgICBkaXNwbGF5OiBmbGV4Ow0KICAgIGZsZXgtZGlyZWN0aW9uOiBjb2x1bW47DQogICAgbWF4LXdpZHRoOiBhdXRvOw0KfQ0KDQoubmF2X2xpc3RfaXRlbSB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogdHJhbnNwYXJlbnQ7DQogICAgY29sb3I6ICNEREQ7DQogICAgZm9udC1mYW1pbHk6IHZhcigtLW5hdkJ0bkZvbnRGYW1pbHkpOw0KICAgIGZvbnQtc2l6ZTogdmFyKC0tbmF2QnRuRm9udFNpemUpOw0KICAgIGhlaWdodDogdmFyKC0tbmF2QnRuSGVpZ2h0KTsNCiAgICBtYXJnaW46IDAuMTVlbSAwLjM1ZW07DQogICAgbWF4LXdpZHRoOiBhdXRvOw0KICAgIHBhZGRpbmc6IDdweCAwcHg7DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCn0NCg0KLm5hdl9saXN0X2l0ZW06aG92ZXIgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICMxZjYxOGQ7DQogICAgY29sb3I6ICNEREQ7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIGZvbnQtc2l6ZTogdmFyKC0tbmF2QnRuRm9udFNpemUpOw0KICAgIGZvbnQtd2VpZ2h0OiA2MDA7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KfQ0KDQouZnJvbnRwYWdlX3RhYmxlIHsNCiAgICBjb2xvcjogI0ZGRkZGRjsNCiAgICBib3JkZXItY29sbGFwc2U6IGNvbGxhcHNlOw0KfQ0KDQouZnJvbnRwYWdlX3RhYmxlIHRkIHsNCiAgICBjb2xvcjogI0ZGRkZGRjsNCiAgICBib3JkZXItY29sbGFwc2U6IGNvbGxhcHNlOw0KICAgIGZvbnQtc2l6ZTogMS4yZW07DQp9DQoNCi5jYXNlX2luZm9fZGV0YWlscyB7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KICAgIHBhZGRpbmc6IDAuM2VtIDAuNWVtIDAuM2VtIDBlbTsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCn0NCg0KLmNhc2VfaW5mb190ZXh0IHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMGVtIDAuM2VtIDAuNWVtOw0KICAgIHRleHQtYWxpZ246IGxlZnQ7DQp9DQoNCi8qIERyb3Bkb3duIEJ1dHRvbiAqLw0KLmRyb3BidG4gew0KICAgIGJvcmRlcjogbm9uZTsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiBkb2RnZXJibHVlOw0KICAgIGNvbG9yOiAjZWRlOw0KICAgIGZvbnQtc2l6ZTogMTZweDsNCiAgICBwYWRkaW5nOiAxNnB4Ow0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQouZHJvcGJ0bjpob3ZlciB7DQogICAgYm9yZGVyOiAxcHggZGFzaGVkIHdoaXRlOw0KICAgIGNvbG9yOiAjRkZGOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQp9DQoNCi8qIFRoZSBjb250YWluZXIgPGRpdj4gLSBuZWVkZWQgdG8gcG9zaXRpb24gdGhlIGRyb3Bkb3duIGNvbnRlbnQgKi8NCi5kcm9wZG93biB7DQogICAgYWxpZ24taXRlbXM6IGNlbnRlcjsNCiAgICBkaXNwbGF5OiBpbmxpbmUtYmxvY2s7DQogICAganVzdGlmeS1jb250ZW50OiBjZW50ZXI7DQogICAgbWFyZ2luOiAxLjc1ZW0gMC4zNWVtIDBlbSAwLjM1ZW07DQogICAgbWF4LXdpZHRoOiBhdXRvOw0KICAgIHBvc2l0aW9uOiByZWxhdGl2ZTsNCiAgICB3aWR0aDogOTYlOw0KfQ0KDQovKiBEcm9wZG93biBDb250ZW50IChIaWRkZW4gYnkgRGVmYXVsdCkgKi8NCi5kcm9wZG93bi1jb250ZW50IHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjZjFmMWYxOw0KICAgIGJveC1zaGFkb3c6IDBweCA4cHggMTZweCAwcHggcmdiYSgwLCAwLCAwLCAwLjIpOw0KICAgIGRpc3BsYXk6IG5vbmU7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICBoZWlnaHQ6IDE1ZW07DQogICAgbWluLXdpZHRoOiAxNjBweDsNCiAgICBvdmVyZmxvdy15OiBzY3JvbGw7DQogICAgcG9zaXRpb246IGFic29sdXRlOw0KICAgIHdpZHRoOiAxMDAlOw0KICAgIHotaW5kZXg6IDE7DQp9DQoNCi8qIExpbmtzIGluc2lkZSB0aGUgZHJvcGRvd24gKi8NCi5kcm9wZG93bi1jb250ZW50IGEgew0KICAgIGNvbG9yOiBibGFjazsNCiAgICBkaXNwbGF5OiBibG9jazsNCiAgICBtYXJnaW4tbGVmdDogM3B4Ow0KICAgIG1hcmdpbi1yaWdodDogM3B4Ow0KICAgIHBhZGRpbmc6IDEycHggMTZweDsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCi8qIENoYW5nZSBjb2xvciBvZiBkcm9wZG93biBsaW5rcyBvbiBob3ZlciAqLw0KLmRyb3Bkb3duLWNvbnRlbnQgYTpob3ZlciB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzU0OTlDNzsNCiAgICBjb2xvcjogI0ZGRjsNCiAgICBmb250LXdlaWdodDogNTAwOw0KfQ0KDQouZHJvcGRvd24tY29udGVudCBhOmFjdGl2ZSB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzAwN0JGRjsNCiAgICBjb2xvcjogI0ZGRjsNCiAgICBmb250LXdlaWdodDogNTAwOw0KfQ0KDQovKiBTaG93IHRoZSBkcm9wZG93biBtZW51IG9uIGhvdmVyICovDQouZHJvcGRvd246aG92ZXIgLmRyb3Bkb3duLWNvbnRlbnQgew0KICAgIGRpc3BsYXk6IGJsb2NrOw0KfQ0KDQovKiBDaGFuZ2UgdGhlIGJhY2tncm91bmQgY29sb3Igb2YgdGhlIGRyb3Bkb3duIGJ1dHRvbiB3aGVuIHRoZSBkcm9wZG93biBjb250ZW50IGlzIHNob3duICovDQouZHJvcGRvd246aG92ZXIgLmRyb3BidG4gew0KICAgIGJhY2tncm91bmQtY29sb3I6IGRvZGdlcmJsdWU7DQp9DQoNCi5kYXRhX2JvZHkgew0KICAgIGJhY2tncm91bmQ6ICMyMjMxM2Y7DQogICAgY29sb3I6ICNEREQ7DQogICAgbWFyZ2luLXRvcDogMmVtOw0KICAgIG1hcmdpbi1yaWdodDogNSU7DQogICAgbWFyZ2luLWJvdHRvbTogMmVtOw0KICAgIG1hcmdpbi1sZWZ0OiA1JTsNCn0NCg0KLyogU3R5bGUgdGhlIGJ1dHRvbiB0aGF0IGlzIHVzZWQgdG8gb3BlbiBhbmQgY2xvc2UgdGhlIGNvbGxhcHNpYmxlIGNvbnRlbnQgKi8NCi5jb2xsYXBzaWJsZSB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzc3NzsNCiAgICBib3JkZXI6IDRweCBzb2xpZCAjMTgxQjIwOw0KICAgIGNvbG9yOiAjREREOw0KICAgIGN1cnNvcjogcG9pbnRlcjsNCiAgICBmb250LXNpemU6IDAuOTVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMGVtIDBlbSAxZW0gMGVtOw0KICAgIG91dGxpbmU6IG5vbmU7DQogICAgcGFkZGluZzogMThweDsNCiAgICB0ZXh0LWFsaWduOiBsZWZ0Ow0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQovKiBBZGQgYSBiYWNrZ3JvdW5kIGNvbG9yIHRvIHRoZSBidXR0b24gaWYgaXQgaXMgY2xpY2tlZCBvbiAoYWRkIHRoZSAuYWN0aXZlIGNsYXNzIHdpdGggSlMpLCBhbmQgd2hlbiB5b3UgbW92ZSB0aGUgbW91c2Ugb3ZlciBpdCAoaG92ZXIpICovDQouYWN0aXZlLCAuY29sbGFwc2libGU6aG92ZXIgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICM3Nzc7DQogICAgYm9yZGVyOiA0cHggZGFzaGVkIGRvZGdlcmJsdWU7DQogICAgY29sb3I6ICNEREQ7DQogICAgZm9udC1zaXplOiAwLjk1ZW07DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KfQ0KDQouY29sbGFwc2libGU6YWZ0ZXIgew0KICAgIC8qIFVuaWNvZGUgY2hhcmFjdGVyIGZvciAicGx1cyIgc2lnbiAoKykgKi8NCiAgICBjb250ZW50OiAnXDAwMkInOw0KICAgIGZvbnQtc2l6ZTogMTZweDsNCiAgICBmb250LXdlaWdodDogYm9sZDsNCiAgICBjb2xvcjogI0RERDsNCiAgICBmbG9hdDogcmlnaHQ7DQogICAgbWFyZ2luLWxlZnQ6IDVweDsNCn0NCg0KLmFjdGl2ZTphZnRlciB7DQogICAgLyogVW5pY29kZSBjaGFyYWN0ZXIgZm9yICJtaW51cyIgc2lnbiAoLSkgKi8NCiAgICBjb250ZW50OiAnXDIwMTMnOw0KICAgIGZvbnQtc2l6ZTogMTZweDsNCiAgICBmb250LXdlaWdodDogYm9sZDsNCiAgICBjb2xvcjogI0RERDsNCn0NCg0KLyogU3R5bGUgdGhlIGNvbGxhcHNpYmxlIGNvbnRlbnQuIE5vdGU6IGhpZGRlbiBieSBkZWZhdWx0ICovDQouY29udGVudCB7DQogICAgY29sb3I6ICMwMDA7DQogICAgcGFkZGluZzogMS41ZW0gMS4yNWVtOw0KICAgIGRpc3BsYXk6IG5vbmU7DQogICAgb3ZlcmZsb3c6IGhpZGRlbjsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjQkJCOw0KfQ0KDQouY29udGVudCBhIHsNCiAgICBjb2xvcjogIzFmNjE4ZDsNCn0NCg0KLmJ0biB7DQogICAgaGVpZ2h0OiAxMDAlOw0KICAgIHdpZHRoOiAxMDAlOw0KICAgIC0tYnMtYnRuLXBhZGRpbmcteDogMC43NXJlbTsNCiAgICAtLWJzLWJ0bi1wYWRkaW5nLXk6IDAuMzc1cmVtOw0KICAgIC0tYnMtYnRuLWZvbnQtZmFtaWx5OiA7DQogICAgLS1icy1idG4tZm9udC1zaXplOiAxcmVtOw0KICAgIC0tYnMtYnRuLWZvbnQtd2VpZ2h0OiA0MDA7DQogICAgLS1icy1idG4tbGluZS1oZWlnaHQ6IDEuNTsNCiAgICAtLWJzLWJ0bi1jb2xvcjogdmFyKC0tYnMtYm9keS1jb2xvcik7DQogICAgLS1icy1idG4tYmc6IHRyYW5zcGFyZW50Ow0KICAgIC0tYnMtYnRuLWJvcmRlci13aWR0aDogMnB4Ow0KICAgIC0tYnMtYnRuLWJvcmRlci1jb2xvcjogdHJhbnNwYXJlbnQ7DQogICAgLS1icy1idG4tYm9yZGVyLXJhZGl1czogdmFyKC0tYnMtYm9yZGVyLXJhZGl1cyk7DQogICAgLS1icy1idG4taG92ZXItYm9yZGVyLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICAtLWJzLWJ0bi1ib3gtc2hhZG93OiBpbnNldCAwIDFweCAwIHJnYmEoMjU1LCAyNTUsIDI1NSwgMC4xNSksIDAgMXB4IDFweCByZ2JhKDAsIDAsIDAsIDAuMDc1KTsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1vcGFjaXR5OiAwLjY1Ow0KICAgIC0tYnMtYnRuLWZvY3VzLWJveC1zaGFkb3c6IDAgMCAwIDAuMjVyZW0gcmdiYSh2YXIoLS1icy1idG4tZm9jdXMtc2hhZG93LXJnYiksIC41KTsNCiAgICBkaXNwbGF5OiBpbmxpbmUtYmxvY2s7DQogICAgcGFkZGluZzogdmFyKC0tYnMtYnRuLXBhZGRpbmcteSkgdmFyKC0tYnMtYnRuLXBhZGRpbmcteCk7DQogICAgZm9udC1mYW1pbHk6IHZhcigtLWJzLWJ0bi1mb250LWZhbWlseSk7DQogICAgZm9udC1zaXplOiB2YXIoLS1icy1idG4tZm9udC1zaXplKTsNCiAgICBmb250LXdlaWdodDogdmFyKC0tYnMtYnRuLWZvbnQtd2VpZ2h0KTsNCiAgICBsaW5lLWhlaWdodDogdmFyKC0tYnMtYnRuLWxpbmUtaGVpZ2h0KTsNCiAgICBjb2xvcjogdmFyKC0tYnMtYnRuLWNvbG9yKTsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KICAgIHZlcnRpY2FsLWFsaWduOiBtaWRkbGU7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIC13ZWJraXQtdXNlci1zZWxlY3Q6IG5vbmU7DQogICAgLW1vei11c2VyLXNlbGVjdDogbm9uZTsNCiAgICB1c2VyLXNlbGVjdDogbm9uZTsNCiAgICBib3JkZXI6IHZhcigtLWJzLWJ0bi1ib3JkZXItd2lkdGgpIHNvbGlkIHZhcigtLWJzLWJ0bi1ib3JkZXItY29sb3IpOw0KICAgIGJvcmRlci1yYWRpdXM6IHZhcigtLWJzLWJ0bi1ib3JkZXItcmFkaXVzKTsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiB2YXIoLS1icy1idG4tYmcpOw0KICAgIHRyYW5zaXRpb246IGNvbG9yIDAuMTVzIGVhc2UtaW4tb3V0LCBiYWNrZ3JvdW5kLWNvbG9yIDAuMTVzIGVhc2UtaW4tb3V0LCBib3JkZXItY29sb3IgMC4xNXMgZWFzZS1pbi1vdXQsIGJveC1zaGFkb3cgMC4xNXMgZWFzZS1pbi1vdXQ7DQp9DQoNCi5idG4tcHJpbWFyeSB7DQogICAgLS1icy1idG4tY29sb3I6ICNmZmY7DQogICAgLS1icy1idG4tYmc6ICMwZDZlZmQ7DQogICAgLS1icy1idG4tYm9yZGVyLWNvbG9yOiAjMGQ2ZWZkOw0KICAgIC0tYnMtYnRuLWhvdmVyLWNvbG9yOiAjZmZmOw0KICAgIC0tYnMtYnRuLWhvdmVyLWJnOiAjMGI1ZWQ3Ow0KICAgIC0tYnMtYnRuLWhvdmVyLWJvcmRlci1jb2xvcjogIzBhNThjYTsNCiAgICAtLWJzLWJ0bi1mb2N1cy1zaGFkb3ctcmdiOiA0OSwgMTMyLCAyNTM7DQogICAgLS1icy1idG4tYWN0aXZlLWNvbG9yOiAjZmZmOw0KICAgIC0tYnMtYnRuLWFjdGl2ZS1iZzogIzBhNThjYTsNCiAgICAtLWJzLWJ0bi1hY3RpdmUtYm9yZGVyLWNvbG9yOiAjMGE1M2JlOw0KICAgIC0tYnMtYnRuLWFjdGl2ZS1zaGFkb3c6IGluc2V0IDAgM3B4IDVweCByZ2JhKDAsIDAsIDAsIDAuMTI1KTsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1jb2xvcjogI2ZmZjsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1iZzogIzBkNmVmZDsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1ib3JkZXItY29sb3I6ICMwZDZlZmQ7DQp9DQoNCi5idG46aG92ZXIgew0KICAgIGNvbG9yOiB2YXIoLS1icy1idG4taG92ZXItY29sb3IpOw0KICAgIGJhY2tncm91bmQtY29sb3I6IHZhcigtLWJzLWJ0bi1ob3Zlci1iZyk7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNGOEY4Rjg7DQp9DQoNCi5idG5UZXh0IHsNCiAgICBjb2xvcjogI2Y4ZjhmODsNCiAgICBkaXNwbGF5OiBpbmxpbmU7DQogICAgbWFyZ2luOiAwcmVtIDFyZW0gMHJlbSAxcmVtOw0KICAgIHBvc2l0aW9uOiByZWxhdGl2ZTsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KICAgIGZvbnQtc2l6ZTogMS4yNXJlbTsNCiAgICB3aWR0aDogYXV0bzsNCn0NCg0KLmJ0blRleHQ6OmFmdGVyIHsNCiAgICBiYWNrZ3JvdW5kOiAjZjhmOGY4Ow0KICAgIGJvdHRvbTogLTJweDsNCiAgICBjb250ZW50OiAiIjsNCiAgICBoZWlnaHQ6IDJweDsNCiAgICBsZWZ0OiAwOw0KICAgIHBvc2l0aW9uOiBhYnNvbHV0ZTsNCiAgICB0cmFuc2Zvcm06IHNjYWxlWCgwKTsNCiAgICB0cmFuc2Zvcm0tb3JpZ2luOiByaWdodDsNCiAgICB0cmFuc2l0aW9uOiB0cmFuc2Zvcm0gMC4ycyBlYXNlLWluOw0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQoubWVudUl0ZW06aG92ZXIgLmJ0blRleHQ6OmFmdGVyIHsNCiAgICB0cmFuc2Zvcm06IHNjYWxlWCgxKTsNCiAgICB0cmFuc2Zvcm0tb3JpZ2luOiBsZWZ0Ow0KfQ0KDQpidXR0b24gew0KICAgIHdpZHRoOiAxMDAlOw0KICAgIGhlaWdodDogMTAwJTsNCn0NCg0KdGFibGUsDQp0ciwNCnRkIHsNCiAgICBib3JkZXI6IDFweCBzb2xpZCB0cmFuc3BhcmVudDsNCiAgICBib3JkZXItY29sbGFwc2U6IGNvbGxhcHNlOw0KICAgIGhlaWdodDogMTAwJTsNCn0NCg0KDQouZ3JlZXRpbmcgew0KICAgIG1hcmdpbi10b3A6IDNyZW07DQp9DQoNCi5tZW51VGFibGUgew0KICAgIGJvcmRlci1jb2xsYXBzZTogc2VwYXJhdGU7DQogICAgYm9yZGVyLXNwYWNpbmc6IDFyZW07DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5tZW51VGFibGUgYnV0dG9uIHsNCiAgICBib3JkZXI6IDFweCBzb2xpZCB0cmFuc3BhcmVudDsNCiAgICBwYWRkaW5nOiAycmVtOw0KICAgIHdpZHRoOiAxMDAlOw0KICAgIGhlaWdodDogMTAwJTsNCn0NCg0KLm1lbnVJdGVtIHsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgdHJhbnNwYXJlbnQ7DQogICAgd2lkdGg6IDIwJTsNCn0NCg0KLm1lbnVTcGFjaW5nIHsNCiAgICB3aWR0aDogNCU7DQp9DQoNCkBwYWdlIHsNCiAgICBzaXplOiBBNDsNCg0KICAgIEBib3R0b20tY2VudGVyIHsNCiAgICAgICAgY29udGVudDogIlBhZ2UgImNvdW50ZXIocGFnZSk7DQogICAgfQ0KfQ0KDQpAbWVkaWEgcHJpbnQgew0KICAgIC5uby1wcmludCwgLm5vLXByaW50ICogew0KICAgICAgICBkaXNwbGF5OiBub25lOw0KICAgIH0NCg0KICAgIGh0bWwsIGJvZHkgew0KICAgICAgICBtYXJnaW46IDByZW07DQogICAgICAgIGJhY2tncm91bmQ6IHRyYW5zcGFyZW50Ow0KICAgIH0NCg0KICAgIC5kYXRhX2JvZHkgew0KICAgICAgICBiYWNrZ3JvdW5kLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICAgICAgY29sb3I6ICMwMDA7DQogICAgfQ0KfQ==
"


Export-ModuleMember -Function Write-HtmlHomePage, Write-HtmlNavPage, Write-HtmlFrontPage, Write-HtmlReadMePage, Write-MainHtmlPage -Variable HtmlHeader, HtmlFooter, ReturnHtmlSnippet, AllStyleCssEncodedText
