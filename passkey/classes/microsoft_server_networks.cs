using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace passkey.classes
{
    public class microsoft_server_networks
    {
        public string id { get; set; }
        public string server_id { get; set; }
        public string nic { get; set; }
        public string nic_name { get; set; }
        public string nic_ip { get; set; }
        public string nic_subnet { get; set; }
        public string nic_gateway { get; set; }
        public string purpose { get; set; }
        public string nic_macaddress { get; set; }

    }
}