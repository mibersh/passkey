using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using passkey.App_Code;

namespace passkey.api
{
    /// <summary>
    /// Summary description for exportdata
    /// </summary>
    public class exportdata : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string client_id = context.Request.QueryString["client_id"];
            string procedure = context.Request.QueryString ["procedure"];
            string data = "";


            
            Support su = new Support();
            DataSet ds = su.getdata(client_id, "get" + procedure);

            if (procedure == "clientnetworks") data=clientnetworks(client_id, procedure,ds);
            if (procedure == "clientemergencycontacts") data=clientemergencycontacts(client_id, procedure,ds);
            if (procedure == "helpdeskemailaccounts") data = helpdeskemailaccounts(client_id, procedure, ds);
            if (procedure == "usermanagement") data = usermanagement(client_id, procedure, ds);
            if (procedure == "helpdeskhardware") data = helpdeskhardware(client_id, procedure, ds);
            if (procedure == "helpdeskcloudapplications") data = helpdeskcloudapplications(client_id, procedure, ds);
            if (procedure == "helpdeskfileaccesssharing") data = helpdeskfileaccesssharing(client_id, procedure, ds);
            if (procedure == "helpdeskwebsiteaccess") data = helpdeskwebsiteaccess(client_id, procedure, ds);
            if (procedure == "helpdesksoftwarelicenses") data = helpdesksoftwarelicenses(client_id, procedure, ds);
            

