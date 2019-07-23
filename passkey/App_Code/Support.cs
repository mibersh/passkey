using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace passkey.App_Code
{
    public class Support
    {
        string cn = ConfigurationManager.ConnectionStrings["drensys"].ConnectionString.ToString();

        internal void InvalidLogin(string userid, string ip)
        {
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "InvalidLogin";



                cm.Parameters.AddWithValue("@userid", userid);
                cm.Parameters.AddWithValue("@ip", ip);

                cm.ExecuteNonQuery();
            }
        }

        internal void setInitedTFA(string userid)
        {
            using (SqlConnection con = new SqlConnection(cn))
            using (SqlCommand command = con.CreateCommand())
            {
                command.CommandText = "UPDATE users SET initedtfa = @tfa Where userid = @userid";

                command.Parameters.AddWithValue("@tfa", true);
                command.Parameters.AddWithValue("@userid", userid);

                con.Open();

                command.ExecuteNonQuery();
            }
        }

        internal void ValidLogin(string userid, string ip)
        {
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "ValidLogin";



                cm.Parameters.AddWithValue("@userid", userid);
                cm.Parameters.AddWithValue("@ip", ip);

                cm.ExecuteNonQuery();
            }
        }

        internal DataSet getClients()
        {
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "GetClients";

                SqlDataAdapter da = new SqlDataAdapter(cm);
                da.Fill(ds);
            }
            return ds;
        }

        internal DataSet getClient(string id)
        {
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.Parameters.AddWithValue("id", id);
                cm.CommandText = "GetClientNew";

                SqlDataAdapter da = new SqlDataAdapter(cm);
                da.Fill(ds);
            }
            return ds;
        }

        internal void deleteRecord(string id, string procedure)
        {
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = procedure;
                cm.Parameters.AddWithValue("@id", id);
                cm.ExecuteNonQuery();
            }

        }

        internal string AddUpdateClient(string id, string companyname, string contactname, string phone, string email, string address, string city, string state, string zipcode, string comments, string active)
        {
            string new_id = id;
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "AddUpdateClient";


                if (!string.IsNullOrEmpty(id))
                {
                    cm.Parameters.AddWithValue("@id", id);
                }
                else
                {
                    cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                }
                cm.Parameters.AddWithValue("@companyname", companyname);
                cm.Parameters.AddWithValue("@contactname", contactname);
                cm.Parameters.AddWithValue("@phone", phone);
                cm.Parameters.AddWithValue("@email", email);
                cm.Parameters.AddWithValue("@address", address);
                cm.Parameters.AddWithValue("@city", city);
                cm.Parameters.AddWithValue("@state", state);
                cm.Parameters.AddWithValue("@zipcode", zipcode);
                cm.Parameters.AddWithValue("@comments", comments);
                cm.Parameters.AddWithValue("@active", active);

                cm.ExecuteNonQuery();

                //if (!string.IsNullOrEmpty(id)) 
                new_id = cm.Parameters["@id"].Value.ToString();
            }
            return new_id;
        }

        internal string AddUpdateLocation(string id, string client_id, string location, string contactname, string phone, string email, string address, string city, string state, string zipcode, string notes, string primary_location)
        {
            string new_id = id;
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "AddUpdateLocation";


                if (!string.IsNullOrEmpty(id))
                {
                    cm.Parameters.AddWithValue("@id", id);
                }
                else
                {
                    cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                }

                cm.Parameters.AddWithValue("@client_id", client_id);
                cm.Parameters.AddWithValue("@location", location);
                cm.Parameters.AddWithValue("@contactname", contactname);
                cm.Parameters.AddWithValue("@phone", phone);
                cm.Parameters.AddWithValue("@email", email);
                cm.Parameters.AddWithValue("@address", address);
                cm.Parameters.AddWithValue("@city", city);
                cm.Parameters.AddWithValue("@state", state);
                cm.Parameters.AddWithValue("@zipcode", zipcode);
                cm.Parameters.AddWithValue("@notes", notes);
                cm.Parameters.AddWithValue("@primary_location", primary_location);


                cm.ExecuteNonQuery();

                if (!string.IsNullOrEmpty(id)) new_id = cm.Parameters["@id"].Value.ToString();
            }
            return new_id;
        }

        internal string AddUpdateClientEmergencyContact(string id, string client_id, string emergencycontact, string emergencyphone, string emergencyemail)
        {
            string new_id = id;
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "AddUpdateClientEmergencyContact";


                if (!string.IsNullOrEmpty(id))
                {
                    cm.Parameters.AddWithValue("@id", id);
                }
                else
                {
                    cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                }
                cm.Parameters.AddWithValue("@client_id", client_id);
                cm.Parameters.AddWithValue("@emergencycontact", emergencycontact);
                cm.Parameters.AddWithValue("@emergencyphone", emergencyphone);
                cm.Parameters.AddWithValue("@emergencyemail", emergencyemail);

                cm.ExecuteNonQuery();

                //if (!string.IsNullOrEmpty(id)) 
                new_id = cm.Parameters["@id"].Value.ToString();
            }
            return new_id;
        }

        internal string AddUpdateClientNetworks(string id, string client_id, string subnet, string ipaddress, string gateway, string purpose)
        {
            string new_id = id;
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "AddUpdateClientNetworks";


                if (!string.IsNullOrEmpty(id))
                {
                    cm.Parameters.AddWithValue("@id", id);
                }
                else
                {
                    cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                }
                cm.Parameters.AddWithValue("@client_id", client_id);
                cm.Parameters.AddWithValue("@subnet", subnet);
                cm.Parameters.AddWithValue("@ipaddress", ipaddress);
                cm.Parameters.AddWithValue("@gateway", gateway);
                cm.Parameters.AddWithValue("@purpose", purpose);

                cm.ExecuteNonQuery();

                //if (!string.IsNullOrEmpty(id)) 
                new_id = cm.Parameters["@id"].Value.ToString();
            }
            return new_id;
        }

        internal string AddUpdateUserManagement(string id, string client_id, string fname, string lname, string phone, string email, string username, string password, string position, string location, string notes, string status)
        {
            string new_id = id;
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "AddUpdateUserManagement";


                if (!string.IsNullOrEmpty(id))
                {
                    cm.Parameters.AddWithValue("@id", id);
                }
                else
                {
                    cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                }
                cm.Parameters.AddWithValue("@client_id", client_id);
                cm.Parameters.AddWithValue("@fname", fname);
                cm.Parameters.AddWithValue("@lname", lname);
                cm.Parameters.AddWithValue("@phone", phone);
                cm.Parameters.AddWithValue("@email", email);
                cm.Parameters.AddWithValue("@username", username);
                cm.Parameters.AddWithValue("@password", password);
                cm.Parameters.AddWithValue("@position", position);
                cm.Parameters.AddWithValue("@location", location);
                cm.Parameters.AddWithValue("@notes", notes);
                cm.Parameters.AddWithValue("@status", status);

                cm.ExecuteNonQuery();

                //if (!string.IsNullOrEmpty(id)) 
                new_id = cm.Parameters["@id"].Value.ToString();
            }
            return new_id;
        }

        internal string AddUpdateHelpdeskEmailAddresses(string id, string client_id, string fname, string lname, string phone, string email, string username, string password, string in_mail_server, string in_mail_server_port, string in_mail_server_password, string out_mail_server, string out_mail_server_port, string out_mail_server_password, string signature, string status)
        {
            string new_id = id;
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "AddUpdateHelpdeskEmailAddresses";


                if (!string.IsNullOrEmpty(id))
                {
                    cm.Parameters.AddWithValue("@id", id);
                }
                else
                {
                    cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                }
                cm.Parameters.AddWithValue("@client_id", client_id);
                cm.Parameters.AddWithValue("@fname", fname);
                cm.Parameters.AddWithValue("@lname", lname);
                cm.Parameters.AddWithValue("@phone", phone);
                cm.Parameters.AddWithValue("@email", email);
                cm.Parameters.AddWithValue("@username", username);
                cm.Parameters.AddWithValue("@password", password);
                cm.Parameters.AddWithValue("@in_mail_server", in_mail_server);
                cm.Parameters.AddWithValue("@in_mail_server_port", in_mail_server_port);
                cm.Parameters.AddWithValue("@in_mail_server_password", in_mail_server_password);
                cm.Parameters.AddWithValue("@out_mail_server", out_mail_server);
                cm.Parameters.AddWithValue("@out_mail_server_port", out_mail_server_port);
                cm.Parameters.AddWithValue("@out_mail_server_password", out_mail_server_password);
                cm.Parameters.AddWithValue("@signature", signature);
                cm.Parameters.AddWithValue("@status", status);

                cm.ExecuteNonQuery();

                //if (!string.IsNullOrEmpty(id)) 
                new_id = cm.Parameters["@id"].Value.ToString();
            }
            return new_id;
        }

        internal string AddUpdateHelpdeskSoftwareLicenses(string id, string client_id, string software_name, string url, string license_number, string software_function, string software_version, string license_type, string username, string password, string installed_device, string installed_date, string notes, string filename)
        {
            string new_id = id;
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "AddUpdateHelpdeskSoftwareLicenses";


                if (!string.IsNullOrEmpty(id))
                {
                    cm.Parameters.AddWithValue("@id", id);
                }
                else
                {
                    cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                }
                cm.Parameters.AddWithValue("@client_id", client_id);
                cm.Parameters.AddWithValue("@software_name", software_name);
                cm.Parameters.AddWithValue("@url", url);
                cm.Parameters.AddWithValue("@license_number", license_number);
                cm.Parameters.AddWithValue("@software_function", software_function);
                cm.Parameters.AddWithValue("@software_version", software_version);
                cm.Parameters.AddWithValue("@license_type", license_type);
                cm.Parameters.AddWithValue("@username", username);
                cm.Parameters.AddWithValue("@password", password);
                cm.Parameters.AddWithValue("@installed_device", installed_device);
                cm.Parameters.AddWithValue("@installed_date", installed_date);
                cm.Parameters.AddWithValue("@notes", notes);
                if (!string.IsNullOrEmpty (filename))cm.Parameters.AddWithValue("@filename", filename);

                cm.ExecuteNonQuery();

                //if (!string.IsNullOrEmpty(id)) 
                new_id = cm.Parameters["@id"].Value.ToString();
            }
            return new_id;

        }

        internal string AddUpdateHelpdeskHardware(string id, string client_id, string hostname, string model, string deviceip, string macaddress, string purchased_from, string purchased_date, string serial, string location, string installed_for, string filename)
        {
            string new_id = id;
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "AddUpdateHelpdeskHardware";


                if (!string.IsNullOrEmpty(id))
                {
                    cm.Parameters.AddWithValue("@id", id);
                }
                else
                {
                    cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                }
                cm.Parameters.AddWithValue("@client_id", client_id);
                cm.Parameters.AddWithValue("@hostname", hostname);
                cm.Parameters.AddWithValue("@model", model);
                cm.Parameters.AddWithValue("@deviceip", deviceip);
                cm.Parameters.AddWithValue("@macaddress", macaddress);
                cm.Parameters.AddWithValue("@purchased_from", purchased_from);
                cm.Parameters.AddWithValue("@purchased_date", purchased_date);
                cm.Parameters.AddWithValue("@serial", serial);
                cm.Parameters.AddWithValue("@location", location);
                cm.Parameters.AddWithValue("@installed_for", installed_for);
                if (!string.IsNullOrEmpty(filename)) cm.Parameters.AddWithValue("@filename", filename);

                cm.ExecuteNonQuery();

                //if (!string.IsNullOrEmpty(id)) 
                new_id = cm.Parameters["@id"].Value.ToString();
            }
            return new_id;

        }



        internal string AddUpdateHelpdeskFileAccessSharing(string id, string client_id, string sharename, string ipaddress, string url, string usergroup, string username, string password, string location, string purpose)
        {
            string new_id = id;
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "AddUpdateHelpdeskFileAccessSharing";


                if (!string.IsNullOrEmpty(id))
                {
                    cm.Parameters.AddWithValue("@id", id);
                }
                else
                {
                    cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                }
                cm.Parameters.AddWithValue("@client_id", client_id);
                cm.Parameters.AddWithValue("@sharename", sharename);
                cm.Parameters.AddWithValue("@ipaddress", ipaddress);
                cm.Parameters.AddWithValue("@url", url);
                cm.Parameters.AddWithValue("@usergroup", usergroup);
                cm.Parameters.AddWithValue("@username", username);
                cm.Parameters.AddWithValue("@password", password);
                cm.Parameters.AddWithValue("@location", location);
                cm.Parameters.AddWithValue("@purpose", purpose);

                cm.ExecuteNonQuery();

                //if (!string.IsNullOrEmpty(id)) 
                new_id = cm.Parameters["@id"].Value.ToString();
            }
            return new_id;
        }

        internal string AddUpdateHelpdeskWebsiteAccess(string id, string client_id, string name, string username, string password, string website, string url, string location, string defaultbrowser, string bookmarks)
        {
            string new_id = id;
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "AddUpdateHelpdeskWebsiteAccess";


                if (!string.IsNullOrEmpty(id))
                {
                    cm.Parameters.AddWithValue("@id", id);
                }
                else
                {
                    cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                }
                cm.Parameters.AddWithValue("@client_id", client_id);
                cm.Parameters.AddWithValue("@name", name);
                cm.Parameters.AddWithValue("@username", username);
                cm.Parameters.AddWithValue("@password", password);
                cm.Parameters.AddWithValue("@website", website);
                cm.Parameters.AddWithValue("@url", url);
                cm.Parameters.AddWithValue("@location", location);
                cm.Parameters.AddWithValue("@defaultbrowser", defaultbrowser);
                if (!string.IsNullOrEmpty(bookmarks)) cm.Parameters.AddWithValue("@bookmarks", bookmarks);

                cm.ExecuteNonQuery();

                //if (!string.IsNullOrEmpty(id)) 
                new_id = cm.Parameters["@id"].Value.ToString();
            }
            return new_id;
        }

        internal string addupdatehelpdeskcloudapplication(string id, string client_id, string application_name, string license_type, string url, string username, string password, string registered_to, string license_key, string location, string filename)
        {
            string new_id = id;
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "addupdatehelpdeskcloudapplication";


                if (!string.IsNullOrEmpty(id))
                {
                    cm.Parameters.AddWithValue("@id", id);
                }
                else
                {
                    cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                }
                cm.Parameters.AddWithValue("@client_id", client_id);
                cm.Parameters.AddWithValue("@application_name", application_name);
                cm.Parameters.AddWithValue("@license_type", license_type);
                cm.Parameters.AddWithValue("@url", url);
                cm.Parameters.AddWithValue("@username", username);
                cm.Parameters.AddWithValue("@password", password);
                cm.Parameters.AddWithValue("@registered_to", registered_to);
                cm.Parameters.AddWithValue("@location", location);
                cm.Parameters.AddWithValue("@license_key", license_key);
                if (!string.IsNullOrEmpty(filename)) cm.Parameters.AddWithValue("@filename", filename);

                cm.ExecuteNonQuery();

                //if (!string.IsNullOrEmpty(id)) 
                new_id = cm.Parameters["@id"].Value.ToString();
            }
            return new_id;
        }


        //internal string AddUpdateClient(string id, string companyname, string contactname, string phone, string email, string address, string city, string state, string zipcode, string comments, string active)
        //{
        //    string new_id = id;
        //    using (SqlConnection con = new SqlConnection(cn))
        //    {
        //        SqlCommand cm = new SqlCommand();

        //        con.Open();
        //        cm.Connection = con;
        //        cm.CommandType = CommandType.StoredProcedure;
        //        cm.CommandText = "AddUpdateClient";


        //        if (!string.IsNullOrEmpty(id))
        //        {
        //            cm.Parameters.AddWithValue("@id", id);
        //        }
        //        else
        //        {
        //            cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
        //        }
        //        cm.Parameters.AddWithValue("@companyname", companyname);
        //        cm.Parameters.AddWithValue("@contactname", contactname);
        //        cm.Parameters.AddWithValue("@phone", phone);
        //        cm.Parameters.AddWithValue("@email", email);
        //        cm.Parameters.AddWithValue("@address", address);
        //        cm.Parameters.AddWithValue("@city", city);
        //        cm.Parameters.AddWithValue("@state", state);
        //        cm.Parameters.AddWithValue("@zipcode", zipcode);
        //        cm.Parameters.AddWithValue("@comments", comments);
        //        cm.Parameters.AddWithValue("@active", active);

        //        cm.ExecuteNonQuery();

        //        //if (!string.IsNullOrEmpty(id)) 
        //        new_id = cm.Parameters["@id"].Value.ToString();
        //    }
        //    return new_id;
        //}




        internal DataSet getdata(string id, string f)
        {
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.Parameters.AddWithValue("@client_id", id);
                cm.CommandText = f;

                SqlDataAdapter da = new SqlDataAdapter(cm);
                da.Fill(ds);
            }
            return ds;
        }

        internal string AddUpdateFile(string client_id, string id, string filename)
        {
            string new_id = id;
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "AddUpdateClientFiles";


                if (!string.IsNullOrEmpty(id))
                {
                    cm.Parameters.AddWithValue("@id", id);
                }
                else
                {
                    cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                }
                cm.Parameters.AddWithValue("@client_id", client_id);

                cm.Parameters.AddWithValue("@filename", filename);

                cm.ExecuteNonQuery();

                //if (!string.IsNullOrEmpty(id)) 
                new_id = cm.Parameters["@id"].Value.ToString();
            }
            return new_id;
        }

        internal string dstojson(DataSet ds)
        {
            DataTable dt = ds.Tables[0];
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
                
            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            return serializer.Serialize(rows);
        }
        internal DataSet gethelpdeskcounts(string  client_id)
        {
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.Parameters.AddWithValue("@client_id", client_id);
                cm.CommandText = "getHelpdeskCounts";

                SqlDataAdapter da = new SqlDataAdapter(cm);
                da.Fill(ds);
            }
            return ds;
        }

        internal void UpdateClientStatus(string client_id, string active)
        {
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "UpdateClientStatus";

                cm.Parameters.AddWithValue("@client_id", client_id);
                cm.Parameters.AddWithValue("@active", active);

                cm.ExecuteNonQuery();

            }
        }

        internal void AddAudit(string client_id, string userid, string changes)
        {
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "AddAudit";



                cm.Parameters.AddWithValue("@client_id", client_id);
                cm.Parameters.AddWithValue("@userid", userid);
                cm.Parameters.AddWithValue("@changedate", DateTime.Now);
                cm.Parameters.AddWithValue("@changes", changes);

                cm.ExecuteNonQuery();
            }

        }

        internal DataSet  getmicrosoft_servers(string id)
        {
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.Parameters.AddWithValue("@client_id", id);
                cm.CommandText = "get_microsoft_servers";

                SqlDataAdapter da = new SqlDataAdapter(cm);
                da.Fill(ds);
            }
            return ds;
        }

        internal string AddUpdateWindowsServer(classes.ws win)
        {
            string new_id = win.id;
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "addupdate_microsoft_servers";


                if (!string.IsNullOrEmpty(win.id.ToString ()))
                {
                    cm.Parameters.AddWithValue("@id", win.id);
                }
                else
                {
                    cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                }
                //cm.Parameters.AddWithValue("@client_id", win.client_id);
                if (!string .IsNullOrEmpty(win.server_version) )cm.Parameters.AddWithValue("@server_version", win.server_version);


                cm.Parameters.AddWithValue("@client_id",win.client_id.ToString () );
                if (!string .IsNullOrEmpty(win.server_version_other) )cm.Parameters.AddWithValue("@server_version_other",win.server_version_other);
                if (!string .IsNullOrEmpty(win.location) )cm.Parameters.AddWithValue("@location",win.location);
                if (!string .IsNullOrEmpty(win.operating_roles) )cm.Parameters.AddWithValue("@operating_roles",win.operating_roles );
                if (!string .IsNullOrEmpty(win.hostname) )cm.Parameters.AddWithValue("@hostname",win.hostname );
                if (!string .IsNullOrEmpty(win.ipaddress) )cm.Parameters.AddWithValue("@ipaddress",win.ipaddress );
                if (!string .IsNullOrEmpty(win.domain) )cm.Parameters.AddWithValue("@domain",win.domain );
                if (!string .IsNullOrEmpty(win.macaddress ) )cm.Parameters.AddWithValue("@macaddress",win.macaddress );
                if (!string .IsNullOrEmpty(win.dns_entry ) )cm.Parameters.AddWithValue("@dns_entry",win.dns_entry );
                if (!string.IsNullOrEmpty(win.username)) cm.Parameters.AddWithValue("@username", win.username);
                if (!string .IsNullOrEmpty(win.password ) )cm.Parameters.AddWithValue("@password",win.password );
                if (!string .IsNullOrEmpty(win.license ) )cm.Parameters.AddWithValue("@license",win.license );
                if (!string .IsNullOrEmpty(win.filename ) )cm.Parameters.AddWithValue("@filename",win.filename );
                if (!string .IsNullOrEmpty(win.dhcp_server.ToString () ) )cm.Parameters.AddWithValue("@dhcp_server",win.dhcp_server );
                if (!string .IsNullOrEmpty(win.dhcp_primary_pool ) )cm.Parameters.AddWithValue("@dhcp_primary_pool",win.dhcp_primary_pool );
                if (!string .IsNullOrEmpty(win.dhcp_additinal_lease_time ) )cm.Parameters.AddWithValue("@dhcp_primary_lease_time",win.dhcp_additinal_lease_time );
                if (!string .IsNullOrEmpty(win.dhcp_additinal_pool ) )cm.Parameters.AddWithValue("@dhcp_additinal_pool",win.dhcp_additinal_pool );
                if (!string .IsNullOrEmpty(win.dhcp_additinal_lease_time ) )cm.Parameters.AddWithValue("@dhcp_additinal_lease_time",win.dhcp_additinal_lease_time );
                if (!string .IsNullOrEmpty(win.dhcp_reservations ) )cm.Parameters.AddWithValue("@dhcp_reservations",win.dhcp_reservations );
                if (!string .IsNullOrEmpty(win.dns_server.ToString ()) )cm.Parameters.AddWithValue("@dns_server",win.dns_server );
                if (!string .IsNullOrEmpty(win.dns_primary_server_ip ) )cm.Parameters.AddWithValue("@dns_primary_server_ip", win.dns_primary_server_ip );
                if (!string .IsNullOrEmpty(win.dns_secondary_server_ip ) )cm.Parameters.AddWithValue("@dns_secondary_server_ip", win.dns_secondary_server_ip );
                if (!string .IsNullOrEmpty(win.dns_static_entry ) )cm.Parameters.AddWithValue("@dns_static_entry",win.dns_static_entry );
                if (!string .IsNullOrEmpty(win.dhcp_filename ) )cm.Parameters.AddWithValue("@dhcp_filename",win.dhcp_filename );
                if (!string .IsNullOrEmpty(win.install_date  ) )cm.Parameters.AddWithValue("@install_date",win.install_date );
                if (!string .IsNullOrEmpty(win.domain_controller .ToString () ) )cm.Parameters.AddWithValue("@domain_controller",win.domain_controller ); 
                if (!string .IsNullOrEmpty(win.domain_primary_controller  ) )cm.Parameters.AddWithValue("@domain_primary_controller",win.domain_primary_controller );
                if (!string .IsNullOrEmpty(win.domain_secondary_controller  ) )cm.Parameters.AddWithValue("@domain_secondary_controller", win.domain_secondary_controller );
                if (!string .IsNullOrEmpty(win.domain_name  ) )cm.Parameters.AddWithValue("@domain_name",win.domain_name );
                if (!string .IsNullOrEmpty(win.dfs.ToString () ) )cm.Parameters.AddWithValue("@dfs",win.dfs);
                if (!string .IsNullOrEmpty(win.dfs_primary_controller_ip  ) )cm.Parameters.AddWithValue("@dfs_primary_controller_ip",win.dfs_primary_controller_ip );
                if (!string .IsNullOrEmpty(win.dfs_secondary_controller_ip  ) )cm.Parameters.AddWithValue("@dfs_secondary_controller_ip", win.dfs_secondary_controller_ip );
                if (!string .IsNullOrEmpty(win.dfs_filename  ) )cm.Parameters.AddWithValue("@dfs_filename",win.dfs_filename );
                if (!string .IsNullOrEmpty(win.ad.ToString () ) )cm.Parameters.AddWithValue("@ad",win.ad); 
                if (!string .IsNullOrEmpty(win.ad_primary_controller  ) )cm.Parameters.AddWithValue("@ad_primary_controller",win.ad_primary_controller );
                if (!string .IsNullOrEmpty(win.ad_secondary_controller  ) )cm.Parameters.AddWithValue("ad_secondary_controller",win.ad_secondary_controller );
                if (!string .IsNullOrEmpty(win.iis_server.ToString () ) )cm.Parameters.AddWithValue("@iis_server", win.iis_server );
                if (!string .IsNullOrEmpty(win.web_application  ) )cm.Parameters.AddWithValue("@web_application" ,win.web_application );
                if (!string .IsNullOrEmpty(win.application_location  ) )cm.Parameters.AddWithValue("@application_location",win.application_location );
                if (!string .IsNullOrEmpty(win.asp_version  ) )cm.Parameters.AddWithValue("@asp_version",win.asp_version );
                if (!string .IsNullOrEmpty(win.iis_version  ) )cm.Parameters.AddWithValue("@iis_version",win.iis_version );
                if (!string .IsNullOrEmpty(win.certificate  ) )cm.Parameters.AddWithValue("@certificate", win.certificate );
                if (!string .IsNullOrEmpty(win.iis_backup  ) )cm.Parameters.AddWithValue("@iis_backup",win.iis_backup );
                if (!string .IsNullOrEmpty(win.additinal_web_applications  ) )cm.Parameters.AddWithValue("additinal_web_applications",win.additinal_web_applications );
                if (!string .IsNullOrEmpty(win.raid.ToString () ) )cm.Parameters.AddWithValue("@raid",win.raid );
                if (!string .IsNullOrEmpty(win.raid_controller_model  ) )cm.Parameters.AddWithValue("@raid_controller_model", win.raid_controller_model );
                if (!string .IsNullOrEmpty(win.raid_controller_version  ) )cm.Parameters.AddWithValue("@raid_controller_version", win.raid_controller_version );
                if (!string .IsNullOrEmpty(win.raid_serial  ) )cm.Parameters.AddWithValue("@raid_serial",win.raid_serial );
                if (!string .IsNullOrEmpty(win.raid_function  ) )cm.Parameters.AddWithValue("@raid_function", win.raid_function );
                if (!string .IsNullOrEmpty(win.type_of_drives  ) )cm.Parameters.AddWithValue("@type_of_drives",win.type_of_drives );
                if (!string .IsNullOrEmpty(win.storage_size) )cm.Parameters.AddWithValue("@storage_size",win.storage_size );
                if (!string .IsNullOrEmpty(win.disk_size_amount  ) )cm.Parameters.AddWithValue("@disk_size_amount",win.disk_size_amount );
                if (!string .IsNullOrEmpty(win.valumes  ) )cm.Parameters.AddWithValue("@valumes",win.valumes );
                if (!string .IsNullOrEmpty(win.storage_notes ) )cm.Parameters.AddWithValue("@storage_notes",win.storage_notes );
                if (!string .IsNullOrEmpty(win.cpu_model  ) )cm.Parameters.AddWithValue("@cpu_model",win.cpu_model );
                if (!string .IsNullOrEmpty(win.cpu_socet  ) )cm.Parameters.AddWithValue("@cpu_socet", win.cpu_socet );
                if (!string .IsNullOrEmpty(win.memory_information  ) )cm.Parameters.AddWithValue("@memory_information", win.memory_information );
                if (!string .IsNullOrEmpty(win.memory_per_module  ) )cm.Parameters.AddWithValue("@memory_per_module", win.memory_per_module );
                if (!string .IsNullOrEmpty(win.total_memory  ) )cm.Parameters.AddWithValue("@total_memory",win.total_memory );
                if (!string.IsNullOrEmpty(win.hardware_drivers)) cm.Parameters.AddWithValue("@hardware_drivers", win.hardware_drivers);

                //cm.Parameters.AddWithValue("@server_version_other", win.server_version_other);

                

                cm.ExecuteNonQuery();

                //if (!string.IsNullOrEmpty(id)) 
                new_id = cm.Parameters["@id"].Value.ToString();
            }
            return new_id;
        }

        internal void AddUpdateMSNetworks(classes.microsoft_server_networks msn)
        {
            
            string new_id = msn.id;
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "addupdate_microsoft_server_networks";



                if (!string.IsNullOrEmpty(msn.id.ToString()))
                {
                    cm.Parameters.AddWithValue("@id", msn.id);
                }
                else
                {
                    cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                }
                //cm.Parameters.AddWithValue("@client_id", win.client_id);
                cm.Parameters.AddWithValue("@server_id", msn.server_id);
                if (!string.IsNullOrEmpty(msn.nic)) cm.Parameters.AddWithValue("@nic", msn.nic);
                if (!string.IsNullOrEmpty(msn.nic_name)) cm.Parameters.AddWithValue("@nic_name", msn.nic_name);
                if (!string.IsNullOrEmpty(msn.nic_ip)) cm.Parameters.AddWithValue("@nic_ip", msn.nic_ip);
                if (!string.IsNullOrEmpty(msn.nic_subnet)) cm.Parameters.AddWithValue("@nic_subnet", msn.nic_subnet );
                if (!string.IsNullOrEmpty(msn.nic_gateway)) cm.Parameters.AddWithValue("@nic_gateway", msn.nic_gateway );
                if (!string.IsNullOrEmpty(msn.purpose )) cm.Parameters.AddWithValue("@purpose", msn.purpose );
                if (!string.IsNullOrEmpty(msn.nic_macaddress)) cm.Parameters.AddWithValue("@nic_macaddress", msn.nic_macaddress);
                cm.ExecuteNonQuery();

                //if (!string.IsNullOrEmpty(id)) 
                new_id = cm.Parameters["@id"].Value.ToString();
            }   
        }

        internal void AddUpdateMSUsers(classes.microsoft_server_users msu)
        {
            string new_id = msu.id;
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "addupdate_microsoft_server_users";



                if (!string.IsNullOrEmpty(msu.id.ToString()))
                {
                    cm.Parameters.AddWithValue("@id", msu.id);
                }
                else
                {
                    cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                }
                //cm.Parameters.AddWithValue("@client_id", win.client_id);
                cm.Parameters.AddWithValue("@server_id", msu.server_id);
                if (!string.IsNullOrEmpty(msu.username )) cm.Parameters.AddWithValue("@username", msu.username);
                if (!string.IsNullOrEmpty(msu.password )) cm.Parameters.AddWithValue("@password", msu.password );
                if (!string.IsNullOrEmpty(msu.permissions)) cm.Parameters.AddWithValue("@permissions", msu.permissions);
                if (!string.IsNullOrEmpty(msu.purpose )) cm.Parameters.AddWithValue("@purpose", msu.purpose );
                
                cm.ExecuteNonQuery();

                //if (!string.IsNullOrEmpty(id)) 
                new_id = cm.Parameters["@id"].Value.ToString();
            }   
        }

        internal void AddUpdateWSFile(string server_id, string field_name, string filename)
        {
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "AddUpdateWSFile";



                
                //cm.Parameters.AddWithValue("@client_id", win.client_id);
                cm.Parameters.AddWithValue("@server_id", server_id);
                cm.Parameters.AddWithValue("@field_name", field_name);
                cm.Parameters.AddWithValue("@filename", filename);
                
                cm.ExecuteNonQuery();

                //if (!string.IsNullOrEmpty(id)) 
               
            }   
        }

        internal string AddUpdateManual(string manual_name, string manual_type,string file_name)
        {
            string new_id = "";
            using (SqlConnection con = new SqlConnection(cn))
            {
                SqlCommand cm = new SqlCommand();

                con.Open();
                cm.Connection = con;
                cm.CommandType = CommandType.StoredProcedure;
                cm.CommandText = "AddUpdateManual";
                cm.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.InputOutput;
                


                //cm.Parameters.AddWithValue("@client_id", win.client_id);
                cm.Parameters.AddWithValue("@manual_name", manual_name);
                cm.Parameters.AddWithValue("@manual_type", manual_type);
                cm.Parameters.AddWithValue("@filename", file_name);

                cm.ExecuteNonQuery();

                new_id = cm.Parameters["@id"].Value.ToString();

            }
            return new_id;
        }
    }
}