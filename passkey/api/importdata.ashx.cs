using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using passkey.App_Code;
using System.IO;

namespace passkey.api
{
    /// <summary>
    /// Summary description for importdata
    /// </summary>
    public class importdata : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {

            string client_id = context.Request.Form["client_id"];
            string procedure = context.Request.Form["procedure"];


            if (context.Request.Files.Count > 0)
            {
                using (StreamReader reader = new StreamReader(context.Request.Files[0].InputStream))
                {
                    int i = 0;
                    while (!reader.EndOfStream)
                    {
                        
                        if (i > 0)
                        {
                            if (procedure == "clientnetworks") clientnetworks(client_id, reader.ReadLine());
                            if (procedure == "clientemergencycontacts") clientemergencycontacts(client_id, reader.ReadLine());
                            if (procedure == "helpdeskemailaccounts") helpdeskemailaccounts(client_id, reader.ReadLine());
                            if (procedure == "usermanagement") usermanagement(client_id, reader.ReadLine());
                            if (procedure == "helpdeskhardware") helpdeskhardware(client_id, reader.ReadLine());
                            if (procedure == "helpdeskcloudapplications") helpdeskcloudapplications(client_id, reader.ReadLine());
                            if (procedure == "helpdeskfileaccesssharing") helpdeskfileaccesssharing(client_id, reader.ReadLine());
                            if (procedure == "helpdeskwebsiteaccess") helpdeskwebsiteaccess(client_id, reader.ReadLine());
                            if (procedure == "helpdesksoftwarelicenses") helpdesksoftwarelicenses(client_id, reader.ReadLine());

                        }
                        else
                        {
                            reader.ReadLine();
                        }
                        i++;
                            
                        

                    }
                }
            }
            
            
        }

        public string clientnetworks(string client_id,string data){

            Support su = new Support();
            string[] a = data.Split(',');
            string subnet = a[0];
            string ipaddress = a[1];
            string gateway = a[2];
            string purpose = a[3];
            int i = 0;
            
                su.AddUpdateClientNetworks(null, client_id, subnet, ipaddress, gateway, purpose);
            
            
            return "completed";
        }

        public string clientemergencycontacts(string client_id, string data)
        {

            Support su = new Support();
            string[] a = data.Split(',');
            string emergencycontact = a[0];
            string emergencyphone = a[1];
            string emergencyemail = a[2];
            int i = 0;
           
                su.AddUpdateClientEmergencyContact(null, client_id, emergencycontact, emergencyphone, emergencyemail);
            
            return "completed";
        }

        public string helpdeskemailaccounts(string client_id, string data)
        {

            Support su = new Support();
            string[] a = data.Split(',');
            string fname = a[0];
            string lname = a[1];
            string phone = a[2];
            string email = a[3];
            string username = a[4];
            string password = a[5];
            string in_mail_server = a[6];
            string in_mail_server_port = a[7];
            string in_mail_server_password = a[8];
            string out_mail_server = a[9];
            string out_mail_server_port = a[10];
            string out_mail_server_password = a[11];
            string signature = a[12];
            string status = a[13];
            if (status == "N")
            {
                status = "1";
            }
            else
            {
                status = "0";
            }
            int i = 0;
                su.AddUpdateHelpdeskEmailAddresses (null,client_id,fname,lname,phone,email,username,password,in_mail_server,in_mail_server_port,in_mail_server_password,out_mail_server,out_mail_server_port,out_mail_server_password ,signature,status );
            return "completed";
        }

        public string usermanagement(string client_id, string data)
        {

            Support su = new Support();
            string[] a = data.Split(',');
            string fname = a[0];
            string lname = a[1];
            string phone = a[2];
            string email = a[3];
            string username = a[4];
            string password = a[5];
            string position = a[6];
            string location = a[7];
            string notes = a[8];
            string status = a[9];

            if (status == "N")
            {
                status = "1";
            }
            else
            {
                status = "0";
            }
            int i = 0;
                su.AddUpdateUserManagement(null, client_id, fname, lname, phone, email, username, password, position, location, notes, status);
            return "completed";
        }
        public string helpdesksoftwarelicenses(string client_id, string data)
        {

            Support su = new Support();
            string[] a = data.Split(',');
            string software_name = a[0];
            string url = a[1];
            string license_number = a[2];
            string software_function = a[3];
            string software_version = a[4];
            string license_type = a[5];
            string username = a[6];
            string password = a[7];
            string installed_device = a[8];
            string installed_date = a[9];
            string notes = a[10];
            string filename = a[11];

            int i = 0;
                su.AddUpdateHelpdeskSoftwareLicenses(null, client_id, software_name, url, license_number, software_function, software_version, license_type, username, password, installed_device, installed_date, notes, filename);
                return "completed";
        }

        public string helpdeskhardware(string client_id, string data)
        {

            Support su = new Support();
            string[] a = data.Split(',');
            string hostname = a[0];
            string model = a[1];
            string deviceip = a[2];
            string macaddress =a[3];
            string purchased_from = a[4];
            string purchased_date = a[5];
            string serial = a[6];
            string location = a[7];
            string installed_for = a[9];
            string filename = a[10];

            int i = 0;
                su.AddUpdateHelpdeskHardware(null, client_id, hostname, model, deviceip, macaddress, purchased_from, purchased_date, serial, location, installed_for, filename);
            return "completed";
        }

        public string helpdeskcloudapplications(string client_id, string data)
        {

            Support su = new Support();
            string[] a = data.Split(',');
            string application_name = a[0];
            string license_type = a[1];
            string url = a[2];
            string username = a[3];
            string password = a[4];
            string registered_to = a[5];
            string license_key = a[7];
            string location = a[8];
            string filename = a[9];

            int i = 0;
                su.addupdatehelpdeskcloudapplication (null, client_id,application_name,license_type,url,username,password,registered_to ,license_key,location,filename );
            return "completed";
        }

        public string helpdeskfileaccesssharing(string client_id, string data)
        {

            Support su = new Support();
            string[] a = data.Split(',');
            string sharename = a[0];

            string ipaddress = a[1];
            string url = a[2];
            string usergroup = a[3];
            string username = a[4];
            string password = a[5];
            string location = a[6];
            string purpose = a[07];
            int i = 0;
                su.AddUpdateHelpdeskFileAccessSharing(null, client_id, sharename, ipaddress, url, usergroup, username, password, location, purpose);
            
            return "completed";
       }

        public string helpdeskwebsiteaccess(string client_id, string data)
        {

            Support su = new Support();
            string[] a = data.Split(',');
            int i = 0;
            string name = a[0];
            string username = a[1];
            string password = a[2];
            string website = a[3];
            string url = a[4];
            string location = a[5];
            string defaultbrowser = a[6];
            string bookmarks = a[7];
                su.AddUpdateHelpdeskWebsiteAccess (null,client_id,name,username,password,website,url,location,defaultbrowser,bookmarks );
            return "completed";
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