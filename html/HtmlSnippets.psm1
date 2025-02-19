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
LyogYWxsc3R5bGUuY3NzICovDQoNCiosICo6OmJlZm9yZSwgKjo6YWZ0ZXIgew0KICAgIGJveC1zaXppbmc6IGJvcmRlci1ib3g7DQogICAgbWFyZ2luOiAwOw0KICAgIHBhZGRpbmc6IDA7DQogICAgLXdlYmtpdC1mb250LXNtb290aGluZzogYW50aWFsaWFzZWQ7DQogICAgdGV4dC1yZW5kZXJpbmc6IG9wdGltaXplTGVnaWJpbGl0eTsNCn0NCg0KaHRtbCB7DQogICAgZm9udC1mYW1pbHk6ICdTZWdvZSBVSScsIEZydXRpZ2VyLCAnRnJ1dGlnZXIgTGlub3R5cGUnLCAnRGVqYXZ1IFNhbnMnLCAnSGVsdmV0aWNhIE5ldWUnLCBBcmlhbCwgc2Fucy1zZXJpZjsNCiAgICBmb250LXdlaWdodDogMzAwOw0KfQ0KDQpib2R5IHsNCiAgICBiYWNrZ3JvdW5kOiAjMjIyOw0KICAgIGZvbnQtc2l6ZTogMWVtOw0KICAgIGNvbG9yOiAjZGRkOw0KICAgIC0tZHJvcEJ0bkNvbG9yOiAjMUU4NDQ5Ow0KICAgIC0tbmF2QnRuUGFkZGluZzogMXB4IDBweCAxcHggMTBweDsNCiAgICAtLW5hdkJ0bkNvbG9ySG92ZXI6ICMyODc0QTY7DQogICAgLS1uYXZCdG5Ib3ZlclRleHRDb2xvcjogI0ZGRkZGRjsNCiAgICAtLW5hdkJ0bkhvdmVyQm9yZGVyOiAxcHggZGFzaGVkICNGRkZGRkY7DQogICAgLS1uYXZCdG5Ib3ZlclJhZGl1czogNXB4Ow0KICAgIC0tbmF2QnRuSGVpZ2h0OiAyLjI1ZW07DQogICAgLS1uYXZCdG5XaWR0aDogOTAlOw0KICAgIC0tbmF2QnRuRm9udEZhbWlseTogJ1JvYm90byBMaWdodCc7DQogICAgLS1uYXZCdG5Gb250U2l6ZTogMS4wNWVtOw0KICAgIG1hcmdpbjogMDsNCiAgICBwYWRkaW5nOiAwOw0KfQ0KDQphIHsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQp9DQoNCnAgew0KICAgIHdoaXRlLXNwYWNlOiBwcmUtd3JhcDsNCn0NCg0KLmJ0bl9sYWJlbCB7DQogICAgY29sb3I6ICNGRkY7DQogICAgZm9udC1zaXplOiAxLjFlbTsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIG1hcmdpbi10b3A6IDAuNWVtOw0KfQ0KDQouY2VudGVyIHsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQp9DQoNCi5yaWdodCB7DQogICAgdGV4dC1hbGlnbjogcmlnaHQ7DQp9DQoNCi5mcm9udF9iYWNrZ3JvdW5kLA0KLm5hdl9iYWNrZ3JvdW5kLA0KLnJlYWRtZV9iYWNrZ3JvdW5kIHsNCiAgICAvKiBiYWNrZ3JvdW5kOiAjMjIzMTNmOyAqLw0KICAgIGJhY2tncm91bmQ6ICMyMjI7DQogICAgY29sb3I6ICNEREQ7DQp9DQoNCi5uYXZfaW1hZ2Ugew0KICAgIGhlaWdodDogMTAwcHg7DQogICAgbWFyZ2luOiAyNHB4IDBweDsNCiAgICB3aWR0aDogMTAwcHg7DQp9DQoNCi5tYWluIHsNCiAgICBtYXJnaW46IDJlbSAyZW0gMWVtIDJlbTsNCn0NCg0KLnNlY3Rpb25faGVhZGVyIHsNCiAgICBmb250LXNpemU6IDAuOWVtOw0KICAgIG1hcmdpbjogMWVtIDBlbTsNCn0NCg0KLmNhc2VfaW5mbyB7DQogICAgYWxpZ24taXRlbXM6IGNlbnRlcjsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgI0RERDsNCiAgICBjb2xvcjogI0RERDsNCiAgICBkaXNwbGF5OiBmbGV4Ow0KICAgIGZsZXgtZGlyZWN0aW9uOiBjb2x1bW47DQogICAganVzdGlmeS1jb250ZW50OiBjZW50ZXI7DQogICAgbWFyZ2luLWJvdHRvbTogMWVtOw0KICAgIHBhZGRpbmctYm90dG9tOiAxZW07DQp9DQoNCi5uYXYgew0KICAgIGFsaWduLWNvbnRlbnQ6IGNlbnRlcjsNCiAgICBhbGlnbi1pdGVtczogY2VudGVyOw0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCB0cmFuc3BhcmVudDsNCiAgICBkaXNwbGF5OiBmbGV4Ow0KICAgIGZsZXgtZGlyZWN0aW9uOiByb3c7DQogICAgZmxleC13cmFwOiB3cmFwOw0KICAgIGp1c3RpZnktY29udGVudDogY2VudGVyOw0KICAgIG1hcmdpbjogMS41ZW0gMGVtOw0KfQ0KDQoubmF2IGEgew0KICAgIGNvbG9yOiBkb2RnZXJibHVlOw0KfQ0KDQoubmF2IGE6aG92ZXIgew0KICAgIHRleHQtZGVjb3JhdGlvbjogdW5kZXJsaW5lOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQp9DQoNCi5uYXYgLnJlYWRtZSB7DQogICAgY29sb3I6ICNDQjQzMzU7DQp9DQoNCi5uYXYgLnJlYWRtZTpob3ZlciB7DQogICAgdGV4dC1kZWNvcmF0aW9uOiB1bmRlcmxpbmU7DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCn0NCg0KLml0ZW1fdGFibGUgew0KICAgIGFsaWduLWNvbnRlbnQ6IGNlbnRlcjsNCiAgICBhbGlnbi1pdGVtczogY2VudGVyOw0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjREREOw0KICAgIGRpc3BsYXk6IGZsZXg7DQogICAgZmxleC1kaXJlY3Rpb246IHJvdzsNCiAgICBmbGV4LXdyYXA6IHdyYXA7DQogICAganVzdGlmeS1jb250ZW50OiBzcGFjZS1ldmVubHk7DQogICAgcGFkZGluZzogMC43NWVtOw0KfQ0KDQouY2FzZV9pbmZvX2RldGFpbHMgew0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCiAgICBwYWRkaW5nOiAwLjNlbSAwLjVlbSAwLjNlbSAwZW07DQogICAgdGV4dC1hbGlnbjogcmlnaHQ7DQp9DQoNCi5jYXNlX2luZm9fdGV4dCB7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KICAgIHBhZGRpbmc6IDAuM2VtIDBlbSAwLjNlbSAwLjVlbTsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCn0NCg0KLnRvcF9oZWFkaW5nIHsNCiAgICBjb2xvcjogI0NCNDMzNTsNCiAgICBmb250LXNpemU6IDIuNGVtOw0KICAgIG1hcmdpbjogMC4yNWVtIDBlbSAwLjI1ZW0gMGVtOw0KICAgIHBhZGRpbmc6IDA7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICB0ZXh0LXRyYW5zZm9ybTogdXBwZXJjYXNlOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLmZpcnN0X2xpbmUgew0KICAgIGZvbnQtc2l6ZTogMS41ZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IDFyZW0gMCAwLjVyZW0gMDsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQp9DQoNCi5zZWNvbmRfbGluZSB7DQogICAgZm9udC1zaXplOiAxLjM1ZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IC0wLjI1cmVtIDAgMnJlbSAwOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLm51bWJlcl9saXN0IHsNCiAgICBmb250LWZhbWlseTogUm9ib3RvOw0KICAgIGZvbnQtc2l6ZTogMC45ZW07DQogICAgbWFyZ2luLWxlZnQ6IDFlbTsNCn0NCg0KLmRhdGFfYm9keSB7DQogICAgbWFyZ2luOiAyZW0gMmVtOw0KfQ0KDQouZGF0YV9ib2R5IGEsDQoubnVtYmVyX2xpc3QgYSB7DQogICAgY29sb3I6IGRvZGdlcmJsdWU7DQogICAgZGlzcGxheTogYmxvY2s7DQogICAgcGFkZGluZy1ib3R0b206IDAuNWVtOw0KfQ0KDQouZGF0YV9ib2R5IGE6aG92ZXIsDQoubnVtYmVyX2xpc3QgYTpob3ZlciB7DQogICAgYmFja2dyb3VuZDogIzQ0NDsNCiAgICBib3JkZXI6IDFweCBkYXNoZWQgd2hpdGU7DQp9DQoNCi5udW1iZXJfbGlzdCAuZmlsZV9saW5rIHsNCiAgICBjb2xvcjogIzI4YjQ2MzsNCiAgICBkaXNwbGF5OiBibG9jazsNCiAgICBwYWRkaW5nLWJvdHRvbTogMC41ZW07DQp9DQoNCi5oZWFkaW5nIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjYWFhOw0KICAgIGNvbG9yOiAjQ0I0MzM1Ow0KICAgIGZvbnQtc2l6ZTogMS4yZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IDBlbSAwLjM1ZW07DQogICAgbWF4LXdpZHRoOiBhdXRvOw0KICAgIHBhZGRpbmc6IDVweCAwcHggNXB4IDBweDsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsNCn0NCg0KLnJlcG9ydF9zZWN0aW9uIHsNCiAgICBkaXNwbGF5OiBmbGV4Ow0KICAgIGZsZXgtZGlyZWN0aW9uOiBjb2x1bW47DQogICAgbWF4LXdpZHRoOiBhdXRvOw0KfQ0KDQoubmF2X2xpc3RfaXRlbSB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogdHJhbnNwYXJlbnQ7DQogICAgY29sb3I6ICNDQjQzMzU7DQogICAgZm9udC1mYW1pbHk6IHZhcigtLW5hdkJ0bkZvbnRGYW1pbHkpOw0KICAgIGZvbnQtc2l6ZTogdmFyKC0tbmF2QnRuRm9udFNpemUpOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgaGVpZ2h0OiB2YXIoLS1uYXZCdG5IZWlnaHQpOw0KICAgIG1hcmdpbjogMC4xNWVtIDAuMzVlbTsNCiAgICBtYXgtd2lkdGg6IGF1dG87DQogICAgcGFkZGluZzogN3B4IDBweDsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCn0NCg0KLm5hdl9saXN0X2l0ZW06aG92ZXIgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICMxZjYxOGQ7DQogICAgY29sb3I6ICNEREQ7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIGZvbnQtc2l6ZTogdmFyKC0tbmF2QnRuRm9udFNpemUpOw0KICAgIGZvbnQtd2VpZ2h0OiA2MDA7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KfQ0KDQouZnJvbnRwYWdlX3RhYmxlIHsNCiAgICBib3JkZXItY29sbGFwc2U6IGNvbGxhcHNlOw0KICAgIGNvbG9yOiAjREREOw0KICAgIHRhYmxlLWxheW91dDogZml4ZWQ7DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5jYXNlX2luZm9fZGV0YWlscyB7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KICAgIHBhZGRpbmc6IDAuM2VtIDAuNWVtIDAuM2VtIDBlbTsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCn0NCg0KLmNhc2VfaW5mb190ZXh0IHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMGVtIDAuM2VtIDAuNWVtOw0KICAgIHRleHQtYWxpZ246IGxlZnQ7DQp9DQoNCi8qIFN0eWxlIHRoZSBidXR0b24gdGhhdCBpcyB1c2VkIHRvIG9wZW4gYW5kIGNsb3NlIHRoZSBjb2xsYXBzaWJsZSBjb250ZW50ICovDQouY29sbGFwc2libGUgew0KICAgIGJhY2tncm91bmQtY29sb3I6ICM3Nzc7DQogICAgYm9yZGVyOiA0cHggc29saWQgdHJhbnNwYXJlbnQ7DQogICAgYm9yZGVyLXJhZGl1czogMC4zNzVlbTsNCiAgICBjb2xvcjogI0RERDsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgZm9udC1zaXplOiAwLjk1ZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IDBlbTsNCiAgICBvdXRsaW5lOiBub25lOw0KICAgIHBhZGRpbmc6IDE4cHg7DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLyogQWRkIGEgYmFja2dyb3VuZCBjb2xvciB0byB0aGUgYnV0dG9uIGlmIGl0IGlzIGNsaWNrZWQgb24gKGFkZCB0aGUgLmFjdGl2ZSBjbGFzcyB3aXRoIEpTKSwgYW5kIHdoZW4geW91IG1vdmUgdGhlIG1vdXNlIG92ZXIgaXQgKGhvdmVyKSAqLw0KLmNvbGxhcHNpYmxlOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjNzc3Ow0KICAgIGJvcmRlcjogNHB4IGRhc2hlZCAjZGMzNTQ1Ow0KICAgIGNvbG9yOiAjREREOw0KICAgIGZvbnQtc2l6ZTogMC45NWVtOw0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCn0NCg0KLmJ0biB7DQogICAgaGVpZ2h0OiAxMDAlOw0KICAgIHdpZHRoOiAxMDAlOw0KICAgIC0tYnMtYnRuLXBhZGRpbmcteDogMC43NXJlbTsNCiAgICAtLWJzLWJ0bi1wYWRkaW5nLXk6IDAuMzc1cmVtOw0KICAgIC0tYnMtYnRuLWZvbnQtZmFtaWx5OiA7DQogICAgLS1icy1idG4tZm9udC1zaXplOiAxcmVtOw0KICAgIC0tYnMtYnRuLWZvbnQtd2VpZ2h0OiA0MDA7DQogICAgLS1icy1idG4tbGluZS1oZWlnaHQ6IDEuNTsNCiAgICAtLWJzLWJ0bi1jb2xvcjogdmFyKC0tYnMtYm9keS1jb2xvcik7DQogICAgLS1icy1idG4tYmc6IHRyYW5zcGFyZW50Ow0KICAgIC0tYnMtYnRuLWJvcmRlci13aWR0aDogMnB4Ow0KICAgIC0tYnMtYnRuLWJvcmRlci1jb2xvcjogdHJhbnNwYXJlbnQ7DQogICAgLS1icy1idG4tYm9yZGVyLXJhZGl1czogMC4zNzVyZW07DQogICAgLS1icy1idG4taG92ZXItYm9yZGVyLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICAtLWJzLWJ0bi1ib3gtc2hhZG93OiBpbnNldCAwIDFweCAwIHJnYmEoMjU1LCAyNTUsIDI1NSwgMC4xNSksIDAgMXB4IDFweCByZ2JhKDAsIDAsIDAsIDAuMDc1KTsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1vcGFjaXR5OiAwLjY1Ow0KICAgIC0tYnMtYnRuLWZvY3VzLWJveC1zaGFkb3c6IDAgMCAwIDAuMjVyZW0gcmdiYSh2YXIoLS1icy1idG4tZm9jdXMtc2hhZG93LXJnYiksIC41KTsNCiAgICBkaXNwbGF5OiBpbmxpbmUtYmxvY2s7DQogICAgcGFkZGluZzogdmFyKC0tYnMtYnRuLXBhZGRpbmcteSkgdmFyKC0tYnMtYnRuLXBhZGRpbmcteCk7DQogICAgZm9udC1mYW1pbHk6IHZhcigtLWJzLWJ0bi1mb250LWZhbWlseSk7DQogICAgZm9udC1zaXplOiB2YXIoLS1icy1idG4tZm9udC1zaXplKTsNCiAgICBmb250LXdlaWdodDogdmFyKC0tYnMtYnRuLWZvbnQtd2VpZ2h0KTsNCiAgICBsaW5lLWhlaWdodDogdmFyKC0tYnMtYnRuLWxpbmUtaGVpZ2h0KTsNCiAgICBjb2xvcjogdmFyKC0tYnMtYnRuLWNvbG9yKTsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KICAgIHZlcnRpY2FsLWFsaWduOiBtaWRkbGU7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIC13ZWJraXQtdXNlci1zZWxlY3Q6IG5vbmU7DQogICAgLW1vei11c2VyLXNlbGVjdDogbm9uZTsNCiAgICB1c2VyLXNlbGVjdDogbm9uZTsNCiAgICBib3JkZXI6IHZhcigtLWJzLWJ0bi1ib3JkZXItd2lkdGgpIHNvbGlkIHZhcigtLWJzLWJ0bi1ib3JkZXItY29sb3IpOw0KICAgIGJvcmRlci1yYWRpdXM6IHZhcigtLWJzLWJ0bi1ib3JkZXItcmFkaXVzKTsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiB2YXIoLS1icy1idG4tYmcpOw0KICAgIHRyYW5zaXRpb246IGNvbG9yIDAuMTVzIGVhc2UtaW4tb3V0LCBiYWNrZ3JvdW5kLWNvbG9yIDAuMTVzIGVhc2UtaW4tb3V0LCBib3JkZXItY29sb3IgMC4xNXMgZWFzZS1pbi1vdXQsIGJveC1zaGFkb3cgMC4xNXMgZWFzZS1pbi1vdXQ7DQp9DQoNCi5idG4tcHJpbWFyeSB7DQogICAgLS1icy1idG4tY29sb3I6ICNmZmY7DQogICAgLS1icy1idG4tYmc6ICMwZDZlZmQ7DQogICAgLS1icy1idG4tYm9yZGVyLWNvbG9yOiAjMGQ2ZWZkOw0KICAgIC0tYnMtYnRuLWhvdmVyLWNvbG9yOiAjZmZmOw0KICAgIC0tYnMtYnRuLWhvdmVyLWJnOiAjMGI1ZWQ3Ow0KICAgIC0tYnMtYnRuLWhvdmVyLWJvcmRlci1jb2xvcjogIzBhNThjYTsNCiAgICAtLWJzLWJ0bi1mb2N1cy1zaGFkb3ctcmdiOiA0OSwgMTMyLCAyNTM7DQogICAgLS1icy1idG4tYWN0aXZlLWNvbG9yOiAjZmZmOw0KICAgIC0tYnMtYnRuLWFjdGl2ZS1iZzogIzBhNThjYTsNCiAgICAtLWJzLWJ0bi1hY3RpdmUtYm9yZGVyLWNvbG9yOiAjMGE1M2JlOw0KICAgIC0tYnMtYnRuLWFjdGl2ZS1zaGFkb3c6IGluc2V0IDAgM3B4IDVweCByZ2JhKDAsIDAsIDAsIDAuMTI1KTsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1jb2xvcjogI2ZmZjsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1iZzogIzBkNmVmZDsNCiAgICAtLWJzLWJ0bi1kaXNhYmxlZC1ib3JkZXItY29sb3I6ICMwZDZlZmQ7DQp9DQoNCi5idG4tcmVhZG1lIHsNCiAgICBiYWNrZ3JvdW5kOiAjZGMzNTQ1Ow0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjZGMzNTQ1Ow0KICAgIGNvbG9yOiAjZGRkOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQp9DQoNCi5idG4tcmVhZG1lOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjYmIyZDNiOw0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjZGRkOw0KICAgIGNvbG9yOiAjZGRkOw0KfQ0KDQouYnRuLXByaW1hcnk6aG92ZXIgew0KICAgIGNvbG9yOiB2YXIoLS1icy1idG4taG92ZXItY29sb3IpOw0KICAgIGJhY2tncm91bmQtY29sb3I6IHZhcigtLWJzLWJ0bi1ob3Zlci1iZyk7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICNGOEY4Rjg7DQp9DQoNCi5maWxlX2J0biwNCi5pdGVtX2J0biwNCi5ub19pbmZvX2J0biB7DQogICAgYm9yZGVyLXJhZGl1czogMC4zNzVlbTsNCiAgICBjb2xvcjogI2NjYzsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgZGlzcGxheTogaW5saW5lLWJsb2NrOw0KICAgIGZvbnQtc2l6ZTogMC45NWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luOiAwLjVlbSAwLjVlbSAwLjVlbSAwLjVlbTsNCiAgICBvdXRsaW5lOiBub25lOw0KICAgIHBhZGRpbmc6IDEuMjVlbTsNCiAgICB0ZXh0LWFsaWduOiBsZWZ0Ow0KICAgIHdpZHRoOiBhdXRvOw0KfQ0KDQouZmlsZV9idG4gew0KICAgIGJhY2tncm91bmQ6ICMxOTg3NTQ7DQogICAgYm9yZGVyOiAycHggZGFzaGVkICMxOTg3NTQ7DQp9DQoNCi5pdGVtX2J0biB7DQogICAgYmFja2dyb3VuZDogIzBkNmVmZDsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgIzBkNmVmZDsNCn0NCg0KLm5vX2luZm9fYnRuIHsNCiAgICBiYWNrZ3JvdW5kOiAjNmM3NTdkOw0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjNmM3NTdkOw0KfQ0KDQouZmlsZV9idG46aG92ZXIsDQouaXRlbV9idG46aG92ZXIsDQoubm9faW5mb19idG46aG92ZXIgew0KICAgIGJvcmRlcjogMnB4IGRhc2hlZCAjY2NjOw0KfQ0KDQouZmlsZV9idG46aG92ZXIgew0KICAgIGJhY2tncm91bmQ6ICMxNTczNDc7DQp9DQoNCi5pdGVtX2J0bjpob3ZlciB7DQogICAgYmFja2dyb3VuZDogIzBiNWVkNzsNCn0NCg0KLm5vX2luZm9fYnRuOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kOiAjNWM2MzZhOw0KfQ0KDQouZmlsZV9idG5fbGFiZWwsDQouaXRlbV9idG5fbGFiZWwgew0KICAgIGNvbG9yOiAjY2NjOw0KICAgIGZvbnQtc2l6ZTogMS4xZW07DQogICAgZm9udC13ZWlnaHQ6IG5vcm1hbDsNCiAgICBtYXJnaW4tdG9wOiAwLjVlbTsNCn0NCg0KLmZpbGVfYnRuX3RleHQsDQouaXRlbV9idG5fdGV4dCwNCi5ub19pbmZvX2J0bl90ZXh0IHsNCiAgICBjb2xvcjogI2Y4ZjhmODsNCiAgICBkaXNwbGF5OiBibG9jazsNCiAgICBtYXJnaW46IDBlbTsNCiAgICBwb3NpdGlvbjogcmVsYXRpdmU7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICBmb250LXNpemU6IDEuMWVtOw0KICAgIHdpZHRoOiBhdXRvOw0KfQ0KDQouYnRuVGV4dCB7DQogICAgY29sb3I6ICNmOGY4Zjg7DQogICAgZGlzcGxheTogaW5saW5lOw0KICAgIG1hcmdpbjogMHJlbSAxcmVtIDByZW0gMXJlbTsNCiAgICBwb3NpdGlvbjogcmVsYXRpdmU7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICBmb250LXNpemU6IDEuMjVyZW07DQogICAgd2lkdGg6IGF1dG87DQp9DQoNCi5idG5UZXh0OjphZnRlciB7DQogICAgYmFja2dyb3VuZDogI2Y4ZjhmODsNCiAgICBib3R0b206IC0ycHg7DQogICAgY29udGVudDogIiI7DQogICAgaGVpZ2h0OiAycHg7DQogICAgbGVmdDogMDsNCiAgICBwb3NpdGlvbjogYWJzb2x1dGU7DQogICAgdHJhbnNmb3JtOiBzY2FsZVgoMCk7DQogICAgdHJhbnNmb3JtLW9yaWdpbjogcmlnaHQ7DQogICAgdHJhbnNpdGlvbjogdHJhbnNmb3JtIDAuMnMgZWFzZS1pbjsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLm1lbnVJdGVtOmhvdmVyIC5idG5UZXh0OjphZnRlciB7DQogICAgdHJhbnNmb3JtOiBzY2FsZVgoMSk7DQogICAgdHJhbnNmb3JtLW9yaWdpbjogbGVmdDsNCn0NCg0KYnV0dG9uIHsNCiAgICB3aWR0aDogMTAwJTsNCiAgICBoZWlnaHQ6IDEwMCU7DQp9DQoNCnRhYmxlLA0KdHIsDQp0ZCB7DQogICAgYm9yZGVyOiAxcHggc29saWQgdHJhbnNwYXJlbnQ7DQogICAgYm9yZGVyLWNvbGxhcHNlOiBjb2xsYXBzZTsNCiAgICBoZWlnaHQ6IDEwMCU7DQp9DQoNCi5tZW51VGFibGUgew0KICAgIGJvcmRlci1jb2xsYXBzZTogc2VwYXJhdGU7DQogICAgYm9yZGVyLXNwYWNpbmc6IDFlbTsNCiAgICBtYXJnaW4tdG9wOiAxZW07DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5tZW51VGFibGUgYnV0dG9uIHsNCiAgICBib3JkZXI6IDFweCBzb2xpZCB0cmFuc3BhcmVudDsNCiAgICBwYWRkaW5nOiAycmVtOw0KICAgIHdpZHRoOiAxMDAlOw0KICAgIGhlaWdodDogMTAwJTsNCn0NCg0KLm1lbnVJdGVtIHsNCiAgICBib3JkZXI6IDJweCBkYXNoZWQgdHJhbnNwYXJlbnQ7DQogICAgd2lkdGg6IDIwJTsNCn0NCg0KQHBhZ2Ugew0KICAgIHNpemU6IEE0Ow0KDQogICAgQGJvdHRvbS1jZW50ZXIgew0KICAgICAgICBjb250ZW50OiAiUGFnZSAiY291bnRlcihwYWdlKTsNCiAgICB9DQp9DQoNCkBtZWRpYSBwcmludCB7DQogICAgLm5vLXByaW50LCAubm8tcHJpbnQgKiB7DQogICAgICAgIGRpc3BsYXk6IG5vbmU7DQogICAgfQ0KDQogICAgaHRtbCwgYm9keSB7DQogICAgICAgIG1hcmdpbjogMHJlbTsNCiAgICAgICAgYmFja2dyb3VuZDogdHJhbnNwYXJlbnQ7DQogICAgfQ0KDQogICAgLmRhdGFfYm9keSB7DQogICAgICAgIGJhY2tncm91bmQtY29sb3I6IHRyYW5zcGFyZW50Ow0KICAgICAgICBjb2xvcjogIzAwMDsNCiAgICB9DQp9DQo=
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
                <a class='readme' href='Resources\static\readme.html' target='_blank'><strong>Read Me First</strong></a>
                <!-- <a href='#process_capture'>Process Capture</a>&ensp;|&ensp;
                <a href='#ram_capture'>RAM Capture</a>&ensp;|&ensp;
                <a href='#edd'>Encryption Detection</a>&ensp;|&ensp;
                <a href='#hives'>Registry Hives</a>&ensp;|&ensp;
                <a href='results\001\001_main.html' target='_blank'>Device Info</a>&ensp;|&ensp;
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
                <a href='#keywords'>Keyword Search(s)</a> -->
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
