using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace passkey.api
{
    /// <summary>
    /// Summary description for test
    /// </summary>
    public class test : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("Hello World");
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