            string fileName = procedure + ".csv";
            
            
            context.Response.Clear();
            context.Response.ContentType = "application/CSV";
            context.Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
            context.Response.Write(data);
            context.Response.End();

        }

        private string helpdesksoftwarelicenses(string client_id, string procedure, DataSet ds)
        {
            string d = "software_name ,url,license_number,software_function,software_version,license_type,username,password,installed_device,installed_date,notes ,filename,\n";
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string software_name = "";
                string url = "";
                string license_number = "";
                string software_function = "";
                string software_version = "";
                string license_type = "";
                string username = "";
                string password = "";
                string installed_device = "";
                string installed_date = "";
                string notes = "";
                string filename = "";

                if (dr["software_name"] != DBNull.Value) software_name = dr["software_name"].ToString();
                if (dr["url"] != DBNull.Value) url = dr["url"].ToString();
                if (dr["license_number"] != DBNull.Value) license_number = dr["license_number"].ToString();
                if (dr["software_function"] != DBNull.Value) software_function = dr["software_function"].ToString();
                if (dr["software_version"] != DBNull.Value) software_version = dr["software_version"].ToString();
                if (dr["license_type"] != DBNull.Value) license_type = dr["license_type"].ToString();
                if (dr["username"] != DBNull.Value) username = dr["username"].ToString();
                if (dr["password"] != DBNull.Value) password = dr["password"].ToString();
                if (dr["installed_device"] != DBNull.Value) installed_device = dr["installed_device"].ToString();
                if (dr["installed_date"] != DBNull.Value) installed_date = dr["installed_date"].ToString();
                if (dr["notes"] != DBNull.Value) notes = dr["notes"].ToString();
                if (dr["filename"] != DBNull.Value) filename = dr["filename"].ToString();

                d+=software_name+","+url+","+license_type +","+software_function +","+ software_version +","+ license_type +","+username +","+ password +","+ installed_device+","+ installed_date +","+ notes +","+  filename +"\n";
            }
            return d;
        }

        private string helpdeskwebsiteaccess(string client_id, string procedure,DataSet ds)
        {
            string d =  "name,username,password,website,url,location,defaultbrowser,bookmarks,\n";
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string name="";
                string username = "";
                string password = "";
                string website = "";
                string url = "";
                string location = "";
                string defaultbrowser ="";
                string bookmarks = "";
                
                if(dr["name"]!= DBNull.Value ) name=dr["name"].ToString ();
                if (dr["username"] != DBNull.Value) username = dr["username"].ToString();
                if (dr["password"] != DBNull.Value) password=dr["password"].ToString();
                if (dr["website"] != DBNull.Value) website = dr["website"].ToString();
                if (dr["url"] != DBNull.Value) url=dr["url"].ToString();
                if (dr["location"] != DBNull.Value) location = dr["location"].ToString();
                if (dr["defaultbrowser"] != DBNull.Value)defaultbrowser= dr["defaultbrowser"].ToString();
                if (dr["bookmarks"] != DBNull.Value) bookmarks=dr["bookmarks"].ToString();
                d += name + "," + username + "," + password + "," + website + "," + url + "," + location + "," + defaultbrowser + "," + bookmarks + "\n";
            }
            return d;
        }

        private string helpdeskfileaccesssharing(string client_id, string procedure, DataSet ds)
        {
            string d = "sharename,ipaddress,url,usergroup,username,password,location,purpose,\n";
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string sharename = "";
                string ipaddress = "";
                string url = "";
                string usergroup = "";
                string username = "";
                string password = "";
                string location = "";
                string purpose = "";

                if (dr["sharename"] != DBNull.Value) sharename = dr["sharename"].ToString();
                if (dr["ipaddress"] != DBNull.Value) ipaddress = dr["ipaddress"].ToString();
                if (dr["url"] != DBNull.Value) url = dr["url"].ToString();
                if (dr["usergroup"] != DBNull.Value) usergroup = dr["usergroup"].ToString();
                if (dr["username"] != DBNull.Value) username = dr["username"].ToString();
                if (dr["password"] != DBNull.Value) password = dr["password"].ToString();
                if (dr["location"] != DBNull.Value) location = dr["location"].ToString();
                if (dr["purpose"] != DBNull.Value) purpose = dr["purpose"].ToString();
                d += sharename + "," + ipaddress + "," + url + "," + usergroup + "," + username + "," + password + "," + location + "," + purpose + "\n";
            
            }
            return d;
        }

        private string helpdeskcloudapplications(string client_id, string procedure, DataSet ds)
        {
            string d = "application_name,license_type,url,username,password,registered_to,license_key,location,filename,\n";
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string application_name = "";
                string license_type = "";
                string url = "";
                string username = "";
                string password = "";
                string registered_to = "";
                string license_key = "";
                string location = "";
                string filename = "";

                if (dr["application_name"] != DBNull.Value) application_name = dr["application_name"].ToString();
                if (dr["license_type"] != DBNull.Value) license_type = dr["license_type"].ToString();
                if (dr["url"] != DBNull.Value) url = dr["url"].ToString();
                if (dr["username"] != DBNull.Value) username = dr["username"].ToString();
                if (dr["password"] != DBNull.Value) password = dr["password"].ToString();
                if (dr["registered_to"] != DBNull.Value) registered_to = dr["registered_to"].ToString();
                if (dr["license_key"] != DBNull.Value) license_key = dr["license_key"].ToString();

                if (dr["location"] != DBNull.Value) location = dr["location"].ToString();
                if (dr["filename"] != DBNull.Value) filename = dr["filename"].ToString();

                d += application_name + "," + license_type + "," + url + "," + username + "," + password + "," + registered_to + "," + license_type + "," + location + "," + filename + "\n";
            }
            return d;


            
        }

        private string helpdeskhardware(string client_id, string procedure, DataSet ds)
        {
            string d = "hostname,model,deviceip,macaddress,purchased_from,purchased_date,serial,location,installed_for,filename,\n";
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string hostname = "";
                string model = "";
                string deviceip = "";
                string macaddress = "";
                string purchased_from = "";
                string purchased_date = "";
                string serial = "";
                string location = "";
                string installed_for = "";
                string filename = "";

                if (dr["hostname"] != DBNull.Value) hostname = dr["hostname"].ToString();
                if (dr["model"] != DBNull.Value) model = dr["model"].ToString();
                if (dr["deviceip"] != DBNull.Value) deviceip = dr["deviceip"].ToString();
                if (dr["macaddress"] != DBNull.Value) macaddress = dr["macaddress"].ToString();
                if (dr["purchased_from"] != DBNull.Value) purchased_from = dr["purchased_from"].ToString();
                if (dr["purchased_date"] != DBNull.Value) purchased_date = dr["purchased_date"].ToString();
                if (dr["serial"] != DBNull.Value) serial = dr["serial"].ToString();
                if (dr["location"] != DBNull.Value) location = dr["location"].ToString();
                if (dr["installed_for"] != DBNull.Value) installed_for = dr["installed_for"].ToString();
                if (dr["filename"] != DBNull.Value) filename = dr["filename"].ToString();
                d += hostname + "," + model + "," + deviceip + "," + macaddress + "," + purchased_from + "," + purchased_date + "," + serial + "," + location + "," + installed_for + "," + filename + "\n";
            }
            return d;
        }

        private string usermanagement(string client_id, string procedure, DataSet ds)
        {
            string d = "fname,lname ,phone,email,username,password,position,location ,notes ,status,\n";
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string fname = "";
                string lname = "";
                string phone = "";
                string email = "";
                string username = "";
                string password = "";
                string position = "";
                string location = "";
                string notes = "";
                string status = "";

                if (dr["fname"] != DBNull.Value) fname = dr["fname"].ToString();
                if (dr["lname"] != DBNull.Value) lname = dr["lname"].ToString();
                if (dr["phone"] != DBNull.Value) phone = dr["phone"].ToString();
                if (dr["email"] != DBNull.Value) email = dr["email"].ToString();
                if (dr["username"] != DBNull.Value) username = dr["username"].ToString();
                if (dr["password"] != DBNull.Value) password = dr["password"].ToString();
                if (dr["location"] != DBNull.Value) location = dr["location"].ToString();
                if (dr["position"] != DBNull.Value) position = dr["position"].ToString();
                if (dr["notes"] != DBNull.Value) notes = dr["notes"].ToString();
                if (dr["status"] != DBNull.Value)
                {
                    if (dr["status"].ToString() == "1")
                    {
                        status = "Y";
                    }
                    else
                    {
                        status = "N";
                    }
                }
                d += fname + "," + lname + "," + phone + "," + email + "," + username + "," + password + "," + position + "," + location + "," + notes + "," + status + "\n";
            }
            return d;
        }

        private string helpdeskemailaccounts(string client_id, string procedure, DataSet ds)
        {
            string d = "fname,lname,phone,email,username,password,in_mail_server,in_mail_server_port,in_mail_server_password,out_mail_server,out_mail_server_port,out_mail_server_password,signature,string status,\n";
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string fname = "";
                string lname = "";
                string phone = "";
                string email = "";
                string username = "";
                string password = "";
                string in_mail_server = "";
                string in_mail_server_port = "";
                string in_mail_server_password = "";
                string out_mail_server = "";
                string out_mail_server_port = "";
                string out_mail_server_password = "";
                string signature = "";
                string status = "";

                if (dr["fname"] != DBNull.Value) fname = dr["fname"].ToString();
                if (dr["lname"] != DBNull.Value) lname = dr["lname"].ToString();
                if (dr["phone"] != DBNull.Value) phone = dr["phone"].ToString();
                if (dr["email"] != DBNull.Value) email = dr["email"].ToString();
                if (dr["username"] != DBNull.Value) username = dr["username"].ToString();
                if (dr["password"] != DBNull.Value) password = dr["password"].ToString();
                if (dr["in_mail_server"] != DBNull.Value) in_mail_server = dr["in_mail_server"].ToString();
                if (dr["in_mail_server_port"] != DBNull.Value) in_mail_server_port = dr["in_mail_server_port"].ToString();
                if (dr["in_mail_server_password"] != DBNull.Value) in_mail_server_password = dr["in_mail_server_password"].ToString();
                if (dr["out_mail_server"] != DBNull.Value) out_mail_server = dr["out_mail_server"].ToString();
                if (dr["out_mail_server_port"] != DBNull.Value) out_mail_server_port = dr["out_mail_server_port"].ToString();
                if (dr["out_mail_server_password"] != DBNull.Value) out_mail_server_password = dr["out_mail_server_password"].ToString();
                if (dr["signature"] != DBNull.Value) signature = dr["signature"].ToString();

                if (dr["status"] != DBNull.Value)
                {
                    if (dr["status"].ToString() == "1")
                    {
                        status = "Y";
                    }
                    else
                    {
                        status = "N";
                    }
                }
                d += fname + "," + lname + "," + phone + "," + email + "," + username + "," + password + "," + in_mail_server + "," + in_mail_server_port + "," + in_mail_server_password + "," + out_mail_server + "," + out_mail_server_port + "," + out_mail_server_password + "," + signature + "," + status + "\n";
            }
            return d;
        }

        private string clientemergencycontacts(string client_id, string procedure, DataSet ds)
        {
            string d = "emergencycontact,emergencyphone,emergencyemail,+\n";
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string emergencycontact = "";
                string emergencyphone = "";
                string emergencyemail = "";


                if (dr["emergencycontact"] != DBNull.Value) emergencycontact = dr["emergencycontact"].ToString();
                if (dr["emergencyphone"] != DBNull.Value) emergencyphone = dr["emergencyphone"].ToString();
                if (dr["emergencyemail"] != DBNull.Value) emergencyemail = dr["emergencyemail"].ToString();

                d+= emergencycontact +"," + emergencyphone +","+ emergencyemail +"\n";
            }
            return d;
        }

        private string clientnetworks(string client_id, string procedure, DataSet ds)
        {
            string d = "subnet,ipaddress,gateway,purpose,\n";
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string subnet = "";
                string ipaddress = "";
                string gateway = "";
                string purpose = "";
                if (dr["subnet"] != DBNull.Value) subnet = dr["subnet"].ToString();
                if (dr["ipaddress"] != DBNull.Value) ipaddress = dr["ipaddress"].ToString();
                if (dr["gateway"] != DBNull.Value) gateway = dr["gateway"].ToString();
                if (dr["purpose"] != DBNull.Value) purpose = dr["purpose"].ToString();
                d += subnet + "," + ipaddress + "," + gateway + "," + purpose + "\n";
            }
            return d;
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