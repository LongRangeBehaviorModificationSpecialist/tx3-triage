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
LyogYWxsc3R5bGUuY3NzICovDQoNCiosICo6OmJlZm9yZSwgKjo6YWZ0ZXIgew0KICAgIGJveC1zaXppbmc6IGJvcmRlci1ib3g7DQogICAgbWFyZ2luOiAwOw0KICAgIHBhZGRpbmc6IDA7DQogICAgLXdlYmtpdC1mb250LXNtb290aGluZzogYW50aWFsaWFzZWQ7DQogICAgdGV4dC1yZW5kZXJpbmc6IG9wdGltaXplTGVnaWJpbGl0eTsNCn0NCg0KaHRtbCB7DQogICAgZm9udC1mYW1pbHk6ICdTZWdvZSBVSScsIEZydXRpZ2VyLCAnRnJ1dGlnZXIgTGlub3R5cGUnLCAnRGVqYXZ1IFNhbnMnLCAnSGVsdmV0aWNhIE5ldWUnLCBBcmlhbCwgc2Fucy1zZXJpZjsNCiAgICBmb250LXdlaWdodDogMzAwOw0KfQ0KDQpib2R5IHsNCiAgICBiYWNrZ3JvdW5kOiAjZmZmOw0KICAgIGZvbnQtc2l6ZTogMWVtOw0KICAgIGNvbG9yOiAjMTgxQjIwOw0KICAgIC0tZHJvcEJ0bkNvbG9yOiAjMUU4NDQ5Ow0KICAgIC0tbmF2QnRuUGFkZGluZzogMXB4IDBweCAxcHggMTBweDsNCiAgICAtLW5hdkJ0bkNvbG9ySG92ZXI6ICMyODc0QTY7DQogICAgLS1uYXZCdG5Ib3ZlclRleHRDb2xvcjogI0ZGRkZGRjsNCiAgICAtLW5hdkJ0bkhvdmVyQm9yZGVyOiAxcHggZGFzaGVkICNGRkZGRkY7DQogICAgLS1uYXZCdG5Ib3ZlclJhZGl1czogNXB4Ow0KICAgIC0tbmF2QnRuSGVpZ2h0OiAyLjI1ZW07DQogICAgLS1uYXZCdG5XaWR0aDogOTAlOw0KICAgIC0tbmF2QnRuRm9udEZhbWlseTogJ1JvYm90byBMaWdodCc7DQogICAgLS1uYXZCdG5Gb250U2l6ZTogMS4wNWVtOw0KICAgIG1hcmdpbjogMDsNCiAgICBwYWRkaW5nOiAwOw0KfQ0KDQphIHsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCnAgew0KICAgIHdoaXRlLXNwYWNlOiBwcmUtd3JhcDsNCn0NCg0KLmJvbGRfcmVkIHsNCiAgICBjb2xvcjogI0ZGOTEwMDsNCiAgICBmb250LXdlaWdodDogNzAwOw0KfQ0KDQouYnRuX2xhYmVsIHsNCiAgICBjb2xvcjogI0ZGRjsNCiAgICBmb250LXNpemU6IDEuMWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgbWFyZ2luLXRvcDogMC41ZW07DQp9DQoNCi5jZW50ZXIgew0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLnJpZ2h0IHsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCn0NCg0KLmZyb250X2JhY2tncm91bmQsDQoubmF2X2JhY2tncm91bmQsDQoucmVhZG1lX2JhY2tncm91bmQgew0KICAgIC8qIGJhY2tncm91bmQ6ICMyMjMxM2Y7ICovDQogICAgYmFja2dyb3VuZDogIzIyMjsNCiAgICBjb2xvcjogI0RERDsNCn0NCg0KLm5hdl9pbWFnZSB7DQogICAgaGVpZ2h0OiAxMDBweDsNCiAgICBtYXJnaW46IDI0cHggMHB4Ow0KICAgIHdpZHRoOiAxMDBweDsNCn0NCg0KLm1haW4gew0KICAgIG1hcmdpbjogMmVtIDJlbSAxZW0gMmVtOw0KDQp9DQoNCi5zZWN0aW9uX2hlYWRlciB7DQogICAgZm9udC1zaXplOiAwLjllbTsNCiAgICBtYXJnaW46IDFlbSAwZW07DQp9DQoNCi5jYXNlX2luZm8gew0KICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNEREQ7DQogICAgY29sb3I6ICNEREQ7DQogICAgZGlzcGxheTogZmxleDsNCiAgICBmbGV4LWRpcmVjdGlvbjogY29sdW1uOw0KICAgIGp1c3RpZnktY29udGVudDogY2VudGVyOw0KICAgIG1hcmdpbi1ib3R0b206IDFlbTsNCiAgICBwYWRkaW5nLWJvdHRvbTogMWVtOw0KfQ0KDQoubmF2IHsNCiAgICBhbGlnbi1jb250ZW50OiBjZW50ZXI7DQogICAgYWxpZ24taXRlbXM6IGNlbnRlcjsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgdHJhbnNwYXJlbnQ7DQogICAgZGlzcGxheTogZmxleDsNCiAgICBmbGV4LWRpcmVjdGlvbjogcm93Ow0KICAgIGZsZXgtd3JhcDogd3JhcDsNCiAgICBqdXN0aWZ5LWNvbnRlbnQ6IGNlbnRlcjsNCiAgICBtYXJnaW46IDEuNWVtIDBlbTsNCn0NCg0KLm5hdiBhIHsNCiAgICBjb2xvcjogZG9kZ2VyYmx1ZTsNCn0NCg0KLm5hdiBhOmhvdmVyIHsNCiAgICB0ZXh0LWRlY29yYXRpb246IHVuZGVybGluZTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KfQ0KDQoubmF2IC5yZWFkbWUgew0KICAgIGNvbG9yOiAjQ0I0MzM1Ow0KfQ0KDQoubmF2IC5yZWFkbWU6aG92ZXIgew0KICAgIHRleHQtZGVjb3JhdGlvbjogdW5kZXJsaW5lOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQp9DQoNCi5pdGVtX3RhYmxlIHsNCiAgICBhbGlnbi1jb250ZW50OiBjZW50ZXI7DQogICAgYWxpZ24taXRlbXM6IGNlbnRlcjsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI0RERDsNCiAgICBkaXNwbGF5OiBmbGV4Ow0KICAgIGZsZXgtZGlyZWN0aW9uOiByb3c7DQogICAgZmxleC13cmFwOiB3cmFwOw0KICAgIGp1c3RpZnktY29udGVudDogc3BhY2UtZXZlbmx5Ow0KICAgIHBhZGRpbmc6IDAuNzVlbTsNCn0NCg0KLmNhc2VfaW5mb19kZXRhaWxzIHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMC41ZW0gMC4zZW0gMGVtOw0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KfQ0KDQouY2FzZV9pbmZvX3RleHQgew0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCiAgICBwYWRkaW5nOiAwLjNlbSAwZW0gMC4zZW0gMC41ZW07DQogICAgdGV4dC1hbGlnbjogcmlnaHQ7DQp9DQoNCi50b3BfaGVhZGluZyB7DQogICAgY29sb3I6ICNDQjQzMzU7DQogICAgZm9udC1zaXplOiAyLjRlbTsNCiAgICBtYXJnaW46IDAuMjVlbSAwZW0gMC4yNWVtIDBlbTsNCiAgICBwYWRkaW5nOiAwOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5maXJzdF9saW5lIHsNCiAgICBmb250LXNpemU6IDEuNWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luOiAxcmVtIDAgMC41cmVtIDA7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KfQ0KDQouc2Vjb25kX2xpbmUgew0KICAgIGZvbnQtc2l6ZTogMS4zNWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luOiAtMC4yNXJlbSAwIDJyZW0gMDsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQp9DQoNCi5udW1iZXJfbGlzdCB7DQogICAgZm9udC1mYW1pbHk6IFJvYm90bzsNCiAgICBmb250LXNpemU6IDAuOWVtOw0KICAgIG1hcmdpbi1sZWZ0OiAxZW07DQp9DQoNCi5udW1iZXJfbGlzdCBhIHsNCiAgICBjb2xvcjogZG9kZ2VyYmx1ZTsNCiAgICBkaXNwbGF5OiBibG9jazsNCiAgICBwYWRkaW5nLWJvdHRvbTogMC41ZW07DQp9DQoNCi5udW1iZXJfbGlzdCBhOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kOiAjNDQ0Ow0KICAgIGJvcmRlcjogMXB4IGRhc2hlZCB3aGl0ZTsNCn0NCg0KLm51bWJlcl9saXN0IC5maWxlX2xpbmsgew0KICAgIGNvbG9yOiAjMjhiNDYzOw0KICAgIGRpc3BsYXk6IGJsb2NrOw0KICAgIHBhZGRpbmctYm90dG9tOiAwLjVlbTsNCn0NCg0KLmhlYWRpbmcgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICNhYWE7DQogICAgY29sb3I6ICNDQjQzMzU7DQogICAgZm9udC1zaXplOiAxLjJlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMGVtIDAuMzVlbTsNCiAgICBtYXgtd2lkdGg6IGF1dG87DQogICAgcGFkZGluZzogNXB4IDBweCA1cHggMHB4Ow0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB0ZXh0LXRyYW5zZm9ybTogdXBwZXJjYXNlOw0KfQ0KDQoucmVwb3J0X3NlY3Rpb24gew0KICAgIGRpc3BsYXk6IGZsZXg7DQogICAgZmxleC1kaXJlY3Rpb246IGNvbHVtbjsNCiAgICBtYXgtd2lkdGg6IGF1dG87DQp9DQoNCi5uYXZfbGlzdF9pdGVtIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICBjb2xvcjogI0NCNDMzNTsNCiAgICBmb250LWZhbWlseTogdmFyKC0tbmF2QnRuRm9udEZhbWlseSk7DQogICAgZm9udC1zaXplOiB2YXIoLS1uYXZCdG5Gb250U2l6ZSk7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICBoZWlnaHQ6IHZhcigtLW5hdkJ0bkhlaWdodCk7DQogICAgbWFyZ2luOiAwLjE1ZW0gMC4zNWVtOw0KICAgIG1heC13aWR0aDogYXV0bzsNCiAgICBwYWRkaW5nOiA3cHggMHB4Ow0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KfQ0KDQoubmF2X2xpc3RfaXRlbTpob3ZlciB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzFmNjE4ZDsNCiAgICBjb2xvcjogI0RERDsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgZm9udC1zaXplOiB2YXIoLS1uYXZCdG5Gb250U2l6ZSk7DQogICAgZm9udC13ZWlnaHQ6IDYwMDsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCi5mcm9udHBhZ2VfdGFibGUgew0KICAgIGJvcmRlci1jb2xsYXBzZTogY29sbGFwc2U7DQogICAgY29sb3I6ICNEREQ7DQogICAgdGFibGUtbGF5b3V0OiBmaXhlZDsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLmNhc2VfaW5mb19kZXRhaWxzIHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMC41ZW0gMC4zZW0gMGVtOw0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KfQ0KDQouY2FzZV9pbmZvX3RleHQgew0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCiAgICBwYWRkaW5nOiAwLjNlbSAwZW0gMC4zZW0gMC41ZW07DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCn0NCg0KLmRhdGFfYm9keSB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzIyMjsNCiAgICBjb2xvcjogI0RERDsNCiAgICBtYXJnaW4tdG9wOiAyZW07DQogICAgbWFyZ2luLXJpZ2h0OiA1JTsNCiAgICBtYXJnaW4tYm90dG9tOiAyZW07DQogICAgbWFyZ2luLWxlZnQ6IDUlOw0KfQ0KDQovKiBTdHlsZSB0aGUgYnV0dG9uIHRoYXQgaXMgdXNlZCB0byBvcGVuIGFuZCBjbG9zZSB0aGUgY29sbGFwc2libGUgY29udGVudCAqLw0KLmNvbGxhcHNpYmxlIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjNzc3Ow0KICAgIGJvcmRlcjogNHB4IHNvbGlkIHRyYW5zcGFyZW50Ow0KICAgIGJvcmRlci1yYWRpdXM6IDAuMzc1ZW07DQogICAgY29sb3I6ICNEREQ7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIGZvbnQtc2l6ZTogMC45NWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luOiAwZW07DQogICAgb3V0bGluZTogbm9uZTsNCiAgICBwYWRkaW5nOiAxOHB4Ow0KICAgIHRleHQtYWxpZ246IGxlZnQ7DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi8qIEFkZCBhIGJhY2tncm91bmQgY29sb3IgdG8gdGhlIGJ1dHRvbiBpZiBpdCBpcyBjbGlja2VkIG9uIChhZGQgdGhlIC5hY3RpdmUgY2xhc3Mgd2l0aCBKUyksIGFuZCB3aGVuIHlvdSBtb3ZlIHRoZSBtb3VzZSBvdmVyIGl0IChob3ZlcikgKi8NCi5jb2xsYXBzaWJsZTpob3ZlciB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzc3NzsNCiAgICBib3JkZXI6IDRweCBkYXNoZWQgI2RjMzU0NTsNCiAgICBjb2xvcjogI0RERDsNCiAgICBmb250LXNpemU6IDAuOTVlbTsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCi5idG4gew0KICAgIGhlaWdodDogMTAwJTsNCiAgICB3aWR0aDogMTAwJTsNCiAgICAtLWJzLWJ0bi1wYWRkaW5nLXg6IDAuNzVyZW07DQogICAgLS1icy1idG4tcGFkZGluZy15OiAwLjM3NXJlbTsNCiAgICAtLWJzLWJ0bi1mb250LWZhbWlseTogOw0KICAgIC0tYnMtYnRuLWZvbnQtc2l6ZTogMXJlbTsNCiAgICAtLWJzLWJ0bi1mb250LXdlaWdodDogNDAwOw0KICAgIC0tYnMtYnRuLWxpbmUtaGVpZ2h0OiAxLjU7DQogICAgLS1icy1idG4tY29sb3I6IHZhcigtLWJzLWJvZHktY29sb3IpOw0KICAgIC0tYnMtYnRuLWJnOiB0cmFuc3BhcmVudDsNCiAgICAtLWJzLWJ0bi1ib3JkZXItd2lkdGg6IDJweDsNCiAgICAtLWJzLWJ0bi1ib3JkZXItY29sb3I6IHRyYW5zcGFyZW50Ow0KICAgIC0tYnMtYnRuLWJvcmRlci1yYWRpdXM6IDAuMzc1cmVtOw0KICAgIC0tYnMtYnRuLWhvdmVyLWJvcmRlci1jb2xvcjogdHJhbnNwYXJlbnQ7DQogICAgLS1icy1idG4tYm94LXNoYWRvdzogaW5zZXQgMCAxcHggMCByZ2JhKDI1NSwgMjU1LCAyNTUsIDAuMTUpLCAwIDFweCAxcHggcmdiYSgwLCAwLCAwLCAwLjA3NSk7DQogICAgLS1icy1idG4tZGlzYWJsZWQtb3BhY2l0eTogMC42NTsNCiAgICAtLWJzLWJ0bi1mb2N1cy1ib3gtc2hhZG93OiAwIDAgMCAwLjI1cmVtIHJnYmEodmFyKC0tYnMtYnRuLWZvY3VzLXNoYWRvdy1yZ2IpLCAuNSk7DQogICAgZGlzcGxheTogaW5saW5lLWJsb2NrOw0KICAgIHBhZGRpbmc6IHZhcigtLWJzLWJ0bi1wYWRkaW5nLXkpIHZhcigtLWJzLWJ0bi1wYWRkaW5nLXgpOw0KICAgIGZvbnQtZmFtaWx5OiB2YXIoLS1icy1idG4tZm9udC1mYW1pbHkpOw0KICAgIGZvbnQtc2l6ZTogdmFyKC0tYnMtYnRuLWZvbnQtc2l6ZSk7DQogICAgZm9udC13ZWlnaHQ6IHZhcigtLWJzLWJ0bi1mb250LXdlaWdodCk7DQogICAgbGluZS1oZWlnaHQ6IHZhcigtLWJzLWJ0bi1saW5lLWhlaWdodCk7DQogICAgY29sb3I6IHZhcigtLWJzLWJ0bi1jb2xvcik7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogbWlkZGxlOw0KICAgIGN1cnNvcjogcG9pbnRlcjsNCiAgICAtd2Via2l0LXVzZXItc2VsZWN0OiBub25lOw0KICAgIC1tb3otdXNlci1zZWxlY3Q6IG5vbmU7DQogICAgdXNlci1zZWxlY3Q6IG5vbmU7DQogICAgYm9yZGVyOiB2YXIoLS1icy1idG4tYm9yZGVyLXdpZHRoKSBzb2xpZCB2YXIoLS1icy1idG4tYm9yZGVyLWNvbG9yKTsNCiAgICBib3JkZXItcmFkaXVzOiB2YXIoLS1icy1idG4tYm9yZGVyLXJhZGl1cyk7DQogICAgYmFja2dyb3VuZC1jb2xvcjogdmFyKC0tYnMtYnRuLWJnKTsNCiAgICB0cmFuc2l0aW9uOiBjb2xvciAwLjE1cyBlYXNlLWluLW91dCwgYmFja2dyb3VuZC1jb2xvciAwLjE1cyBlYXNlLWluLW91dCwgYm9yZGVyLWNvbG9yIDAuMTVzIGVhc2UtaW4tb3V0LCBib3gtc2hhZG93IDAuMTVzIGVhc2UtaW4tb3V0Ow0KfQ0KDQouYnRuLXByaW1hcnkgew0KICAgIC0tYnMtYnRuLWNvbG9yOiAjZmZmOw0KICAgIC0tYnMtYnRuLWJnOiAjMGQ2ZWZkOw0KICAgIC0tYnMtYnRuLWJvcmRlci1jb2xvcjogIzBkNmVmZDsNCiAgICAtLWJzLWJ0bi1ob3Zlci1jb2xvcjogI2ZmZjsNCiAgICAtLWJzLWJ0bi1ob3Zlci1iZzogIzBiNWVkNzsNCiAgICAtLWJzLWJ0bi1ob3Zlci1ib3JkZXItY29sb3I6ICMwYTU4Y2E7DQogICAgLS1icy1idG4tZm9jdXMtc2hhZG93LXJnYjogNDksIDEzMiwgMjUzOw0KICAgIC0tYnMtYnRuLWFjdGl2ZS1jb2xvcjogI2ZmZjsNCiAgICAtLWJzLWJ0bi1hY3RpdmUtYmc6ICMwYTU4Y2E7DQogICAgLS1icy1idG4tYWN0aXZlLWJvcmRlci1jb2xvcjogIzBhNTNiZTsNCiAgICAtLWJzLWJ0bi1hY3RpdmUtc2hhZG93OiBpbnNldCAwIDNweCA1cHggcmdiYSgwLCAwLCAwLCAwLjEyNSk7DQogICAgLS1icy1idG4tZGlzYWJsZWQtY29sb3I6ICNmZmY7DQogICAgLS1icy1idG4tZGlzYWJsZWQtYmc6ICMwZDZlZmQ7DQogICAgLS1icy1idG4tZGlzYWJsZWQtYm9yZGVyLWNvbG9yOiAjMGQ2ZWZkOw0KfQ0KDQouYnRuLXJlYWRtZSB7DQogICAgYmFja2dyb3VuZDogI2RjMzU0NTsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI2RjMzU0NTsNCiAgICBjb2xvcjogI2RkZDsNCiAgICBmb250LXdlaWdodDogNDAwOw0KfQ0KDQouYnRuLXJlYWRtZTpob3ZlciB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogI2JiMmQzYjsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI2RkZDsNCiAgICBjb2xvcjogI2RkZDsNCn0NCg0KLmJ0bi1wcmltYXJ5OmhvdmVyIHsNCiAgICBjb2xvcjogdmFyKC0tYnMtYnRuLWhvdmVyLWNvbG9yKTsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiB2YXIoLS1icy1idG4taG92ZXItYmcpOw0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjRjhGOEY4Ow0KfQ0KDQouZmlsZV9idG4sDQouaXRlbV9idG4sDQoubm9faW5mb19idG4gew0KICAgIGJvcmRlci1yYWRpdXM6IDAuMzc1ZW07DQogICAgY29sb3I6ICNjY2M7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIGRpc3BsYXk6IGlubGluZS1ibG9jazsNCiAgICBmb250LXNpemU6IDAuOTVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMC41ZW0gMC41ZW0gMC41ZW0gMC41ZW07DQogICAgb3V0bGluZTogbm9uZTsNCiAgICBwYWRkaW5nOiAxLjI1ZW07DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCiAgICB3aWR0aDogYXV0bzsNCn0NCg0KLmZpbGVfYnRuIHsNCiAgICBiYWNrZ3JvdW5kOiAjMTk4NzU0Ow0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjMTk4NzU0Ow0KfQ0KDQouaXRlbV9idG4gew0KICAgIGJhY2tncm91bmQ6ICMwZDZlZmQ7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICMwZDZlZmQ7DQp9DQoNCi5ub19pbmZvX2J0biB7DQogICAgYmFja2dyb3VuZDogIzZjNzU3ZDsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgIzZjNzU3ZDsNCn0NCg0KLmZpbGVfYnRuOmhvdmVyLA0KLml0ZW1fYnRuOmhvdmVyLA0KLm5vX2luZm9fYnRuOmhvdmVyIHsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI2NjYzsNCn0NCg0KLmZpbGVfYnRuOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kOiAjMTU3MzQ3Ow0KfQ0KDQouaXRlbV9idG46aG92ZXIgew0KICAgIGJhY2tncm91bmQ6ICMwYjVlZDc7DQp9DQoNCi5ub19pbmZvX2J0bjpob3ZlciB7DQogICAgYmFja2dyb3VuZDogIzVjNjM2YTsNCn0NCg0KLmZpbGVfYnRuX2xhYmVsLA0KLml0ZW1fYnRuX2xhYmVsIHsNCiAgICBjb2xvcjogI2NjYzsNCiAgICBmb250LXNpemU6IDEuMWVtOw0KICAgIGZvbnQtd2VpZ2h0OiBub3JtYWw7DQogICAgbWFyZ2luLXRvcDogMC41ZW07DQp9DQoNCi5maWxlX2J0bl90ZXh0LA0KLml0ZW1fYnRuX3RleHQsDQoubm9faW5mb19idG5fdGV4dCB7DQogICAgY29sb3I6ICNmOGY4Zjg7DQogICAgZGlzcGxheTogYmxvY2s7DQogICAgbWFyZ2luOiAwZW07DQogICAgcG9zaXRpb246IHJlbGF0aXZlOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQogICAgZm9udC1zaXplOiAxLjFlbTsNCiAgICB3aWR0aDogYXV0bzsNCn0NCg0KLmJ0blRleHQgew0KICAgIGNvbG9yOiAjZjhmOGY4Ow0KICAgIGRpc3BsYXk6IGlubGluZTsNCiAgICBtYXJnaW46IDByZW0gMXJlbSAwcmVtIDFyZW07DQogICAgcG9zaXRpb246IHJlbGF0aXZlOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQogICAgZm9udC1zaXplOiAxLjI1cmVtOw0KICAgIHdpZHRoOiBhdXRvOw0KfQ0KDQouYnRuVGV4dDo6YWZ0ZXIgew0KICAgIGJhY2tncm91bmQ6ICNmOGY4Zjg7DQogICAgYm90dG9tOiAtMnB4Ow0KICAgIGNvbnRlbnQ6ICIiOw0KICAgIGhlaWdodDogMnB4Ow0KICAgIGxlZnQ6IDA7DQogICAgcG9zaXRpb246IGFic29sdXRlOw0KICAgIHRyYW5zZm9ybTogc2NhbGVYKDApOw0KICAgIHRyYW5zZm9ybS1vcmlnaW46IHJpZ2h0Ow0KICAgIHRyYW5zaXRpb246IHRyYW5zZm9ybSAwLjJzIGVhc2UtaW47DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5tZW51SXRlbTpob3ZlciAuYnRuVGV4dDo6YWZ0ZXIgew0KICAgIHRyYW5zZm9ybTogc2NhbGVYKDEpOw0KICAgIHRyYW5zZm9ybS1vcmlnaW46IGxlZnQ7DQp9DQoNCmJ1dHRvbiB7DQogICAgd2lkdGg6IDEwMCU7DQogICAgaGVpZ2h0OiAxMDAlOw0KfQ0KDQp0YWJsZSwNCnRyLA0KdGQgew0KICAgIGJvcmRlcjogMXB4IHNvbGlkIHRyYW5zcGFyZW50Ow0KICAgIGJvcmRlci1jb2xsYXBzZTogY29sbGFwc2U7DQogICAgaGVpZ2h0OiAxMDAlOw0KfQ0KDQoubWVudVRhYmxlIHsNCiAgICBib3JkZXItY29sbGFwc2U6IHNlcGFyYXRlOw0KICAgIGJvcmRlci1zcGFjaW5nOiAxZW07DQogICAgbWFyZ2luLXRvcDogMWVtOw0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQoubWVudVRhYmxlIGJ1dHRvbiB7DQogICAgYm9yZGVyOiAxcHggc29saWQgdHJhbnNwYXJlbnQ7DQogICAgcGFkZGluZzogMnJlbTsNCiAgICB3aWR0aDogMTAwJTsNCiAgICBoZWlnaHQ6IDEwMCU7DQp9DQoNCi5tZW51SXRlbSB7DQogICAgYm9yZGVyOiAycHggZGFzaGVkIHRyYW5zcGFyZW50Ow0KICAgIHdpZHRoOiAyMCU7DQp9DQoNCkBwYWdlIHsNCiAgICBzaXplOiBBNDsNCg0KICAgIEBib3R0b20tY2VudGVyIHsNCiAgICAgICAgY29udGVudDogIlBhZ2UgImNvdW50ZXIocGFnZSk7DQogICAgfQ0KfQ0KDQpAbWVkaWEgcHJpbnQgew0KICAgIC5uby1wcmludCwgLm5vLXByaW50ICogew0KICAgICAgICBkaXNwbGF5OiBub25lOw0KICAgIH0NCg0KICAgIGh0bWwsIGJvZHkgew0KICAgICAgICBtYXJnaW46IDByZW07DQogICAgICAgIGJhY2tncm91bmQ6IHRyYW5zcGFyZW50Ow0KICAgIH0NCg0KICAgIC5kYXRhX2JvZHkgew0KICAgICAgICBiYWNrZ3JvdW5kLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICAgICAgY29sb3I6ICMwMDA7DQogICAgfQ0KfQ0KDQovKiBhbGxzdHlsZS5jc3MgKi8NCg0KKiwgKjo6YmVmb3JlLCAqOjphZnRlciB7DQogICAgYm94LXNpemluZzogYm9yZGVyLWJveDsNCiAgICBtYXJnaW46IDA7DQogICAgcGFkZGluZzogMDsNCiAgICAtd2Via2l0LWZvbnQtc21vb3RoaW5nOiBhbnRpYWxpYXNlZDsNCiAgICB0ZXh0LXJlbmRlcmluZzogb3B0aW1pemVMZWdpYmlsaXR5Ow0KfQ0KDQpodG1sIHsNCiAgICBmb250LWZhbWlseTogJ1NlZ29lIFVJJywgRnJ1dGlnZXIsICdGcnV0aWdlciBMaW5vdHlwZScsICdEZWphdnUgU2FucycsICdIZWx2ZXRpY2EgTmV1ZScsIEFyaWFsLCBzYW5zLXNlcmlmOw0KICAgIGZvbnQtd2VpZ2h0OiAzMDA7DQp9DQoNCmJvZHkgew0KICAgIGJhY2tncm91bmQ6ICNmZmY7DQogICAgZm9udC1zaXplOiAxZW07DQogICAgY29sb3I6ICMxODFCMjA7DQogICAgLS1kcm9wQnRuQ29sb3I6ICMxRTg0NDk7DQogICAgLS1uYXZCdG5QYWRkaW5nOiAxcHggMHB4IDFweCAxMHB4Ow0KICAgIC0tbmF2QnRuQ29sb3JIb3ZlcjogIzI4NzRBNjsNCiAgICAtLW5hdkJ0bkhvdmVyVGV4dENvbG9yOiAjRkZGRkZGOw0KICAgIC0tbmF2QnRuSG92ZXJCb3JkZXI6IDFweCBkYXNoZWQgI0ZGRkZGRjsNCiAgICAtLW5hdkJ0bkhvdmVyUmFkaXVzOiA1cHg7DQogICAgLS1uYXZCdG5IZWlnaHQ6IDIuMjVlbTsNCiAgICAtLW5hdkJ0bldpZHRoOiA5MCU7DQogICAgLS1uYXZCdG5Gb250RmFtaWx5OiAnUm9ib3RvIExpZ2h0JzsNCiAgICAtLW5hdkJ0bkZvbnRTaXplOiAxLjA1ZW07DQogICAgbWFyZ2luOiAwOw0KICAgIHBhZGRpbmc6IDA7DQp9DQoNCmEgew0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCn0NCg0KcCB7DQogICAgd2hpdGUtc3BhY2U6IHByZS13cmFwOw0KfQ0KDQouYm9sZF9yZWQgew0KICAgIGNvbG9yOiAjRkY5MTAwOw0KICAgIGZvbnQtd2VpZ2h0OiA3MDA7DQp9DQoNCi5idG5fbGFiZWwgew0KICAgIGNvbG9yOiAjRkZGOw0KICAgIGZvbnQtc2l6ZTogMS4xZW07DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICBtYXJnaW4tdG9wOiAwLjVlbTsNCn0NCg0KLmNlbnRlciB7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KfQ0KDQoucmlnaHQgew0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KfQ0KDQouZnJvbnRfYmFja2dyb3VuZCwNCi5uYXZfYmFja2dyb3VuZCwNCi5yZWFkbWVfYmFja2dyb3VuZCB7DQogICAgLyogYmFja2dyb3VuZDogIzIyMzEzZjsgKi8NCiAgICBiYWNrZ3JvdW5kOiAjMjIyOw0KICAgIGNvbG9yOiAjREREOw0KfQ0KDQoubmF2X2ltYWdlIHsNCiAgICBoZWlnaHQ6IDEwMHB4Ow0KICAgIG1hcmdpbjogMjRweCAwcHg7DQogICAgd2lkdGg6IDEwMHB4Ow0KfQ0KDQoubWFpbiB7DQogICAgbWFyZ2luOiAyZW0gMmVtIDFlbSAyZW07DQoNCn0NCg0KLnNlY3Rpb25faGVhZGVyIHsNCiAgICBmb250LXNpemU6IDAuOWVtOw0KICAgIG1hcmdpbi1ib3R0b206IDFlbTsNCn0NCg0KLmNhc2VfaW5mbyB7DQogICAgYWxpZ24taXRlbXM6IGNlbnRlcjsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI0RERDsNCiAgICBjb2xvcjogI0RERDsNCiAgICBkaXNwbGF5OiBmbGV4Ow0KICAgIGZsZXgtZGlyZWN0aW9uOiBjb2x1bW47DQogICAganVzdGlmeS1jb250ZW50OiBjZW50ZXI7DQogICAgbWFyZ2luLWJvdHRvbTogMWVtOw0KICAgIHBhZGRpbmctYm90dG9tOiAxZW07DQp9DQoNCi5pdGVtX3RhYmxlIHsNCiAgICBhbGlnbi1jb250ZW50OiBjZW50ZXI7DQogICAgYWxpZ24taXRlbXM6IGNlbnRlcjsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI0RERDsNCiAgICBkaXNwbGF5OiBmbGV4Ow0KICAgIGZsZXgtZGlyZWN0aW9uOiByb3c7DQogICAgZmxleC13cmFwOiB3cmFwOw0KICAgIGp1c3RpZnktY29udGVudDogc3BhY2UtZXZlbmx5Ow0KICAgIHBhZGRpbmc6IDAuNzVlbTsNCn0NCg0KLmNhc2VfaW5mb19kZXRhaWxzIHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMC41ZW0gMC4zZW0gMGVtOw0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KfQ0KDQouY2FzZV9pbmZvX3RleHQgew0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCiAgICBwYWRkaW5nOiAwLjNlbSAwZW0gMC4zZW0gMC41ZW07DQogICAgdGV4dC1hbGlnbjogcmlnaHQ7DQp9DQoNCi5yZWFkbWVfaW5mbyB7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNkZGQ7DQogICAgbWFyZ2luOiAyZW0gMmVtIDFlbSAyZW07DQogICAgcGFkZGluZzogMCA1ZW07DQp9DQoNCi50b3BfaGVhZGluZyB7DQogICAgY29sb3I6ICNDQjQzMzU7DQogICAgZm9udC1zaXplOiAyLjRlbTsNCiAgICBtYXJnaW46IDAuMjVlbSAwZW0gMC4yNWVtIDBlbTsNCiAgICBwYWRkaW5nOiAwOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5maXJzdF9saW5lIHsNCiAgICBmb250LXNpemU6IDEuNWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luOiAxcmVtIDAgMC41cmVtIDA7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KfQ0KDQouc2Vjb25kX2xpbmUgew0KICAgIGZvbnQtc2l6ZTogMS4zNWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luOiAtMC4yNXJlbSAwIDJyZW0gMDsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQp9DQoNCi5udW1iZXJfbGlzdCB7DQogICAgZm9udC1mYW1pbHk6IFJvYm90bzsNCiAgICBmb250LXNpemU6IDAuOWVtOw0KICAgIG1hcmdpbi1sZWZ0OiAxZW07DQp9DQoNCi5udW1iZXJfbGlzdCBhIHsNCiAgICBjb2xvcjogZG9kZ2VyYmx1ZTsNCiAgICBkaXNwbGF5OiBibG9jazsNCiAgICBwYWRkaW5nLWJvdHRvbTogMC41ZW07DQp9DQoNCi5udW1iZXJfbGlzdCBhOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kOiAjNDQ0Ow0KICAgIGJvcmRlcjogMXB4IGRhc2hlZCB3aGl0ZTsNCn0NCg0KLnJlYWRtZV9saXN0IHsNCiAgICBmb250LXNpemU6IDEuMWVtOw0KfQ0KDQoucmVhZG1lX2xpc3Qgb2wgbGkgew0KICAgIG1hcmdpbi1ib3R0b206IDEuNzVlbTsNCn0NCg0KLmhlYWRpbmcgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICNhYWE7DQogICAgY29sb3I6ICNDQjQzMzU7DQogICAgZm9udC1zaXplOiAxLjJlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMGVtIDAuMzVlbTsNCiAgICBtYXgtd2lkdGg6IGF1dG87DQogICAgcGFkZGluZzogNXB4IDBweCA1cHggMHB4Ow0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB0ZXh0LXRyYW5zZm9ybTogdXBwZXJjYXNlOw0KfQ0KDQoucmVwb3J0X3NlY3Rpb24gew0KICAgIGRpc3BsYXk6IGZsZXg7DQogICAgZmxleC1kaXJlY3Rpb246IGNvbHVtbjsNCiAgICBtYXgtd2lkdGg6IGF1dG87DQp9DQoNCi5uYXZfbGlzdF9pdGVtIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICBjb2xvcjogI0NCNDMzNTsNCiAgICBmb250LWZhbWlseTogdmFyKC0tbmF2QnRuRm9udEZhbWlseSk7DQogICAgZm9udC1zaXplOiB2YXIoLS1uYXZCdG5Gb250U2l6ZSk7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICBoZWlnaHQ6IHZhcigtLW5hdkJ0bkhlaWdodCk7DQogICAgbWFyZ2luOiAwLjE1ZW0gMC4zNWVtOw0KICAgIG1heC13aWR0aDogYXV0bzsNCiAgICBwYWRkaW5nOiA3cHggMHB4Ow0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KfQ0KDQoubmF2X2xpc3RfaXRlbTpob3ZlciB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzFmNjE4ZDsNCiAgICBjb2xvcjogI0RERDsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgZm9udC1zaXplOiB2YXIoLS1uYXZCdG5Gb250U2l6ZSk7DQogICAgZm9udC13ZWlnaHQ6IDYwMDsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCi5mcm9udHBhZ2VfdGFibGUgew0KICAgIGJvcmRlci1jb2xsYXBzZTogY29sbGFwc2U7DQogICAgY29sb3I6ICNEREQ7DQogICAgdGFibGUtbGF5b3V0OiBmaXhlZDsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLmNhc2VfaW5mb19kZXRhaWxzIHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMC41ZW0gMC4zZW0gMGVtOw0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KfQ0KDQouY2FzZV9pbmZvX3RleHQgew0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCiAgICBwYWRkaW5nOiAwLjNlbSAwZW0gMC4zZW0gMC41ZW07DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCn0NCg0KLmRhdGFfYm9keSB7DQogICAgLyogYmFja2dyb3VuZDogIzIyMzEzZjsgKi8NCiAgICBiYWNrZ3JvdW5kOiAjMjIyOw0KICAgIGNvbG9yOiAjREREOw0KICAgIG1hcmdpbi10b3A6IDJlbTsNCiAgICBtYXJnaW4tcmlnaHQ6IDUlOw0KICAgIG1hcmdpbi1ib3R0b206IDJlbTsNCiAgICBtYXJnaW4tbGVmdDogNSU7DQp9DQoNCi8qIFN0eWxlIHRoZSBidXR0b24gdGhhdCBpcyB1c2VkIHRvIG9wZW4gYW5kIGNsb3NlIHRoZSBjb2xsYXBzaWJsZSBjb250ZW50ICovDQouY29sbGFwc2libGUgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICM3Nzc7DQogICAgYm9yZGVyOiA0cHggc29saWQgdHJhbnNwYXJlbnQ7DQogICAgYm9yZGVyLXJhZGl1czogMC4zNzVlbTsNCiAgICBjb2xvcjogI0RERDsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgZm9udC1zaXplOiAwLjk1ZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IDBlbTsNCiAgICBvdXRsaW5lOiBub25lOw0KICAgIHBhZGRpbmc6IDE4cHg7DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLyogQWRkIGEgYmFja2dyb3VuZCBjb2xvciB0byB0aGUgYnV0dG9uIGlmIGl0IGlzIGNsaWNrZWQgb24gKGFkZCB0aGUgLmFjdGl2ZSBjbGFzcyB3aXRoIEpTKSwgYW5kIHdoZW4geW91IG1vdmUgdGhlIG1vdXNlIG92ZXIgaXQgKGhvdmVyKSAqLw0KLmNvbGxhcHNpYmxlOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjNzc3Ow0KICAgIGJvcmRlcjogNHB4IGRhc2hlZCAjZGMzNTQ1Ow0KICAgIGNvbG9yOiAjREREOw0KICAgIGZvbnQtc2l6ZTogMC45NWVtOw0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCn0NCg0KLmJ0biB7DQogICAgaGVpZ2h0OiAxMDAlOw0KICAgIHdpZHRoOiAxMDAlOw0KICAgIC0tYnMtYnRuLXBhZGRpbmcteDogMC43NXJlbTsNCiAgICAtLWJzLWJ0bi1wYWRkaW5nLXk6IDAuMzc1cmVtOw0KICAgIC0tYnMtYnRuLWZvbnQtZmFtaWx5OiA7DQogICAgLS1icy1idG4tZm9udC1zaXplOiAxcmVtOw0KICAgIC0tYnMtYnRuLWZvbnQtd2VpZ2h0OiA0MDA7DQogICAgLS1icy1idG4tbGluZS1oZWlnaHQ6IDEuNTsNCiAgICAtLWJzLWJ0bi1jb2xvcjogdmFyKC0tYnMtYm9keS1jb2xvcik7DQogICAgLS1icy1idG4tYmc6IHRyYW5zcGFyZW50Ow0KICAgIC0tYnMtYnRuLWJvcmRlci13aWR0aDogMnB4Ow0KICAgIC0tYnMtYnRuLWJvcmRlci1jb2xvcjogdHJhbnNwYXJlbnQ7DQogICAgLS1icy1idG4tYm9yZGVyLXJhZGl1czogMC4zNzVyZW07DQogICAgLS1icy1idG4taG92ZXItYm9yZGVyLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICAtLWJzLWJ0bi1ib3gtc2hhZG93OiBpbnNldCAwIDFweCAwIHJnYmEoMjU1LCAyNTUsIDI1NSwgMC4xNSksIDAgMXB4IDFweCByZ2JhKDAsIDAsIDAsIDAuMDc1KTsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1vcGFjaXR5OiAwLjY1Ow0KICAgIC0tYnMtYnRuLWZvY3VzLWJveC1zaGFkb3c6IDAgMCAwIDAuMjVyZW0gcmdiYSh2YXIoLS1icy1idG4tZm9jdXMtc2hhZG93LXJnYiksIC41KTsNCiAgICBkaXNwbGF5OiBpbmxpbmUtYmxvY2s7DQogICAgcGFkZGluZzogdmFyKC0tYnMtYnRuLXBhZGRpbmcteSkgdmFyKC0tYnMtYnRuLXBhZGRpbmcteCk7DQogICAgZm9udC1mYW1pbHk6IHZhcigtLWJzLWJ0bi1mb250LWZhbWlseSk7DQogICAgZm9udC1zaXplOiB2YXIoLS1icy1idG4tZm9udC1zaXplKTsNCiAgICBmb250LXdlaWdodDogdmFyKC0tYnMtYnRuLWZvbnQtd2VpZ2h0KTsNCiAgICBsaW5lLWhlaWdodDogdmFyKC0tYnMtYnRuLWxpbmUtaGVpZ2h0KTsNCiAgICBjb2xvcjogdmFyKC0tYnMtYnRuLWNvbG9yKTsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KICAgIHZlcnRpY2FsLWFsaWduOiBtaWRkbGU7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIC13ZWJraXQtdXNlci1zZWxlY3Q6IG5vbmU7DQogICAgLW1vei11c2VyLXNlbGVjdDogbm9uZTsNCiAgICB1c2VyLXNlbGVjdDogbm9uZTsNCiAgICBib3JkZXI6IHZhcigtLWJzLWJ0bi1ib3JkZXItd2lkdGgpIHNvbGlkIHZhcigtLWJzLWJ0bi1ib3JkZXItY29sb3IpOw0KICAgIGJvcmRlci1yYWRpdXM6IHZhcigtLWJzLWJ0bi1ib3JkZXItcmFkaXVzKTsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiB2YXIoLS1icy1idG4tYmcpOw0KICAgIHRyYW5zaXRpb246IGNvbG9yIDAuMTVzIGVhc2UtaW4tb3V0LCBiYWNrZ3JvdW5kLWNvbG9yIDAuMTVzIGVhc2UtaW4tb3V0LCBib3JkZXItY29sb3IgMC4xNXMgZWFzZS1pbi1vdXQsIGJveC1zaGFkb3cgMC4xNXMgZWFzZS1pbi1vdXQ7DQp9DQoNCi5idG4tcHJpbWFyeSB7DQogICAgLS1icy1idG4tY29sb3I6ICNmZmY7DQogICAgLS1icy1idG4tYmc6ICMwZDZlZmQ7DQogICAgLS1icy1idG4tYm9yZGVyLWNvbG9yOiAjMGQ2ZWZkOw0KICAgIC0tYnMtYnRuLWhvdmVyLWNvbG9yOiAjZmZmOw0KICAgIC0tYnMtYnRuLWhvdmVyLWJnOiAjMGI1ZWQ3Ow0KICAgIC0tYnMtYnRuLWhvdmVyLWJvcmRlci1jb2xvcjogIzBhNThjYTsNCiAgICAtLWJzLWJ0bi1mb2N1cy1zaGFkb3ctcmdiOiA0OSwgMTMyLCAyNTM7DQogICAgLS1icy1idG4tYWN0aXZlLWNvbG9yOiAjZmZmOw0KICAgIC0tYnMtYnRuLWFjdGl2ZS1iZzogIzBhNThjYTsNCiAgICAtLWJzLWJ0bi1hY3RpdmUtYm9yZGVyLWNvbG9yOiAjMGE1M2JlOw0KICAgIC0tYnMtYnRuLWFjdGl2ZS1zaGFkb3c6IGluc2V0IDAgM3B4IDVweCByZ2JhKDAsIDAsIDAsIDAuMTI1KTsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1jb2xvcjogI2ZmZjsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1iZzogIzBkNmVmZDsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1ib3JkZXItY29sb3I6ICMwZDZlZmQ7DQp9DQoNCi5idG4tcmVhZG1lIHsNCiAgICBiYWNrZ3JvdW5kOiAjZGMzNTQ1Ow0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjZGMzNTQ1Ow0KICAgIGNvbG9yOiAjZGRkOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQp9DQoNCi5idG4tcmVhZG1lOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjYmIyZDNiOw0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjZGRkOw0KICAgIGNvbG9yOiAjZGRkOw0KfQ0KDQouYnRuLXByaW1hcnk6aG92ZXIgew0KICAgIGNvbG9yOiB2YXIoLS1icy1idG4taG92ZXItY29sb3IpOw0KICAgIGJhY2tncm91bmQtY29sb3I6IHZhcigtLWJzLWJ0bi1ob3Zlci1iZyk7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNGOEY4Rjg7DQp9DQoNCi5maWxlX2J0biwNCi5pdGVtX2J0biwNCi5ub19pbmZvX2J0biB7DQogICAgYm9yZGVyLXJhZGl1czogMC4zNzVlbTsNCiAgICBjb2xvcjogI2NjYzsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgZGlzcGxheTogaW5saW5lLWJsb2NrOw0KICAgIGZvbnQtc2l6ZTogMC45NWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luOiAwLjVlbSAwLjVlbSAwLjVlbSAwLjVlbTsNCiAgICBvdXRsaW5lOiBub25lOw0KICAgIHBhZGRpbmc6IDEuMjVlbTsNCiAgICB0ZXh0LWFsaWduOiBsZWZ0Ow0KICAgIHdpZHRoOiBhdXRvOw0KfQ0KDQouZmlsZV9idG4gew0KICAgIGJhY2tncm91bmQ6ICMxOTg3NTQ7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICMxOTg3NTQ7DQp9DQoNCi5pdGVtX2J0biB7DQogICAgYmFja2dyb3VuZDogIzBkNmVmZDsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgIzBkNmVmZDsNCn0NCg0KLm5vX2luZm9fYnRuIHsNCiAgICBiYWNrZ3JvdW5kOiAjNmM3NTdkOw0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjNmM3NTdkOw0KfQ0KDQouZmlsZV9idG46aG92ZXIsDQouaXRlbV9idG46aG92ZXIsDQoubm9faW5mb19idG46aG92ZXIgew0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjY2NjOw0KfQ0KDQouZmlsZV9idG46aG92ZXIgew0KICAgIGJhY2tncm91bmQ6ICMxNTczNDc7DQp9DQoNCi5pdGVtX2J0bjpob3ZlciB7DQogICAgYmFja2dyb3VuZDogIzBiNWVkNzsNCn0NCg0KLm5vX2luZm9fYnRuOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kOiAjNWM2MzZhOw0KfQ0KDQouZmlsZV9idG5fbGFiZWwsDQouaXRlbV9idG5fbGFiZWwgew0KICAgIGNvbG9yOiAjY2NjOw0KICAgIGZvbnQtc2l6ZTogMS4xZW07DQogICAgZm9udC13ZWlnaHQ6IG5vcm1hbDsNCiAgICBtYXJnaW4tdG9wOiAwLjVlbTsNCn0NCg0KLmZpbGVfYnRuX3RleHQsDQouaXRlbV9idG5fdGV4dCwNCi5ub19pbmZvX2J0bl90ZXh0IHsNCiAgICBjb2xvcjogI2Y4ZjhmODsNCiAgICBkaXNwbGF5OiBibG9jazsNCiAgICBtYXJnaW46IDBlbTsNCiAgICBwb3NpdGlvbjogcmVsYXRpdmU7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICBmb250LXNpemU6IDEuMWVtOw0KICAgIHdpZHRoOiBhdXRvOw0KfQ0KDQouYnRuVGV4dCB7DQogICAgY29sb3I6ICNmOGY4Zjg7DQogICAgZGlzcGxheTogaW5saW5lOw0KICAgIG1hcmdpbjogMHJlbSAxcmVtIDByZW0gMXJlbTsNCiAgICBwb3NpdGlvbjogcmVsYXRpdmU7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICBmb250LXNpemU6IDEuMjVyZW07DQogICAgd2lkdGg6IGF1dG87DQp9DQoNCi5idG5UZXh0OjphZnRlciB7DQogICAgYmFja2dyb3VuZDogI2Y4ZjhmODsNCiAgICBib3R0b206IC0ycHg7DQogICAgY29udGVudDogIiI7DQogICAgaGVpZ2h0OiAycHg7DQogICAgbGVmdDogMDsNCiAgICBwb3NpdGlvbjogYWJzb2x1dGU7DQogICAgdHJhbnNmb3JtOiBzY2FsZVgoMCk7DQogICAgdHJhbnNmb3JtLW9yaWdpbjogcmlnaHQ7DQogICAgdHJhbnNpdGlvbjogdHJhbnNmb3JtIDAuMnMgZWFzZS1pbjsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLm1lbnVJdGVtOmhvdmVyIC5idG5UZXh0OjphZnRlciB7DQogICAgdHJhbnNmb3JtOiBzY2FsZVgoMSk7DQogICAgdHJhbnNmb3JtLW9yaWdpbjogbGVmdDsNCn0NCg0KYnV0dG9uIHsNCiAgICB3aWR0aDogMTAwJTsNCiAgICBoZWlnaHQ6IDEwMCU7DQp9DQoNCnRhYmxlLA0KdHIsDQp0ZCB7DQogICAgYm9yZGVyOiAxcHggc29saWQgdHJhbnNwYXJlbnQ7DQogICAgYm9yZGVyLWNvbGxhcHNlOiBjb2xsYXBzZTsNCiAgICBoZWlnaHQ6IDEwMCU7DQp9DQoNCi5tZW51VGFibGUgew0KICAgIGJvcmRlci1jb2xsYXBzZTogc2VwYXJhdGU7DQogICAgYm9yZGVyLXNwYWNpbmc6IDFlbTsNCiAgICBtYXJnaW4tdG9wOiAxZW07DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5tZW51VGFibGUgYnV0dG9uIHsNCiAgICBib3JkZXI6IDFweCBzb2xpZCB0cmFuc3BhcmVudDsNCiAgICBwYWRkaW5nOiAycmVtOw0KICAgIHdpZHRoOiAxMDAlOw0KICAgIGhlaWdodDogMTAwJTsNCn0NCg0KLm1lbnVJdGVtIHsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgdHJhbnNwYXJlbnQ7DQogICAgd2lkdGg6IDIwJTsNCn0NCg0KQHBhZ2Ugew0KICAgIHNpemU6IEE0Ow0KDQogICAgQGJvdHRvbS1jZW50ZXIgew0KICAgICAgICBjb250ZW50OiAiUGFnZSAiY291bnRlcihwYWdlKTsNCiAgICB9DQp9DQoNCkBtZWRpYSBwcmludCB7DQogICAgLm5vLXByaW50LCAubm8tcHJpbnQgKiB7DQogICAgICAgIGRpc3BsYXk6IG5vbmU7DQogICAgfQ0KDQogICAgaHRtbCwgYm9keSB7DQogICAgICAgIG1hcmdpbjogMHJlbTsNCiAgICAgICAgYmFja2dyb3VuZDogdHJhbnNwYXJlbnQ7DQogICAgfQ0KDQogICAgLmRhdGFfYm9keSB7DQogICAgICAgIGJhY2tncm91bmQtY29sb3I6IHRyYW5zcGFyZW50Ow0KICAgICAgICBjb2xvcjogIzAwMDsNCiAgICB9DQp9
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

            <div class='nav'>
                <a class='readme' href='Resources\static\readme.html' target='_blank'><strong>Read Me</strong></a>&ensp;|&ensp;
                <a href='#process_capture'>Process Capture</a>&ensp;|&ensp;
                <a href='#ram_capture'>RAM Capture</a>&ensp;|&ensp;
                <a href='#edd'>Encryption Detection</a>&ensp;|&ensp;
                <a href='#device'>Device Info</a>&ensp;|&ensp;
                <a href='#user'>User Info</a>&ensp;|&ensp;
                <a href='#network'>Network Info</a>&ensp;|&ensp;
                <a href='#processes'>Process Info</a>&ensp;|&ensp;
                <a href='#system'>System Info</a>&ensp;|&ensp;
                <a href='#prefetch'>Prefetch Info</a>&ensp;|&ensp;
                <a href='#events'>Event Log Info</a>&ensp;|&ensp;
                <a href='#firewall'>Firewall Info</a>&ensp;|&ensp;
                <a href='#bitlocker'>BitLocker Info</a>&ensp;|&ensp;
                <a href='#ntuser'>NTUSER.DAT Files</a>&ensp;|&ensp;
                <a href='#file_lists'>File List(s)</a>&ensp;|&ensp;
                <a href='#keywords'>Keyword Search(s)</a>
            </div>
"

    Add-Content -Path $FilePath -Value $MainReportPage -Encoding UTF8
}

function Write-MainHtmlPageEnd {

    param (
        [string]$FilePath
    )

    $MainHtmlPageEnd = "
    </body>
</html>"

    Add-Content -Path $FilePath -Value $MainHtmlPageEnd -Encoding UTF8

}


Export-ModuleMember -Function Write-HtmlReadMePage, Write-MainHtmlPage, Write-MainHtmlPageEnd -Variable HtmlHeader, HtmlFooter, ReturnHtmlSnippet, AllStyleCssEncodedText
