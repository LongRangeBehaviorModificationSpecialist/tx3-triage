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

        <link rel='stylesheet' type='text/css' href='../css/style.css' />

        <script>
            window.console = window.console || function (t) { };
        </script>

        <script>
            if (document.location.search.match(/type=embed/gi)) {
                window.parent.postMessage('resize', '*');
            }
        </script>

    </head>

    <body class='data_body' translate='no'>"


$HtmlDetailsHeader = "<!DOCTYPE html>

<html lang='en' dir='ltr'>

    <head>

        <title>$($ComputerName) Triage Data</title>

        <meta charset='utf-8' />
        <meta name='viewport' content='width=device-width, initial-scale=1.0' />
        <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1' />

        <script src='https://unpkg.com/ionicons@5.1.2/dist/ionicons.js'></script>
        <link href='https://fonts.googleapis.com/css2?family=DM+Sans:wght@400; 500&display=swap' rel='stylesheet'>
        <link href='https://unpkg.com/ionicons@4.5.10-0/dist/css/ionicons.min.css' rel='stylesheet'>

        <link rel='stylesheet' type='text/css' href='../css/styledetails.css' />

        <script>
            window.console = window.console || function (t) { };
        </script>

        <script>
            if (document.location.search.match(/type=embed/gi)) {
                window.parent.postMessage('resize', '*');
            }
        </script>

    </head>

    <body class='detail_body' translate='no'>"



# Variable to ass the "Return to Top" link next to each header
$ReturnHtmlSnippet = "<a href='#top' class='top'>(Return to Top)</a>"


$EndingHtml = "
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


