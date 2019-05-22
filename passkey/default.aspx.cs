using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using System.Data;
using passkey.App_Code ;
using System.IO;

namespace passkey
{
    public partial class _default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod ]
        public static string getclients()
        {
            Support su = new Support ();
            DataSet ds = su.getClients ();
            string comp="";
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string companyname = "";
                string contactname = "";
                string location = "";
                string active = "";


                if (dr["companyname"] != DBNull.Value) companyname = dr["companyname"].ToString();
                if (dr["contactname"] != DBNull.Value) contactname = dr["contactname"].ToString();
                if (dr["address"] != DBNull.Value) location = dr["address"].ToString();
                if (dr["active"] != DBNull.Value)
                {
                    if (dr["active"].ToString() == "1")
                    {
                        active = "Yes";
                    }
                    else
                    {
                        active = "No";
                    }
                }
                else
                {
                    active = "No";
                }

                comp += "<tr><td><a class='green-link' href='#' onclick='getclient("+ dr["id"].ToString() +");'>" + companyname + "</a></td><td>" + contactname + "</td><td>" + location + "</td><td>" + active + "</td></tr>";
            }
            return comp;
        }

        [WebMethod ]
        public static string[] getclient(string id)
        {
            Support su = new Support();
            DataSet ds = su.getClient(id);
            List<string> data = new List<string>();


            string location_str = "<table width='100%' class='table table-striped table-bordered table-hover'><tr><th>Location</th><th>Contact Name</th><th>Phone</th><th>Email</th><th>Address</th><th>City</th><th>State</th><th>Zip</th><th>Notes</th><th>Primaty Location</th><th></th></tr>";
            string companyname = "";
            foreach (DataRow dr in ds.Tables[1].Rows)
            {
                string location = "";
                string contactname = "";
                string phone = "";
                string email = "";
                string address = "";
                string city = "";
                string state = "";
                string zipcode = "";
                string notes = "";
                string primary_location = "0";
                string pl = "N";

                if (dr["location"] != DBNull.Value)
                {
                    location = dr["location"].ToString();
                    companyname = dr["location"].ToString();
                }
                if (dr["contactname"] != DBNull.Value) contactname = dr["contactname"].ToString();
                if (dr["phone"] != DBNull.Value) phone = dr["phone"].ToString();
                if (dr["email"] != DBNull.Value) email = dr["email"].ToString();
                if (dr["address"] != DBNull.Value) address = dr["address"].ToString();
                if (dr["city"] != DBNull.Value) city = dr["city"].ToString();
                if (dr["state"] != DBNull.Value) state = dr["state"].ToString();
                if (dr["zipcode"] != DBNull.Value) zipcode = dr["zipcode"].ToString();
                if (dr["notes"] != DBNull.Value) notes = dr["notes"].ToString();
                if (dr["primary_location"] != DBNull.Value)
                {
                    primary_location = dr["primary_location"].ToString();
                    if (primary_location=="1") {
                        pl = "Y";
                    }
                }
                location_str += "<tr id='location" + dr["id"].ToString() + "'><td>" + location + "</td><td>" + contactname + "</td><td>" + phone + "</td><td>" + email + "</td><td>" + address + "</td><td>" + city + "</td><td>" + state + "</td><td>" + zipcode + "</td><td>" + notes + "</td><td>"+pl+"</td>";
                if (primary_location == "1")
                {
                    location_str += "<td><a data-toggle='modal' href='#locationModel'><span style='cursor:pointer;' onclick=\"editLocation('" + dr["id"].ToString() + "'," + primary_location + ")\" >edit</span></a></td></tr>";
                }
                else
                {
                    //if (allowDelete)
                    //{
                    location_str += "<td><span style='cursor:pointer;' onclick=\"editLocation('" + dr["id"].ToString() + "'," + primary_location + ")\">edit</span>&nbsp;<span style='cursor:pointer;' onclick=\"if (confirm('Are you sure?')){ deleteRecord('" + dr["id"].ToString() + "','Location')};\">delete</span></td></tr>";

                    //}
                    //else
                    //{
                    //    location_str += "<td><span style='cursor:pointer;' onclick=\"editLocation('" + dr["id"].ToString() + "'," + primary_location + ")\">edit</span></td></tr>";

                    //}
                }
            }

            location_str += "<tfoot><tr><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th><button class='btn btn-success' type='button' onclick='editLocation();'>Add New</button></th></tr></tfoot></table>";
            data.Add(companyname );
            data.Add(location_str);


            string client_networks = "<table width='100%' class='table table-striped table-bordered table-hover'><tr><th>Subnet</th><th>IP Address</th><th>Gateway</th><th>Purpose</th><th></th></tr>";
            foreach (DataRow dr in ds.Tables[2].Rows)
            {
                string subnet = "";
                string ipaddress = "";
                string gateway = "";
                string purpose = "";
                if (dr["subnet"] != DBNull.Value) subnet = dr["subnet"].ToString();
                if (dr["ipaddress"] != DBNull.Value) ipaddress = dr["ipaddress"].ToString();
                if (dr["gateway"] != DBNull.Value) gateway = dr["gateway"].ToString();
                if (dr["purpose"] != DBNull.Value) purpose = dr["purpose"].ToString();

                client_networks += "<tr id='clientnetworks" + dr["id"].ToString() + "'><td>" + subnet + "</td><td>" + ipaddress + "</td><td>" + gateway + "</td><td>" + purpose + "</td>";
                client_networks += "<td><span style='cursor:pointer;' onclick=\"editclientnetworks('" + dr["id"].ToString() + "')\">edit</span>&nbsp;<span style='cursor:pointer;' onclick=\"if (confirm('Are you sure?')) {deleteRecord('" + dr["id"].ToString() + "','ClientNetworks')}\">delete</span></td></tr>";

            }

            client_networks += "<tfoot><tr><th></th><th><button class=\"btn btn-success\" type=\"button\" onclick=\"exportFile('clientnetworks')\" >Export</button></th><th><input type=\"file\" id=\"clientnetworksfile\" class=\"form-control-file\" /></th><th><button class=\"btn btn-success\" type=\"button\" onclick=\"uploadFile('clientnetworksfile','clientnetworks');\">Upload File</button></th><th><button class='btn btn-success' type='button' onclick='editclientnetworks();'>Add New</button></th></tr></tfoot></table>";
            
            data.Add(client_networks);


            string client_files = "<table width='100%' class='table table-striped table-bordered table-hover'><tr><th>Files</th><th></th></tr>";
            foreach (DataRow dr in ds.Tables[3].Rows)
            {
                string filename = "";
                if (dr["filename"] != DBNull.Value) filename = dr["filename"].ToString();
                client_files += "<tr id='ClientFiles" + dr["id"].ToString() + "'><td><a href='AddUpdateClientFiles/" +dr["id"].ToString() + filename + "' target='_blank'>" + filename + "</a></td>";
                client_files += "<td><span style='cursor:pointer;' onclick=\"if (confirm('Are you sure?')) {deleteRecord('" + dr["id"].ToString() + "','ClientFiles')}\">delete</span></td></tr>";


            }

            client_files += "<tfoot><tr><th><input type=\"file\" name=\"client_file\" id=\"client_file\" /><input type=\"button\" value=\"Save File\" id=\"up_btn_client_file\" class='btn btn-success' onclick=\"AddUpdateClientFiles();\" /></th><th></th></tr></tfoot></table>";
            data.Add(client_files);


            string client_emergency_contacts = "<table width='100%' class='table table-striped table-bordered table-hover'><tr><th>Contact Name</th><th>Phone</th><th>Email</th><th></th></tr>";
            foreach (DataRow dr in ds.Tables[4].Rows)
            {
                string emergencycontact = "";
                string emergencyphone = "";
                string emergencyemail = "";


                if (dr["emergencycontact"] != DBNull.Value) emergencycontact = dr["emergencycontact"].ToString();
                if (dr["emergencyphone"] != DBNull.Value) emergencyphone = dr["emergencyphone"].ToString();
                if (dr["emergencyemail"] != DBNull.Value) emergencyemail = dr["emergencyemail"].ToString();

                client_emergency_contacts += "<tr id='emergencycontacts" + dr["id"].ToString() + "'><td>" + emergencycontact + "</td><td>" + emergencyphone + "</td><td>" + emergencyemail + "</td>";
                client_emergency_contacts += "<td><span style='cursor:pointer;' onclick=\"editemergencycontacts('" + dr["id"].ToString() + "')\">edit</span>&nbsp;<span style='cursor:pointer;' onclick=\"if (confirm('Are you sure?')) {deleteRecord('" + dr["id"].ToString() + "','ClientEmergencyContacts')}\">delete</span></td></tr>";


            }

            client_emergency_contacts += "<tfoot><tr><th><button class=\"btn btn-success\" type=\"button\" onclick=\"exportFile('clientemergencycontacts')\" >Export</button></th><th><input type=\"file\" id=\"clientemergencycontactsfile\" class=\"form-control-file\" /></th><th><button class=\"btn btn-success\" type=\"button\" onclick=\"uploadFile('clientemergencycontactsfile','clientemergencycontacts');\">Upload File</button></th><th><button class='btn btn-success' type='button' onclick='editemergencycontacts();'>Add New</button></th></tr></tfoot></table>";
            data.Add(client_emergency_contacts);

            return data.ToArray();
        }

        public static string gethelpdeskemailaccounts(DataSet ds)
        {
            //Support su = new Support();
            //DataSet ds = su.getusermanagement(id);
            string d = "";

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string fname="";
			    string lname="";
			    string phone="";
			    string email="";
			    string username="";
			    string password="";
			    string in_mail_server="";
                string in_mail_server_port = "";
                string in_mail_server_password= "";
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

                d += "<tr id='helpdeskemailaccounts" + dr["id"].ToString() + "'><td>" + lname + "</td><td>" + fname + "</td><td>" + phone + "</td><td>" + email + "</td><td>" + username + "</td><td>" + password + "</td><td>" + in_mail_server + "</td><td>" + in_mail_server_port + "</td><td>" + in_mail_server_password + "</td><td>" + out_mail_server + "</td><td>" + out_mail_server_port + "</td><td>" + out_mail_server_password + "</td><td><a href='helpdeskemailaccounts/" + dr["id"].ToString() + signature + "' target='_blank'>" + signature + "</a></td><td>" + status + "</td>";
                d += "<td><span style='cursor:pointer;' onclick=\"edithelpdeskemailaccounts('" + dr["id"].ToString() + "')\">edit</span>&nbsp;<span style='cursor:pointer;' onclick=\"if (confirm('Are you sure?')) {deleteRecord('" + dr["id"].ToString() + "','helpdeskemailaccounts')}\">delete</span></td></tr>";

            }

            return d;
        }

        public static string getusermanagement(DataSet ds)
        {
            //Support su = new Support();
            //DataSet ds = su.getusermanagement(id);
            string d = "";

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
                
                d += "<tr id='usermanagement" + dr["id"].ToString() + "'><td>" + lname + "</td><td>" + fname + "</td><td>" + phone + "</td><td>" + email + "</td><td>" + username + "</td><td>" + password + "</td><td>" + position + "</td><td>" + location + "</td><td>" + notes + "</td><td>" + status + "</td>";
                d += "<td><span style='cursor:pointer;' onclick=\"editusermanagement('" + dr["id"].ToString() + "')\">edit</span>&nbsp;<span style='cursor:pointer;' onclick=\"if (confirm('Are you sure?')) {deleteRecord('" + dr["id"].ToString() + "','ClientNetworks')}\">delete</span></td></tr>";

            }

            return d;
        }

        public static string gethelpdesksoftwarelicenses(DataSet ds)
        {
            string d = "";

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


                d += "<tr id='helpdesksoftwarelicenses" + dr["id"].ToString() + "'><td>" + software_name + "</td><td>" + url + "</td><td>" + license_number + "</td><td>" + software_function + "</td><td>" + software_version + "</td><td>" + license_type + "</td><td>" + username + "</td><td>" + password + "</td><td>" + installed_device + "</td><td>" + installed_date + "</td><td>" + notes + "</td><td><a href='helpdesksoftwarelicenses/" + dr["id"].ToString() + filename + "' target='_blank'>" + filename + "</a></td>";
                d += "<td><span style='cursor:pointer;' onclick=\"edithelpdesksoftwarelicenses('" + dr["id"].ToString() + "')\">edit</span>&nbsp;<span style='cursor:pointer;' onclick=\"if (confirm('Are you sure?')) {deleteRecord('" + dr["id"].ToString() + "','helpdesksoftwarelicenses')}\">delete</span></td></tr>";

            }

            return d;
        }


        public static string gethelpdeskhardware(DataSet ds)
        {
            string d = "";

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

                d += "<tr id='helpdeskhardware" + dr["id"].ToString() + "'><td>" + hostname + "</td><td>" + model + "</td><td>" + deviceip + "</td><td>" + macaddress + "</td><td>" + purchased_from + "</td><td>" + purchased_date + "</td><td>" + serial + "</td><td>" + location + "</td><td>" + installed_for + "</td><td><a href='helpdeskhardware/" + dr["id"].ToString() + filename + "' target='_blank'>" + filename + "</a></td>";
                d += "<td><span style='cursor:pointer;' onclick=\"edithelpdeskhardware('" + dr["id"].ToString() + "')\">edit</span>&nbsp;<span style='cursor:pointer;' onclick=\"if (confirm('Are you sure?')) {deleteRecord('" + dr["id"].ToString() + "','helpdeskhardware')}\">delete</span></td></tr>";

            }

            return d;
        }

        public static string gethelpdeskcloudapplications(DataSet ds)
        {
            string d = "";

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string application_name="";
                string license_type="";
                string url="";
                string username="";
                string password="";
                string registered_to="";
                string license_key="";
                string location="";
                string filename = "";

                if (dr["application_name"] != DBNull.Value) application_name = dr["application_name"].ToString();
                if (dr["license_type"] != DBNull.Value)  license_type = dr["license_type"].ToString();
                if (dr["url"] != DBNull.Value) url = dr["url"].ToString();
                if (dr["username"] != DBNull.Value) username = dr["username"].ToString();
                if (dr["password"] != DBNull.Value) password = dr["password"].ToString();
                if (dr["registered_to"] != DBNull.Value) registered_to = dr["registered_to"].ToString();
                if (dr["license_key"] != DBNull.Value) license_key = dr["license_key"].ToString();
                
                if (dr["location"] != DBNull.Value) location = dr["location"].ToString();
                if (dr["filename"] != DBNull.Value) filename = dr["filename"].ToString();

                d += "<tr id='helpdeskcloudapplications" + dr["id"].ToString() + "'><td>" + application_name + "</td><td>" + license_type + "</td><td>" + url + "</td><td>" + username + "</td><td>" + password + "</td><td>" + registered_to + "</td><td>" + license_key + "</td><td>" + location + "</td><td><a href='helpdeskcloudapplications/" + dr["id"].ToString() + filename + "' target='_blank'>" + filename + "</a></td>";
                d += "<td><span style='cursor:pointer;' onclick=\"edithelpdeskcloudapplications('" + dr["id"].ToString() + "')\">edit</span>&nbsp;<span style='cursor:pointer;' onclick=\"if (confirm('Are you sure?')) {deleteRecord('" + dr["id"].ToString() + "','helpdeskcloudapplications')}\">delete</span></td></tr>";

             }

            return d;
        }

        public static string getclientlocations(DataSet ds)
        {
            string d = "";

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string location= "";
                
                
               
                if (dr["location"] != DBNull.Value) location = dr["location"].ToString();
                
                d += "<option value=\"" + dr["location"].ToString() +"\">"  + location + "</option>";
                
            }

            return d;
        }

        public static string gethelpdeskfileaccesssharing(DataSet ds)
        {
            string d = "";

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
                
                d += "<tr id='helpdeskfileaccesssharing" + dr["id"].ToString() + "'><td>" + sharename + "</td><td>" + ipaddress + "</td><td>" + url + "</td><td>" + usergroup + "</td><td>" + username + "</td><td>" + password + "</td><td>" + location + "</td><td>" + purpose + "</td>";
                d += "<td><span style='cursor:pointer;' onclick=\"edithelpdeskfileaccesssharing('" + dr["id"].ToString() + "')\">edit</span>&nbsp;<span style='cursor:pointer;' onclick=\"if (confirm('Are you sure?')) {deleteRecord('" + dr["id"].ToString() + "','helpdeskfileaccesssharing')}\">delete</span></td></tr>";

            }

            return d;
        }

        public static string gethelpdeskwebsiteaccess(DataSet ds)
        {
            string d = "";

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string name = "";
                string username = "";
                string password = "";
                string website = "";
                string url = "";
                string location = "";
                string defaultbrowser = "";
                string bookmarks = "";

                if (dr["name"] != DBNull.Value) name = dr["name"].ToString();
                if (dr["username"] != DBNull.Value) username = dr["username"].ToString();
                if (dr["password"] != DBNull.Value) password = dr["password"].ToString();
                if (dr["website"] != DBNull.Value) website = dr["website"].ToString();
                if (dr["url"] != DBNull.Value) url = dr["url"].ToString();
                if (dr["location"] != DBNull.Value) location = dr["location"].ToString();
                if (dr["defaultbrowser"] != DBNull.Value) defaultbrowser = dr["defaultbrowser"].ToString();
                if (dr["bookmarks"] != DBNull.Value) bookmarks = dr["bookmarks"].ToString();


                d += "<tr id='helpdeskwebsiteaccess" + dr["id"].ToString() + "'><td>" + name + "</td><td>" + username + "</td><td>" + password + "</td><td>" + website + "</td><td>" + url + "</td><td>" + location + "</td><td>" + defaultbrowser + "</td><td><a href='" + dr["id"].ToString() + bookmarks + "' target='_blank'>" + bookmarks + "</a></td>";
                d += "<td><span style='cursor:pointer;' onclick=\"edithelpdeskwebsiteaccess('" + dr["id"].ToString() + "')\">edit</span>&nbsp;<span style='cursor:pointer;' onclick=\"if (confirm('Are you sure?')) {deleteRecord('" + dr["id"].ToString() + "','helpdeskwebsiteaccess')}\">delete</span></td></tr>";

            }

            return d;
        }
        
        [WebMethod ]
        public static string getdata(string id, string f)
        {
            Support su= new Support ();
            DataSet ds = su.getdata(id, f);
            string str = "";

            if (f == "getusermanagement")
            {
                str = getusermanagement(ds);
            }

           
            if (f == "gethelpdeskemailaccounts")
            {
                str = gethelpdeskemailaccounts(ds);
            }

            if (f == "gethelpdesksoftwarelicenses")
            {
                str = gethelpdesksoftwarelicenses(ds);
            }
            if (f == "gethelpdeskhardware")
            {
                str = gethelpdeskhardware(ds);
            }

            if (f == "gethelpdeskfileaccesssharing")
            {
                str = gethelpdeskfileaccesssharing(ds);
            }

            if (f == "gethelpdeskwebsiteaccess")
            {
                str = gethelpdeskwebsiteaccess(ds);
            }
            if (f == "gethelpdeskcloudapplications")
            {
                str = gethelpdeskcloudapplications(ds);
            }

            if (f == "getclientlocations")
            {
                str = getclientlocations(ds);
            }

            
            
            return str;
        }

       
        //generic delete function

        [WebMethod ]
        public static string deleteRecord(string id, string procedure){
            Support su = new Support();
            su.deleteRecord(id, procedure);

            return "Record Deleted";
        }

        [WebMethod]
        public static string UpdateLocation(string location_id, string client_id, string companyname, string contactname, string phone, string email, string address, string city, string state, string zipcode, string comments, string status, string primary_location)
        {
            Support su = new Support();
            
            if (primary_location == "1")
            {
                su.AddUpdateClient(client_id, companyname, contactname, phone, email, address, city, state, zipcode, comments, status);
            }
            su.AddUpdateLocation(location_id, client_id, companyname, contactname, phone, email, address, city, state, zipcode, comments, primary_location);
            return "completed";
        }


        [WebMethod ]
        public static string AddUpdateClientEmergencyContact(string id, string client_id, string emergencycontact, string emergencyphone, string emergencyemail){
            Support su = new Support();
            su.AddUpdateClientEmergencyContact(id, client_id, emergencycontact, emergencyphone, emergencyemail);

            return "completed";
        }

        [WebMethod ]
        public static string addupdateclientnetworks(string id, string client_id,string subnet,string ipaddress, string gateway, string purpose)
        {
            Support su = new Support();
            id=su.AddUpdateClientNetworks(id, client_id, subnet, ipaddress, gateway, purpose);
            return id;
        }
        [WebMethod ]
        public static string addupdateusermanagement(string id, string client_id,string fname,string lname,string phone, string email,string username,string password,string position,string location, string notes, string status)
        {
            Support su = new Support();
            id=su.AddUpdateUserManagement(id, client_id, fname,lname,phone,email,username,password,position,location,notes,status);
            return id;
        }

        [WebMethod]
        public static string addupdatehelpdeskemailaccounts(string id, string client_id, string fname, string lname, string phone, string email, string username, string password, string in_mail_server, string in_mail_server_port, string in_mail_server_password, string out_mail_server, string out_mail_server_port, string out_mail_server_password, string signature, string status)
        {
            Support su = new Support();
            id =su.AddUpdateHelpdeskEmailAddresses(id, client_id, fname, lname, phone, email, username, password, in_mail_server,  in_mail_server_port, in_mail_server_password, out_mail_server,out_mail_server_port, out_mail_server_password, signature,status);
            return id;
        }


        [WebMethod]
        public static string AddUpdateHelpdeskSoftwareLicenses(string id, string client_id, string software_name ,string url ,string license_number,string software_function,string software_version, string license_type,string username,string password,string installed_device ,string installed_date, string notes, string filename)
        {
            Support su = new Support();
            id = su.AddUpdateHelpdeskSoftwareLicenses(id, client_id, software_name ,url ,license_number,software_function,software_version, license_type,username,password, installed_device ,installed_date, notes, filename);
            return id;
        }

        [WebMethod]
        public static string addupdatehelpdeskhardware(string id, string client_id, string hostname, string model, string deviceip, string macaddress, string purchased_from, string purchased_date, string serial, string location, string installed_for, string filename)
        {
            Support su = new Support();
            id = su.AddUpdateHelpdeskHardware(id, client_id, hostname ,model, deviceip, macaddress,purchased_from,purchased_date,serial,location,installed_for, filename);
            return id;
        }
        [WebMethod]
        public static string AddUpdateHelpdeskFileAccessSharing(string id, string client_id,string sharename,string ipaddress,string url,string usergroup, string username,string password, string location, string  purpose)
        {
            Support su = new Support();
            id=su.AddUpdateHelpdeskFileAccessSharing(id, client_id, sharename,ipaddress,url,usergroup,username,password,location,purpose);
            return id;
        }
        [WebMethod]
        public static string addupdatehelpdeskwebsiteaccess(string id, string client_id, string name, string username, string password, string website, string url, string location, string defaultbrowser, string bookmarks)
        {
            Support su = new Support();
            id = su.AddUpdateHelpdeskWebsiteAccess(id, client_id, name, username, password, website, url, location, defaultbrowser, bookmarks);
            return id;
        }

        [WebMethod]

        public static string addupdatehelpdeskcloudapplications(string id, string client_id, string application_name, string license_type, string url, string username, string password, string registered_to, string license_key, string location, string filename)
        {
            Support su = new Support();
            id=su.addupdatehelpdeskcloudapplication(id, client_id, application_name, license_type, url, username, password, registered_to, license_key,location, filename);
            return id;
        }
        [WebMethod ]

        public static string AddClient(string primary_location, string companyname, string contactname, string phone, string email, string address, string city, string state, string zipcode, string notes)
        {                               
            Support su = new Support();

            string client_id = su.AddUpdateClient(null, companyname, contactname, phone, email, address, city, state, zipcode, notes, primary_location);
            string location_id = su.AddUpdateLocation(null, client_id, companyname, contactname, phone, email, address, city, state, zipcode, notes, primary_location);
            return "{\"client_id\":\"" + client_id + "\",\"location_id\":\"" + location_id + "\"}";
        }

        [WebMethod]

        public static string UpdateClient(string client_id,string location_id,string primary_location, string companyname, string contactname, string phone, string email, string address, string city, string state, string zipcode, string notes)
        {
            Support su = new Support();

            client_id = su.AddUpdateClient(client_id, companyname, contactname, phone, email, address, city, state, zipcode, notes, primary_location);
            location_id = su.AddUpdateLocation(location_id , client_id, companyname, contactname, phone, email, address, city, state, zipcode, notes, primary_location);
            return "{\"client_id\":\"" + client_id + "\",\"location_id\":\"" + location_id + "\"}";
        }

        [WebMethod]
        public void uploadfile()
        {
            if (HttpContext.Current.Request.Files.AllKeys.Any())
            {
                // Get the uploaded image from the Files collection
                var httpPostedFile = HttpContext.Current.Request.Files["UploadedImage"];

                if (httpPostedFile != null)
                {
                    // Validate the uploaded image(optional)

                    // Get the complete file path
                    var fileSavePath = Path.Combine(HttpContext.Current.Server.MapPath("~/UploadedFiles"), httpPostedFile.FileName);

                    // Save the uploaded file to "UploadedFiles" folder
                    httpPostedFile.SaveAs(fileSavePath);
                }
            }
            
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static bool SaveData(string Name, string[] fileData)
        {
            //Breakpoint
            return true;
        }

        [WebMethod(EnableSession = true)]
        public static string uploadattachment()
        {
            string UploadingMsg;
            var Postedfile = HttpContext.Current.Request.Files[0];
            //Miscellaneous.AnyFileUpload(HttpContext.Current.Request.PhysicalApplicationPath, "chatuploads", Postedfile, out UploadingMsg, 209715200, "200mb");
            return "done";
        }
    }
}