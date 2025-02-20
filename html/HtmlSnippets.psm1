# Assigning variables to use in the script
$HtmlHeader = "<!DOCTYPE html>

<html lang='en' dir='ltr'>
    <head>
        <title>$($ComputerName) Triage Data</title>

        <meta charset='utf-8' />
        <meta name='viewport' content='width=device-width, initial-scale=1.0' />
        <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1' />

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
        <div class='main'>
"


# Variable to ass the "Return to Top" link next to each header
$ReturnHtmlSnippet = "<a href='#top' class='top'>(Return to Top)</a>"


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

    <body class='background'>

        <div class='readme_info'>

            <div class='top_heading'>&mdash; WARNING &mdash;</div>

            <h3 class='first_line'>CRIMINAL REPORT PRODUCT</h3>
            <h3 class='second_line'>DIGITAL COPY</h3>

            <div class='readme_list'>

                <ol type='1'>

                    <li> Enclosed is a digital copy of a criminal report by the High Tech Crimes Division (HTCD) of the Virginia State Police provided for investigator and prosecutor review.&ensp;Maintain security of this report and do not make copies.&ensp;Third party dissemination is strictly forbidden unless ordered by the Court.&ensp;The original case report is maintained by the examining agent.</li>

                    <li> This report should be viewed on a computer that is not connected to the Internet or other networks as certain files within this report when viewed may attempt to access online resources.</li>

                    <li> Any references to file dates and times that may be contained in this report are based upon the accuracy of the examined system when events occurred.&ensp;No representation can be made as to their accuracy at any other time than when noted during the examination.&ensp;Any prosecutorial decisions made regarding dates and times of evidentiary data should be discussed with the examiner beforehand.</li>

                    <li> This report may contain images, movies, descriptions and depictions that are of a sexual nature and may involve individuals who may be under the age of eighteen.&ensp;Such items may be considered contraband for which distribution is illegal.&ensp;The digital copy of the report has been designed to minimize local storage of items viewed within this report; however, accessing such images may cause local storage of these images.</li>

                    <li> It is strongly suggested that you consult with the examiner who prepared this report as you make further investigative and prosecutive decisions.&ensp;Often as the information in the report is processed, additional questions or avenues of investigation may need to be addressed and/or additional information may be available.</li>

                </ol>
            </div>
        </div>
    </body>
</html>"


    Add-Content -Path $FilePath -Value $ReadMeReportPage -Encoding UTF8
}