$CssEncodedFileText = "
KiwgKjo6YmVmb3JlLCAqOjphZnRlciB7DQogICAgYm94LXNpemluZzogYm9yZGVyLWJveDsNCiAgICBtYXJnaW46IDA7DQogICAgcGFkZGluZzogMDsNCiAgICAtd2Via2l0LWZvbnQtc21vb3RoaW5nOiBhbnRpYWxpYXNlZDsNCiAgICB0ZXh0LXJlbmRlcmluZzogb3B0aW1pemVMZWdpYmlsaXR5Ow0KfQ0KDQouY2VudGVyIHsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQp9DQoNCi5udW1MaXN0IHsNCiAgICBmb250LWZhbWlseTogUm9ib3RvOw0KICAgIGZvbnQtc2l6ZTogMS4xNWVtOw0KICAgIGxpbmUtaGVpZ2h0OiAxLjM1Ow0KICAgIG1hcmdpbi1sZWZ0OiAxMCU7DQogICAgbWFyZ2luLXJpZ2h0OiAxMCU7DQp9DQoNCmh0bWwgew0KICAgIGZvbnQtZmFtaWx5OiAiU2Vnb2UgVUkiLCBGcnV0aWdlciwgIkZydXRpZ2VyIExpbm90eXBlIiwgIkRlamF2dSBTYW5zIiwgIkhlbHZldGljYSBOZXVlIiwgQXJpYWwsIHNhbnMtc2VyaWY7DQogICAgZm9udC13ZWlnaHQ6IDMwMDsNCn0NCg0KYm9keSB7DQogICAgYmFja2dyb3VuZDogI2ZmZjsNCiAgICBmb250LXNpemU6IDE2cHg7DQogICAgY29sb3I6ICMxODFCMjA7DQogICAgLS1kcm9wQnRuQ29sb3I6ICMxRTg0NDk7DQogICAgLS1uYXZCdG5QYWRkaW5nOiAxcHggMHB4IDFweCAxMHB4Ow0KICAgIC0tbmF2QnRuQ29sb3JIb3ZlcjogIzI4NzRBNjsNCiAgICAtLW5hdkJ0bkhvdmVyVGV4dENvbG9yOiAjRkZGRkZGOw0KICAgIC0tbmF2QnRuSG92ZXJCb3JkZXI6IDFweCBkYXNoZWQgI0ZGRkZGRjsNCiAgICAtLW5hdkJ0bkhvdmVyUmFkaXVzOiA1cHg7DQogICAgLS1uYXZCdG5IZWlnaHQ6IDIuMjVlbTsNCiAgICAtLW5hdkJ0bldpZHRoOiA5MCU7DQogICAgLS1uYXZCdG5Gb250RmFtaWx5OiAnUm9ib3RvIExpZ2h0JzsNCiAgICAtLW5hdkJ0bkZvbnRTaXplOiAxLjA1ZW07DQogICAgbWFyZ2luOiAwOw0KICAgIHBhZGRpbmc6IDA7DQp9DQoNCnAgew0KICAgIHdoaXRlLXNwYWNlOiBwcmUtd3JhcDsNCn0NCg0KLmRhdGFfYm9keSB7DQogICAgbWFyZ2luLWJvdHRvbTogMmVtOw0KICAgIG1hcmdpbi1sZWZ0OiA1JTsNCiAgICBtYXJnaW4tcmlnaHQ6IDUlOw0KfQ0KDQouZGF0YSB7DQogICAgY29sb3I6ICNmMDA7DQogICAgZm9udC1mYW1pbHk6ICdIZWx2ZXRpY2EnOw0KICAgIGZvbnQtd2VpZ2h0OiBib2xkOw0KICAgIGZvbnQtc2l6ZTogMS4xNWVtOw0KfQ0KDQoubmF2X19iYWNrZ3JvdW5kIHsNCiAgICBiYWNrZ3JvdW5kOiAjYmJiDQp9DQoNCi5tYWduZXQtbG9nbyB7DQogICAgaGVpZ2h0OiAxNTBweDsNCiAgICBtYXJnaW46IDMycHggMHB4IDMycHggMHB4Ow0KICAgIHdpZHRoOiAxNTBweDsNCn0NCg0KLyogTkVFRCBUTyBGSVggVEhBVCBUV08gRklMRVMgVVNFIFRIRSBgaGVhZGluZ2AgY2xhc3MgKi8NCg0KLmhlYWRpbmcgew0KICAgIGJhY2tncm91bmQtY29sb3I6IHJnYigyMzAsIDIzMCwgMjMwKTsNCiAgICBtYXJnaW46IDAuMmVtIDBlbTsNCiAgICBwYWRkaW5nOiA1cHggMHB4IDVweCAwcHg7DQogICAgZm9udC1zaXplOiAxLjJlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCiAgICB0ZXh0LXRyYW5zZm9ybTogdXBwZXJjYXNlOw0KDQp9DQoNCi5oZWFkaW5nIGxpIHsNCiAgICBsaXN0LXN0eWxlOiBub25lOw0KfQ0KDQouaGVhZGluZz51bCB7DQogICAgbWFyZ2luOiA4cHggMHB4IDhweDsNCn0NCg0KLmhlYWRpbmcgYSB7DQogICAgY29sb3I6ICMyMjI7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIGRpc3BsYXk6IGJsb2NrOw0KICAgIGhlaWdodDogMjVweDsNCiAgICBsaW5lLWhlaWdodDogMjVweDsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi5yZWFkX21lX2hlYWRpbmcgew0KICAgIHRleHQtdHJhbnNmb3JtOiB1cHBlcmNhc2U7DQogICAgZm9udC1zaXplOiAxLjJlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KfQ0KDQoucmVhZF9tZV9oZWFkaW5nIGxpIHsNCiAgICBsaXN0LXN0eWxlOiBub25lOw0KfQ0KDQoucmVhZF9tZV9oZWFkaW5nPnVsIHsNCiAgICBtYXJnaW46IDhweCAwcHggOHB4Ow0KfQ0KDQoucmVhZF9tZV9oZWFkaW5nIGEgew0KICAgIGNvbG9yOiAjMjIyOw0KICAgIGN1cnNvcjogcG9pbnRlcjsNCiAgICBkaXNwbGF5OiBibG9jazsNCiAgICBoZWlnaHQ6IDI1cHg7DQogICAgbGluZS1oZWlnaHQ6IDI1cHg7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KICAgIHdpZHRoOiAxMDAlOw0KfQ0KDQoNCi8qIE15IEFkZGVkIFN0eWxlICovDQouYnRuX18xIHsNCiAgICBib3JkZXI6IDFweDsNCiAgICBwYWRkaW5nOiB2YXIoLS1uYXZCdG5QYWRkaW5nKTsNCiAgICB3aWR0aDogdmFyKC0tbmF2QnRuV2lkdGgpOw0KICAgIGhlaWdodDogdmFyKC0tbmF2QnRuSGVpZ2h0KTsNCiAgICB0ZXh0LWFsaWduOiBsZWZ0Ow0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICBjb2xvcjogYmxhY2s7DQogICAgZm9udC1zaXplOiB2YXIoLS1uYXZCdG5Gb250U2l6ZSk7DQogICAgZm9udC1mYW1pbHk6IHZhcigtLW5hdkJ0bkZvbnRGYW1pbHkpOw0KICAgIC8qIGJvcmRlcjogMXB4IHNvbGlkIGJsYWNrOyAqLw0KICAgIGJvcmRlcjogMHB4IHNvbGlkIHRyYW5zcGFyZW50Ow0KICAgIGJhY2tncm91bmQtY29sb3I6IHRyYW5zcGFyZW50Ow0KfQ0KDQouYnRuX18xIHsNCiAgICBtYXJnaW46IDAuMTVlbSAwZW0gMGVtIDFlbTsNCn0NCg0KLyogTXkgQWRkZWQgU3R5bGUgKi8NCi5idG5fXzE6aG92ZXIsDQouYnRuX18yOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiB2YXIoLS1uYXZCdG5Db2xvckhvdmVyKTsNCiAgICBjb2xvcjogdmFyKC0tbmF2QnRuSG92ZXJUZXh0Q29sb3IpOw0KICAgIGJvcmRlcjogdmFyKC0tbmF2QnRuSG92ZXJCb3JkZXIpOw0KICAgIGJvcmRlci1yYWRpdXM6IHZhcigtLW5hdkJ0bkhvdmVyUmFkaXVzKTsNCiAgICBmb250LXdlaWdodDogNzAwOw0KICAgIHRyYW5zaXRpb246IGFsbCAwLjJzIGVhc2U7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIGhlaWdodDogMi4yNWVtOw0KICAgIGJveC1zaGFkb3c6IDVweCA1cHggNXB4ICM3RjhDOEQ7DQp9DQoNCi5idG5fXzEgYSwNCi5idG5fXzIgYSB7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lDQp9DQoNCi5idG5fXzEgYTphY3RpdmUsDQouYnRuX18yIGE6YWN0aXZlIHsNCiAgICB0ZXh0LWRlY29yYXRpb246IHVuZGVybGluZTsNCiAgICBjb2xvcjogI0NCNDMzNTsNCn0NCg0KLmJ0bl9fMSBhOnZpc2l0ZWQsDQouYnRuX18yIGE6dmlzaXRlZCB7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KICAgIGNvbG9yOiAjMDAwMDAwOw0KfQ0KDQovKiBNeSBBZGRlZCBTdHlsZSAqLw0KLmZyb250X19iYWNrZ3JvdW5kLA0KLmNhc2VfX2JhY2tncm91bmQsDQouZXZpZGVuY2VfX2JhY2tncm91bmQsDQoucmVhZG1lLWJhY2tncm91bmQgew0KICAgIGJhY2tncm91bmQ6ICMyMjMxM2Y7DQogICAgY29sb3I6ICNEREQ7DQp9DQoNCi5jYXNlaW5mbyB7DQogICAgZGlzcGxheTogZmxleDsNCiAgICBmbGV4LWRpcmVjdGlvbjogY29sdW1uOw0KICAgIG1hcmdpbjogMmVtIDJlbSAxZW0gMmVtOw0KICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7DQogICAganVzdGlmeS1jb250ZW50OiBjZW50ZXI7DQogICAgY29sb3I6ICNGRkZGRkY7DQogICAgYm9yZGVyOiAxcHggZGFzaGVkICNGRkZGRkY7DQp9DQoNCi50b3BIZWFkaW5nLA0KLnNlY29uZEhlYWRpbmcgew0KICAgIGNvbG9yOiAjQ0I0MzM1Ow0KICAgIG1hcmdpbjogMC41ZW0gMGVtIDBlbSAwZW07DQogICAgcGFkZGluZzogMDsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHRleHQtdHJhbnNmb3JtOiB1cHBlcmNhc2U7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KfQ0KDQoudG9wSGVhZGluZyB7DQogICAgZm9udC1zaXplOiAyLjRlbTsNCn0NCg0KLmZyb250cGFnZV9fdGFibGUgew0KICAgIGNvbG9yOiAjRkZGRkZGOw0KICAgIGJvcmRlci1jb2xsYXBzZTogY29sbGFwc2U7DQp9DQoNCi5mcm9udHBhZ2VfX3RhYmxlIHRkIHsNCiAgICBjb2xvcjogI0ZGRkZGRjsNCiAgICBib3JkZXItY29sbGFwc2U6IGNvbGxhcHNlOw0KICAgIGZvbnQtc2l6ZTogMS4yZW07DQp9DQoNCi5jYXNlaW5mb19fZGV0YWlscyB7DQogICAgZm9udC13ZWlnaHQ6IDQwMDsNCiAgICB2ZXJ0aWNhbC1hbGlnbjogY2VudGVyOw0KICAgIHBhZGRpbmc6IDAuM2VtIDAuNWVtIDAuM2VtIDBlbTsNCiAgICB0ZXh0LWFsaWduOiByaWdodDsNCn0NCg0KLmNhc2VpbmZvX190ZXh0IHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMGVtIDAuM2VtIDAuNWVtOw0KICAgIHRleHQtYWxpZ246IGxlZnQ7DQp9DQoNCi5jb250YWluZXIgew0KICAgIHdpZHRoOiAxMDAlOw0KICAgIGhlaWdodDogYXV0bzsNCiAgICAvKiBtYXJnaW4tbGVmdDogMnJlbTsgKi8NCiAgICAvKiBwYWRkaW5nOiAwcmVtIDFyZW07ICovDQogICAgLyogYmFja2dyb3VuZC1jb2xvcjogIzlEOUQ5RDsgKi8NCn0NCg0KLmJ1dHRvbi1jb250YWluZXIgew0KICAgIGRpc3BsYXk6IGZsZXg7DQogICAgZmxleC1kaXJlY3Rpb246IHJvdzsNCiAgICBmbGV4LXdyYXA6IG5vd3JhcDsNCiAgICBqdXN0aWZ5LWNvbnRlbnQ6IGNlbnRlcjsNCiAgICBhbGlnbi1pdGVtczogY2VudGVyOw0KICAgIHBvc2l0aW9uOiBmaXhlZDsNCiAgICB0b3A6IDA7DQogICAgbGVmdDogMDsNCiAgICB3aWR0aDogMTAwJTsNCiAgICBwYWRkaW5nOiAxZW0gMGVtOw0KICAgIGJhY2tncm91bmQtY29sb3I6ICMyMjMxM2Y7DQogICAgYm9yZGVyLWJvdHRvbTogMXB4IHNvbGlkICMwMDAwMDANCiAgICAgICAgLyogbWFyZ2luLXRvcDogMC41cmVtOyAqLw0KICAgICAgICAvKiBib3gtc2hhZG93OiAwIDdweCA4cHggcmdiYSgwLCAwLCAwLCAwLjEyKTsgKi8NCn0NCg0KLmJ1dHRvblRvcDpob3ZlciAuYnRuLXR4dDo6YWZ0ZXIgew0KICAgIHRyYW5zZm9ybTogc2NhbGVYKDEpOw0KICAgIHRyYW5zZm9ybS1vcmlnaW46IGxlZnQ7DQp9DQoNCi5wcmludC1idXR0b24sDQouY2xvc2UtYnV0dG9uIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjREREOw0KICAgIHdpZHRoOiAxM3JlbTsNCiAgICBoZWlnaHQ6IDNyZW07DQogICAgY29sb3I6IGJsYWNrOw0KICAgIGZvbnQtc2l6ZTogMXJlbTsNCiAgICBmb250LXdlaWdodDogNjAwOw0KICAgIGZvbnQtZmFtaWx5OiBWZXJkYW5hOw0KICAgIHRleHQtdHJhbnNmb3JtOiB1cHBlcmNhc2U7DQogICAgcGFkZGluZzogMC41cmVtOw0KfQ0KDQoucHJpbnQtYnV0dG9uOmhvdmVyLA0KLmNsb3NlLWJ1dHRvbjpob3ZlciB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzg4ODg4OEZGOw0KICAgIGJvcmRlcjogMnB4IGRvdHRlZCAjRkZGRkZGOw0KICAgIGNvbG9yOiB3aGl0ZTsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgYm94LXNoYWRvdzogMHB4IDFweCAxcHggcmdiYSgwLCAwLCAwLCAwLjc1KTsNCiAgICAvKiBib3JkZXItcmFkaXVzOiAxMHB4OyAqLw0KfQ0KDQouY2xvc2UtYnV0dG9uIHsNCiAgICBtYXJnaW4tbGVmdDogM2VtOw0KfQ0KDQouYnRuLXR4dCB7DQogICAgZGlzcGxheTogaW5saW5lOw0KICAgIHBvc2l0aW9uOiByZWxhdGl2ZTsNCiAgICBmb250LWZhbWlseTogJ1JvYm90byBMaWdodCc7DQp9DQoNCi5idG4tdHh0OjphZnRlciB7DQogICAgY29udGVudDogJyc7DQogICAgcG9zaXRpb246IGFic29sdXRlOw0KICAgIGxlZnQ6IDA7DQogICAgYm90dG9tOiAtMnB4Ow0KICAgIHdpZHRoOiAxMDAlOw0KICAgIGhlaWdodDogMnB4Ow0KICAgIGJhY2tncm91bmQ6ICNGRkZGRkY7DQogICAgdHJhbnNmb3JtOiBzY2FsZVgoMCk7DQogICAgdHJhbnNmb3JtLW9yaWdpbjogcmlnaHQ7DQogICAgdHJhbnNpdGlvbjogdHJhbnNmb3JtIDAuMnMgZWFzZS1pbjsNCn0NCg0KLmJ1dHRvblRvcDpob3ZlciAuYnRuLXR4dDo6YWZ0ZXIgew0KICAgIHRyYW5zZm9ybTogc2NhbGVYKDEpOw0KICAgIHRyYW5zZm9ybS1vcmlnaW46IGxlZnQ7DQp9DQoNCi5saW5lRmlyc3Qgew0KICAgIGZvbnQtc2l6ZTogMS41ZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IDFyZW0gMCAwLjVyZW0gMDsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQp9DQoNCi5saW5lU2Vjb25kIHsNCiAgICBmb250LXNpemU6IDEuMzVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogLTAuMjVyZW0gMCAycmVtIDA7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KfQ0KDQp0YWJsZSB7DQogICAgZm9udC1zaXplOiAwLjg1ZW07DQogICAgYm9yZGVyOiAwcHg7DQp9DQoNCnRkIHsNCiAgICBwYWRkaW5nOiA0cHg7DQogICAgbWFyZ2luOiAwcHg7DQogICAgYm9yZGVyOiAwOw0KICAgIHdoaXRlLXNwYWNlOiBwcmUtd3JhcDsNCn0NCg0KdGggew0KICAgIGJhY2tncm91bmQ6ICMzOTU4NzA7DQogICAgYmFja2dyb3VuZDogbGluZWFyLWdyYWRpZW50KCM0OTcwOGYsICMyOTNmNTApOw0KICAgIGNvbG9yOiAjZmZmOw0KICAgIGZvbnQtc2l6ZTogMS4wNWVtOw0KICAgIHRleHQtdHJhbnNmb3JtOiB1cHBlcmNhc2U7DQogICAgcGFkZGluZzogMTBweCAxNXB4Ow0KICAgIHZlcnRpY2FsLWFsaWduOiBtaWRkbGU7DQp9DQoNCi50b3Agew0KICAgIGNvbG9yOiBkb2RnZXJibHVlOw0KICAgIGRpc3BsYXk6IGlubGluZTsNCiAgICBmb250LXNpemU6IDEycHg7DQp9DQoNCi5pbmZvX2hlYWRlciB7DQogICAgbWFyZ2luLXRvcDogMS43NWVtOw0KICAgIG1hcmdpbi1ib3R0b206IDAuMjVlbTsNCn0NCg0KLyogU3R5bGUgdGhlIGJ1dHRvbiB0aGF0IGlzIHVzZWQgdG8gb3BlbiBhbmQgY2xvc2UgdGhlIGNvbGxhcHNpYmxlIGNvbnRlbnQgKi8NCi5jb2xsYXBzaWJsZSB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogI2VlZTsNCiAgICBib3JkZXI6IG5vbmU7DQogICAgYm9yZGVyOiAxcHg7DQogICAgY29sb3I6ICMzMzM7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIGZvbnQtc2l6ZTogMC44NWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luOiAyZW0gMGVtIDBlbSAwZW07DQogICAgb3V0bGluZTogbm9uZTsNCiAgICBwYWRkaW5nOiAxOHB4Ow0KICAgIHRleHQtYWxpZ246IGxlZnQ7DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCi8qIEFkZCBhIGJhY2tncm91bmQgY29sb3IgdG8gdGhlIGJ1dHRvbiBpZiBpdCBpcyBjbGlja2VkIG9uIChhZGQgdGhlIC5hY3RpdmUgY2xhc3Mgd2l0aCBKUyksIGFuZCB3aGVuIHlvdSBtb3ZlIHRoZSBtb3VzZSBvdmVyIGl0IChob3ZlcikgKi8NCi5hY3RpdmUsIC5jb2xsYXBzaWJsZTpob3ZlciB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogI2NjYzsNCiAgICBib3JkZXI6IDFweCBzb2xpZCBkb2RnZXJibHVlOw0KICAgIGNvbG9yOiBkb2RnZXJibHVlOw0KICAgIGZvbnQtd2VpZ2h0OiA2MDA7DQogICAgdGV4dC1kZWNvcmF0aW9uOiB1bmRlcmxpbmU7DQp9DQoNCi5jb2xsYXBzaWJsZTphZnRlciB7DQogICAgY29udGVudDogJ1wwMjc5NSc7DQogICAgLyogVW5pY29kZSBjaGFyYWN0ZXIgZm9yICJwbHVzIiBzaWduICgrKSAqLw0KICAgIGZvbnQtc2l6ZTogMTNweDsNCiAgICBjb2xvcjogIzc3NzsNCiAgICBmbG9hdDogcmlnaHQ7DQogICAgbWFyZ2luLWxlZnQ6IDVweDsNCn0NCg0KLmFjdGl2ZTphZnRlciB7DQogICAgY29udGVudDogIlwyNzk2IjsNCiAgICAvKiBVbmljb2RlIGNoYXJhY3RlciBmb3IgIm1pbnVzIiBzaWduICgtKSAqLw0KfQ0KDQovKiBTdHlsZSB0aGUgY29sbGFwc2libGUgY29udGVudC4gTm90ZTogaGlkZGVuIGJ5IGRlZmF1bHQgKi8NCi5jb250ZW50IHsNCiAgICBwYWRkaW5nOiAwIDE4cHg7DQogICAgZGlzcGxheTogbm9uZTsNCiAgICBvdmVyZmxvdzogaGlkZGVuOw0KICAgIGJhY2tncm91bmQtY29sb3I6ICNmMWYxZjE7DQp9DQoNCkBwYWdlIHsNCiAgICBzaXplOiBBNDsNCg0KICAgIEBib3R0b20tY2VudGVyIHsNCiAgICAgICAgY29udGVudDogIlBhZ2UgImNvdW50ZXIocGFnZSk7DQogICAgfQ0KfQ0KDQpAbWVkaWEgcHJpbnQgew0KICAgIC5uby1wcmludCwgLm5vLXByaW50ICogew0KICAgICAgICBkaXNwbGF5OiBub25lOw0KICAgIH0NCg0KICAgIGh0bWwsIGJvZHkgew0KICAgICAgICBtYXJnaW46IDByZW07DQogICAgICAgIGJhY2tncm91bmQ6IHRyYW5zcGFyZW50Ow0KICAgIH0NCg0KICAgIC5jb250YWluZXIgew0KICAgICAgICBiYWNrZ3JvdW5kLWNvbG9yOiB0cmFuc3BhcmVudDsNCiAgICB9DQoNCiAgICAuaGVhZGluZyB7DQogICAgICAgIG1hcmdpbi10b3A6IDFlbTsNCiAgICB9DQoNCiAgICAuaGVhZGluZyBwIHsNCiAgICAgICAgbWFyZ2luLXRvcDogMGVtOw0KICAgIH0NCg0KICAgIGgzLCBvbCB7DQogICAgICAgIGNvbG9yOiAjMDAwOw0KICAgIH0NCn0NCg==
"


