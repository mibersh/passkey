using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace passkey.classes
{
    public class ws
    {
        public string id { get; set; }
        public int client_id { get; set; }
        public string server_version { get; set; }
        public string server_version_other { get; set; }
        public string location { get; set; }
        public string operating_roles { get; set; }
        public string hostname { get; set; }
        public string ipaddress { get; set; }
        public string domain { get; set; }
        public string macaddress { get; set; }
        public string dns_entry { get; set; }
        public string username { get; set; }
        public string password { get; set; }
        public string license { get; set; }
        public string filename { get; set; }
        public string dhcp_server { get; set; }
        public string dhcp_primary_pool { get; set; }
        public string dhcp_primary_lease_time { get; set; }
        public string dhcp_additinal_pool { get; set; }
        public string dhcp_additinal_lease_time { get; set; }
        public string dhcp_reservations { get; set; }
        public string dns_server { get; set; }
        public string dns_primary_server_ip { get; set; }
        public string dns_secondary_server_ip { get; set; }
        public string dns_static_entry { get; set; }
        public string dhcp_filename { get; set; }
        public string install_date { get; set; }
        public string domain_controller { get; set; }
        public string domain_primary_controller { get; set; }
        public string domain_secondary_controller { get; set; }
        public string domain_name { get; set; }
        public string dfs { get; set; }
        public string dfs_primary_controller_ip { get; set; }
        public string dfs_secondary_controller_ip { get; set; }
        public string dfs_filename { get; set; }
        public string ad { get; set; }
        public string ad_primary_controller { get; set; }
        public string ad_secondary_controller { get; set; }
        public string iis_server { get; set; }
        public string web_application { get; set; }
        public string application_location { get; set; }
        public string asp_version { get; set; }
        public string iis_version { get; set; }
        public string certificate { get; set; }
        public string iis_backup { get; set; }
        public string additinal_web_applications { get; set; }
        public string raid { get; set; }
        public string raid_controller_model { get; set; }
        public string raid_controller_version { get; set; }
        public string raid_serial { get; set; }
        public string raid_function { get; set; }
        public string type_of_drives { get; set; }
        public string storage_size { get; set; }
        public string disk_size_amount { get; set; }
        public string valumes { get; set; }
        public string storage_notes { get; set; }
        public string cpu_model { get; set; }
        public string cpu_socet { get; set; }
        public string memory_information { get; set; }
        public string memory_per_module { get; set; }
        public string total_memory { get; set; }
        public string hardware_drivers { get; set; }

        public string nics { get; set; }
        public string users { get; set; }
    }
}