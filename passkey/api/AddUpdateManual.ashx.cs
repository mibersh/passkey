using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using passkey.App_Code;
using System.Text.RegularExpressions;
using System.IO;

namespace passkey.api
{
    /// <summary>
    /// Summary description for AddUpdateManual
    /// </summary>
    public class AddUpdateManual : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string manual_name = context.Request.Form["manual_name"];
            string manual_type = context.Request.Form["manual_type"];
            if (context.Request.Files.Count > 0)
            {

                var file = context.Request.Files[0];

                string file_name = Regex.Match(file.FileName, @".*\\([^\\]+$)").Groups[1].Value;
                string path = context.Server.MapPath("~/manuals");
                if (!Directory.Exists(path))
                    Directory.CreateDirectory(path);


                

                Support su = new Support();
                //string id = su.AddUpdateManual( manual_name, manual_type,file_name);
                string id = su.AddUpdateManual(manual_name, manual_type, file.FileName);
                string filename = Path.Combine(path, file.FileName);
                
                file.SaveAs(filename);


                //context.Response.ContentType = "text/plain";
                context.Response.Write(id);
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}