$AllStyleCssEncodedText = "
LyogYWxsc3R5bGUuY3NzICovDQoNCiosICo6OmJlZm9yZSwgKjo6YWZ0ZXIgew0KICAgIGJveC1zaXppbmc6IGJvcmRlci1ib3g7DQogICAgbWFyZ2luOiAwOw0KICAgIHBhZGRpbmc6IDA7DQogICAgLXdlYmtpdC1mb250LXNtb290aGluZzogYW50aWFsaWFzZWQ7DQogICAgdGV4dC1yZW5kZXJpbmc6IG9wdGltaXplTGVnaWJpbGl0eTsNCn0NCg0KaHRtbCB7DQogICAgZm9udC1mYW1pbHk6ICdTZWdvZSBVSScsIEZydXRpZ2VyLCAnRnJ1dGlnZXIgTGlub3R5cGUnLCAnRGVqYXZ1IFNhbnMnLCAnSGVsdmV0aWNhIE5ldWUnLCBBcmlhbCwgc2Fucy1zZXJpZjsNCiAgICBmb250LXdlaWdodDogMzAwOw0KfQ0KDQpib2R5IHsNCiAgICBiYWNrZ3JvdW5kOiAjMjIyOw0KICAgIGZvbnQtc2l6ZTogMWVtOw0KICAgIGNvbG9yOiAjREREOw0KICAgIG1hcmdpbjogMDsNCiAgICBwYWRkaW5nOiAwOw0KfQ0KDQphIHsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCnAgew0KICAgIHdoaXRlLXNwYWNlOiBwcmUtd3JhcDsNCn0NCg0KcHJlIHsNCiAgICBmb250LXNpemU6IDEuMTVlbTsNCn0NCg0KLmJhY2tncm91bmQgew0KICAgIGJhY2tncm91bmQ6ICMyMjI7DQogICAgY29sb3I6ICNEREQ7DQp9DQoNCi5tYWluIHsNCiAgICBtYXJnaW46IDJlbSAyZW0gMWVtIDJlbTsNCn0NCg0KLnNlY3Rpb25faGVhZGVyIHsNCiAgICBtYXJnaW46IDFlbSAwZW07DQogICAgdGV4dC1kZWNvcmF0aW9uOiB1bmRlcmxpbmU7DQp9DQoNCi5jYXNlX2luZm8gew0KICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNEREQ7DQogICAgY29sb3I6ICNEREQ7DQogICAgZGlzcGxheTogZmxleDsNCiAgICBmbGV4LWRpcmVjdGlvbjogY29sdW1uOw0KICAgIGp1c3RpZnktY29udGVudDogY2VudGVyOw0KICAgIG1hcmdpbi1ib3R0b206IDFlbTsNCiAgICBwYWRkaW5nLWJvdHRvbTogMWVtOw0KfQ0KDQoubmF2IHsNCiAgICBhbGlnbi1jb250ZW50OiBjZW50ZXI7DQogICAgYWxpZ24taXRlbXM6IGNlbnRlcjsNCiAgICBkaXNwbGF5OiBmbGV4Ow0KICAgIGZsZXgtZGlyZWN0aW9uOiByb3c7DQogICAgZmxleC13cmFwOiB3cmFwOw0KICAgIGp1c3RpZnktY29udGVudDogY2VudGVyOw0KICAgIG1hcmdpbjogMS41ZW0gMGVtOw0KfQ0KDQoubmF2IGEgew0KICAgIGJvcmRlcjogMXB4IHNvbGlkICNEREQ7DQogICAgY29sb3I6IGRvZGdlcmJsdWU7DQogICAgcGFkZGluZzogMWVtOw0KfQ0KDQoubmF2IGE6aG92ZXIgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICM0NDQ7DQogICAgYm9yZGVyOiAxcHggZGFzaGVkICNEREQ7DQogICAgdGV4dC1kZWNvcmF0aW9uOiB1bmRlcmxpbmU7DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCn0NCg0KLm5hdiAucmVhZG1lIHsNCiAgICBjb2xvcjogI0NCNDMzNTsNCn0NCg0KLm5hdiAucmVhZG1lOmhvdmVyIHsNCiAgICB0ZXh0LWRlY29yYXRpb246IHVuZGVybGluZTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KfQ0KDQouY2FzZV9pbmZvX2RldGFpbHMgew0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCiAgICBwYWRkaW5nOiAwLjNlbSAwLjVlbSAwLjNlbSAwZW07DQogICAgdGV4dC1hbGlnbjogcmlnaHQ7DQp9DQoNCi5jYXNlX2luZm9fdGV4dCB7DQogICAgY29sb3I6IGRvZGdlcmJsdWU7DQogICAgZm9udC1zaXplOiAxLjA1ZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBwYWRkaW5nOiAwLjNlbSAwZW0gMC4zZW0gMC41ZW07DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KfQ0KDQoucmVhZG1lX2luZm8gew0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjREREOw0KICAgIG1hcmdpbjogMmVtIDJlbSAxZW0gMmVtOw0KfQ0KDQoucmVhZG1lX2xpc3Qgew0KICAgIGNvbG9yOiAjREREOw0KICAgIGZvbnQtZmFtaWx5OiBSb2JvdG87DQogICAgbWFyZ2luOiAxZW0gNWVtOw0KfQ0KDQoucmVhZG1lX2xpc3Qgb2wgbGkgew0KICAgIGZvbnQtc2l6ZTogbGFyZ2U7DQogICAgbWFyZ2luLWJvdHRvbTogMWVtOw0KfQ0KDQoudG9wX2hlYWRpbmcgew0KICAgIGNvbG9yOiAjQ0I0MzM1Ow0KICAgIGZvbnQtc2l6ZTogMi40ZW07DQogICAgbWFyZ2luOiAwLjI1ZW0gMGVtIDAuMjVlbSAwZW07DQogICAgcGFkZGluZzogMDsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHRleHQtdHJhbnNmb3JtOiB1cHBlcmNhc2U7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQouZmlyc3RfbGluZSB7DQogICAgZm9udC1zaXplOiAxLjVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMXJlbSAwIDAuNXJlbSAwOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLnNlY29uZF9saW5lIHsNCiAgICBmb250LXNpemU6IDEuMzVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogLTAuMjVyZW0gMCAycmVtIDA7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KfQ0KDQoubnVtYmVyX2xpc3QgYSwNCi5kYXRhX2JvZHkgYSB7DQogICAgY29sb3I6IGRvZGdlcmJsdWU7DQogICAgZGlzcGxheTogYmxvY2s7DQogICAgZm9udC1mYW1pbHk6IFJvYm90bzsNCiAgICBmb250LXNpemU6IDFlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbi1sZWZ0OiAxZW07DQogICAgcGFkZGluZy1ib3R0b206IDFlbTsNCn0NCg0KLmRhdGFfYm9keSBhOmhvdmVyLA0KLm51bWJlcl9saXN0IGE6aG92ZXIgew0KICAgIGJhY2tncm91bmQ6ICM0NDQ7DQogICAgYm9yZGVyOiAxcHggZGFzaGVkIHdoaXRlOw0KfQ0KDQoubnVtYmVyX2xpc3QgLmZpbGVfbGluayB7DQogICAgY29sb3I6ICMyOEI0NjM7DQp9DQoNCi5mcm9udHBhZ2VfdGFibGUgew0KICAgIGJvcmRlci1jb2xsYXBzZTogY29sbGFwc2U7DQogICAgY29sb3I6ICNEREQ7DQogICAgdGFibGUtbGF5b3V0OiBmaXhlZDsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KYnV0dG9uIHsNCiAgICB3aWR0aDogMTAwJTsNCiAgICBoZWlnaHQ6IDEwMCU7DQp9DQoNCnRhYmxlLA0KdHIsDQp0ZCB7DQogICAgYm9yZGVyOiAxcHggc29saWQgdHJhbnNwYXJlbnQ7DQogICAgYm9yZGVyLWNvbGxhcHNlOiBjb2xsYXBzZTsNCiAgICBoZWlnaHQ6IDEwMCU7DQp9DQoNCkBwYWdlIHsNCiAgICBzaXplOiBBNDsNCg0KICAgIEBib3R0b20tY2VudGVyIHsNCiAgICAgICAgY29udGVudDogIlBhZ2UgImNvdW50ZXIocGFnZSk7DQogICAgfQ0KfQ0KDQpAbWVkaWEgcHJpbnQgew0KICAgIC5uby1wcmludCwgLm5vLXByaW50ICogew0KICAgICAgICBkaXNwbGF5OiBub25lOw0KICAgIH0NCg0KICAgIGh0bWwsIGJvZHkgew0KICAgICAgICBtYXJnaW46IDByZW07DQogICAgICAgIGJhY2tncm91bmQ6IHRyYW5zcGFyZW50Ow0KICAgIH0NCg0KICAgIC5kYXRhX2JvZHkgew0KICAgICAgICBiYWNrZ3JvdW5kLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICAgICAgY29sb3I6ICMwMDA7DQogICAgfQ0KfQ==
"


function Write-MainHtmlPage {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $FilePath,
        [Parameter(Mandatory, Position = 1)]
        [string]
        $User,
        [Parameter(Mandatory, Position = 2)]
        [string]
        $Agency,
        [Parameter(Mandatory, Position = 3)]
        [string]
        $CaseNumber,
        [Parameter(Mandatory, Position = 4)]
        [string]
        $ComputerName,
        [Parameter(Mandatory, Position = 5)]
        [string]
        $Ipv4,
        [Parameter(Mandatory, Position = 6)]
        [string]
        $Ipv6
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

    <body class='background'>
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

            <div class='nav'>
                <a class='readme' href='Resources\static\readme.html' target='_blank'><strong>Read Me First</strong></a>
            </div>

            <div class='data_body'>
"

    Add-Content -Path $FilePath -Value $MainReportPage -Encoding UTF8
}


Export-ModuleMember -Function Write-HtmlReadMePage, Write-MainHtmlPage -Variable HtmlHeader, HtmlFooter, ReturnHtmlSnippet, AllStyleCssEncodedText