$CssDetailsEncodedFileText = "
KiwgKjo6YmVmb3JlLCAqOjphZnRlciB7DQogICAgYm94LXNpemluZzogYm9yZGVyLWJveDsNCiAgICBtYXJnaW46IDA7DQogICAgcGFkZGluZzogMDsNCiAgICAtd2Via2l0LWZvbnQtc21vb3RoaW5nOiBhbnRpYWxpYXNlZDsNCiAgICB0ZXh0LXJlbmRlcmluZzogb3B0aW1pemVMZWdpYmlsaXR5Ow0KfQ0KDQouY2VudGVyIHsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQp9DQoNCi5udW1MaXN0IHsNCiAgICBmb250LWZhbWlseTogUm9ib3RvOw0KICAgIGZvbnQtc2l6ZTogMS4xNWVtOw0KICAgIGxpbmUtaGVpZ2h0OiAxLjM1Ow0KICAgIG1hcmdpbi1sZWZ0OiAxMCU7DQogICAgbWFyZ2luLXJpZ2h0OiAxMCU7DQp9DQoNCmh0bWwgew0KICAgIGZvbnQtZmFtaWx5OiBBcmlhbCwgc2Fucy1zZXJpZjsNCiAgICBmb250LXdlaWdodDogMzAwOw0KfQ0KDQpib2R5IHsNCiAgICBiYWNrZ3JvdW5kOiAjZmZmOw0KICAgIGZvbnQtc2l6ZTogMTZweDsNCiAgICBjb2xvcjogIzE4MUIyMDsNCiAgICAtLWRyb3BCdG5Db2xvcjogIzFFODQ0OTsNCiAgICAtLW5hdkJ0blBhZGRpbmc6IDFweCAwcHggMXB4IDEwcHg7DQogICAgLS1uYXZCdG5Db2xvckhvdmVyOiAjMjg3NEE2Ow0KICAgIC0tbmF2QnRuSG92ZXJUZXh0Q29sb3I6ICNGRkZGRkY7DQogICAgLS1uYXZCdG5Ib3ZlckJvcmRlcjogMXB4IGRhc2hlZCAjRkZGRkZGOw0KICAgIC0tbmF2QnRuSG92ZXJSYWRpdXM6IDVweDsNCiAgICAtLW5hdkJ0bkhlaWdodDogMi4yNWVtOw0KICAgIC0tbmF2QnRuV2lkdGg6IDkwJTsNCiAgICAtLW5hdkJ0bkZvbnRGYW1pbHk6ICdSb2JvdG8gTGlnaHQnOw0KICAgIC0tbmF2QnRuRm9udFNpemU6IDEuMDVlbTsNCiAgICBtYXJnaW46IDA7DQogICAgcGFkZGluZzogMDsNCn0NCg0KcCB7DQogICAgd2hpdGUtc3BhY2U6IHByZS13cmFwOw0KfQ0KDQouZGV0YWlsX2JvZHkgew0KICAgIG1hcmdpbi10b3A6IDJlbTsNCiAgICBtYXJnaW4tcmlnaHQ6IDUlOw0KICAgIG1hcmdpbi1ib3R0b206IDJlbTsNCiAgICBtYXJnaW4tbGVmdDogNSU7DQp9DQoNCi5kYXRhIHsNCiAgICBjb2xvcjogI2YwMDsNCiAgICBmb250LWZhbWlseTogJ0hlbHZldGljYSc7DQogICAgZm9udC13ZWlnaHQ6IGJvbGQ7DQogICAgZm9udC1zaXplOiAxLjE1ZW07DQp9DQoNCi5uYXZfX2JhY2tncm91bmQgew0KICAgIGJhY2tncm91bmQ6ICNiYmINCn0NCg0KLm1hZ25ldC1sb2dvIHsNCiAgICBoZWlnaHQ6IDE1MHB4Ow0KICAgIG1hcmdpbjogMzJweCAwcHggMzJweCAwcHg7DQogICAgd2lkdGg6IDE1MHB4Ow0KfQ0KDQovKiBORUVEIFRPIEZJWCBUSEFUIFRXTyBGSUxFUyBVU0UgVEhFIGBoZWFkaW5nYCBjbGFzcyAqLw0KDQouaGVhZGluZyB7DQogICAgYmFja2dyb3VuZC1jb2xvcjogcmdiKDIzMCwgMjMwLCAyMzApOw0KICAgIG1hcmdpbjogMC4yZW0gMGVtOw0KICAgIHBhZGRpbmc6IDVweCAwcHggNXB4IDBweDsNCiAgICBmb250LXNpemU6IDEuMmVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgdGV4dC1hbGlnbjogY2VudGVyOw0KICAgIHRleHQtdHJhbnNmb3JtOiB1cHBlcmNhc2U7DQoNCn0NCg0KLmhlYWRpbmcgbGkgew0KICAgIGxpc3Qtc3R5bGU6IG5vbmU7DQp9DQoNCi5oZWFkaW5nPnVsIHsNCiAgICBtYXJnaW46IDhweCAwcHggOHB4Ow0KfQ0KDQouaGVhZGluZyBhIHsNCiAgICBjb2xvcjogIzIyMjsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgZGlzcGxheTogYmxvY2s7DQogICAgaGVpZ2h0OiAyNXB4Ow0KICAgIGxpbmUtaGVpZ2h0OiAyNXB4Ow0KICAgIHRleHQtZGVjb3JhdGlvbjogbm9uZTsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLnJlYWRfbWVfaGVhZGluZyB7DQogICAgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsNCiAgICBmb250LXNpemU6IDEuMmVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQp9DQoNCi5yZWFkX21lX2hlYWRpbmcgbGkgew0KICAgIGxpc3Qtc3R5bGU6IG5vbmU7DQp9DQoNCi5yZWFkX21lX2hlYWRpbmc+dWwgew0KICAgIG1hcmdpbjogOHB4IDBweCA4cHg7DQp9DQoNCi5yZWFkX21lX2hlYWRpbmcgYSB7DQogICAgY29sb3I6ICMyMjI7DQogICAgY3Vyc29yOiBwb2ludGVyOw0KICAgIGRpc3BsYXk6IGJsb2NrOw0KICAgIGhlaWdodDogMjVweDsNCiAgICBsaW5lLWhlaWdodDogMjVweDsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQogICAgd2lkdGg6IDEwMCU7DQp9DQoNCg0KLyogTXkgQWRkZWQgU3R5bGUgKi8NCi5idG5fXzEgew0KICAgIGJvcmRlcjogMXB4Ow0KICAgIHBhZGRpbmc6IHZhcigtLW5hdkJ0blBhZGRpbmcpOw0KICAgIHdpZHRoOiB2YXIoLS1uYXZCdG5XaWR0aCk7DQogICAgaGVpZ2h0OiB2YXIoLS1uYXZCdG5IZWlnaHQpOw0KICAgIHRleHQtYWxpZ246IGxlZnQ7DQogICAgdGV4dC1kZWNvcmF0aW9uOiBub25lOw0KICAgIGNvbG9yOiBibGFjazsNCiAgICBmb250LXNpemU6IHZhcigtLW5hdkJ0bkZvbnRTaXplKTsNCiAgICBmb250LWZhbWlseTogdmFyKC0tbmF2QnRuRm9udEZhbWlseSk7DQogICAgLyogYm9yZGVyOiAxcHggc29saWQgYmxhY2s7ICovDQogICAgYm9yZGVyOiAwcHggc29saWQgdHJhbnNwYXJlbnQ7DQogICAgYmFja2dyb3VuZC1jb2xvcjogdHJhbnNwYXJlbnQ7DQp9DQoNCi5idG5fXzEgew0KICAgIG1hcmdpbjogMC4xNWVtIDBlbSAwZW0gMWVtOw0KfQ0KDQovKiBNeSBBZGRlZCBTdHlsZSAqLw0KLmJ0bl9fMTpob3ZlciwNCi5idG5fXzI6aG92ZXIgew0KICAgIGJhY2tncm91bmQtY29sb3I6IHZhcigtLW5hdkJ0bkNvbG9ySG92ZXIpOw0KICAgIGNvbG9yOiB2YXIoLS1uYXZCdG5Ib3ZlclRleHRDb2xvcik7DQogICAgYm9yZGVyOiB2YXIoLS1uYXZCdG5Ib3ZlckJvcmRlcik7DQogICAgYm9yZGVyLXJhZGl1czogdmFyKC0tbmF2QnRuSG92ZXJSYWRpdXMpOw0KICAgIGZvbnQtd2VpZ2h0OiA3MDA7DQogICAgdHJhbnNpdGlvbjogYWxsIDAuMnMgZWFzZTsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgaGVpZ2h0OiAyLjI1ZW07DQogICAgYm94LXNoYWRvdzogNXB4IDVweCA1cHggIzdGOEM4RDsNCn0NCg0KLmJ0bl9fMSBhLA0KLmJ0bl9fMiBhIHsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmUNCn0NCg0KLmJ0bl9fMSBhOmFjdGl2ZSwNCi5idG5fXzIgYTphY3RpdmUgew0KICAgIHRleHQtZGVjb3JhdGlvbjogdW5kZXJsaW5lOw0KICAgIGNvbG9yOiAjQ0I0MzM1Ow0KfQ0KDQouYnRuX18xIGE6dmlzaXRlZCwNCi5idG5fXzIgYTp2aXNpdGVkIHsNCiAgICB0ZXh0LWRlY29yYXRpb246IG5vbmU7DQogICAgY29sb3I6ICMwMDAwMDA7DQp9DQoNCi8qIE15IEFkZGVkIFN0eWxlICovDQouZnJvbnRfX2JhY2tncm91bmQsDQouY2FzZV9fYmFja2dyb3VuZCwNCi5ldmlkZW5jZV9fYmFja2dyb3VuZCwNCi5yZWFkbWUtYmFja2dyb3VuZCB7DQogICAgYmFja2dyb3VuZDogIzIyMzEzZjsNCiAgICBjb2xvcjogI0RERDsNCn0NCg0KLmNhc2VpbmZvIHsNCiAgICBkaXNwbGF5OiBmbGV4Ow0KICAgIGZsZXgtZGlyZWN0aW9uOiBjb2x1bW47DQogICAgbWFyZ2luOiAyZW0gMmVtIDFlbSAyZW07DQogICAgYWxpZ24taXRlbXM6IGNlbnRlcjsNCiAgICBqdXN0aWZ5LWNvbnRlbnQ6IGNlbnRlcjsNCiAgICBjb2xvcjogI0ZGRkZGRjsNCiAgICBib3JkZXI6IDFweCBkYXNoZWQgI0ZGRkZGRjsNCn0NCg0KLnRvcEhlYWRpbmcsDQouc2Vjb25kSGVhZGluZyB7DQogICAgY29sb3I6ICNDQjQzMzU7DQogICAgbWFyZ2luOiAwLjVlbSAwZW0gMGVtIDBlbTsNCiAgICBwYWRkaW5nOiAwOw0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQp9DQoNCi50b3BIZWFkaW5nIHsNCiAgICBmb250LXNpemU6IDIuNGVtOw0KfQ0KDQouZnJvbnRwYWdlX190YWJsZSB7DQogICAgY29sb3I6ICNGRkZGRkY7DQogICAgYm9yZGVyLWNvbGxhcHNlOiBjb2xsYXBzZTsNCn0NCg0KLmZyb250cGFnZV9fdGFibGUgdGQgew0KICAgIGNvbG9yOiAjRkZGRkZGOw0KICAgIGJvcmRlci1jb2xsYXBzZTogY29sbGFwc2U7DQogICAgZm9udC1zaXplOiAxLjJlbTsNCn0NCg0KLmNhc2VpbmZvX19kZXRhaWxzIHsNCiAgICBmb250LXdlaWdodDogNDAwOw0KICAgIHZlcnRpY2FsLWFsaWduOiBjZW50ZXI7DQogICAgcGFkZGluZzogMC4zZW0gMC41ZW0gMC4zZW0gMGVtOw0KICAgIHRleHQtYWxpZ246IHJpZ2h0Ow0KfQ0KDQouY2FzZWluZm9fX3RleHQgew0KICAgIGZvbnQtd2VpZ2h0OiA0MDA7DQogICAgdmVydGljYWwtYWxpZ246IGNlbnRlcjsNCiAgICBwYWRkaW5nOiAwLjNlbSAwZW0gMC4zZW0gMC41ZW07DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCn0NCg0KLmNvbnRhaW5lciB7DQogICAgd2lkdGg6IDEwMCU7DQogICAgaGVpZ2h0OiBhdXRvOw0KICAgIC8qIG1hcmdpbi1sZWZ0OiAycmVtOyAqLw0KICAgIC8qIHBhZGRpbmc6IDByZW0gMXJlbTsgKi8NCiAgICAvKiBiYWNrZ3JvdW5kLWNvbG9yOiAjOUQ5RDlEOyAqLw0KfQ0KDQouYnV0dG9uLWNvbnRhaW5lciB7DQogICAgZGlzcGxheTogZmxleDsNCiAgICBmbGV4LWRpcmVjdGlvbjogcm93Ow0KICAgIGZsZXgtd3JhcDogbm93cmFwOw0KICAgIGp1c3RpZnktY29udGVudDogY2VudGVyOw0KICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7DQogICAgcG9zaXRpb246IGZpeGVkOw0KICAgIHRvcDogMDsNCiAgICBsZWZ0OiAwOw0KICAgIHdpZHRoOiAxMDAlOw0KICAgIHBhZGRpbmc6IDFlbSAwZW07DQogICAgYmFja2dyb3VuZC1jb2xvcjogIzIyMzEzZjsNCiAgICBib3JkZXItYm90dG9tOiAxcHggc29saWQgIzAwMDAwMA0KICAgICAgICAvKiBtYXJnaW4tdG9wOiAwLjVyZW07ICovDQogICAgICAgIC8qIGJveC1zaGFkb3c6IDAgN3B4IDhweCByZ2JhKDAsIDAsIDAsIDAuMTIpOyAqLw0KfQ0KDQouYnV0dG9uVG9wOmhvdmVyIC5idG4tdHh0OjphZnRlciB7DQogICAgdHJhbnNmb3JtOiBzY2FsZVgoMSk7DQogICAgdHJhbnNmb3JtLW9yaWdpbjogbGVmdDsNCn0NCg0KLnByaW50LWJ1dHRvbiwNCi5jbG9zZS1idXR0b24gew0KICAgIGJhY2tncm91bmQtY29sb3I6ICNEREQ7DQogICAgd2lkdGg6IDEzcmVtOw0KICAgIGhlaWdodDogM3JlbTsNCiAgICBjb2xvcjogYmxhY2s7DQogICAgZm9udC1zaXplOiAxcmVtOw0KICAgIGZvbnQtd2VpZ2h0OiA2MDA7DQogICAgZm9udC1mYW1pbHk6IFZlcmRhbmE7DQogICAgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsNCiAgICBwYWRkaW5nOiAwLjVyZW07DQp9DQoNCi5wcmludC1idXR0b246aG92ZXIsDQouY2xvc2UtYnV0dG9uOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjODg4ODg4RkY7DQogICAgYm9yZGVyOiAycHggZG90dGVkICNGRkZGRkY7DQogICAgY29sb3I6IHdoaXRlOw0KICAgIGN1cnNvcjogcG9pbnRlcjsNCiAgICBib3gtc2hhZG93OiAwcHggMXB4IDFweCByZ2JhKDAsIDAsIDAsIDAuNzUpOw0KICAgIC8qIGJvcmRlci1yYWRpdXM6IDEwcHg7ICovDQp9DQoNCi5jbG9zZS1idXR0b24gew0KICAgIG1hcmdpbi1sZWZ0OiAzZW07DQp9DQoNCi5idG4tdHh0IHsNCiAgICBkaXNwbGF5OiBpbmxpbmU7DQogICAgcG9zaXRpb246IHJlbGF0aXZlOw0KICAgIGZvbnQtZmFtaWx5OiAnUm9ib3RvIExpZ2h0JzsNCn0NCg0KLmJ0bi10eHQ6OmFmdGVyIHsNCiAgICBjb250ZW50OiAnJzsNCiAgICBwb3NpdGlvbjogYWJzb2x1dGU7DQogICAgbGVmdDogMDsNCiAgICBib3R0b206IC0ycHg7DQogICAgd2lkdGg6IDEwMCU7DQogICAgaGVpZ2h0OiAycHg7DQogICAgYmFja2dyb3VuZDogI0ZGRkZGRjsNCiAgICB0cmFuc2Zvcm06IHNjYWxlWCgwKTsNCiAgICB0cmFuc2Zvcm0tb3JpZ2luOiByaWdodDsNCiAgICB0cmFuc2l0aW9uOiB0cmFuc2Zvcm0gMC4ycyBlYXNlLWluOw0KfQ0KDQouYnV0dG9uVG9wOmhvdmVyIC5idG4tdHh0OjphZnRlciB7DQogICAgdHJhbnNmb3JtOiBzY2FsZVgoMSk7DQogICAgdHJhbnNmb3JtLW9yaWdpbjogbGVmdDsNCn0NCg0KLmxpbmVGaXJzdCB7DQogICAgZm9udC1zaXplOiAxLjVlbTsNCiAgICBmb250LXdlaWdodDogNTAwOw0KICAgIG1hcmdpbjogMXJlbSAwIDAuNXJlbSAwOw0KICAgIHRleHQtYWxpZ246IGNlbnRlcjsNCn0NCg0KLmxpbmVTZWNvbmQgew0KICAgIGZvbnQtc2l6ZTogMS4zNWVtOw0KICAgIGZvbnQtd2VpZ2h0OiA1MDA7DQogICAgbWFyZ2luOiAtMC4yNXJlbSAwIDJyZW0gMDsNCiAgICB0ZXh0LWFsaWduOiBjZW50ZXI7DQp9DQoNCnRhYmxlIHsNCiAgICBmb250LXNpemU6IDAuODVlbTsNCiAgICBib3JkZXI6IDBweDsNCn0NCg0KdGQgew0KICAgIHBhZGRpbmc6IDRweDsNCiAgICBtYXJnaW46IDBweDsNCiAgICBib3JkZXI6IDA7DQogICAgd2hpdGUtc3BhY2U6IHByZS13cmFwOw0KfQ0KDQp0aCB7DQogICAgYmFja2dyb3VuZDogIzM5NTg3MDsNCiAgICBiYWNrZ3JvdW5kOiBsaW5lYXItZ3JhZGllbnQoIzQ5NzA4ZiwgIzI5M2Y1MCk7DQogICAgY29sb3I6ICNmZmY7DQogICAgZm9udC1zaXplOiAxLjA1ZW07DQogICAgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsNCiAgICBwYWRkaW5nOiAxMHB4IDE1cHg7DQogICAgdmVydGljYWwtYWxpZ246IG1pZGRsZTsNCn0NCg0KLnRvcCB7DQogICAgY29sb3I6IGRvZGdlcmJsdWU7DQogICAgZGlzcGxheTogaW5saW5lOw0KICAgIGZvbnQtc2l6ZTogMTJweDsNCn0NCg0KLmluZm9faGVhZGVyIHsNCiAgICBtYXJnaW4tdG9wOiAxLjc1ZW07DQogICAgbWFyZ2luLWJvdHRvbTogMC4yNWVtOw0KfQ0KDQovKiBTdHlsZSB0aGUgYnV0dG9uIHRoYXQgaXMgdXNlZCB0byBvcGVuIGFuZCBjbG9zZSB0aGUgY29sbGFwc2libGUgY29udGVudCAqLw0KLmNvbGxhcHNpYmxlIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjZWVlOw0KICAgIGJvcmRlcjogbm9uZTsNCiAgICBib3JkZXI6IDFweDsNCiAgICBjb2xvcjogIzMzMzsNCiAgICBjdXJzb3I6IHBvaW50ZXI7DQogICAgZm9udC1zaXplOiAwLjg1ZW07DQogICAgZm9udC13ZWlnaHQ6IDUwMDsNCiAgICBtYXJnaW46IDJlbSAwZW0gMGVtIDBlbTsNCiAgICBvdXRsaW5lOiBub25lOw0KICAgIHBhZGRpbmc6IDE4cHg7DQogICAgdGV4dC1hbGlnbjogbGVmdDsNCiAgICB3aWR0aDogMTAwJTsNCn0NCg0KLyogQWRkIGEgYmFja2dyb3VuZCBjb2xvciB0byB0aGUgYnV0dG9uIGlmIGl0IGlzIGNsaWNrZWQgb24gKGFkZCB0aGUgLmFjdGl2ZSBjbGFzcyB3aXRoIEpTKSwgYW5kIHdoZW4geW91IG1vdmUgdGhlIG1vdXNlIG92ZXIgaXQgKGhvdmVyKSAqLw0KLmFjdGl2ZSwgLmNvbGxhcHNpYmxlOmhvdmVyIHsNCiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjY2NjOw0KICAgIGJvcmRlcjogMXB4IHNvbGlkIGRvZGdlcmJsdWU7DQogICAgY29sb3I6IGRvZGdlcmJsdWU7DQogICAgZm9udC13ZWlnaHQ6IDYwMDsNCiAgICB0ZXh0LWRlY29yYXRpb246IHVuZGVybGluZTsNCn0NCg0KLmNvbGxhcHNpYmxlOmFmdGVyIHsNCiAgICBjb250ZW50OiAnXDAyNzk1JzsNCiAgICAvKiBVbmljb2RlIGNoYXJhY3RlciBmb3IgInBsdXMiIHNpZ24gKCspICovDQogICAgZm9udC1zaXplOiAxM3B4Ow0KICAgIGNvbG9yOiAjNzc3Ow0KICAgIGZsb2F0OiByaWdodDsNCiAgICBtYXJnaW4tbGVmdDogNXB4Ow0KfQ0KDQouYWN0aXZlOmFmdGVyIHsNCiAgICBjb250ZW50OiAiXDI3OTYiOw0KICAgIC8qIFVuaWNvZGUgY2hhcmFjdGVyIGZvciAibWludXMiIHNpZ24gKC0pICovDQp9DQoNCi8qIFN0eWxlIHRoZSBjb2xsYXBzaWJsZSBjb250ZW50LiBOb3RlOiBoaWRkZW4gYnkgZGVmYXVsdCAqLw0KLmNvbnRlbnQgew0KICAgIHBhZGRpbmc6IDAgMThweDsNCiAgICBkaXNwbGF5OiBub25lOw0KICAgIG92ZXJmbG93OiBoaWRkZW47DQogICAgYmFja2dyb3VuZC1jb2xvcjogI2YxZjFmMTsNCn0NCg0KQHBhZ2Ugew0KICAgIHNpemU6IEE0Ow0KDQogICAgQGJvdHRvbS1jZW50ZXIgew0KICAgICAgICBjb250ZW50OiAiUGFnZSAiY291bnRlcihwYWdlKTsNCiAgICB9DQp9DQoNCkBtZWRpYSBwcmludCB7DQogICAgLm5vLXByaW50LCAubm8tcHJpbnQgKiB7DQogICAgICAgIGRpc3BsYXk6IG5vbmU7DQogICAgfQ0KDQogICAgaHRtbCwgYm9keSB7DQogICAgICAgIG1hcmdpbjogMHJlbTsNCiAgICAgICAgYmFja2dyb3VuZDogdHJhbnNwYXJlbnQ7DQogICAgfQ0KDQogICAgLmNvbnRhaW5lciB7DQogICAgICAgIGJhY2tncm91bmQtY29sb3I6IHRyYW5zcGFyZW50Ow0KICAgIH0NCg0KICAgIC5oZWFkaW5nIHsNCiAgICAgICAgbWFyZ2luLXRvcDogMWVtOw0KICAgIH0NCg0KICAgIC5oZWFkaW5nIHAgew0KICAgICAgICBtYXJnaW4tdG9wOiAwZW07DQogICAgfQ0KDQogICAgaDMsIG9sIHsNCiAgICAgICAgY29sb3I6ICMwMDA7DQogICAgfQ0KfQ==
"



