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


$HtmlHeaderEdited = "<!DOCTYPE html>

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

    <body translate='no'>

    <div class='container'>
      <div class='accordion'>

    "



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
    /* --navBtnPadding: 8px 0px 8px 0px; */
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
    /* margin: 0.5em 0em; */
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
    /* margin: 1em 0em; */
    width: 100%;
}

button.nav-list-item {
    border: 0px solid transparent;
    background-color: transparent;
    /* padding: var(--navBtnPadding); */
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
    /* background-color: var(--navBtnColorHover); */
    /* color: var(--navBtnHoverTextColor); */
    /* border: var(--navBtnHoverBorder); */
    /* border-radius: var(--navBtnHoverRadius); */
    font-weight: 700;
    /* transition: all 0.2s ease; */
    color: blue;
    text-decoration: underline;
    cursor: pointer;
    /* margin: 0.15em 1em 0em 1em; */
    /* height: 2.25em; */
    /* box-shadow: 5px 5px 5px #7F8C8D; */
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


Export-ModuleMember -Variable HtmlHeader, HtmlHeaderEdited, EndingHtml, ReturnHtmlSnippet, CssEncodedFileText, NavHtmlFileCss, FrontHtmlFileCss, ReadMeHtmlFileCss, FileKeyWords
