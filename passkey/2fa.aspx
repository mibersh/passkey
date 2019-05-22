<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="2fa.aspx.cs" Inherits="passkey._2fa" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>PassKey Application google authenticator</title>
    <!-- 
         * @Package: Ultra Admin - Responsive Theme
         * @Subpackage: Bootstrap
         * @Version: B4-1.1
         * This file is part of Ultra Admin Theme.
        -->
        <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
        <meta content="" name="" />
        <meta content="" name="Mikhail Bershchanskiy" />

        <link rel="shortcut icon" href="assets/images/favicon.png" type="image/x-icon" />    <!-- Favicon -->
        <link rel="apple-touch-icon-precomposed" href="assets/images/apple-touch-icon-57-precomposed.png">	<!-- For iPhone -->
        <link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/images/apple-touch-icon-114-precomposed.png">    <!-- For iPhone 4 Retina display -->
        <link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/images/apple-touch-icon-72-precomposed.png">    <!-- For iPad -->
        <link rel="apple-touch-icon-precomposed" sizes="144x144" href="assets/images/apple-touch-icon-144-precomposed.png">    <!-- For iPad Retina display -->




        <!-- CORE CSS FRAMEWORK - START -->
        <link href="assets/plugins/pace/pace-theme-flash.css" rel="stylesheet" type="text/css" media="screen"/>
        <link href="assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="assets/fonts/font-awesome/css/font-awesome.css" rel="stylesheet" type="text/css"/>
        <link href="assets/css/animate.min.css" rel="stylesheet" type="text/css"/>
        <link href="assets/plugins/perfect-scrollbar/perfect-scrollbar.css" rel="stylesheet" type="text/css"/>
        <!-- CORE CSS FRAMEWORK - END -->

        <!-- OTHER SCRIPTS INCLUDED ON THIS PAGE - START --> 
        <link href="assets/plugins/icheck/skins/square/orange.css" rel="stylesheet" type="text/css" media="screen"/>        <!-- OTHER SCRIPTS INCLUDED ON THIS PAGE - END --> 


        <!-- CORE CSS TEMPLATE - START -->
        <link href="assets/css/style.css" rel="stylesheet" type="text/css"/>
        <link href="assets/css/responsive.css" rel="stylesheet" type="text/css"/>
        <!-- CORE CSS TEMPLATE - END -->

     <!-- LOAD FILES AT PAGE END FOR FASTER LOADING -->


        <!-- CORE JS FRAMEWORK - START --> 
        <script src="assets/js/jquery-3.2.1.min.js" type="text/javascript"></script> 
        <script src="assets/js/popper.min.js" type="text/javascript"></script> 
        <!-- <script src="assets/js/jquery.easing.min.js" type="text/javascript"></script>  -->
        <script src="assets/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script> 
        <script src="assets/plugins/pace/pace.min.js" data-pace-options='{ "ajax": false }' type="text/javascript"></script>  

        <script src="assets/plugins/perfect-scrollbar/perfect-scrollbar.min.js" type="text/javascript"></script> 
        <script src="assets/plugins/viewport/viewportchecker.js" type="text/javascript"></script>  
        <!-- CORE JS FRAMEWORK - END --> 


        <!-- OTHER SCRIPTS INCLUDED ON THIS PAGE - START --> 
        <script src="assets/plugins/icheck/icheck.min.js" type="text/javascript"></script><!-- OTHER SCRIPTS INCLUDED ON THIS PAGE - END --> 


        <!-- CORE TEMPLATE JS - START --> 
        <script src="assets/js/scripts.js" type="text/javascript"></script> 
        <!-- END CORE TEMPLATE JS - END --> 

        <!-- Sidebar Graph - START --> 
        <script src="assets/plugins/sparkline-chart/jquery.sparkline.min.js" type="text/javascript"></script>
        <script src="assets/js/chart-sparkline.js" type="text/javascript"></script>
        <!-- Sidebar Graph - END --> 

</head>
<body class="login_page">
    <form id="form1" runat="server">
    <div class="login-wrapper">
            <div id="login" class="login loginpage offset-xl-4 col-xl-4 offset-lg-3 col-lg-6 offset-md-3 col-md-6 col-offset-0 col-12">
                <h1><a href="#" title="Login Page" tabindex="-1">PassKey</a></h1>

                  

                                         <p>
                                            <asp:PlaceHolder ID="initGoogleAuthenticator" runat="server">
                                            Use Google Authenticator App to Scan the QR Code:
                                            <div style="text-align: center;">
                                                <asp:Image runat="server" ID="barcodeImage" BorderStyle="None" />
                                            </div>
                                            <div style="margin-bottom: 10px;">
                                                <asp:Label runat="server" Text="Or Manual Setup Code:"></asp:Label>
                                            </div>
                                            <asp:Label ID="barcodeManual" Style="text-align: center;margin-bottom: 10px;" Width="100%" runat="server"></asp:Label>
                                            </asp:PlaceHolder>
                                            </p>
                                                        <p>
                        <label for="user_login">Enter Code<br /></label><asp:TextBox ID="verificationCode" runat="server" required="required"  autofocus="autofocus" CssClass="input"></asp:TextBox></p>
                                                        <p>
                        <asp:Label ID="lblerror" runat="server" Text=""></asp:Label>
                    </p>
                                                        <p class="submit"><asp:Button ID="Button2" runat="server" Text="Login" CssClass="btn btn-orange btn-block" OnClick="Button1_Click" /></p>
                                                 
                                        </div>


                


            </div>
        </div>





       









    </form>
</body>
</html>
