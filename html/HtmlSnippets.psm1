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

        <frame name='content' src='Resources/static/front.html' marginheight='0' marginwidth='0' scrolling='auto'>

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
                </tr>

                <tr>
                    <td class='case_info_details'>Agency Name<strong>:</strong></td>
                    <td class='case_info_text'>$($Agency)</td>
                </tr>

                <tr>
                    <td class='case_info_details'>Case Number<strong>:</strong></td>
                    <td class='case_info_text'>$($CaseNumber)</td>
                </tr>

                <tr>
                    <td class='case_info_details'>Report Generated <strong>:</strong></td>
                    <td class='case_info_text'>$($ReportGenTime) ET</td>
                </tr>

                <tr>
                    <td class='case_info_details'>Computer Name <strong>:</strong></td>
                    <td class='case_info_text'>$($ComputerName)</td>
                </tr>

                <tr>
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

    param (
        [string]$FilePath
    )

    $MainReportPage = "<!DOCTYPE html>

<html lang='en' dir='ltr'>

    <head>

        <title>Main.html</title>

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

        <table class='menuTable greeting'>

            <tr>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <button class='btn btn-primary'>
                        <a href='../webpages/001_DeviceInfo.html' target='content'>
                            <span class='btnText'>Device Information</span>
                        </a>
                    </button>
                </td>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <button class='btn btn-primary'>
                        <a href='../webpages/002_UserInfo.html' target='content'>
                            <span class='btnText'>User Data</span>
                        </a>
                    </button>
                </td>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <button class='btn btn-primary'>
                        <a href='../webpages/003_NetworkInfo.html' target='content'>
                            <span class='btnText'>Network Information</span>
                        </a>
                    </button>
                </td>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <button class='btn btn-primary'>
                        <a href='../webpages/004_ProcessInfo.html' target='content'>
                            <span class='btnText'>Processes Information</span>
                        </a>
                    </button>
                </td>

                <td class='menuSpacing'></td>

            </tr>

            <tr>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <button class='btn btn-primary'>
                        <a href='../webpages/005_SystemInfo.html' target='content'>
                            <span class='btnText'>System Information</span>
                        </a>
                    </button>
                </td>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <button class='btn btn-primary'>
                        <a href='../webpages/006_PrefetchInfo.html' target='content'>
                            <span class='btnText'>Prefetch File Data</span>
                        </a>
                    </button>
                </td>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <button class='btn btn-primary'>
                        <a href='../webpages/007_EventLogInfo.html' target='content'>
                            <span class='btnText'>Event Log Data</span>
                        </a>
                    </button>
                </td>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <button class='btn btn-primary'>
                        <a href='../webpages/008_FirewallInfo.html' target='content'>
                            <span class='btnText'>Firewall Data Settings</span>
                        </a>
                    </button>
                </td>

                <td class='menuSpacing'></td>

            </tr>

            <tr>

                <td class='menuSpacing'></td>

                <td class='menuItem'>
                    <button class='btn btn-primary'>
                        <a href='../webpages/009_BitLockerInfo.html' target='content'>
                            <span class='btnText'>BitLocker Data</span>
                        </a>
                    </button>
                </td>

                <td class='menuSpacing'></td>

            </tr>

        </table>

    </body>

</html>"


    Add-Content -Path $FilePath -Value $MainReportPage -Encoding UTF8
}