$NavHtmlFileCss = "
*, *::before, *::after {
    box-sizing: border-box;
    margin: 2px;
    padding: 0;
    -webkit-font-smoothing: antialiased;
    text-rendering: optimizeLegibility;
}

.center {
    text-align: center;
}

.numList {
    font-family: Roboto;
    font-size: 1.15em;
    line-height: 1.35;
    margin-left: 10%;
    margin-right: 10%;
}

html {
    font-family: 'Segoe UI', Frutiger, 'Frutiger Linotype', 'Dejavu Sans', 'Helvetica Neue', Arial, sans-serif;
    font-weight: 300;
}

body {
    background: #fff;
    font-size: 16px;
    color: #181B20;
    --dropBtnColor: #1E8449;
    --navBtnColorHover: #2874A6;
    --navBtnHoverTextColor: #FFFFFF;
    --navBtnHoverBorder: 1px dashed #FFFFFF;
    --navBtnHoverRadius: 5px;
    --navBtnHeight: 1.45em;
    --navBtnWidth: 98%;
    --navBtnFontFamily: 'Roboto Light';
    --navBtnFontSize: 1.05em;
    margin: 0;
    padding: 0;
}

.nav__background {
    background: #bbb
}

.nav-image {
    height: 100px;
    margin: 24px 0px;
    width: 100px;
}

