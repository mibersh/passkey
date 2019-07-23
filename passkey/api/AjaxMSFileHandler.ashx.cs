using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using passkey.App_Code;
using System.Text.RegularExpressions;

namespace passkey.api
{
    /// <summary>
    /// Summary description for AjaxMSFileHandler_ashx
    /// </summary>
    public class AjaxMSFileHandler : IHttpHandler
    {
        
        public void ProcessRequest(HttpContext context)
        {
            string server_id = context.Request.Form["server_id"];
            string field_name = context.Request.Form["field_name"];
            if (context.Request.Files.Count > 0)
            {




                string path = context.Server.MapPath("~/wsfiles");
                if (!Directory.Exists(path))
                    Directory.CreateDirectory(path);

                var file = context.Request.Files[0];


                Support su = new Support();
                su.AddUpdateWSFile(server_id, field_name, Regex.Match(file.FileName, @".*\\([^\\]+$)").Groups[1].Value);

                string filename = Path.Combine(path, server_id + Regex.Match(file.FileName, @".*\\([^\\]+$)").Groups[1].Value);
                file.SaveAs(filename);

                context.Response.ContentType = "text/plain";
                var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                var result = new { name = file.FileName };
                context.Response.Write(serializer.Serialize(result));
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