$AllStyleCssEncodedText = "
LyogZnJvbnQuY3NzICovDQoNCiosICo6OmJlZm9yZSwgKjo6YWZ0ZXIgew0KICAgIGJveC1zaXppbmc6IGJvcmRlci1ib3g7DQogICAgbWFyZ2luOiAwOw0KICAgIHBhZGRpbmc6IDA7DQogICAgLXdlYmtpdC1mb250LXNtb290aGluZzogYW50aWFsaWFzZWQ7DQogICAgdGV4dC1yZW5kZXJpbmc6IG9wdGltaXplTGVnaWJpbGl0eTsNCn0NCg0KaHRtbCB7DQogICAgZm9udC1mYW1pbHk6ICdTZWdvZSBVSScsIEZydXRpZ2VyLCAnRnJ1dGlnZXIgTGlub3R5cGUnLCAnRGVqYXZ1IFNhbnMnLCAnSGVsdmV0aWNhIE5ldWUnLCBBcmlhbCwgc2Fucy1zZXJpZjsNCiAgICBmb250LXdlaWdodDogMzAwOw0KfQ0KDQpib2R5IHsNCiAgICBiYWNrZ3JvdW5kOiAjZmZmOw0KICAgIGZvbnQtc2l6ZTogMTZweDsNCiAgICBjb2xvcjogIzE4MUIyMDsNCiAgICAtLWRyb3BCdG5Db2xvcjogIzFFODQ0OTsNCiAgICAtLW5hdkJ0blBhZGRpbmc6IDFweCAwcHggMXB4IDEwcHg7DQogICAgLS1uYXZCdG5Db2xvckhvdmVyOiAjMjg3NEE2Ow0KICAgIC0tbmF2QnRuSG92ZXJUZXh0Q29sb3I6ICNGRkZGRkY7DQogICAgLS1uYXZCdG5Ib3ZlckJvcmRlcjogMXB4IGRhc2hlZCAjRkZGRkZGOw0KICAgIC0tbmF2QnRuSG92ZXJSYWRpdXM6IDVweDsNCiAgICAtLW5hdkJ0bkhlaWdodDogMi4yNWVtOw0KICAgIC0tbmF2QnRuV2lkdGg6IDkwJTsNCiAgICAtLW5hdkJ0bkZvbnRGYW1pbHk6ICdSb2JvdG8gTGlnaHQnOw0KICAgIC0tbmF2QnRuRm9udFNpemU6IDEuMDVlbTsNCiAgICBtYXJnaW46IDA7DQogICAgcGFkZGluZzogMDsNCn0NCg0KcCB7DQogICAgd2hpdGUtc3BhY2U6IHByZS13cmFwOw0KfQ0KDQouYm9sZF9yZWQgew0KICAgIGNvbG9yOiAjRkY5MTAwOw0KICAgIGZvbnQtd2VpZ2h0OiA3MDA7DQp9DQoNCi5idG5fbGFiZWwgew0KICAgIGNvbG9yOiAjRkZGOw0KICAgIGZvbnQtc2l6ZTogMS4xZW07DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICBtYXJnaW4tdG9wOiAwLjVlbTsNCg0KfQ0KDQouY2VudGVyIHsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQp9DQoNCi8qIE15IEFkZGVkIFN0eWxlICovDQouZnJvbnRfYmFja2dyb3VuZCwNCi5uYXZfYmFja2dyb3VuZCwNCi5yZWFkbWVfYmFja2dyb3VuZCB7DQogICAgYmFja2dyb3VuZDogIzIyMzEzZjsNCiAgICBjb2xvcjogI0RERDsNCn0NCg0KLm5hdl9pbWFnZSB7DQogICAgaGVpZ2h0OiAxMDBweDsNCiAgICBtYXJnaW46IDI0cHggMHB4Ow0KICAgIHdpZHRoOiAxMDBweDsNCn0NCg0KLmNhc2VfaW5mbyB7DQogICAgZGlzcGxheTogZmxleDsNCiAgICBmbGV4LWRpcmVjdGlvbjogY29sdW1uOw0KICAgIG1hcmdpbjogMmVtIDJlbSAxZW0gMmVtOw0KICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7DQogICAganVzdGlmeS1jb250ZW50OiBjZW50ZXI7DQogICAgY29sb3I6ICNGRkZGRkY7DQogICAgYm9yZGVyOiAxcHggZGFzaGVkICNGRkZGRkY7DQp9DQoNCi5jYXNlX2luZm9fZGV0YWlscyB7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KICAgIHBhZGRpbmc6IDAuM2VtIDAuNWVtIDAuM2VtIDBlbTsNCiAgICB0ZXh0LWFsaWduOiBsZWZ0Ow0KfQ0KDQouY2FzZV9pbmZvX3RleHQgew0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCiAgICBwYWRkaW5nOiAwLjNlbSAwZW0gMC4zZW0gMC41ZW07DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCn0NCg0KLnRvcF9oZWFkaW5nIHsNCiAgICBjb2xvcjogI0NCNDMzNTsNCiAgICBmb250LXNpemU6IDIuNGVtOw0KICAgIG1hcmdpbjogMC41ZW0gMGVtIDBlbSAwZW07DQogICAgcGFkZGluZzogMDsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHRleHQtdHJhbnNmb3JtOiB1cHBlcmNhc2U7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KfQ0KDQouZmlyc3RfbGluZSB7DQogICAgZm9udC1zaXplOiAxLjVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMXJlbSAwIDAuNXJlbSAwOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLnNlY29uZF9saW5lIHsNCiAgICBmb250LXNpemU6IDEuMzVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogLTAuMjVyZW0gMCAycmVtIDA7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KfQ0KDQoubnVtYmVyX2xpc3Qgew0KICAgIGZvbnQtZmFtaWx5OiBSb2JvdG87DQogICAgZm9udC1zaXplOiAxLjE1ZW07DQogICAgbGluZS1oZWlnaHQ6IDEuMzU7DQogICAgbWFyZ2luLWxlZnQ6IDEwJTsNCiAgICBtYXJnaW4tcmlnaHQ6IDEwJTsNCn0NCg0KLmhlYWRpbmcgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICNhYWE7DQogICAgY29sb3I6ICNDQjQzMzU7DQogICAgZm9udC1zaXplOiAxLjJlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMGVtIDAuMzVlbTsNCiAgICBtYXgtd2lkdGg6IGF1dG87DQogICAgcGFkZGluZzogNXB4IDBweCA1cHggMHB4Ow0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB0ZXh0LXRyYW5zZm9ybTogdXBwZXJjYXNlOw0KfQ0KDQoucmVwb3J0X3NlY3Rpb24gew0KICAgIGRpc3BsYXk6IGZsZXg7DQogICAgZmxleC1kaXJlY3Rpb246IGNvbHVtbjsNCiAgICBtYXgtd2lkdGg6IGF1dG87DQp9DQoNCi5uYXZfbGlzdF9pdGVtIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICBjb2xvcjogI0RERDsNCiAgICBmb250LWZhbWlseTogdmFyKC0tbmF2QnRuRm9udEZhbWlseSk7DQogICAgZm9udC1zaXplOiB2YXIoLS1uYXZCdG5Gb250U2l6ZSk7DQogICAgaGVpZ2h0OiB2YXIoLS1uYXZCdG5IZWlnaHQpOw0KICAgIG1hcmdpbjogMC4xNWVtIDAuMzVlbTsNCiAgICBtYXgtd2lkdGg6IGF1dG87DQogICAgcGFkZGluZzogN3B4IDBweDsNCiAgICB0ZXh0LWFsaWduOiBsZWZ0Ow0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KfQ0KDQoubmF2X2xpc3RfaXRlbTpob3ZlciB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzFmNjE4ZDsNCiAgICBjb2xvcjogI0RERDsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgZm9udC1zaXplOiB2YXIoLS1uYXZCdG5Gb250U2l6ZSk7DQogICAgZm9udC13ZWlnaHQ6IDYwMDsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCi5mcm9udHBhZ2VfdGFibGUgew0KICAgIGNvbG9yOiAjRkZGRkZGOw0KICAgIGJvcmRlci1jb2xsYXBzZTogY29sbGFwc2U7DQp9DQoNCi5mcm9udHBhZ2VfdGFibGUgdGQgew0KICAgIGNvbG9yOiAjRkZGRkZGOw0KICAgIGJvcmRlci1jb2xsYXBzZTogY29sbGFwc2U7DQogICAgZm9udC1zaXplOiAxLjJlbTsNCn0NCg0KLmNhc2VfaW5mb19kZXRhaWxzIHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMC41ZW0gMC4zZW0gMGVtOw0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KfQ0KDQouY2FzZV9pbmZvX3RleHQgew0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCiAgICBwYWRkaW5nOiAwLjNlbSAwZW0gMC4zZW0gMC41ZW07DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCn0NCg0KLyogRHJvcGRvd24gQnV0dG9uICovDQouZHJvcGJ0biB7DQogICAgYm9yZGVyOiBub25lOw0KICAgIGJhY2tncm91bmQtY29sb3I6IGRvZGdlcmJsdWU7DQogICAgY29sb3I6ICNlZGU7DQogICAgZm9udC1zaXplOiAxNnB4Ow0KICAgIHBhZGRpbmc6IDE2cHg7DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5kcm9wYnRuOmhvdmVyIHsNCiAgICBib3JkZXI6IDFweCBkYXNoZWQgd2hpdGU7DQogICAgY29sb3I6ICNGRkY7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCn0NCg0KLyogVGhlIGNvbnRhaW5lciA8ZGl2PiAtIG5lZWRlZCB0byBwb3NpdGlvbiB0aGUgZHJvcGRvd24gY29udGVudCAqLw0KLmRyb3Bkb3duIHsNCiAgICBhbGlnbi1pdGVtczogY2VudGVyOw0KICAgIGRpc3BsYXk6IGlubGluZS1ibG9jazsNCiAgICBqdXN0aWZ5LWNvbnRlbnQ6IGNlbnRlcjsNCiAgICBtYXJnaW46IDEuNzVlbSAwLjM1ZW0gMGVtIDAuMzVlbTsNCiAgICBtYXgtd2lkdGg6IGF1dG87DQogICAgcG9zaXRpb246IHJlbGF0aXZlOw0KICAgIHdpZHRoOiA5NiU7DQp9DQoNCi8qIERyb3Bkb3duIENvbnRlbnQgKEhpZGRlbiBieSBEZWZhdWx0KSAqLw0KLmRyb3Bkb3duLWNvbnRlbnQgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICNmMWYxZjE7DQogICAgYm94LXNoYWRvdzogMHB4IDhweCAxNnB4IDBweCByZ2JhKDAsIDAsIDAsIDAuMik7DQogICAgZGlzcGxheTogbm9uZTsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIGhlaWdodDogMTVlbTsNCiAgICBtaW4td2lkdGg6IDE2MHB4Ow0KICAgIG92ZXJmbG93LXk6IHNjcm9sbDsNCiAgICBwb3NpdGlvbjogYWJzb2x1dGU7DQogICAgd2lkdGg6IDEwMCU7DQogICAgei1pbmRleDogMTsNCn0NCg0KLyogTGlua3MgaW5zaWRlIHRoZSBkcm9wZG93biAqLw0KLmRyb3Bkb3duLWNvbnRlbnQgYSB7DQogICAgY29sb3I6IGJsYWNrOw0KICAgIGRpc3BsYXk6IGJsb2NrOw0KICAgIG1hcmdpbi1sZWZ0OiAzcHg7DQogICAgbWFyZ2luLXJpZ2h0OiAzcHg7DQogICAgcGFkZGluZzogMTJweCAxNnB4Ow0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCn0NCg0KLyogQ2hhbmdlIGNvbG9yIG9mIGRyb3Bkb3duIGxpbmtzIG9uIGhvdmVyICovDQouZHJvcGRvd24tY29udGVudCBhOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjNTQ5OUM3Ow0KICAgIGNvbG9yOiAjRkZGOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQp9DQoNCi5kcm9wZG93bi1jb250ZW50IGE6YWN0aXZlIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjMDA3QkZGOw0KICAgIGNvbG9yOiAjRkZGOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQp9DQoNCi8qIFNob3cgdGhlIGRyb3Bkb3duIG1lbnUgb24gaG92ZXIgKi8NCi5kcm9wZG93bjpob3ZlciAuZHJvcGRvd24tY29udGVudCB7DQogICAgZGlzcGxheTogYmxvY2s7DQp9DQoNCi8qIENoYW5nZSB0aGUgYmFja2dyb3VuZCBjb2xvciBvZiB0aGUgZHJvcGRvd24gYnV0dG9uIHdoZW4gdGhlIGRyb3Bkb3duIGNvbnRlbnQgaXMgc2hvd24gKi8NCi5kcm9wZG93bjpob3ZlciAuZHJvcGJ0biB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogZG9kZ2VyYmx1ZTsNCn0NCg0KLmRhdGFfYm9keSB7DQogICAgYmFja2dyb3VuZDogIzIyMzEzZjsNCiAgICBjb2xvcjogI0RERDsNCiAgICBtYXJnaW4tdG9wOiAyZW07DQogICAgbWFyZ2luLXJpZ2h0OiA1JTsNCiAgICBtYXJnaW4tYm90dG9tOiAyZW07DQogICAgbWFyZ2luLWxlZnQ6IDUlOw0KfQ0KDQovKiBTdHlsZSB0aGUgYnV0dG9uIHRoYXQgaXMgdXNlZCB0byBvcGVuIGFuZCBjbG9zZSB0aGUgY29sbGFwc2libGUgY29udGVudCAqLw0KLmNvbGxhcHNpYmxlIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjNzc3Ow0KICAgIGJvcmRlcjogNHB4IHNvbGlkICMxODFCMjA7DQogICAgY29sb3I6ICNEREQ7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIGZvbnQtc2l6ZTogMC45NWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luOiAwZW0gMGVtIDFlbSAwZW07DQogICAgb3V0bGluZTogbm9uZTsNCiAgICBwYWRkaW5nOiAxOHB4Ow0KICAgIHRleHQtYWxpZ246IGxlZnQ7DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi8qIEFkZCBhIGJhY2tncm91bmQgY29sb3IgdG8gdGhlIGJ1dHRvbiBpZiBpdCBpcyBjbGlja2VkIG9uIChhZGQgdGhlIC5hY3RpdmUgY2xhc3Mgd2l0aCBKUyksIGFuZCB3aGVuIHlvdSBtb3ZlIHRoZSBtb3VzZSBvdmVyIGl0IChob3ZlcikgKi8NCi5hY3RpdmUsIC5jb2xsYXBzaWJsZTpob3ZlciB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzc3NzsNCiAgICBib3JkZXI6IDRweCBkYXNoZWQgZG9kZ2VyYmx1ZTsNCiAgICBjb2xvcjogI0RERDsNCiAgICBmb250LXNpemU6IDAuOTVlbTsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCi5jb2xsYXBzaWJsZTphZnRlciB7DQogICAgLyogVW5pY29kZSBjaGFyYWN0ZXIgZm9yICJwbHVzIiBzaWduICgrKSAqLw0KICAgIGNvbnRlbnQ6ICdcMDAyQic7DQogICAgZm9udC1zaXplOiAxNnB4Ow0KICAgIGZvbnQtd2VpZ2h0OiBib2xkOw0KICAgIGNvbG9yOiAjREREOw0KICAgIGZsb2F0OiByaWdodDsNCiAgICBtYXJnaW4tbGVmdDogNXB4Ow0KfQ0KDQouYWN0aXZlOmFmdGVyIHsNCiAgICAvKiBVbmljb2RlIGNoYXJhY3RlciBmb3IgIm1pbnVzIiBzaWduICgtKSAqLw0KICAgIGNvbnRlbnQ6ICdcMjAxMyc7DQogICAgZm9udC1zaXplOiAxNnB4Ow0KICAgIGZvbnQtd2VpZ2h0OiBib2xkOw0KICAgIGNvbG9yOiAjREREOw0KfQ0KDQovKiBTdHlsZSB0aGUgY29sbGFwc2libGUgY29udGVudC4gTm90ZTogaGlkZGVuIGJ5IGRlZmF1bHQgKi8NCi5jb250ZW50IHsNCiAgICBjb2xvcjogIzAwMDsNCiAgICBwYWRkaW5nOiAxLjVlbSAxLjI1ZW07DQogICAgZGlzcGxheTogbm9uZTsNCiAgICBvdmVyZmxvdzogaGlkZGVuOw0KICAgIGJhY2tncm91bmQtY29sb3I6ICNCQkI7DQp9DQoNCi5jb250ZW50IGEgew0KICAgIGNvbG9yOiAjMWY2MThkOw0KfQ0KDQoNCi5idG4gew0KICAgIGhlaWdodDogMTAwJTsNCiAgICB3aWR0aDogMTAwJTsNCiAgICAtLWJzLWJ0bi1wYWRkaW5nLXg6IDAuNzVyZW07DQogICAgLS1icy1idG4tcGFkZGluZy15OiAwLjM3NXJlbTsNCiAgICAtLWJzLWJ0bi1mb250LWZhbWlseTogOw0KICAgIC0tYnMtYnRuLWZvbnQtc2l6ZTogMXJlbTsNCiAgICAtLWJzLWJ0bi1mb250LXdlaWdodDogNDAwOw0KICAgIC0tYnMtYnRuLWxpbmUtaGVpZ2h0OiAxLjU7DQogICAgLS1icy1idG4tY29sb3I6IHZhcigtLWJzLWJvZHktY29sb3IpOw0KICAgIC0tYnMtYnRuLWJnOiB0cmFuc3BhcmVudDsNCiAgICAtLWJzLWJ0bi1ib3JkZXItd2lkdGg6IHZhcigtLWJzLWJvcmRlci13aWR0aCk7DQogICAgLS1icy1idG4tYm9yZGVyLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICAtLWJzLWJ0bi1ib3JkZXItcmFkaXVzOiB2YXIoLS1icy1ib3JkZXItcmFkaXVzKTsNCiAgICAtLWJzLWJ0bi1ob3Zlci1ib3JkZXItY29sb3I6IHRyYW5zcGFyZW50Ow0KICAgIC0tYnMtYnRuLWJveC1zaGFkb3c6IGluc2V0IDAgMXB4IDAgcmdiYSgyNTUsIDI1NSwgMjU1LCAwLjE1KSwgMCAxcHggMXB4IHJnYmEoMCwgMCwgMCwgMC4wNzUpOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLW9wYWNpdHk6IDAuNjU7DQogICAgLS1icy1idG4tZm9jdXMtYm94LXNoYWRvdzogMCAwIDAgMC4yNXJlbSByZ2JhKHZhcigtLWJzLWJ0bi1mb2N1cy1zaGFkb3ctcmdiKSwgLjUpOw0KICAgIGRpc3BsYXk6IGlubGluZS1ibG9jazsNCiAgICBwYWRkaW5nOiB2YXIoLS1icy1idG4tcGFkZGluZy15KSB2YXIoLS1icy1idG4tcGFkZGluZy14KTsNCiAgICBmb250LWZhbWlseTogdmFyKC0tYnMtYnRuLWZvbnQtZmFtaWx5KTsNCiAgICBmb250LXNpemU6IHZhcigtLWJzLWJ0bi1mb250LXNpemUpOw0KICAgIGZvbnQtd2VpZ2h0OiB2YXIoLS1icy1idG4tZm9udC13ZWlnaHQpOw0KICAgIGxpbmUtaGVpZ2h0OiB2YXIoLS1icy1idG4tbGluZS1oZWlnaHQpOw0KICAgIGNvbG9yOiB2YXIoLS1icy1idG4tY29sb3IpOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQogICAgdmVydGljYWwtYWxpZ246IG1pZGRsZTsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgLXdlYmtpdC11c2VyLXNlbGVjdDogbm9uZTsNCiAgICAtbW96LXVzZXItc2VsZWN0OiBub25lOw0KICAgIHVzZXItc2VsZWN0OiBub25lOw0KICAgIGJvcmRlcjogdmFyKC0tYnMtYnRuLWJvcmRlci13aWR0aCkgc29saWQgdmFyKC0tYnMtYnRuLWJvcmRlci1jb2xvcik7DQogICAgYm9yZGVyLXJhZGl1czogdmFyKC0tYnMtYnRuLWJvcmRlci1yYWRpdXMpOw0KICAgIGJhY2tncm91bmQtY29sb3I6IHZhcigtLWJzLWJ0bi1iZyk7DQogICAgdHJhbnNpdGlvbjogY29sb3IgMC4xNXMgZWFzZS1pbi1vdXQsIGJhY2tncm91bmQtY29sb3IgMC4xNXMgZWFzZS1pbi1vdXQsIGJvcmRlci1jb2xvciAwLjE1cyBlYXNlLWluLW91dCwgYm94LXNoYWRvdyAwLjE1cyBlYXNlLWluLW91dDsNCn0NCg0KLmJ0bi1wcmltYXJ5IHsNCiAgICAtLWJzLWJ0bi1jb2xvcjogI2ZmZjsNCiAgICAtLWJzLWJ0bi1iZzogIzBkNmVmZDsNCiAgICAtLWJzLWJ0bi1ib3JkZXItY29sb3I6ICMwZDZlZmQ7DQogICAgLS1icy1idG4taG92ZXItY29sb3I6ICNmZmY7DQogICAgLS1icy1idG4taG92ZXItYmc6ICMwYjVlZDc7DQogICAgLS1icy1idG4taG92ZXItYm9yZGVyLWNvbG9yOiAjMGE1OGNhOw0KICAgIC0tYnMtYnRuLWZvY3VzLXNoYWRvdy1yZ2I6IDQ5LCAxMzIsIDI1MzsNCiAgICAtLWJzLWJ0bi1hY3RpdmUtY29sb3I6ICNmZmY7DQogICAgLS1icy1idG4tYWN0aXZlLWJnOiAjMGE1OGNhOw0KICAgIC0tYnMtYnRuLWFjdGl2ZS1ib3JkZXItY29sb3I6ICMwYTUzYmU7DQogICAgLS1icy1idG4tYWN0aXZlLXNoYWRvdzogaW5zZXQgMCAzcHggNXB4IHJnYmEoMCwgMCwgMCwgMC4xMjUpOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLWNvbG9yOiAjZmZmOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLWJnOiAjMGQ2ZWZkOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLWJvcmRlci1jb2xvcjogIzBkNmVmZDsNCn0NCg0KLmJ0bjpob3ZlciB7DQogICAgY29sb3I6IHZhcigtLWJzLWJ0bi1ob3Zlci1jb2xvcik7DQogICAgYmFja2dyb3VuZC1jb2xvcjogdmFyKC0tYnMtYnRuLWhvdmVyLWJnKTsNCiAgICBib3JkZXItY29sb3I6IHZhcigtLWJzLWJ0bi1ob3Zlci1ib3JkZXItY29sb3IpOw0KfQ0KDQpidXR0b24gew0KICAgIHdpZHRoOiAxMDAlOw0KICAgIGhlaWdodDogMTAwJTsNCn0NCg0KdGFibGUsDQp0ciwNCnRkIHsNCiAgICBib3JkZXI6IDFweCBzb2xpZCB0cmFuc3BhcmVudDsNCiAgICBib3JkZXItY29sbGFwc2U6IGNvbGxhcHNlOw0KICAgIGhlaWdodDogMTAwJTsNCn0NCg0KDQouZ3JlZXRpbmcgew0KICAgIG1hcmdpbi10b3A6IDNyZW07DQp9DQoNCi5tZW51VGFibGUgew0KICAgIGJvcmRlci1jb2xsYXBzZTogc2VwYXJhdGU7DQogICAgLyogc3BhY2UgYmV0d2VlbiBlYWNoIGNvbHVtbiBhbmQgcm93ICovDQogICAgLyogRURJVEVEIEJZIE1BUyAtLSBmcm9tICJib3JkZXItc3BhY2luZzogM3JlbTsiICovDQogICAgYm9yZGVyLXNwYWNpbmc6IDFyZW07DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5tZW51VGFibGUgYnV0dG9uIHsNCiAgICBib3JkZXI6IDFweCBzb2xpZCB0cmFuc3BhcmVudDsNCiAgICAvKiBFRElURUQgQlkgTUFTIC0tIGZyb20gInBhZGRpbmc6IDVyZW07IiAqLw0KICAgIHBhZGRpbmc6IDJyZW07DQogICAgd2lkdGg6IDEwMCU7DQogICAgaGVpZ2h0OiAxMDAlOw0KfQ0KDQoubWVudVRhYmxlIGJ1dHRvbjpob3ZlciB7DQogICAgYm9yZGVyOiAxcHggZGFzaGVkICNmOGY4Zjg7DQogICAgZm9udC1zaXplOiAxLjFyZW07DQp9DQoNCi5tZW51SXRlbSB7DQogICAgd2lkdGg6IDIwJTsNCn0NCg0KLm1lbnVTcGFjaW5nIHsNCiAgICB3aWR0aDogNCU7DQp9DQoNCmEgew0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCn0NCg0KLmJ0blRleHQgew0KICAgIGNvbG9yOiAjZjhmOGY4Ow0KICAgIGRpc3BsYXk6IGJsb2NrOw0KICAgIG1hcmdpbjogMHJlbSAxcmVtIDByZW0gMXJlbTsNCiAgICBwb3NpdGlvbjogcmVsYXRpdmU7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICBmb250LXNpemU6IDEuMjVyZW07DQogICAgd2lkdGg6IGF1dG87DQp9DQoNCi5idG5UZXh0OjphZnRlciB7DQogICAgYmFja2dyb3VuZDogI2Y4ZjhmODsNCiAgICBib3R0b206IC0ycHg7DQogICAgY29udGVudDogIiI7DQogICAgaGVpZ2h0OiAycHg7DQogICAgbGVmdDogMDsNCiAgICBwb3NpdGlvbjogYWJzb2x1dGU7DQogICAgdHJhbnNmb3JtOiBzY2FsZVgoMCk7DQogICAgdHJhbnNmb3JtLW9yaWdpbjogcmlnaHQ7DQogICAgdHJhbnNpdGlvbjogdHJhbnNmb3JtIDAuMnMgZWFzZS1pbjsNCiAgICB3aWR0aDogYXV0bzsNCn0NCg0KLm1lbnVJdGVtOmhvdmVyIC5idG5UZXh0OjphZnRlciB7DQogICAgdHJhbnNmb3JtOiBzY2FsZVgoMSk7DQogICAgdHJhbnNmb3JtLW9yaWdpbjogbGVmdDsNCn0NCg0KQHBhZ2Ugew0KICAgIHNpemU6IEE0Ow0KDQogICAgQGJvdHRvbS1jZW50ZXIgew0KICAgICAgICBjb250ZW50OiAiUGFnZSAiY291bnRlcihwYWdlKTsNCiAgICB9DQp9DQoNCkBtZWRpYSBwcmludCB7DQogICAgLm5vLXByaW50LCAubm8tcHJpbnQgKiB7DQogICAgICAgIGRpc3BsYXk6IG5vbmU7DQogICAgfQ0KDQogICAgaHRtbCwgYm9keSB7DQogICAgICAgIG1hcmdpbjogMHJlbTsNCiAgICAgICAgYmFja2dyb3VuZDogdHJhbnNwYXJlbnQ7DQogICAgfQ0KDQogICAgLmRhdGFfYm9keSB7DQogICAgICAgIGJhY2tncm91bmQtY29sb3I6IHRyYW5zcGFyZW50Ow0KICAgICAgICBjb2xvcjogIzAwMDsNCiAgICB9DQp9
"


Export-ModuleMember -Function Write-HtmlHomePage, Write-HtmlNavPage, Write-HtmlFrontPage, Write-HtmlReadMePage, Write-MainHtmlPage -Variable HtmlHeader, HtmlFooter, ReturnHtmlSnippet, AllStyleCssEncodedText
