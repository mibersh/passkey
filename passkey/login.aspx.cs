using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using passkey.App_Code;

namespace passkey
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            SqlCommand cm = new SqlCommand();
            Support su = new Support();

            string connectionString = ConfigurationManager.ConnectionStrings["drensys"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                string storedProc = "GetUserByID";
                SqlCommand command = new SqlCommand(storedProc, con);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@userid", userid.Text));
                command.Parameters.Add(new SqlParameter("@password", password.Text));

                using (SqlDataAdapter ad = new SqlDataAdapter(command))
                {
                    DataSet ds = new DataSet();
                    ad.Fill(ds);
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        bool isInited = false;
                        if (ds.Tables[0].Rows[0]["initedtfa"] != DBNull.Value) isInited = (bool)ds.Tables[0].Rows[0]["initedtfa"];

                        Session["isInitedTFA"] = isInited;
                        Session["userId"] = userid.Text;

                        Response.Redirect("/2fa.aspx");
                    }
                    else
                    {
                        su.InvalidLogin(userid.Text, Request.UserHostAddress);
                        lblerror.Text = "Invalid Login";
                    }
                }

            }
        }
    }
}