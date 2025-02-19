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
LyogYWxsc3R5bGUuY3NzICovDQoNCiosICo6OmJlZm9yZSwgKjo6YWZ0ZXIgew0KICAgIGJveC1zaXppbmc6IGJvcmRlci1ib3g7DQogICAgbWFyZ2luOiAwOw0KICAgIHBhZGRpbmc6IDA7DQogICAgLXdlYmtpdC1mb250LXNtb290aGluZzogYW50aWFsaWFzZWQ7DQogICAgdGV4dC1yZW5kZXJpbmc6IG9wdGltaXplTGVnaWJpbGl0eTsNCn0NCg0KaHRtbCB7DQogICAgZm9udC1mYW1pbHk6ICdTZWdvZSBVSScsIEZydXRpZ2VyLCAnRnJ1dGlnZXIgTGlub3R5cGUnLCAnRGVqYXZ1IFNhbnMnLCAnSGVsdmV0aWNhIE5ldWUnLCBBcmlhbCwgc2Fucy1zZXJpZjsNCiAgICBmb250LXdlaWdodDogMzAwOw0KfQ0KDQpib2R5IHsNCiAgICBiYWNrZ3JvdW5kOiAjMjIyOw0KICAgIGZvbnQtc2l6ZTogMWVtOw0KICAgIGNvbG9yOiAjZGRkOw0KICAgIC0tZHJvcEJ0bkNvbG9yOiAjMUU4NDQ5Ow0KICAgIC0tbmF2QnRuUGFkZGluZzogMXB4IDBweCAxcHggMTBweDsNCiAgICAtLW5hdkJ0bkNvbG9ySG92ZXI6ICMyODc0QTY7DQogICAgLS1uYXZCdG5Ib3ZlclRleHRDb2xvcjogI0ZGRkZGRjsNCiAgICAtLW5hdkJ0bkhvdmVyQm9yZGVyOiAxcHggZGFzaGVkICNGRkZGRkY7DQogICAgLS1uYXZCdG5Ib3ZlclJhZGl1czogNXB4Ow0KICAgIC0tbmF2QnRuSGVpZ2h0OiAyLjI1ZW07DQogICAgLS1uYXZCdG5XaWR0aDogOTAlOw0KICAgIC0tbmF2QnRuRm9udEZhbWlseTogJ1JvYm90byBMaWdodCc7DQogICAgLS1uYXZCdG5Gb250U2l6ZTogMS4wNWVtOw0KICAgIG1hcmdpbjogMDsNCiAgICBwYWRkaW5nOiAwOw0KfQ0KDQphIHsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCnAgew0KICAgIHdoaXRlLXNwYWNlOiBwcmUtd3JhcDsNCn0NCg0KcHJlIHsNCiAgICBmb250LXNpemU6IDEuMTVlbTsNCn0NCg0KLmJ0bl9sYWJlbCB7DQogICAgY29sb3I6ICNGRkY7DQogICAgZm9udC1zaXplOiAxLjFlbTsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIG1hcmdpbi10b3A6IDAuNWVtOw0KfQ0KDQouY2VudGVyIHsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQp9DQoNCi5yaWdodCB7DQogICAgdGV4dC1hbGlnbjogcmlnaHQ7DQp9DQoNCi5mcm9udF9iYWNrZ3JvdW5kLA0KLm5hdl9iYWNrZ3JvdW5kLA0KLnJlYWRtZV9iYWNrZ3JvdW5kIHsNCiAgICAvKiBiYWNrZ3JvdW5kOiAjMjIzMTNmOyAqLw0KICAgIGJhY2tncm91bmQ6ICMyMjI7DQogICAgY29sb3I6ICNEREQ7DQp9DQoNCi5uYXZfaW1hZ2Ugew0KICAgIGhlaWdodDogMTAwcHg7DQogICAgbWFyZ2luOiAyNHB4IDBweDsNCiAgICB3aWR0aDogMTAwcHg7DQp9DQoNCi5tYWluIHsNCiAgICBtYXJnaW46IDJlbSAyZW0gMWVtIDJlbTsNCn0NCg0KLnNlY3Rpb25faGVhZGVyIHsNCiAgICBmb250LXNpemU6IDAuOWVtOw0KICAgIG1hcmdpbjogMWVtIDBlbTsNCn0NCg0KLmNhc2VfaW5mbyB7DQogICAgYWxpZ24taXRlbXM6IGNlbnRlcjsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI0RERDsNCiAgICBjb2xvcjogI0RERDsNCiAgICBkaXNwbGF5OiBmbGV4Ow0KICAgIGZsZXgtZGlyZWN0aW9uOiBjb2x1bW47DQogICAganVzdGlmeS1jb250ZW50OiBjZW50ZXI7DQogICAgbWFyZ2luLWJvdHRvbTogMWVtOw0KICAgIHBhZGRpbmctYm90dG9tOiAxZW07DQp9DQoNCi5uYXYgew0KICAgIGFsaWduLWNvbnRlbnQ6IGNlbnRlcjsNCiAgICBhbGlnbi1pdGVtczogY2VudGVyOw0KICAgIGRpc3BsYXk6IGZsZXg7DQogICAgZmxleC1kaXJlY3Rpb246IHJvdzsNCiAgICBmbGV4LXdyYXA6IHdyYXA7DQogICAganVzdGlmeS1jb250ZW50OiBjZW50ZXI7DQogICAgbWFyZ2luOiAxLjVlbSAwZW07DQp9DQoNCi5uYXYgYSB7DQogICAgYm9yZGVyOiAxcHggc29saWQgI2RkZDsNCiAgICBjb2xvcjogZG9kZ2VyYmx1ZTsNCiAgICBwYWRkaW5nOiAxZW07DQp9DQoNCi5uYXYgYTpob3ZlciB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzQ0NDsNCiAgICBib3JkZXI6IDFweCBkYXNoZWQgI2RkZDsNCiAgICB0ZXh0LWRlY29yYXRpb246IHVuZGVybGluZTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KfQ0KDQoubmF2IC5yZWFkbWUgew0KICAgIGNvbG9yOiAjQ0I0MzM1Ow0KfQ0KDQoubmF2IC5yZWFkbWU6aG92ZXIgew0KICAgIHRleHQtZGVjb3JhdGlvbjogdW5kZXJsaW5lOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQp9DQoNCi5pdGVtX3RhYmxlIHsNCiAgICBhbGlnbi1jb250ZW50OiBjZW50ZXI7DQogICAgYWxpZ24taXRlbXM6IGNlbnRlcjsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI0RERDsNCiAgICBkaXNwbGF5OiBmbGV4Ow0KICAgIGZsZXgtZGlyZWN0aW9uOiByb3c7DQogICAgZmxleC13cmFwOiB3cmFwOw0KICAgIGp1c3RpZnktY29udGVudDogc3BhY2UtZXZlbmx5Ow0KICAgIHBhZGRpbmc6IDAuNzVlbTsNCn0NCg0KLmNhc2VfaW5mb19kZXRhaWxzIHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMC41ZW0gMC4zZW0gMGVtOw0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KfQ0KDQouY2FzZV9pbmZvX3RleHQgew0KICAgIGNvbG9yOiBkb2RnZXJibHVlOw0KICAgIGZvbnQtc2l6ZTogMS4wNWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgcGFkZGluZzogMC4zZW0gMGVtIDAuM2VtIDAuNWVtOw0KICAgIHRleHQtYWxpZ246IGxlZnQ7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCn0NCg0KLnJlYWRtZV9pbmZvIHsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI0RERDsNCiAgICBtYXJnaW46IDJlbSAyZW0gMWVtIDJlbTsNCn0NCg0KLnJlYWRtZV9saXN0IHsNCiAgICBjb2xvcjogI2RkZDsNCiAgICBmb250LWZhbWlseTogUm9ib3RvOw0KICAgIG1hcmdpbjogMWVtIDVlbTsNCn0NCg0KLnJlYWRtZV9saXN0IG9sIGxpIHsNCiAgICBmb250LXNpemU6IGxhcmdlOw0KICAgIG1hcmdpbi1ib3R0b206IDFlbTsNCn0NCg0KLnRvcF9oZWFkaW5nIHsNCiAgICBjb2xvcjogI0NCNDMzNTsNCiAgICBmb250LXNpemU6IDIuNGVtOw0KICAgIG1hcmdpbjogMC4yNWVtIDBlbSAwLjI1ZW0gMGVtOw0KICAgIHBhZGRpbmc6IDA7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICB0ZXh0LXRyYW5zZm9ybTogdXBwZXJjYXNlOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLmZpcnN0X2xpbmUgew0KICAgIGZvbnQtc2l6ZTogMS41ZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IDFyZW0gMCAwLjVyZW0gMDsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQp9DQoNCi5zZWNvbmRfbGluZSB7DQogICAgZm9udC1zaXplOiAxLjM1ZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IC0wLjI1cmVtIDAgMnJlbSAwOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLmRhdGFfYm9keSB7DQogICAgbWFyZ2luOiAyZW0gMmVtOw0KfQ0KDQouZGF0YV9ib2R5IGEsDQoubnVtYmVyX2xpc3QgYSB7DQogICAgY29sb3I6IGRvZGdlcmJsdWU7DQogICAgZGlzcGxheTogYmxvY2s7DQogICAgZm9udC1mYW1pbHk6IFJvYm90bzsNCiAgICBmb250LXNpemU6IDAuOWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luLWxlZnQ6IDFlbTsNCiAgICBwYWRkaW5nLWJvdHRvbTogMWVtOw0KfQ0KDQouZGF0YV9ib2R5IGE6aG92ZXIsDQoubnVtYmVyX2xpc3QgYTpob3ZlciB7DQogICAgYmFja2dyb3VuZDogIzQ0NDsNCiAgICBib3JkZXI6IDFweCBkYXNoZWQgd2hpdGU7DQp9DQoNCi5udW1iZXJfbGlzdCAuZmlsZV9saW5rIHsNCiAgICBjb2xvcjogIzI4YjQ2MzsNCn0NCg0KLmhlYWRpbmcgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICNhYWE7DQogICAgY29sb3I6ICNDQjQzMzU7DQogICAgZm9udC1zaXplOiAxLjJlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMGVtIDAuMzVlbTsNCiAgICBtYXgtd2lkdGg6IGF1dG87DQogICAgcGFkZGluZzogNXB4IDBweCA1cHggMHB4Ow0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB0ZXh0LXRyYW5zZm9ybTogdXBwZXJjYXNlOw0KfQ0KDQoucmVwb3J0X3NlY3Rpb24gew0KICAgIGRpc3BsYXk6IGZsZXg7DQogICAgZmxleC1kaXJlY3Rpb246IGNvbHVtbjsNCiAgICBtYXgtd2lkdGg6IGF1dG87DQp9DQoNCi5uYXZfbGlzdF9pdGVtIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICBjb2xvcjogI0NCNDMzNTsNCiAgICBmb250LWZhbWlseTogdmFyKC0tbmF2QnRuRm9udEZhbWlseSk7DQogICAgZm9udC1zaXplOiB2YXIoLS1uYXZCdG5Gb250U2l6ZSk7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICBoZWlnaHQ6IHZhcigtLW5hdkJ0bkhlaWdodCk7DQogICAgbWFyZ2luOiAwLjE1ZW0gMC4zNWVtOw0KICAgIG1heC13aWR0aDogYXV0bzsNCiAgICBwYWRkaW5nOiA3cHggMHB4Ow0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KfQ0KDQoubmF2X2xpc3RfaXRlbTpob3ZlciB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzFmNjE4ZDsNCiAgICBjb2xvcjogI0RERDsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgZm9udC1zaXplOiB2YXIoLS1uYXZCdG5Gb250U2l6ZSk7DQogICAgZm9udC13ZWlnaHQ6IDYwMDsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCi5mcm9udHBhZ2VfdGFibGUgew0KICAgIGJvcmRlci1jb2xsYXBzZTogY29sbGFwc2U7DQogICAgY29sb3I6ICNEREQ7DQogICAgdGFibGUtbGF5b3V0OiBmaXhlZDsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLyogU3R5bGUgdGhlIGJ1dHRvbiB0aGF0IGlzIHVzZWQgdG8gb3BlbiBhbmQgY2xvc2UgdGhlIGNvbGxhcHNpYmxlIGNvbnRlbnQgKi8NCi5jb2xsYXBzaWJsZSB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzc3NzsNCiAgICBib3JkZXI6IDRweCBzb2xpZCB0cmFuc3BhcmVudDsNCiAgICBib3JkZXItcmFkaXVzOiAwLjM3NWVtOw0KICAgIGNvbG9yOiAjREREOw0KICAgIGN1cnNvcjogcG9pbnRlcjsNCiAgICBmb250LXNpemU6IDAuOTVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMGVtOw0KICAgIG91dGxpbmU6IG5vbmU7DQogICAgcGFkZGluZzogMThweDsNCiAgICB0ZXh0LWFsaWduOiBsZWZ0Ow0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQovKiBBZGQgYSBiYWNrZ3JvdW5kIGNvbG9yIHRvIHRoZSBidXR0b24gaWYgaXQgaXMgY2xpY2tlZCBvbiAoYWRkIHRoZSAuYWN0aXZlIGNsYXNzIHdpdGggSlMpLCBhbmQgd2hlbiB5b3UgbW92ZSB0aGUgbW91c2Ugb3ZlciBpdCAoaG92ZXIpICovDQouY29sbGFwc2libGU6aG92ZXIgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICM3Nzc7DQogICAgYm9yZGVyOiA0cHggZGFzaGVkICNkYzM1NDU7DQogICAgY29sb3I6ICNEREQ7DQogICAgZm9udC1zaXplOiAwLjk1ZW07DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KfQ0KDQouYnRuIHsNCiAgICBoZWlnaHQ6IDEwMCU7DQogICAgd2lkdGg6IDEwMCU7DQogICAgLS1icy1idG4tcGFkZGluZy14OiAwLjc1cmVtOw0KICAgIC0tYnMtYnRuLXBhZGRpbmcteTogMC4zNzVyZW07DQogICAgLS1icy1idG4tZm9udC1mYW1pbHk6IDsNCiAgICAtLWJzLWJ0bi1mb250LXNpemU6IDFyZW07DQogICAgLS1icy1idG4tZm9udC13ZWlnaHQ6IDQwMDsNCiAgICAtLWJzLWJ0bi1saW5lLWhlaWdodDogMS41Ow0KICAgIC0tYnMtYnRuLWNvbG9yOiB2YXIoLS1icy1ib2R5LWNvbG9yKTsNCiAgICAtLWJzLWJ0bi1iZzogdHJhbnNwYXJlbnQ7DQogICAgLS1icy1idG4tYm9yZGVyLXdpZHRoOiAycHg7DQogICAgLS1icy1idG4tYm9yZGVyLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICAtLWJzLWJ0bi1ib3JkZXItcmFkaXVzOiAwLjM3NXJlbTsNCiAgICAtLWJzLWJ0bi1ob3Zlci1ib3JkZXItY29sb3I6IHRyYW5zcGFyZW50Ow0KICAgIC0tYnMtYnRuLWJveC1zaGFkb3c6IGluc2V0IDAgMXB4IDAgcmdiYSgyNTUsIDI1NSwgMjU1LCAwLjE1KSwgMCAxcHggMXB4IHJnYmEoMCwgMCwgMCwgMC4wNzUpOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLW9wYWNpdHk6IDAuNjU7DQogICAgLS1icy1idG4tZm9jdXMtYm94LXNoYWRvdzogMCAwIDAgMC4yNXJlbSByZ2JhKHZhcigtLWJzLWJ0bi1mb2N1cy1zaGFkb3ctcmdiKSwgLjUpOw0KICAgIGRpc3BsYXk6IGlubGluZS1ibG9jazsNCiAgICBwYWRkaW5nOiB2YXIoLS1icy1idG4tcGFkZGluZy15KSB2YXIoLS1icy1idG4tcGFkZGluZy14KTsNCiAgICBmb250LWZhbWlseTogdmFyKC0tYnMtYnRuLWZvbnQtZmFtaWx5KTsNCiAgICBmb250LXNpemU6IHZhcigtLWJzLWJ0bi1mb250LXNpemUpOw0KICAgIGZvbnQtd2VpZ2h0OiB2YXIoLS1icy1idG4tZm9udC13ZWlnaHQpOw0KICAgIGxpbmUtaGVpZ2h0OiB2YXIoLS1icy1idG4tbGluZS1oZWlnaHQpOw0KICAgIGNvbG9yOiB2YXIoLS1icy1idG4tY29sb3IpOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQogICAgdmVydGljYWwtYWxpZ246IG1pZGRsZTsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgLXdlYmtpdC11c2VyLXNlbGVjdDogbm9uZTsNCiAgICAtbW96LXVzZXItc2VsZWN0OiBub25lOw0KICAgIHVzZXItc2VsZWN0OiBub25lOw0KICAgIGJvcmRlcjogdmFyKC0tYnMtYnRuLWJvcmRlci13aWR0aCkgc29saWQgdmFyKC0tYnMtYnRuLWJvcmRlci1jb2xvcik7DQogICAgYm9yZGVyLXJhZGl1czogdmFyKC0tYnMtYnRuLWJvcmRlci1yYWRpdXMpOw0KICAgIGJhY2tncm91bmQtY29sb3I6IHZhcigtLWJzLWJ0bi1iZyk7DQogICAgdHJhbnNpdGlvbjogY29sb3IgMC4xNXMgZWFzZS1pbi1vdXQsIGJhY2tncm91bmQtY29sb3IgMC4xNXMgZWFzZS1pbi1vdXQsIGJvcmRlci1jb2xvciAwLjE1cyBlYXNlLWluLW91dCwgYm94LXNoYWRvdyAwLjE1cyBlYXNlLWluLW91dDsNCn0NCg0KLmJ0bi1wcmltYXJ5IHsNCiAgICAtLWJzLWJ0bi1jb2xvcjogI2ZmZjsNCiAgICAtLWJzLWJ0bi1iZzogIzBkNmVmZDsNCiAgICAtLWJzLWJ0bi1ib3JkZXItY29sb3I6ICMwZDZlZmQ7DQogICAgLS1icy1idG4taG92ZXItY29sb3I6ICNmZmY7DQogICAgLS1icy1idG4taG92ZXItYmc6ICMwYjVlZDc7DQogICAgLS1icy1idG4taG92ZXItYm9yZGVyLWNvbG9yOiAjMGE1OGNhOw0KICAgIC0tYnMtYnRuLWZvY3VzLXNoYWRvdy1yZ2I6IDQ5LCAxMzIsIDI1MzsNCiAgICAtLWJzLWJ0bi1hY3RpdmUtY29sb3I6ICNmZmY7DQogICAgLS1icy1idG4tYWN0aXZlLWJnOiAjMGE1OGNhOw0KICAgIC0tYnMtYnRuLWFjdGl2ZS1ib3JkZXItY29sb3I6ICMwYTUzYmU7DQogICAgLS1icy1idG4tYWN0aXZlLXNoYWRvdzogaW5zZXQgMCAzcHggNXB4IHJnYmEoMCwgMCwgMCwgMC4xMjUpOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLWNvbG9yOiAjZmZmOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLWJnOiAjMGQ2ZWZkOw0KICAgIC0tYnMtYnRuLWRpc2FibGVkLWJvcmRlci1jb2xvcjogIzBkNmVmZDsNCn0NCg0KLmJ0bi1yZWFkbWUgew0KICAgIGJhY2tncm91bmQ6ICNkYzM1NDU7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNkYzM1NDU7DQogICAgY29sb3I6ICNkZGQ7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCn0NCg0KLmJ0bi1yZWFkbWU6aG92ZXIgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICNiYjJkM2I7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNkZGQ7DQogICAgY29sb3I6ICNkZGQ7DQp9DQoNCi5idG4tcHJpbWFyeTpob3ZlciB7DQogICAgY29sb3I6IHZhcigtLWJzLWJ0bi1ob3Zlci1jb2xvcik7DQogICAgYmFja2dyb3VuZC1jb2xvcjogdmFyKC0tYnMtYnRuLWhvdmVyLWJnKTsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI0Y4RjhGODsNCn0NCg0KLmZpbGVfYnRuLA0KLml0ZW1fYnRuLA0KLm5vX2luZm9fYnRuIHsNCiAgICBib3JkZXItcmFkaXVzOiAwLjM3NWVtOw0KICAgIGNvbG9yOiAjY2NjOw0KICAgIGN1cnNvcjogcG9pbnRlcjsNCiAgICBkaXNwbGF5OiBpbmxpbmUtYmxvY2s7DQogICAgZm9udC1zaXplOiAwLjk1ZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IDAuNWVtIDAuNWVtIDAuNWVtIDAuNWVtOw0KICAgIG91dGxpbmU6IG5vbmU7DQogICAgcGFkZGluZzogMS4yNWVtOw0KICAgIHRleHQtYWxpZ246IGxlZnQ7DQogICAgd2lkdGg6IGF1dG87DQp9DQoNCi5maWxlX2J0biB7DQogICAgYmFja2dyb3VuZDogIzE5ODc1NDsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgIzE5ODc1NDsNCn0NCg0KLml0ZW1fYnRuIHsNCiAgICBiYWNrZ3JvdW5kOiAjMGQ2ZWZkOw0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjMGQ2ZWZkOw0KfQ0KDQoubm9faW5mb19idG4gew0KICAgIGJhY2tncm91bmQ6ICM2Yzc1N2Q7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICM2Yzc1N2Q7DQp9DQoNCi5maWxlX2J0bjpob3ZlciwNCi5pdGVtX2J0bjpob3ZlciwNCi5ub19pbmZvX2J0bjpob3ZlciB7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNjY2M7DQp9DQoNCi5maWxlX2J0bjpob3ZlciB7DQogICAgYmFja2dyb3VuZDogIzE1NzM0NzsNCn0NCg0KLml0ZW1fYnRuOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kOiAjMGI1ZWQ3Ow0KfQ0KDQoubm9faW5mb19idG46aG92ZXIgew0KICAgIGJhY2tncm91bmQ6ICM1YzYzNmE7DQp9DQoNCi5maWxlX2J0bl9sYWJlbCwNCi5pdGVtX2J0bl9sYWJlbCB7DQogICAgY29sb3I6ICNjY2M7DQogICAgZm9udC1zaXplOiAxLjFlbTsNCiAgICBmb250LXdlaWdodDogbm9ybWFsOw0KICAgIG1hcmdpbi10b3A6IDAuNWVtOw0KfQ0KDQouZmlsZV9idG5fdGV4dCwNCi5pdGVtX2J0bl90ZXh0LA0KLm5vX2luZm9fYnRuX3RleHQgew0KICAgIGNvbG9yOiAjZjhmOGY4Ow0KICAgIGRpc3BsYXk6IGJsb2NrOw0KICAgIG1hcmdpbjogMGVtOw0KICAgIHBvc2l0aW9uOiByZWxhdGl2ZTsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KICAgIGZvbnQtc2l6ZTogMS4xZW07DQogICAgd2lkdGg6IGF1dG87DQp9DQoNCi5idG5UZXh0IHsNCiAgICBjb2xvcjogI2Y4ZjhmODsNCiAgICBkaXNwbGF5OiBpbmxpbmU7DQogICAgbWFyZ2luOiAwcmVtIDFyZW0gMHJlbSAxcmVtOw0KICAgIHBvc2l0aW9uOiByZWxhdGl2ZTsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KICAgIGZvbnQtc2l6ZTogMS4yNXJlbTsNCiAgICB3aWR0aDogYXV0bzsNCn0NCg0KLmJ0blRleHQ6OmFmdGVyIHsNCiAgICBiYWNrZ3JvdW5kOiAjZjhmOGY4Ow0KICAgIGJvdHRvbTogLTJweDsNCiAgICBjb250ZW50OiAiIjsNCiAgICBoZWlnaHQ6IDJweDsNCiAgICBsZWZ0OiAwOw0KICAgIHBvc2l0aW9uOiBhYnNvbHV0ZTsNCiAgICB0cmFuc2Zvcm06IHNjYWxlWCgwKTsNCiAgICB0cmFuc2Zvcm0tb3JpZ2luOiByaWdodDsNCiAgICB0cmFuc2l0aW9uOiB0cmFuc2Zvcm0gMC4ycyBlYXNlLWluOw0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQoubWVudUl0ZW06aG92ZXIgLmJ0blRleHQ6OmFmdGVyIHsNCiAgICB0cmFuc2Zvcm06IHNjYWxlWCgxKTsNCiAgICB0cmFuc2Zvcm0tb3JpZ2luOiBsZWZ0Ow0KfQ0KDQpidXR0b24gew0KICAgIHdpZHRoOiAxMDAlOw0KICAgIGhlaWdodDogMTAwJTsNCn0NCg0KdGFibGUsDQp0ciwNCnRkIHsNCiAgICBib3JkZXI6IDFweCBzb2xpZCB0cmFuc3BhcmVudDsNCiAgICBib3JkZXItY29sbGFwc2U6IGNvbGxhcHNlOw0KICAgIGhlaWdodDogMTAwJTsNCn0NCg0KLm1lbnVUYWJsZSB7DQogICAgYm9yZGVyLWNvbGxhcHNlOiBzZXBhcmF0ZTsNCiAgICBib3JkZXItc3BhY2luZzogMWVtOw0KICAgIG1hcmdpbi10b3A6IDFlbTsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLm1lbnVUYWJsZSBidXR0b24gew0KICAgIGJvcmRlcjogMXB4IHNvbGlkIHRyYW5zcGFyZW50Ow0KICAgIHBhZGRpbmc6IDJyZW07DQogICAgd2lkdGg6IDEwMCU7DQogICAgaGVpZ2h0OiAxMDAlOw0KfQ0KDQoubWVudUl0ZW0gew0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCB0cmFuc3BhcmVudDsNCiAgICB3aWR0aDogMjAlOw0KfQ0KDQpAcGFnZSB7DQogICAgc2l6ZTogQTQ7DQoNCiAgICBAYm90dG9tLWNlbnRlciB7DQogICAgICAgIGNvbnRlbnQ6ICJQYWdlICJjb3VudGVyKHBhZ2UpOw0KICAgIH0NCn0NCg0KQG1lZGlhIHByaW50IHsNCiAgICAubm8tcHJpbnQsIC5uby1wcmludCAqIHsNCiAgICAgICAgZGlzcGxheTogbm9uZTsNCiAgICB9DQoNCiAgICBodG1sLCBib2R5IHsNCiAgICAgICAgbWFyZ2luOiAwcmVtOw0KICAgICAgICBiYWNrZ3JvdW5kOiB0cmFuc3BhcmVudDsNCiAgICB9DQoNCiAgICAuZGF0YV9ib2R5IHsNCiAgICAgICAgYmFja2dyb3VuZC1jb2xvcjogdHJhbnNwYXJlbnQ7DQogICAgICAgIGNvbG9yOiAjMDAwOw0KICAgIH0NCn0=
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

            <div class='nav'>
                <a class='readme' href='Resources\static\readme.html' target='_blank'><strong>Read Me First</strong></a>
            </div>

            <div class='data_body'>
"

    Add-Content -Path $FilePath -Value $MainReportPage -Encoding UTF8
}

function Write-MainHtmlPageEnd {

    param (
        [string]$FilePath
    )

    $MainHtmlPageEnd = "
        </div>
    </body>
</html>"

    Add-Content -Path $FilePath -Value $MainHtmlPageEnd -Encoding UTF8

}


Export-ModuleMember -Function Write-HtmlReadMePage, Write-MainHtmlPage, Write-MainHtmlPageEnd -Variable HtmlHeader, HtmlFooter, ReturnHtmlSnippet, AllStyleCssEncodedText