.heading {
    background-color: rgb(230, 230, 230);
    padding: 5px 0px 5px 0px;
    font-size: 1.2em;
    font-weight: 500;
    text-align: center;
    text-transform: uppercase;

}

.report-section {
    color: #000000;
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    width: 100%;
}

button.nav-list-item {
    border: 0px solid transparent;
    background-color: transparent;
    width: var(--navBtnWidth);
    height: var(--navBtnHeight);
    text-align: left;
    text-decoration: none;
    color: black;
    font-size: var(--navBtnFontSize);
    font-family: var(--navBtnFontFamily);
    margin: 0.35em 1em;
}

button.nav-list-item a:link {
    color: blue;
    background-color: transparent;
    text-decoration: none;
}

button.nav-list-item a:hover {
    font-weight: 700;
    color: blue;
    text-decoration: underline;
    cursor: pointer;
}

button .nav-list-item a:active {
    text-decoration: underline;
    color: #CB4335;
}

button .nav-list-item a:visited {
    text-decoration: none;
    color: yellow;
}
"


$FrontHtmlFileCss = "
*, *::before, *::after {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    -webkit-font-smoothing: antialiased;
    text-rendering: optimizeLegibility;
}

html {
    font-family: 'Segoe UI', Frutiger, 'Frutiger Linotype', 'Dejavu Sans', 'Helvetica Neue', Arial, sans-serif;
    font-weight: 300;
}

