using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using passkey.App_Code;
using System.Text.RegularExpressions;

namespace passkey
{
    /// <summary>
    /// Summary description for AjaxFileHandler
    /// </summary>
    public class AjaxFileHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string client_id = context.Request.Form["client_id"];
            string record_id = context.Request.Form["record_id"];
            string procedure = context.Request.Form["procedure"];

            
            if (context.Request.Files.Count > 0)
            {

                


                string path = context.Server.MapPath("~/"+procedure);
                if (!Directory.Exists(path))
                    Directory.CreateDirectory(path);
                
                var file = context.Request.Files[0];

                if (procedure == "AddUpdateClientFiles")
                {
                    Support su = new Support();
                    record_id=su.AddUpdateFile(client_id, "", Regex.Match(file.FileName, @".*\\([^\\]+$)").Groups[1].Value);
                }
                string filename = Path.Combine(path, record_id + Regex.Match(file.FileName, @".*\\([^\\]+$)").Groups[1].Value);
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