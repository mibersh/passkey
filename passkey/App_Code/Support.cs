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

    }
}