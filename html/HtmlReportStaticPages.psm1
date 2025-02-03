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

        <frame name='menu' src='Resources/static/nav.html' marginheight='0' marginwidth='0' scrolling='auto'>
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

        <link rel='stylesheet' type='text/css' href='../css/nav.css' />

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

    <body class='nav__background'>

        <div class='center'>
            <img src='../images/customLogo.png' class='nav-image' />
        </div>

        <div>

            <div class='heading'>Triage Report</div>

            <div class='report-section'>

                <button class='nav-list-item'>
                    <a href='./front.html' target='content'>Cover Page</a>
                </button>

                <button class='nav-list-item'>
                    <a href='./readme.html' target='content'>Read Me First</a>
                </button>

            </div>

            <div class='heading'>Category Report</div>

            <div class='report-section'>

                <button class='nav-list-item'>
                    <a href='../pages/001_DeviceInfo.html' target='content'>Device Information</a>
                </button>

                <button class='nav-list-item'>
                    <a href='../pages/002_UserInfo.html' target='content'>User Data</a>
                </button>

                <button class='nav-list-item'>
                    <a href='../pages/003_NetworkInfo.html' target='content'>Network Information</a>
                </button>

                <button class='nav-list-item'>
                    <a href='../pages/004_ProcessInfo.html' target='content'>Processes Information</a>
                </button>

                <button class='nav-list-item'>
                    <a href='../pages/005_SystemInfo.html' target='content'>System Information</a>
                </button>

                <button class='nav-list-item'>
                    <a href='../pages/006_PrefetchInfo.html' target='content'>Prefetch File Data</a>
                </button>

                <button class='nav-list-item'>
                    <a href='../pages/007_EventLogInfo.html' target='content'>Event Log Data</a>
                </button>

                <button class='nav-list-item'>
                    <a href='../pages/008_FirewallInfo.html' target='content'>Firewall Data/Settings</a>
                </button>

                <button class='nav-list-item'>
                    <a href='../pages/009_BitLockerInfo.html' target='content'>BitLocker Data</a>
                </button>

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

        <link rel='stylesheet' type='text/css' href='../css/front.css' />

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

    <body class='front__background'>

        <div class='caseinfo'>

            <h1 class='topHeading'>Triage Report</h1>

            <br>

            <table class='frontpage__table'>

                <br>

                <tr>
                    <td class='caseinfo__details'>Examiner <strong>:</strong></td>
                    <td class='caseinfo__text'>$($User)</td>
                </tr>

                <tr>
                    <td class='caseinfo__details'>Report Generated <strong>:</strong></td>
                    <td class='caseinfo__text'>$($ReportGenTime) ET</td>
                </tr>

                <tr>
                    <td class='caseinfo__details'>Computer Name <strong>:</strong></td>
                    <td class='caseinfo__text'>$($ComputerName)</td>
                </tr>

                <tr>
                    <td class='caseinfo__details'>IPv4 Address <strong>:</strong></td>
                    <td class='caseinfo__text'>$($Ipv4)</td>
                </tr>

                <tr>
                    <td class='caseinfo__details'>IPv6 Address <strong>:</strong></td>
                    <td class='caseinfo__text'>$($Ipv6)</td>
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

        <link rel='stylesheet' type='text/css' href='../css/readme.css' />

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

    <body class='readme-background'>

        <div class='caseinfo'>

            <div class='topHeading'>&mdash; &mdash; WARNING &mdash; &mdash;</div>

            <h3 class='lineFirst'>CRIMINAL REPORT PRODUCT</h3>
            <h3 class='lineSecond'>DIGITAL COPY</h3>

            <div class='numList'>

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


Export-ModuleMember -Function Write-HtmlHomePage, Write-HtmlNavPage, Write-HtmlFrontPage, Write-HtmlReadMePage
