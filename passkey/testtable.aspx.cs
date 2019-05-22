using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services; 
using passkey.App_Code ;


namespace passkey
{
    public partial class testtable : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod ]
        public string getclients(){
            string str="";
            Support su = new Support();
            str=su.dstojson (su.getClients ());
            return str;
        }
    }
}