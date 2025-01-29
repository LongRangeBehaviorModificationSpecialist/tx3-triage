

function Write-HtmlHomePage {

    [CmdletBinding()]

    param (
        [string]$FilePath
    )

    $ReportHomePage = '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html lang="en" dir="ltr">
    <head>
        <link rel="shortcut icon" type="img/png" href="Resources/images/binary.png">
        <title>Triage Report</title>
    </head>
    <frameset cols="20%,80%" frameborder="1" border="1" framespacing="1">
        <frame name="menu" src="Resources/static/nav.html" marginheight="0" marginwidth="0" scrolling="auto">
        <frame name="content" src="Resources/static/front.html" marginheight="0" marginwidth="0" scrolling="auto">
        <!-- <frame name="content" src="Resources/front.html" marginheight="0" marginwidth="0" scrolling="auto"> -->
        <noframes>
        <p>A browser that supports HTML frames is required to view this report.</p>
        </noframes>
    </frameset>
</html>
'

    Add-Content -Path $FilePath -Value $ReportHomePage

}


function Write-NavHtmlPage {

    [CmdletBinding()]

    param (
        [string]$FilePath
    )

    $NavReportPage = '<!DOCTYPE html>

<html lang="en" dir="ltr">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie-edge">
        <title>nav.html</title>
        <link rel="stylesheet" type="text/css" href="../css/style.css" />
        <link rel="shortcut icon" type="img/png" href="../images/binary.png">

    </head>

    <body class="nav__background">

        <center>
            <img src="../images/icon-cyber-forensics.png" class="magnet-logo" />
        </center>

        <div>

            <center class="heading">Triage Report</center>

            <ul>
                <li>
                    <a href="front.html" target="content">
                        <button class="btn__1__top">Cover Page</button>
                    </a>
                </li>
                <li>
                    <a href="readme.html" target="content">
                        <button class="btn__1">Read Me First</button>
                    </a>
                </li>
            </ul>

            <center class="heading">Category Report</center>


            <a href="../pages/001_DeviceInfo.html" target="content">
                <button class="btn__1">Device Information</button>
            </a>
            <a href="../pages/002_UserInfo.html" target="content">
                <button class="btn__1">User Data</button>
            </a>
            <a href="../pages/003_NetworkInfo.html" target="content">
                <button class="btn__1">Network Information</button>
            </a>
            <a href="../pages/004_ProcessInfo.html" target="content">
                <button class="btn__1">Processes Information</button>
            </a>
            <a href="../pages/005_SystemInfo.html" target="content">
                <button class="btn__1">System Information</button>
            </a>
            <a href="../pages/006_PrefetchInfo.html" target="content">
                <button class="btn__1">Prefetch File Data</button>
            </a>
            <a href="../pages/007_EventLogInfo.html" target="content">
                <button class="btn__1">Event Log Data</button>
            </a>
            <a href="../pages/008_FirewallInfo.html" target="content">
                <button class="btn__1">Firewall Data/Settings</button>
            </a>
            <a href="../pages/009_BitLockerInfo.html" target="content">
                <button class="btn__1">BitLocker Data</button>
            </a>


        </div>

    </body>

</html>'


    Add-Content -Path $FilePath -Value $NavReportPage

}


