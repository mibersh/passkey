using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Google.Authenticator;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;
using passkey.App_Code;
namespace passkey
{
    public partial class _2fa : System.Web.UI.Page
    {
            private const string key = "qaz123!@@";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                if (Session["userId"] == null) Response.Redirect("/login.aspx");
                if ((bool)Session["isInitedTFA"]) initGoogleAuthenticator.Visible = false;

                TwoFactorAuthenticator tfa = new TwoFactorAuthenticator();
                var userId = Session["userId"].ToString();
                string userUniqueKey = userId + key;
                var setupInfo = tfa.GenerateSetupCode("Drensys", userId, userUniqueKey, 300, 300);

                barcodeImage.ImageUrl = setupInfo.QrCodeSetupImageUrl;
                barcodeManual.Text = setupInfo.ManualEntryKey;
                //verificationCode.Text = tfa.GetCurrentPIN(userUniqueKey);//delete this
            }
            else
            {
                Response.Redirect("/default.aspx");
            }
        }
        

        protected void Button1_Click(object sender, EventArgs e)
        {
            SqlCommand cm = new SqlCommand();
            Support su = new Support();
            TwoFactorAuthenticator tfa = new TwoFactorAuthenticator();
            string connectionString = ConfigurationManager.ConnectionStrings["drensys"].ConnectionString;
            var userId = Session["userId"].ToString();
            var token = verificationCode.Text;
            string userUniqueKey = userId + key;

            bool isValid = tfa.ValidateTwoFactorPIN(userUniqueKey, token);

            if (userId != null && isValid)
            {

                Session.Remove("isInitedTFA");
                su.setInitedTFA(userId);
                su.ValidLogin(userId, Request.UserHostAddress);
                FormsAuthentication.SetAuthCookie(userId, true);

                Response.Redirect("/default.aspx");
            }
            else
            {
                lblerror.Text = "Invalid code";
            }
        }
    }
}