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
using passkey.classes;
using Newtonsoft.Json;
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
            string active = "0";

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                if (dr["active"] != DBNull.Value)
                {
                    if (dr["active"].ToString() == "1")
                    {
                        active = dr["active"].ToString();
                    }
                    
                }
            }

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

            //client_networks += "<tfoot><tr><th></th><th><button class=\"btn btn-success\" type=\"button\" onclick=\"exportFile('clientnetworks')\" >Export</button></th><th><input type=\"file\" id=\"clientnetworksfile\" class=\"form-control-file\" /></th><th><button class=\"btn btn-success\" type=\"button\" onclick=\"uploadFile('clientnetworksfile','clientnetworks');\">Upload File</button></th><th><button class='btn btn-success' type='button' onclick='editclientnetworks();'>Add New</button></th></tr></tfoot></table>";
            client_networks += "<tfoot><tr><th></th><th></th><th></th><th></th><th></th></tr></tfoot></table>";
            
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

            //client_emergency_contacts += "<tfoot><tr><th><button class=\"btn btn-success\" type=\"button\" onclick=\"exportFile('clientemergencycontacts')\" >Export</button></th><th><input type=\"file\" id=\"clientemergencycontactsfile\" class=\"form-control-file\" /></th><th><button class=\"btn btn-success\" type=\"button\" onclick=\"uploadFile('clientemergencycontactsfile','clientemergencycontacts');\">Upload File</button></th><th><button class='btn btn-success' type='button' onclick='editemergencycontacts();'>Add New</button></th></tr></tfoot></table>";
            client_emergency_contacts += "<tfoot><tr><th></th><th></th><th></th><th></th></tr></tfoot></table>";
            
            data.Add(client_emergency_contacts);
            data.Add(active);
            return data.ToArray();
        }


        [WebMethod ]

        public static string getWindowsServer(string id){
            ws msn = new ws();
            Support su= new Support();
            DataSet ds = su.getdata(id, "get_microsoft_server_by_id");

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                msn.id= dr["id"].ToString ();
                msn.client_id = int.Parse (dr["client_id"].ToString ());
                if (dr["server_version"] != DBNull.Value) msn.server_version = dr["server_version"].ToString ();
                if (dr["server_version_other"] != DBNull.Value) msn.server_version_other = dr["server_version_other"].ToString ();
                if (dr["location"] != DBNull.Value) msn.location  = dr["location"].ToString ();
                if (dr["operating_roles"] != DBNull.Value) msn.operating_roles  = dr["operating_roles"].ToString ();
                if (dr["hostname"] != DBNull.Value) msn.hostname   = dr["hostname"].ToString ();
                if (dr["ipaddress"] != DBNull.Value) msn.ipaddress  = dr["ipaddress"].ToString ();
                if (dr["domain"] != DBNull.Value) msn.domain  = dr["domain"].ToString ();
                if (dr["macaddress"] != DBNull.Value) msn.macaddress  = dr["macaddress"].ToString ();
                if (dr["dns_entry"] != DBNull.Value) msn.dns_entry  = dr["dns_entry"].ToString ();
                if (dr["username"] != DBNull.Value) msn.username  = dr["username"].ToString ();
                if (dr["password"] != DBNull.Value) msn.password  = dr["password"].ToString () ;
                if (dr["license"] != DBNull.Value) msn.license  = dr["license"].ToString ();
                if (dr["filename"] != DBNull.Value) msn.filename   = dr["filename"].ToString ();
                if (dr["dhcp_server"] != DBNull.Value) msn.dhcp_server   = dr["dhcp_server"].ToString ();
                if (dr["dhcp_primary_pool"] != DBNull.Value) msn.dhcp_primary_pool   = dr["dhcp_primary_pool"].ToString ();
                if (dr["dhcp_primary_lease_time"] != DBNull.Value) msn.dhcp_primary_lease_time  = dr["dhcp_primary_lease_time"].ToString ();
                if (dr["dhcp_additinal_pool"] != DBNull.Value) msn.dhcp_additinal_pool  = dr["dhcp_additinal_pool"].ToString ();
                if (dr["dhcp_additinal_lease_time"] != DBNull.Value) msn.dhcp_additinal_lease_time  = dr["dhcp_additinal_lease_time"].ToString ();
                if (dr["dhcp_reservations"] != DBNull.Value) msn.dhcp_reservations  = dr["dhcp_reservations"].ToString ();
                if (dr["dns_server"] != DBNull.Value) msn.dns_server  = dr["dns_server"].ToString ();
                if (dr["dns_primary_server_ip"] != DBNull.Value) msn.dns_primary_server_ip  = dr["dns_primary_server_ip"].ToString ();
                if (dr["dns_secondary_server_ip"] != DBNull.Value) msn.dns_secondary_server_ip  = dr["dns_secondary_server_ip"].ToString ();
                if (dr["dns_static_entry"] != DBNull.Value) msn.dns_static_entry  = dr["dns_static_entry"].ToString ();
                if (dr["dhcp_filename"] != DBNull.Value) msn.dhcp_filename  = dr["dhcp_filename"].ToString ();
                if (dr["install_date"] != DBNull.Value) msn.install_date  = dr["install_date"].ToString ();
                if (dr["domain_controller"] != DBNull.Value) msn.domain_controller  = dr["domain_controller"].ToString ();
                if (dr["domain_primary_controller"] != DBNull.Value) msn.domain_primary_controller  = dr["domain_primary_controller"].ToString ();
                if (dr["domain_secondary_controller"] != DBNull.Value) msn.domain_secondary_controller  = dr["domain_secondary_controller"].ToString ();
                if (dr["domain_name"] != DBNull.Value) msn.domain_name  = dr["domain_name"].ToString ();
                if (dr["dfs"] != DBNull.Value) msn.dfs  = dr["dfs"].ToString ();
                if (dr["dfs_primary_controller_ip"] != DBNull.Value) msn.dfs_primary_controller_ip  = dr["dfs_primary_controller_ip"].ToString ();
                if (dr["dfs_secondary_controller_ip"] != DBNull.Value) msn.dfs_secondary_controller_ip  = dr["dfs_secondary_controller_ip"].ToString ();
                if (dr["dfs_filename"] != DBNull.Value) msn.dfs_filename  = dr["dfs_filename"].ToString ();
                if (dr["ad"] != DBNull.Value) msn.ad  = dr["ad"].ToString ();
                if (dr["ad_primary_controller"] != DBNull.Value) msn.ad_primary_controller  = dr["ad_primary_controller"].ToString ();
                if (dr["ad_secondary_controller"] != DBNull.Value) msn.ad_secondary_controller  = dr["ad_secondary_controller"].ToString ();
                if (dr["iis_server"] != DBNull.Value) msn.iis_server  = dr["iis_server"].ToString ();
                if (dr["web_application"] != DBNull.Value) msn.web_application  = dr["web_application"].ToString ();
                if (dr["application_location"] != DBNull.Value) msn.application_location = dr["application_location"].ToString();
                if (dr["asp_version"] != DBNull.Value) msn.asp_version = dr["asp_version"].ToString();
                if (dr["iis_version"] != DBNull.Value) msn.iis_version = dr["iis_version"].ToString();
                if (dr["certificate"] != DBNull.Value) msn.certificate = dr["certificate"].ToString();
                if (dr["iis_backup"] != DBNull.Value) msn.iis_backup = dr["iis_backup"].ToString();
                if (dr["additinal_web_applications"] != DBNull.Value) msn.additinal_web_applications = dr["additinal_web_applications"].ToString();
                if (dr["raid"] != DBNull.Value) msn.raid = dr["raid"].ToString();
                if (dr["raid_controller_model"] != DBNull.Value) msn.raid_controller_model = dr["raid_controller_model"].ToString();
                if (dr["raid_controller_version"] != DBNull.Value) msn.raid_controller_version = dr["raid_controller_version"].ToString();
                if (dr["raid_serial"] != DBNull.Value) msn.raid_serial = dr["raid_serial"].ToString();
                if (dr["raid_function"] != DBNull.Value) msn.raid_function = dr["raid_function"].ToString();
                if (dr["type_of_drives"] != DBNull.Value) msn.type_of_drives = dr["type_of_drives"].ToString();
                if (dr["storage_size"] != DBNull.Value) msn.storage_size  = dr["storage_size"].ToString ();
                if (dr["disk_size_amount"] != DBNull.Value) msn.disk_size_amount = dr["disk_size_amount"].ToString();
                if (dr["valumes"] != DBNull.Value) msn.valumes = dr["valumes"].ToString();
                if (dr["storage_notes"] != DBNull.Value) msn.storage_notes = dr["storage_notes"].ToString();
                if (dr["cpu_model"] != DBNull.Value) msn.cpu_model = dr["cpu_model"].ToString();
                if (dr["cpu_socet"] != DBNull.Value) msn.cpu_socet = dr["cpu_socet"].ToString();
                if (dr["memory_information"] != DBNull.Value) msn.memory_information = dr["memory_information"].ToString();
                if (dr["memory_per_module"] != DBNull.Value) msn.memory_per_module  = dr["memory_per_module"].ToString ();
                if (dr["total_memory"] != DBNull.Value) msn.total_memory = dr["total_memory"].ToString();
                if (dr["hardware_drivers"] != DBNull.Value) msn.hardware_drivers = dr["hardware_drivers"].ToString();
            }


            
            foreach (DataRow dr in ds.Tables[1].Rows)
            {
                string username="";
                string password="";
                string permissions="";
                string purpose="";

                if (dr["username"]!=DBNull.Value )username =dr["username"].ToString ();
                if (dr["password"] != DBNull.Value) password = dr["password"].ToString();
                if (dr["permissions"] != DBNull.Value) permissions = dr["permissions"].ToString();
                if (dr["purpose"] != DBNull.Value) purpose = dr["purpose"].ToString();

                msn.users += "<tr id='msu" + dr["id"].ToString() + "'><td>" + username + "</td><td>" + password + "</td><td>" + permissions + "</td><td>" + purpose + "</td><td><button class='btn btn-success' type='button' onclick='editwsuser($(this));'>edit</button>&nbsp;<button class='btn btn-success' type='button' onclick='deletewsuser($(this));'>Delete</button></td></tr>";
            }
            foreach (DataRow dr in ds.Tables[2].Rows)
            {

                string nic_name = "";
                string nic_ip = "";
                string nic_subnet = "";
                string nic_gateway = "";
                string nic_macaddress = "";
                string purpose = "";
                string nic = "";
                string chk = "";

                

                if (dr["nic_name"] != DBNull.Value) nic_name = dr["nic_name"].ToString();
                if (dr["nic_ip"] != DBNull.Value) nic_ip = dr["nic_ip"].ToString();
                if (dr["nic_subnet"] != DBNull.Value) nic_subnet = dr["nic_subnet"].ToString();
                if (dr["purpose"] != DBNull.Value) purpose = dr["purpose"].ToString();
                if (dr["nic_gateway"] != DBNull.Value) nic_gateway = dr["nic_gateway"].ToString();
                if (dr["nic_macaddress"] != DBNull.Value) nic_macaddress = dr["nic_macaddress"].ToString();

                if (dr["nic"] != DBNull.Value)
                {
                    if (dr["nic"] .ToString () == "True")
                    {
                        chk = "<input type='checkbox' checked id='edit_ws_nic' />";
                    }
                    else
                    {
                        chk = "<input type='checkbox' id='edit_ws_nic' />";
                    }
                }

                msn.nics += "<tr id='msn" + dr["id"].ToString() + "'><td>" + nic_name + "</td><td>" + nic_ip + "</td><td>" + nic_subnet + "</td><td>" + nic_gateway + "</td><td>" + nic_macaddress + "</td><td>" + purpose + "</td><td>" + chk + "</td><td><button class='btn btn-success' type='button' onclick='editwsnic($(this));'>edit</button>&nbsp;<button class='btn btn-success' type='button' onclick='deletewsnic($(this));'>Delete</button></td></tr>";
           
            }

            return JsonConvert.SerializeObject(msn);
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
            if (f == "getHelpdeskCounts")
            {
                str = gethelpdeskcounts(id);
            }
            if (f == "getmicrosoft_servers")
            {
                str = getmicrosoft_servers(ds);
            }

            
            
            return str;
        }

        private static string getmicrosoft_servers(DataSet ds)
        {
            string str = "";


            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string version = "";
                string hostname="";
                string ipaddress="";
                string domain="";
                string license="";
                string username = "";
                string password = "";
                string macaddress = "";
                string location = "";
                
                if (dr["server_version"] != DBNull.Value) version = dr["server_version"].ToString();
                if (dr["hostname"] != DBNull.Value) hostname = dr["hostname"].ToString();
                if (dr["ipaddress"] != DBNull.Value) ipaddress = dr["ipaddress"].ToString();
                if (dr["domain"] != DBNull.Value) domain = dr["domain"].ToString();
                if (dr["license"] != DBNull.Value) license = dr["license"].ToString();
                if (dr["username"] != DBNull.Value) username = dr["username"].ToString();
                if (dr["password"] != DBNull.Value) password = dr["password"].ToString();
                if (dr["macaddress"] != DBNull.Value) macaddress = dr["macaddress"].ToString();
                if (dr["location"] != DBNull.Value) location = dr["location"].ToString();


                str += "<tr id='microsoft_servers" + dr["id"].ToString() + "'><td>" + version + "</td><td>" + hostname + "</td><td>" + ipaddress + "</td><td>" + domain + "</td><td>" + license + "</td><td>" + username + "</td><td>" + password + "</td><td>" + macaddress + "</td><td>" + location + "</td>";
                str += "<td><span style='cursor:pointer;' onclick=\"editmicrosoft_server('" + dr["id"].ToString() + "')\">edit</span>&nbsp;<span style='cursor:pointer;' onclick=\"if (confirm('Are you sure?')) {deleteRecord('" + dr["id"].ToString() + "','microsoft_servers')}\">delete</span></td></tr>";

            }

            return str;
        }

        private static string gethelpdeskcounts(string id)
        {
            Support su= new Support ();
            DataSet ds = su.gethelpdeskcounts(id);
            return ds.Tables[0].Rows[0][0].ToString() + "," + ds.Tables[1].Rows[0][0].ToString() + "," + ds.Tables[2].Rows[0][0].ToString() + "," + ds.Tables[3].Rows[0][0].ToString() + "," + ds.Tables[4].Rows[0][0].ToString() + "," + ds.Tables[5].Rows[0][0].ToString() + "," + ds.Tables[6].Rows[0][0].ToString() + "," + ds.Tables[7].Rows[0][0].ToString();
        }

       
        //generic delete function

        [WebMethod ]
        public static string deleteRecord(string id,string client_id, string procedure){
            Support su = new Support();
            su.deleteRecord(id, procedure);

            su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, procedure + " id:" + id);

            return "Record Deleted";
        }

        [WebMethod]
        public static string UpdateLocation(string location_id, string client_id, string companyname, string contactname, string phone, string email, string address, string city, string state, string zipcode, string comments, string status, string primary_location)
        {
            Support su = new Support();
            string new_client_id = "";
            
            if (primary_location == "1")
            {
                new_client_id=su.AddUpdateClient(client_id, companyname, contactname, phone, email, address, city, state, zipcode, comments, status);
            }
            su.AddUpdateLocation(location_id, client_id, companyname, contactname, phone, email, address, city, state, zipcode, comments, primary_location);

            if (client_id != "")
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "New Client was added " + "client_id:" + new_client_id);
            }
            else
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "Client location was added or updated " + "client_id:" + client_id);
            }
            return "completed";
        }


        [WebMethod ]
        public static string AddUpdateWServer(ws win)
        {

            Support su = new Support();

            string newid = "";
            newid = su.AddUpdateWindowsServer(win);

            return newid;
        }

        [WebMethod ]
        public static string  AddUpdateMSUsers(microsoft_server_users  msu){

            Support su = new Support();
            su.AddUpdateMSUsers(msu);
            string str="Server network was added: ";
            if (msu.id!=null){

            }
            su.AddAudit(msu.client_id, HttpContext.Current.User.Identity.Name, "add update microsoft server network server id: " + msu.server_id + ", network_id: " + msu.id);


            //su.AddAudit (msu)

            return "completed";
        }

        [WebMethod]
        public static string AddUpdateMSNetworks(microsoft_server_networks msn)
        {

            Support su = new Support();
            su.AddUpdateMSNetworks(msn);

            return "completed";
        }


        [WebMethod ]
        public static string AddUpdateClientEmergencyContact(string id, string client_id, string emergencycontact, string emergencyphone, string emergencyemail){
            Support su = new Support();
            string new_id = "";
            new_id = su.AddUpdateClientEmergencyContact(id, client_id, emergencycontact, emergencyphone, emergencyemail);
            if (id != "")
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "New Client Emergancy contact was added " + " id:" + new_id);
            }
            else
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "New Client Emergancy contact was updated " + " id:" + new_id);
            }
            return "completed";
        }

        [WebMethod ]
        public static string addupdateclientnetworks(string id, string client_id,string subnet,string ipaddress, string gateway, string purpose)
        {
            Support su = new Support();
            string new_id = "";
            new_id = su.AddUpdateClientNetworks(id, client_id, subnet, ipaddress, gateway, purpose);
            if (id != "")
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "New Client network was added " + " id:" + new_id);
            }
            else
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "Client network was updated " + " id:" + new_id);
            }
            return new_id;
        }
        [WebMethod ]
        public static string addupdateusermanagement(string id, string client_id,string fname,string lname,string phone, string email,string username,string password,string position,string location, string notes, string status)
        {
            Support su = new Support();
            string new_id = "";
            new_id=su.AddUpdateUserManagement(id, client_id, fname,lname,phone,email,username,password,position,location,notes,status);
            if (id != "")
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "New help desk user management was added " + " id:" + new_id);
            }
            else
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "Help desk user management was updated " + " id:" + new_id);
            }
            return new_id;
        }

        [WebMethod]
        public static string addupdatehelpdeskemailaccounts(string id, string client_id, string fname, string lname, string phone, string email, string username, string password, string in_mail_server, string in_mail_server_port, string in_mail_server_password, string out_mail_server, string out_mail_server_port, string out_mail_server_password, string signature, string status)
        {
            Support su = new Support();
            string new_id = "";
            new_id =su.AddUpdateHelpdeskEmailAddresses(id, client_id, fname, lname, phone, email, username, password, in_mail_server,  in_mail_server_port, in_mail_server_password, out_mail_server,out_mail_server_port, out_mail_server_password, signature,status);
            if (id != "")
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "New helpdesk email account was added " + " id:" + new_id);
            }
            else
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "Helpdesk email account was updated " + " id:" + new_id);
            }
            return new_id;
        }


        [WebMethod]
        public static string AddUpdateHelpdeskSoftwareLicenses(string id, string client_id, string software_name ,string url ,string license_number,string software_function,string software_version, string license_type,string username,string password,string installed_device ,string installed_date, string notes, string filename)
        {
            Support su = new Support();
            string new_id = "";
            new_id = su.AddUpdateHelpdeskSoftwareLicenses(id, client_id, software_name ,url ,license_number,software_function,software_version, license_type,username,password, installed_device ,installed_date, notes, filename);
            if (id != "")
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "Helpdesk Software License was added " + " id:" + new_id);
            }
            else
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "New helpdesk Software License was updated " + " id:" + new_id);
            }
            return new_id;
        }

        [WebMethod]
        public static string addupdatehelpdeskhardware(string id, string client_id, string hostname, string model, string deviceip, string macaddress, string purchased_from, string purchased_date, string serial, string location, string installed_for, string filename)
        {
            Support su = new Support();
            string new_id = "";
            new_id = su.AddUpdateHelpdeskHardware(id, client_id, hostname ,model, deviceip, macaddress,purchased_from,purchased_date,serial,location,installed_for, filename);
            if (id != "")
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "Helpdesk Hardware was added " + " id:" + new_id);
            }
            else
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "New helpdesk Hardware was updated " + " id:" + new_id);
            }
            return new_id;
        }
        [WebMethod]
        public static string AddUpdateHelpdeskFileAccessSharing(string id, string client_id,string sharename,string ipaddress,string url,string usergroup, string username,string password, string location, string  purpose)
        {
            Support su = new Support();
            string new_id = "";
            new_id=su.AddUpdateHelpdeskFileAccessSharing(id, client_id, sharename,ipaddress,url,usergroup,username,password,location,purpose);
            if (id != "")
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "Helpdesk File Access Sharing was added " + " id:" + new_id);
            }
            else
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "New helpdesk File Access Sharing was updated " + " id:" + new_id);
            }
            return new_id;
        }
        [WebMethod]
        public static string addupdatehelpdeskwebsiteaccess(string id, string client_id, string name, string username, string password, string website, string url, string location, string defaultbrowser, string bookmarks)
        {
            Support su = new Support();
            string new_id = "";
            new_id = su.AddUpdateHelpdeskWebsiteAccess(id, client_id, name, username, password, website, url, location, defaultbrowser, bookmarks);
            if (id != "")
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "Helpdesk WebsiteAccess was added " + " id:" + new_id);
            }
            else
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "New helpdesk WebsiteAccess was updated " + " id:" + new_id);
            }
            return new_id;
        }

        [WebMethod]

        public static string addupdatehelpdeskcloudapplications(string id, string client_id, string application_name, string license_type, string url, string username, string password, string registered_to, string license_key, string location, string filename)
        {
            Support su = new Support();
            string new_id = "";
            new_id=su.addupdatehelpdeskcloudapplication(id, client_id, application_name, license_type, url, username, password, registered_to, license_key,location, filename);
            if (id != "")
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "Helpdesk cloud application was added " + " id:" + new_id);
            }
            else
            {
                su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "New helpdesk cloud application was updated " + " id:" + new_id);
            }
            return new_id;
        }
        [WebMethod ]

        public static string AddClient(string primary_location, string companyname, string contactname, string phone, string email, string address, string city, string state, string zipcode, string notes)
        {                               
            Support su = new Support();

            string client_id = su.AddUpdateClient(null, companyname, contactname, phone, email, address, city, state, zipcode, notes, primary_location);
            string location_id = su.AddUpdateLocation(null, client_id, companyname, contactname, phone, email, address, city, state, zipcode, notes, primary_location);
            
            su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "Client was added " + " id:" + client_id);
            return "{\"client_id\":\"" + client_id + "\",\"location_id\":\"" + location_id + "\"}";
        }

        [WebMethod]

        public static string UpdateClient(string client_id,string location_id,string primary_location, string companyname, string contactname, string phone, string email, string address, string city, string state, string zipcode, string notes)
        {
            Support su = new Support();

            client_id = su.AddUpdateClient(client_id, companyname, contactname, phone, email, address, city, state, zipcode, notes, primary_location);
            location_id = su.AddUpdateLocation(location_id , client_id, companyname, contactname, phone, email, address, city, state, zipcode, notes, primary_location);
            su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "Client was updated " + " id:" + client_id);
            
            return "{\"client_id\":\"" + client_id + "\",\"location_id\":\"" + location_id + "\"}";
        }

       

        [WebMethod]

        public static string UpdateClientStatus(string client_id, string active)
        {
            Support su = new Support();

            su.UpdateClientStatus(client_id, active);
            su.AddAudit(client_id, HttpContext.Current.User.Identity.Name, "Client status was changed for " + "id:" + client_id + " status:" + active);
            
            return "Comepleted";
        }

        
        [WebMethod ]
        public static string getManuals(string manual_type)
        {
            string str = "";
            Support su=new Support ();
            DataSet ds = su.getdata(manual_type, "getManuals");

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string filename = "";
                string manual_name = "";

                if (dr["manual_name"] != DBNull.Value) manual_name = dr["manual_name"].ToString();
                if (dr["filename"] != DBNull.Value) filename = dr["filename"].ToString();


                str += "<tr id='manual" + dr["id"].ToString() + "'><td><a href='manuals/"+ filename + "' target='_blank'>" + manual_name + "</a></td><td></td>";
                str += "<td><span style='cursor:pointer;' onclick=\"if (confirm('Are you sure?')) {deleteRecord('" + dr["id"].ToString() + "','manual')}\">delete</span></td></tr>";

            }

            return str;
        }
    }
}