body {
    background: #fff;
    font-size: 16px;
    color: #181B20;
    --dropBtnColor: #1E8449;
    --navBtnPadding: 1px 0px 1px 10px;
    --navBtnColorHover: #2874A6;
    --navBtnHoverTextColor: #FFFFFF;
    --navBtnHoverBorder: 1px dashed #FFFFFF;
    --navBtnHoverRadius: 5px;
    --navBtnHeight: 2.25em;
    --navBtnWidth: 90%;
    --navBtnFontFamily: 'Roboto Light';
    --navBtnFontSize: 1.05em;
    margin: 0;
    padding: 0;
}

.center {
    text-align: center;
}

/* My Added Style */
.front__background,
.case__background,
.evidence__background,
.readme-background {
    background: #22313f;
    color: #DDD;
}

.caseinfo {
    display: flex;
    flex-direction: column;
    margin: 2em 2em 1em 2em;
    align-items: center;
    justify-content: center;
    color: #FFFFFF;
    border: 1px dashed #FFFFFF;
}

.caseinfo__details {
    font-weight: 400;
    vertical-align: center;
    padding: 0.3em 0.5em 0.3em 0em;
    text-align: right;
}

.caseinfo__text {
    font-weight: 400;
    vertical-align: center;
    padding: 0.3em 0em 0.3em 0.5em;
    text-align: left;
}