function Write-FrontHtmlPage {

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

    $FrontReportPage = '<!DOCTYPE html>

<html lang="en" dir="ltr">

    <head>

        <title>front.html</title>

        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie-edge">

        <link rel="stylesheet" type="text/css" href="../css/style.css" />

        <link rel="shortcut icon" type="img/png" href="../images/binary.png">

    </head>

    <body class="front__background">

        <div class="caseinfo">

            <h1 class="topHeading">Triage Report</h1>

            <br>

            <table class="frontpage__table">

                <br>

                <tr>
                    <td class="caseinfo__details">Examiner <strong>:</strong></td>
                    <td class="caseinfo__text">{0}</td>
                </tr>

                <tr>
                    <td class="caseinfo__details">Report Generated <strong>:</strong></td>
                    <td class="caseinfo__text">{1}</td>
                </tr>

                <tr>
                    <td class="caseinfo__details">Computer Name <strong>:</strong></td>
                    <td class="caseinfo__text">{2}</td>
                </tr>

                <tr>
                    <td class="caseinfo__details">IPv4 Address <strong>:</strong></td>
                    <td class="caseinfo__text">{3}</td>
                </tr>

                <tr>
                    <td class="caseinfo__details">IPv6 Address <strong>:</strong></td>
                    <td class="caseinfo__text">{4}</td>
                </tr>

             </table>

            <br>

        </div>

    </body>

</html>' -f $User, $ReportGenTime, $ComputerName, $Ipv4, $Ipv6


    Add-Content -Path $FilePath -Value $FrontReportPage

}


function Write-ReadMeHtml {

    [CmdletBinding()]

    param (
        [string]$FilePath
    )

    $ReadMeReportPage = '<!DOCTYPE html>
<html lang="en" dir="ltr">

    <head>

        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie-edge">

        <link href="https://fonts.googleapis.com/css?family=Roboto&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Cinzel&display=swap" rel="stylesheet" type="text/css">

        <link rel="stylesheet" type="text/css" href="../css/readme.css">

        <link rel="shortcut icon" type="img/png" href="../images/binary.png">

        <title>Read Me</title>

    </head>

    <body>

        <div class="container">

            <div class="button-container">

                <div class="buttonTop">
                    <a href="javascript:window.print()">
                    <button class="print-button no-print">
                        <div class="btn-txt">Print Page</div>
                    </button>
                    </a>
                </div>

                <div class="buttonTop">
                    <a href="JavaScript:myUnloadEvent()">
                    <button onclick="self.close()" class="close-button no-print">
                        <div class="btn-txt">Close Window</div>
                    </button>
                    </a>
                </div>

            </div>

            <div class="heading">
                <p><strong>&mdash; &mdash; WARNING &mdash; &mdash;</strong></p>
            </div>

            <h3 class="lineFirst">CRIMINAL REPORT PRODUCT</h3>
            <h3 class="lineSecond">DIGITAL COPY</h3>

            <ol>

            <li>Enclosed is a digital copy of a criminal report by the High Tech Crimes Division (HTCD) of the Virginia State Police provided for investigator and prosecutor review.&ensp;Maintain security of this report and do not make copies.&ensp;Third party dissemination is strictly forbidden unless ordered by the Court.&ensp;The original case report is maintained by the examining agent.</li>

            <li>This report should be viewed on a computer that is not connected to the Internet or other networks as certain files within this report when viewed may attempt to access online resources.</li>

            <li>Any references to file dates and times that may be contained in this report are based upon the accuracy of the examined system when events occurred.&ensp;No representation can be made as to their accuracy at any other time than when noted during the examination.&ensp;Any prosecutorial decisions made regarding dates and times of evidentiary data should be discussed with the examiner beforehand.</li>

            <li>This report may contain images, movies, descriptions and depictions that are of a sexual nature and may involve individuals who may be under the age of eighteen.&ensp;Such items may be considered contraband for which distribution is illegal.&ensp;The digital copy of the report has been designed to minimize local storage of items viewed within this report; however, accessing such images may cause local storage of these images.</li>

            <li>It is strongly suggested that you consult with the examiner who prepared this report as you make further investigative and prosecutive decisions.&ensp;Often as the information in the report is processed, additional questions or avenues of investigation may need to be addressed and/or additional information may be available.</li>

            </ol>

        </div>

    </body>

</html>'

    Add-Content -Path $FilePath -Value $ReadMeReportPage

}







Export-ModuleMember -Function Write-HtmlHomePage, Write-NavHtmlPage, Write-FrontHtmlPage, Write-ReadMeHtml