.topHeading,
.secondHeading {
    color: #CB4335;
    margin: 0.5em 0em 0em 0em;
    padding: 0;
    font-weight: 400;
    text-transform: uppercase;
    text-align: center;
}

.topHeading {
    font-size: 2.4em;
}

.frontpage__table {
    color: #FFFFFF;
    border-collapse: collapse;
}

.frontpage__table td {
    color: #FFFFFF;
    border-collapse: collapse;
    font-size: 1.2em;
}

.caseinfo__details {
    font-weight: 400;
    vertical-align: center;
    padding: 0.3em 0.5em 0.3em 0em;
    text-align: right;
}

.caseinfo__text {
    font-weight: 400;
    vertical-align: center;
    padding: 0.3em 0em 0.3em 0.5em;
    text-align: left;
}"


$ReadMeHtmlFileCss = "
*, *::before, *::after {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    -webkit-font-smoothing: antialiased;
    text-rendering: optimizeLegibility;
}

html {
    font-family: 'Segoe UI', Frutiger, 'Frutiger Linotype', 'Dejavu Sans', 'Helvetica Neue', Arial, sans-serif;
    font-weight: 300;
}

body {
    background: #fff;
    font-size: 16px;
    color: #181B20;
    --dropBtnColor: #1E8449;
    --navBtnPadding: 1px 0px 1px 10px;
    --navBtnColorHover: #2874A6;
    --navBtnHoverTextColor: #FFFFFF;
    --navBtnHoverBorder: 1px dashed #FFFFFF;
    --navBtnHoverRadius: 5px;
    --navBtnHeight: 2.25em;
    --navBtnWidth: 90%;
    --navBtnFontFamily: 'Roboto Light';
    --navBtnFontSize: 1.05em;
    margin: 0;
    padding: 0;
}

.center {
    text-align: center;
}

.readme-background {
    background: #22313f;
    color: #DDD;
}

.caseinfo {
    display: flex;
    flex-direction: column;
    margin: 2em 2em 1em 2em;
    align-items: center;
    justify-content: center;
    color: #FFFFFF;
    border: 1px dashed #FFFFFF;
}

.topHeading,
.secondHeading {
    color: #CB4335;
    font-size: 2.4em;
    margin: 0.5em 0em 0em 0em;
    padding: 0;
    font-weight: 400;
    text-transform: uppercase;
    text-align: center;
}

.lineFirst {
    font-size: 1.5em;
    font-weight: 500;
    margin: 1rem 0 0.5rem 0;
    text-align: center;
}

.lineSecond {
    font-size: 1.35em;
    font-weight: 500;
    margin: -0.25rem 0 2rem 0;
    text-align: center;
}

.numList {
    font-family: Roboto;
    font-size: 1.15em;
    line-height: 1.35;
    margin-left: 10%;
    margin-right: 10%;
}
"


Export-ModuleMember -Variable HtmlHeader, HtmlDetailsHeader, EndingHtml, ReturnHtmlSnippet, CssEncodedFileText, CssDetailsEncodedFileText, NavHtmlFileCss, FrontHtmlFileCss, ReadMeHtmlFileCss, FileKeyWords
