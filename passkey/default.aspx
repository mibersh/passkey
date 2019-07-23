<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="passkey._default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .modal-lg {
            max-width: 80% !important;
        }
    </style>
    <script>

        var oldNic = {
            id: '',
            name: '',
            ip:'',
            subnet: '',
            gateway: '',
            macaddress: '',
            purpose: '',
            status:''
        };

        var oldUser = {
            id: '',
            username:'',
            password:'',
            permissions: '',
            purpose:''
        }

        $(document).ready(function () {
            
            getclients();
           
        });
        
        function getclients() {
            hideall();
            var r = ajaxhelper('','getclients');
            $('#clients-table').DataTable().clear().destroy();
            $('#clients-data').html(r);
            $('#clientsbox').show();
            $('#clients-table').DataTable({
                dom: 'Bfrtip',
                retrieve: true
            });
            
            //$('#clientsbox').show();
        }

        function getclient(id) {
            if (id == '') {
                return true;
            }
            $('#client_id').val(id);
            var client = ajaxhelper('{"id":' + id + '}', 'getclient');

            $('#sidebar-companyname').html(client[0])
            $('#client-locations').html(client[1]);
            $('#client-emergency_contacts').html(client[4]);
            $('#client-networks').html(client[2]);
            $('#client-files').html(client[3]);

            var active = client[5];

            if (active == "1") {
                $('#client_status').prop('checked', true);
            }
            else
            {
                $('#client_status').prop('checked', false);
            }
            $('#client_status').show();
            hideall();
            $('#client-info').show();
            $('#helpdeskhardware_location option').remove();
            $('#usermanagement_location option').remove();
            $('#helpdeskfileaccesssharing_location option').remove();
            
            //load location 
            var locations = getclientlocations(id)

            

            $('#helpdeskhardware_location').append(locations);
            $('#usermanagement_location').append(locations);
            $('#helpdeskfileaccesssharing_location').append(locations);

            getHelpdeskCounts(id);
            
        }
        function getclientlocations(id) {
            return  ajaxhelper('{"id":' + id + ',"f":"getclientlocations"}', 'getdata');
        }
        function getdata(id, f) {

            if (id == '') {
                return true;
            }
            hideall();
            var data = ajaxhelper('{"id":' + id + ',"f":"get' + f + '"}', 'getdata');

            $('#' + f + '-table').DataTable().clear().destroy();
            $('#' + f + '-data').html(data);
            $('#' + f + '-box').show();
            $('#' + f + '-table').DataTable({
                dom: 'Bfrtip',
                retrieve: true,
                scrollX: true

            });
            getCounter(f);

        }

        
        //delete functions goes here
        function deleteRecord(id,procedure) {
            ajaxhelper('{"id":' + id + ',"client_id":"'+ $('#client_id').val()+'","procedure":"delete' + procedure + '"}', 'deleteRecord');
            $('#' + procedure + id).remove();
            getCounter(procedure);
            
        }
        //end delete functions

        //hide all panels
        function hideall() {
            $('.databox').hide();
        }


        //function to edit records

        function editLocation(id, primary_location, active) {

            $('#<%=location_id.ClientID %>').val(id);
            $('#<%=primary_location.ClientID %>').val(primary_location);
            $('#<%=companyname.ClientID %>').val($('#location' + id).find("td:eq(0)").text());
            $('#<%=contactname.ClientID %>').val($('#location' + id).find("td:eq(1)").text());
            $('#<%=phone.ClientID %>').val($('#location' + id).find("td:eq(2)").text());
            $('#<%=email.ClientID %>').val($('#location' + id).find("td:eq(3)").text());
            $('#<%=address.ClientID %>').val($('#location' + id).find("td:eq(4)").text());
            $('#<%=city.ClientID %>').val($('#location' + id).find("td:eq(5)").text());
            $('#<%=state.ClientID %>').val($('#location' + id).find("td:eq(6)").text());
            $('#<%=zipcode.ClientID %>').val($('#location' + id).find("td:eq(7)").text());
            $('#<%=comments.ClientID %>').val($('#location' + id).find("td:eq(8)").text());

            $('#locationModal').modal('show');
        }

        function editemergencycontacts(id) {

            if (id == "") {
                $('#emergencycontacts_id').val('');
                $('#emergencycontact').val('');
                $('#emergencyphone').val('');
                $('#emergencyemail').val('');
            }
            else
            {
                $('#emergencycontacts_id').val(id);
                $('#emergencycontact').val($('#emergencycontacts' + id).find("td:eq(0)").text());
                $('#emergencyphone').val($('#emergencycontacts' + id).find("td:eq(1)").text());
                $('#emergencyemail').val($('#emergencycontacts' + id).find("td:eq(2)").text());
            }
            $('#emergencycontactsModal').modal('show');
        }
        function editclientnetworks(id) {
            if (id == "") {
                $('#clientnetworks_id').val('');
                $('#clientnetworks_subnet').val('');
                $('#clientnetworks_ipaddress').val('');
                $('#clientnetworks_gateway').val('');
                $('#clientnetworks_purpose').val('');
            }
            else
            {
                $('#clientnetworks_id').val(id);
                $('#clientnetworks_subnet').val($('#clientnetworks' + id).find("td:eq(0)").text());
                $('#clientnetworks_ipaddress').val($('#clientnetworks' + id).find("td:eq(1)").text());
                $('#clientnetworks_gateway').val($('#clientnetworks' + id).find("td:eq(2)").text());
                $('#clientnetworks_purpose').val($('#clientnetworks' + id).find("td:eq(3)").text());
            }
            $('#clientnetworksModal').modal('show');
        }

        function editusermanagement(id) {
            if (id == "") {
                $('#usermanagement_id').val('');
                $('#usermanagement_fname').val('');
                $('#usermanagement_lname').val('');
                $('#usermanagement_phone').val('');
                $('#usermanagement_email').val('');
                $('#usermanagement_username').val('');
                $('#usermanagement_password').val('');
                $('#usermanagement_position').val('');
                $('#usermanagement_location').val('');
                $('#usermanagement_notes').val('');
            }
            else {
                $('#usermanagement_id').val(id);
                $('#usermanagement_fname').val($('#usermanagement' + id).find("td:eq(0)").text());
                $('#usermanagement_lname').val($('#usermanagement' + id).find("td:eq(1)").text());
                $('#usermanagement_phone').val($('#usermanagement' + id).find("td:eq(2)").text());
                $('#usermanagement_email').val($('#usermanagement' + id).find("td:eq(3)").text());
                $('#usermanagement_usename').val($('#usermanagement' + id).find("td:eq(4)").text());
                $('#usermanagement_password').val($('#usermanagement' + id).find("td:eq(5)").text());
                $('#usermanagement_position').val($('#usermanagement' + id).find("td:eq(6)").text());
                $('#usermanagement_location').val($('#usermanagement' + id).find("td:eq(7)").text());
                $('#usermanagement_notes').val($('#usermanagement' + id).find("td:eq(8)").text());

                var status = $('#usermanagement' + id).find("td:eq(9)").text()

                if (status == "Y") {
                    $("#usermanagement_status").prop("checked", true);
                }
                else
                {
                    $("#usermanagement_status").prop("checked", false);
                }

            }
            $('#usermanagementModal').modal('show');
        }
        function edithelpdeskemailaccounts(id) {
            if (id == "") {
                $('#helpdeskemailaccounts_id').val('');
                $('#helpdeskemailaccounts_fname').val('');
                $('#helpdeskemailaccounts_lname').val('');
                $('#helpdeskemailaccounts_phone').val('');
                $('#helpdeskemailaccounts_email').val('');
                $('#helpdeskemailaccounts_username').val('');
                $('#helpdeskemailaccounts_password').val('');
                $('#helpdeskemailaccounts_in_mail_server').val('');
                $('#helpdeskemailaccounts_in_mail_server_port').val('');
                $('#helpdeskemailaccounts_in_mail_server_password').val('');
                $('#helpdeskemailaccounts_out_mail_server').val('');
                $('#helpdeskemailaccounts_out_mail_server_port').val('');
                $('#helpdeskemailaccounts_out_mail_server_password').val('');
                $('#helpdeskemailaccounts_signature').val('');

            }
            else {
                $('#helpdeskemailaccounts_id').val(id);
                $('#helpdeskemailaccounts_fname').val($('#helpdeskemailaccounts' + id).find("td:eq(0)").text());
                $('#helpdeskemailaccounts_lname').val($('#helpdeskemailaccounts' + id).find("td:eq(1)").text());
                $('#helpdeskemailaccounts_phone').val($('#helpdeskemailaccounts' + id).find("td:eq(2)").text());
                $('#helpdeskemailaccounts_email').val($('#helpdeskemailaccounts' + id).find("td:eq(3)").text());
                $('#helpdeskemailaccounts_username').val($('#helpdeskemailaccounts' + id).find("td:eq(4)").text());
                $('#helpdeskemailaccounts_password').val($('#helpdeskemailaccounts' + id).find("td:eq(5)").text());
                $('#helpdeskemailaccounts_in_mail_server').val($('#helpdeskemailaccounts' + id).find("td:eq(6)").text());
                $('#helpdeskemailaccounts_in_mail_server_port').val($('#helpdeskemailaccounts' + id).find("td:eq(7)").text());
                $('#helpdeskemailaccounts_in_mail_server_password').val($('#helpdeskemailaccounts' + id).find("td:eq(8)").text());
                $('#helpdeskemailaccounts_out_mail_server').val($('#helpdeskemailaccounts' + id).find("td:eq(9)").text());
                $('#helpdeskemailaccounts_out_mail_server_port').val($('#helpdeskemailaccounts' + id).find("td:eq(10)").text());
                $('#helpdeskemailaccounts_out_mail_server_password').val($('#helpdeskemailaccounts' + id).find("td:eq(11)").text());
                $('#helpdeskemailaccounts_signature').val('');


                var status = $('#helpdeskemailaccounts' + id).find("td:eq(9)").text();
                if (status == "Y") {
                    $("#helpdeskemailaccounts_status").prop("checked", true);
                }
                else {
                    $("#helpdeskemailaccounts_status").prop("checked", false);
                }
              

            }
            passwordToDefaultState();
            $('#helpdeskemailaccountsModal').modal('show');
        }
        function edithelpdesksoftwarelicenses(id) {
            if (id == "") {
                $('#helpdesksoftwarelicenses_id').val('');
                $('#helpdesksoftwarelicenses_software_name').val('');
                $('#helpdesksoftwarelicenses_url').val('');
                $('#helpdesksoftwarelicenses_license_number').val('');
                $('#helpdesksoftwarelicenses_software_function').val('');
                $('#helpdesksoftwarelicenses_software_version').val('');
                $('#helpdesksoftwarelicenses_license_type').val('');
                $('#helpdesksoftwarelicenses_username').val('');
                $('#helpdesksoftwarelicenses_password').val('');
                $('#helpdesksoftwarelicenses_installed_device').val('');
                $('#helpdesksoftwarelicenses_installed_date').val('');
                $('#helpdesksoftwarelicenses_filename').val('');
                $('#helpdesksoftwarelicenses_notes').val('');
            }
            else {
                $('#helpdesksoftwarelicenses_id').val(id);
                $('#helpdesksoftwarelicenses_software_name').val($('#helpdesksoftwarelicenses' + id).find("td:eq(0)").text());
                $('#helpdesksoftwarelicenses_url').val($('#helpdesksoftwarelicenses' + id).find("td:eq(1)").text());
                $('#helpdesksoftwarelicenses_license_number').val($('#helpdesksoftwarelicenses' + id).find("td:eq(2)").text());
                $('#helpdesksoftwarelicenses_software_function').val($('#helpdesksoftwarelicenses' + id).find("td:eq(3)").text());
                $('#helpdesksoftwarelicenses_software_version').val($('#helpdesksoftwarelicenses' + id).find("td:eq(4)").text());
                $('#helpdesksoftwarelicenses_license_type').val($('#helpdesksoftwarelicenses' + id).find("td:eq(5)").text());
                $('#helpdesksoftwarelicenses_username').val($('#helpdesksoftwarelicenses' + id).find("td:eq(6)").text());
                $('#helpdesksoftwarelicenses_password').val($('#helpdesksoftwarelicenses' + id).find("td:eq(7)").text());
                $('#helpdesksoftwarelicenses_installed_device').val($('#helpdesksoftwarelicenses' + id).find("td:eq(8)").text());
                $('#helpdesksoftwarelicenses_installed_date').val($('#helpdesksoftwarelicenses' + id).find("td:eq(9)").text());
                $('#helpdesksoftwarelicenses_notes').val($('#helpdesksoftwarelicenses' + id).find("td:eq(10)").text());
                $('#helpdesksoftwarelicenses_filename').val('');

            }
            $('#helpdesksoftwarelicensesModal').modal('show');
        }
        function edithelpdeskhardware(id) {
            if (id == "") {
                $('#helpdeskhardware_id').val('');
                $('#helpdeskhardware_hostname').val('');
                $('#helpdeskhardware_model').val('');
                $('#helpdeskhardware_deviceip').val('');
                $('#helpdeskhardware_macaddress').val('');
                $('#helpdeskhardware_purchased_from').val('');
                $('#helpdeskhardware_purchased_date').val('');
                $('#helpdeskhardware_serial').val('');
                $('#helpdeskhardware_location').val('');
                $('#helpdeskhardware_installed_for').val('');
                $('#helpdeskhardware_filename').val('');

            }
            else {

                $('#helpdeskhardware_id').val(id);
                $('#helpdeskhardware_hostname').val($('#helpdeskhardware' + id).find("td:eq(0)").text());
                $('#helpdeskhardware_model').val($('#helpdeskhardware' + id).find("td:eq(1)").text());
                $('#helpdeskhardware_deviceip').val($('#helpdeskhardware' + id).find("td:eq(2)").text());
                $('#helpdeskhardware_macaddress').val($('#helpdeskhardware' + id).find("td:eq(3)").text());
                $('#helpdeskhardware_purchased_from').val($('#helpdeskhardware' + id).find("td:eq(4)").text());
                $('#helpdeskhardware_purchased_date').val($('#helpdeskhardware' + id).find("td:eq(5)").text());
                $('#helpdeskhardware_serial').val($('#helpdeskhardware' + id).find("td:eq(6)").text());
                $('#helpdeskhardware_location').val($('#helpdeskhardware' + id).find("td:eq(7)").text());
                $('#helpdeskhardware_installed_for').val($('#helpdeskhardware' + id).find("td:eq(8)").text());
                $('#helpdeskhardware_filename').val('');

            }
            $('#helpdeskhardwareModal').modal('show');
        }
        function edithelpdeskfileaccesssharing(id) {
            if (id == "") {
                
                $('#helpdeskfileaccesssharing_id').val('');
                $('#helpdeskfileaccesssharing_sharename').val('');
                $('#helpdeskfileaccesssharing_ipaddress').val('');
                $('#helpdeskfileaccesssharing_url').val('');
                $('#helpdeskfileaccesssharing_usergroup').val('');
                $('#helpdeskfileaccesssharing_username').val('');
                $('#helpdeskfileaccesssharing_password').val('');
                $('#helpdeskfileaccesssharing_location').val('');
                $('#helpdeskfileaccesssharing_purpose').val('');
            }
            else {
                

                $('#helpdeskfileaccesssharing_id').val(id);
                $('#helpdeskfileaccesssharing_sharename').val($('#helpdeskfileaccesssharing' + id).find("td:eq(0)").text());
                $('#helpdeskfileaccesssharing_ipaddress').val($('#helpdeskfileaccesssharing' + id).find("td:eq(1)").text());
                $('#helpdeskfileaccesssharing_url').val($('#helpdeskfileaccesssharing' + id).find("td:eq(2)").text());
                $('#helpdeskfileaccesssharing_usergroup').val($('#helpdeskfileaccesssharing' + id).find("td:eq(3)").text());
                $('#helpdeskfileaccesssharing_username').val($('#helpdeskfileaccesssharing' + id).find("td:eq(4)").text());
                $('#helpdeskfileaccesssharing_password').val($('#helpdeskfileaccesssharing' + id).find("td:eq(5)").text());
                $('#helpdeskfileaccesssharing_location').val($('#helpdeskfileaccesssharing' + id).find("td:eq(6)").text());
                $('#helpdeskfileaccesssharing_purpose').val($('#helpdeskfileaccesssharing' + id).find("td:eq(7)").text());

            }
            $('#helpdeskfileaccesssharingModal').modal('show');
        }
        function edithelpdeskwebsiteaccess(id) {
            if (id == "") {
                $('#helpdeskwebsiteaccess_id').val('');
                $('#helpdeskwebsiteaccess_name').val('');
                $('#helpdeskwebsiteaccess_username').val('');
                $('#helpdeskwebsiteaccess_password').val('');
                $('#helpdeskwebsiteaccess_website').val('');
                $('#helpdeskwebsiteaccess_url').val('');
                $('#helpdeskwebsiteaccess_location').val('');
                $('#helpdeskwebsiteaccess_defaultbrowser').val('');
                $('#helpdeskwebsiteaccess_bookmarks').val('');

            }
            else {
                $('#helpdeskwebsiteaccess_id').val(id);
                $('#helpdeskwebsiteaccess_name').val($('#helpdeskwebsiteaccess' + id).find("td:eq(0)").text());
                $('#helpdeskwebsiteaccess_username').val($('#helpdeskwebsiteaccess' + id).find("td:eq(1)").text());
                $('#helpdeskwebsiteaccess_password').val($('#helpdeskwebsiteaccess' + id).find("td:eq(2)").text());
                $('#helpdeskwebsiteaccess_website').val($('#helpdeskwebsiteaccess' + id).find("td:eq(3)").text());
                $('#helpdeskwebsiteaccess_url').val($('#helpdeskwebsiteaccess' + id).find("td:eq(4)").text());
                $('#helpdeskwebsiteaccess_location').val($('#helpdeskwebsiteaccess' + id).find("td:eq(5)").text());
                $('#helpdeskwebsiteaccess_defaultbrowser').val($('#helpdeskwebsiteaccess' + id).find("td:eq(6)").text());
                $('#helpdeskwebsiteaccess_bookmarks').val('');
            }
            $('#helpdeskwebsiteaccessModal').modal('show');
        }

        function edithelpdeskcloudapplications(id) {
            if (id == "") {
                $('#helpdeskcloudapplications_id').val('');
                $('#helpdeskcloudapplications_application_name').val('');
                $('#helpdeskcloudapplications_license_type').val('');
                $('#helpdeskcloudapplications_url').val('');
                $('#helpdeskcloudapplications_username').val('');
                $('#helpdeskcloudapplications_password').val('');
                $('#helpdeskcloudapplications_registered_to').val('');
                $('#helpdeskcloudapplications_license_key').val('');
                $('#helpdeskcloudapplications_location').val('');
                $('#helpdeskcloudapplications_filename').val('');
            }
            else {
                $('#helpdeskcloudapplications_id').val(id);
                $('#helpdeskcloudapplications_application_name').val($('#helpdeskcloudapplications' + id).find("td:eq(0)").text());
                $('#helpdeskcloudapplications_license_type').val($('#helpdeskcloudapplications' + id).find("td:eq(1)").text());
                $('#helpdeskcloudapplications_url').val($('#helpdeskcloudapplications' + id).find("td:eq(2)").text());
                $('#helpdeskcloudapplications_username').val($('#helpdeskcloudapplications' + id).find("td:eq(3)").text());
                $('#helpdeskcloudapplications_password').val($('#helpdeskcloudapplications' + id).find("td:eq(4)").text());
                $('#helpdeskcloudapplications_registered_to').val($('#helpdeskcloudapplications' + id).find("td:eq(5)").text());
                $('#helpdeskcloudapplications_license_key').val($('#helpdeskcloudapplications' + id).find("td:eq(6)").text());
                $('#helpdeskcloudapplications_location').val($('#helpdeskcloudapplications' + id).find("td:eq(7)").text());
                $('#helpdeskcloudapplications_filename').val('');
            }
            $('#helpdeskcloudapplicationsModal').modal('show');
        }
        function editmicrosoft_server(id) {
            
            if (id == "") {
                //init forms
                $('#server_version').val('');
                $('#server_version_other').val('');
                $('#ws_location').val('');
                $('#ws_operating_roles').val('');
                $('#ws_hostname').val('');
                $('#ws_ipaddress').val('');
                $('#ws_domain').val('');
                $('#ws_macaddress').val('');
                $('#ws_dns_entry').val('');
                $('#ws_username').val('');
                $('#ws_password').val('');
                $('#ws_license').val('');
                $('#ws_filename').val('');
                $('#ws_filename_download').html('');
                $('#ws_dhcp_server').prop("checked", false);
                $('#ws_dhcp_primary_pool').val('');
                $('#ws_dhcp_primary_lease_time').val('');
                $('#ws_dhcp_additinal_pool').val('');
                $('#ws_dhcp_additinal_lease_time').val('');
                $('#ws_dhcp_reservations').val('');
                
                $('#ws_dns_server').prop("checked", false);
                $('#ws_dns_primary_server_ip').val('');
                $('#ws_dns_secondary_server_ip').val('');
                $('#ws_dns_static_entry').val('');
                $('#ws_dhcp_filename').val('');
                $('#ws_dhcp_download').html('');
                $('#ws_install_date').val('');
                $('#ws_domain_controller').prop("checked", false);
                $('#ws_domain_primary_controller').val('');
                $('#ws_domain_secondary_controller').val('');
                $('#ws_domain_primary_controller_ip').val('');
                $('#ws_domain_name').val('');
                $('#ws_dfs').prop("checked", false);
                $('#ws_dfs_primary_controller_ip').val('');
                $('#ws_dfs_secondary_controller_ip').val('');
                $('#ws_dfs_filename').val('');
                $('#ws_dfs_download').html('');
                $('#ws_ad').prop("checked", false);
                $('#ws_ad_primary_controller').val('');
                $('#ws_ad_secondary_controller').val('');
                $('#ws_iis_server').prop("checked", false);
                $('#ws_web_application').val('');
                $('#ws_application_location').val('');
                $('#ws_asp_version').val('');
                $('#ws_iis_version').val('');
                $('#ws_certificate').val('');
                $('#ws_certificate_download').html('');
                $('#ws_iis_backup').val('');
                $('#ws_iis_backup_download').html('');
                $('#ws_additinal_web_applications').val('');
                $('#ws_raid').prop("checked", false);
                $('#ws_raid_controller_model').val('');
                $('#ws_raid_controller_version').val('');
                $('#ws_raid_serial').val('');
                $('#ws_raid_function').val('');
                $('#ws_type_of_drives').val('');
                $('#ws_storage_size').val('');
                $('#ws_disk_size_amount').val('');
                $('#ws_valumes').val('');
                $('#ws_storage_notes').val('');
                $('#ws_cpu_model').val('');
                $('#ws_cpu_socet').val('');
                $('#ws_memory_information').val('');
                $('#ws_memory_per_module').val('');
                $('#ws_total_memory').val('');
                $('#ws_hardware_drivers').val('');

            }
            else
            {
                
                var r;
                $.ajax({
                    type: "POST",
                    url: 'default.aspx/getWindowsServer',
                    async: false,
                    dataType: "json",
                    data: JSON.stringify({ 'id': id }),
                    contentType: "application/json; charset=utf-8",
                    success: function (result) {
                        r = $.parseJSON(result.d);
                    },
                    failure: function (response) {
                        alert("Unable to get Data:");
                    }
                });

                ;
                //var ws = {
                $('#ws_server_id').val(r.id);
                if (r.server_version != null) { $('#ws_server_version').val(r.server_version); } else {$('#ws_server_version').val('')}
                if (r.server_version == "Other") {
                    if (r.server_version_other != null) { $('#server_version_other').val(r.server_version_other); } else { $('#server_version_other').val('') }
                }
                if (r.location != null) { $('#ws_location').val(r.location); } else { $('#ws_location').val('');}
                if (r.operating_roles != null) {$('#ws_operating_roles').val(r.operating_roles);} else{$('#ws_operating_roles').val('');}
                if (r.hostname != null) {$('#ws_hostname').val(r.hostname);}else{$('#ws_hostname').val('')};
                if (r.ipaddress != null) {$('#ws_ipaddress').val(r.ipaddress);}else{$('#ws_ipaddress').val('');}
                if (r.domain != null) {$('#ws_domain').val(r.domain);}else{$('#ws_domain').val('');}
                if (r.macaddress != null) { $('#ws_macaddress').val(r.macaddress); } else { $('#ws_macaddress').val(''); }
                if (r.dns_entry != null) {$('#ws_dns_entry').val(r.dns_entry);}else  {$('#ws_dns_entry').val('');}
                if (r.username != null) {$('#ws_username').val(r.username);}else{$('#ws_username').val('');}
                if (r.password != null) {$('#ws_password').val(r.password);}else {$('#ws_password').val('');}
                if (r.license != null) { $('#ws_license').val(r.license); } else { $('#ws_license').val(''); }

                if (r.filename != null) {
                    $('#ws_filename_download').html('<a href="wsfiles/' + r.id + r.filename + '" target="_blank">' + r.filename + '</a>');

                }
                else {
                    $('#ws_filename_download').html('');
                }
                $('#ws_filename').val('');
                if (r.dhcp_server == "True") { $('#ws_dhcp_server').prop("checked", true); } else { $('#ws_dhcp_server').prop("checked", false); }
                if (r.dhcp_primary_pool != null) { $('#ws_dhcp_primary_pool').val(r.dhcp_primary_pool);}else{$('#ws_dhcp_primary_pool').val('');}
                if (r.dhcp_primary_lease_time != null) { $('#ws_dhcp_primary_lease_time').val(r.dhcp_primary_lease_time)}else{$('#ws_dhcp_primary_lease_time').val('');}
                if (r.dhcp_additinal_pool != null) { $('#ws_dhcp_additinal_pool').val(r.dhcp_additinal_pool)}else{$('#ws_dhcp_additinal_pool').val('');}
                if (r.dhcp_additinal_lease_time != null) { $('#ws_dhcp_additinal_lease_time').val(r.dhcp_additinal_lease_time);}else{$('#ws_dhcp_additinal_lease_time').val('');}
                if (r.dhcp_reservations != null) { $('#ws_dhcp_reservations').val(r.dhcp_reservations); } else { $('#ws_dhcp_reservations').val(''); }
                if (r.dns_server == "True") { $('#ws_dns_server').prop("checked", true); } else { $('#ws_dns_server').prop("checked", false); }
                if (r.dns_primary_server_ip != null) { $('#ws_dns_primary_server_ip').val(r.dns_primary_server_ip);}else{$('#ws_dns_primary_server_ip').val('');}
                if (r.dns_secondary_server_ip != null) { $('#ws_dns_secondary_server_ip').val(r.dns_secondary_server_ip);}else{$('#ws_dns_secondary_server_ip').val('');}
                if (r.dns_static_entry != null) { $('#ws_dns_static_entry').val(r.dns_static_entry);} else { $('#ws_dns_static_entry').val('');}
                if (r.dhcp_filename != null) {
                    $('#ws_dhcp_filename_download').html('<a href="wsfiles/' + r.id + r.dhcp_filename+'" target="_blank">' + r.dhcp_filename + '</a>');

                }
                else {
                    $('#ws_dhcp_filename_download').html('');
                }
                $('#ws_dhcp_filename').val('');
                if (r.install_date != null) { $('#ws_install_date').val(r.install_date);}else{ $('#ws_install_date').val('');}
                if (r.domain_controller == "True") { $('#ws_domain_controller ').prop("checked", true); } else { $('#ws_domain_controller ').prop("checked", false); }
                if (r.domain_primary_controller != null) { $('#ws_domain_primary_controller').val(r.domain_primary_controller);}else{$('#ws_domain_primary_controller').val('');}
                if (r.domain_secondary_controller != null) { $('#ws_domain_secondary_controller').val(r.domain_secondary_controller);}else{$('#ws_domain_secondary_controller').val('');}
                if (r.domain_name != null) {$('#ws_domain_name').val(r.domain_name);}else{$('#ws_domain_name').val('');}
                if (r.dfs == "True") { $('#ws_dfs').prop("checked", true); } else { $('#ws_dfs').prop("checked", false); }
                if (r.dfs_primary_controller_ip != null) {$('#ws_dfs_primary_controller_ip').val(r.dfs_primary_controller_ip);} else{$('#ws_dfs_primary_controller_ip').val('');}
                if (r.dfs_secondary_controller_ip != null) { $('#ws_dfs_secondary_controller_ip').val(r.dfs_secondary_controller_ip);}else{ $('#ws_dfs_secondary_controller_ip').val('');}
                if (r.dfs_filename != null) {
                    $('#ws_dfs_filename_download').html('<a href="wsfiles/' + r.id + r.dfs_filename + '" target="_blank">' + r.dfs_filename + '</a>');

                }
                else {
                    $('#ws_dfs_filename_download').html('');
                }
                $('#ws_dfs_filename').val('');
                if (r.ad == "True") { $('#ws_ad').prop("checked", true); } else { $('#ws_ad').prop("checked", false); }
                if (r.iis_server == "True") { $('#ws_iis_server').prop("checked", true); } else { $('#ws_iis_server').prop("checked", false); }
                if (r.ad_primary_controller != null) { $('#ws_ad_primary_controller').val(r.ad_primary_controller);}else{$('#ws_ad_primary_controller').val('');}
                if (r.ad_secondary_controller != null) { $('#ws_ad_secondary_controller').val(r.ad_secondary_controller);}else{$('#ws_ad_secondary_controller').val('');}
                if (r.web_application != null) { $('#ws_web_application').val(r.web_application);}else{ $('#ws_web_application').val('');}
                if (r.application_location != null) { $('#ws_application_location').val(r.application_location);}else{$('#ws_application_location').val('');}
                if (r.asp_version != null) { $('#ws_asp_version').val(r.asp_version);}else { $('#ws_asp_version').val('');}
                if (r.iis_version != null) { $('#ws_iis_version').val(r.iis_version); } else { $('#ws_iis_version').val(''); }
                if (r.certificate != null) {
                    $('#ws_certificate_download').html('<a href="wsfiles/' + r.id + r.certificate + '" target="_blank">' + r.certificate + '</a>');
                }
                else {
                    $('#ws_certificate_download').html('');
                }
                $('#ws_iis_backup').val('');
                if (r.iis_backup != null) {
                    $('#ws_iis_backup_download').html('<a href="wsfiles/' + r.id + r.iis_backup + '" target="_blank">' + r.iis_backup + '</a>');
                }
                else
                {
                    $('#ws_iis_backup_download').html('');
                }
                $('#ws_iis_backup').val('');
                if (r.additinal_web_applications != null) { $('#ws_additinal_web_applications').val(r.additinal_web_applications);}else{$('#ws_additinal_web_applications').val('');}
                if (r.raid == "True") { $('#ws_raid').prop("checked", true); } else { $('#ws_raid').prop("checked", false); }
                if (r.raid_controller_model != null) { $('#ws_raid_controller_model').val(r.raid_controller_model);}else{$('#ws_raid_controller_model').val('');}
                if (r.raid_controller_version != null) {$('#ws_raid_controller_version').val(r.raid_controller_version);}else{$('#ws_raid_controller_version').val('');}
                if (r.raid_serial != null) { $('#ws_raid_serial').val(r.raid_serial);}else{$('#ws_raid_serial').val('');}
                if (r.raid_function != null) {$('#ws_raid_function').val(r.raid_function);}else{$('#ws_raid_function').val('');}
                if (r.type_of_drives != null) { $('#ws_type_of_drives').val(r.type_of_drives);}else{$('#ws_type_of_drives').val('');}
                if (r.storage_size!= null) { $('#ws_storage_size').val(r.storage_size);}else{$('#ws_storage_size').val('');}
                if (r.disk_size_amount != null) { $('#ws_disk_size_amount').val(r.disk_size_amount);}else{$('#ws_disk_size_amount').val('');}
                if (r.valumes != null) { $('#ws_valumes').val(r.valumes);}else{$('#ws_valumes').val('');}
                if (r.storage_notes != null) { $('#ws_storage_notes').val(r.storage_notes);}else{$('#ws_storage_notes').val('');}
                if (r.cpu_model != null) { $('#ws_cpu_model').val(r.cpu_model);}else{ $('#ws_cpu_model').val('');}
                if (r.cpu_socet != null) { $('#ws_cpu_socet').val(r.cpu_socet);}else{$('#ws_cpu_socet').val('');}
                if (r.memory_information != null) {$('#ws_memory_information').val(r.memory_information);}else{$('#ws_memory_information').val('');}
                if (r.memory_per_module != null) { $('#ws_memory_per_module').val(r.memory_per_module);}else{$('#ws_memory_per_module').val()};
                if (r.total_memory != null) { $('#ws_total_memory').val(r.total_memory);}else{$('#ws_total_memory').val('');}
                if (r.hardware_drivers != null) { $('#ws_hardware_drivers').val(r.hardware_drivers);}else{$('#ws_hardware_drivers').val();}

                //}


                //load nic and users
                if (r.nics!=null){

                    //$('#microsoft_server_network-table').DataTable().clear().destroy();
                    $('#microsoft_server_network-data').html(r.nics);
                    //$('#microsoft_server_network-table').DataTable({
                    //    dom: 'Bfrtip',
                    //    retrieve: true,
                    //    scrollX: true

                    //});
                }

                if (r.users != null ) {
                    //$('#microsoft_server_users-table').DataTable().clear().destroy();
                    $('#microsoft_server_users-data').html(r.users);
                    //$('#microsoft_server_usera-table').DataTable({
                    //    dom: 'Bfrtip',
                    //    retrieve: true,
                    //    scrollX: true

                    //});
                }
                
                
                        
           }

                
            $('#microsoft_serverModal').modal('show');
        }

        function AddUpdateWServer() {
            var ws = {
                id: $('#ws_server_id').val(),
                client_id: $('#client_id').val(),
                server_version: $('#ws_server_version').val(),
                server_version_other: $('#ws_server_version_other').val(),
                location: $('#ws_location').val(),
                operating_roles: $('#ws_operating_roles').val(),
                hostname: $('#ws_hostname').val(),
                ipaddress: $('#ws_ipaddress').val(),
                domain: $('#ws_domain').val(),
                macaddress: $('#ws_macaddress').val(),
                dns_entry: $('#ws_dns_entry').val(),
                username: $('#ws_username').val(),
                password: $('#ws_password').val(),
                license: $('#ws_license').val(),
                filename: $('#ws_filename').val(),
                dhcp_server:  ($('#ws_dhcp_server').is(':checked')) ? "1": "0",
                dhcp_primary_pool: $('#ws_dhcp_primary_pool').val(),
                dhcp_primary_lease_time: $('#ws_dhcp_primary_lease_time').val(),
                dhcp_additinal_pool: $('#ws_dhcp_additinal_pool').val(),
                dhcp_additinal_lease_time: $('#ws_dhcp_additinal_lease_time').val(),
                dhcp_reservations: $('#ws_dhcp_reservations').val(),
                dns_server: ($('#ws_dns_server').is(':checked')) ? "1": "0",
                dns_primary_server_ip: $('#ws_dns_primary_server_ip').val(),
                dns_secondary_server_ip: $('#ws_dns_secondary_server_ip').val(),
                dns_static_entry: $('#ws_dns_static_entry').val(),
                dhcp_filename: $('#ws_dhcp_filename').val(),
                install_date: $('#ws_install_date').val(),
                domain_controller: ($('#ws_domain_controller').is(':checked')) ? "1": "0",
                domain_primary_controller: $('#ws_domain_primary_controller').val(),
                domain_secondary_controller: $('#ws_domain_secondary_controller').val(),
                domain_name: $('#ws_domain_name').val(),
                dfs: ($('#ws_dfs').is(':checked')) ? "1": "0",
                dfs_primary_controller_ip: $('#ws_dfs_primary_controller_ip').val(),
                dfs_secondary_controller_ip: $('#ws_dfs_secondary_controller_ip').val(),
                dfs_filename: $('#ws_dfs_filename').val(),
                ad: ($('#ws_ad').is(':checked')) ? "1": "0",
                ad_primary_controller: $('#ws_ad_primary_controller').val(),
                ad_secondary_controller: $('#ws_ad_secondary_controller').val(),
                iis_server: ($('#ws_iis_server').is(':checked')) ? "1": "0",
                web_application: $('#ws_web_application').val(),
                application_location: $('#ws_application_location').val(),
                asp_version: $('#ws_asp_version').val(),
                iis_version: $('#ws_iis_version').val(),
                certificate: $('#ws_certificate').val(),
                iis_backup: $('#ws_iis_backup').val(),
                additinal_web_applications: $('#ws_additinal_web_applications').val(),
                raid : ($('#ws_raid').is(':checked')) ? "1": "0",
                raid_controller_model: $('#ws_raid_controller_model').val(),
                raid_controller_version: $('#ws_raid_controller_version').val(),
                raid_serial: $('#ws_raid_serial').val(),
                raid_function: $('#ws_raid_function').val(),
                type_of_drives: $('#ws_type_of_drives').val(),
                storage_size: $('#ws_storage_size').val(),
                disk_size_amount: $('#ws_disk_size_amount').val(),
                valumes: $('#ws_valumes').val(),
                storage_notes: $('#ws_storage_notes').val(),
                cpu_model: $('#ws_cpu_model').val(),
                cpu_socet: $('#ws_cpu_socet').val(),
                memory_information: $('#ws_memory_information').val(),
                memory_per_module: $('#ws_memory_per_module').val(),
                total_memory: $('#ws_total_memory').val(),
                hardware_drivers: $('#ws_hardware_drivers').val()

            }

            var r = "";
            
            $.ajax({
                type: "POST",
                url: 'default.aspx/AddUpdateWServer',
                async: false,
                dataType: "json",
                data: JSON.stringify({ 'win': ws }),
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    r = result.d;
                },
                failure: function (response) {
                    alert("Unable to get Data:" );
                }
            });
            AddUpdateMSNetworks(r);
            AddUpdateMSUsers(r);


            if ($('#ws_filename').val() != '') {
                sendMSfiles(r, "ws_filename", "filename");
            }
            if ($('#ws_dhcp_filename').val() != '') {
                sendMSfiles(r, "ws_dhcp_filename", "dhcp_filename");
            }
            if ($('#ws_dfs_filename').val() != '') {
                sendMSfiles(r, "ws_dfs_filename", "dfs_filename");
            }
            if ($('#ws_certificate').val() != '') {
                sendMSfiles(r, "ws_certificate", "certificate");
            }
            if ($('#ws_iis_backup').val() != '') {
                sendMSfiles(r, "ws_iis_backup", "iis_backup");
            }
            //getdata($('#client_id').val(), 'usermanagement')
            //$('#microsoft_serverModal').modal('hide');
            $('#microsoft_serverModal').modal('hide');
        }
        function AddUpdateMSNetworks(server_id) {


            var msn = $('#microsoft_server_network-table tbody tr').each(function () {

                var id = $(this).attr("id");
                if (typeof(id) == "undefined") {
                    id = "";
                }
                else
                {
                    id = id.replace("msn", "");
                }
                var msn = {

                    id: id,
                    server_id: server_id,
                    nic_name: $(this.cells[0]).text(),
                    nic_ip: $(this.cells[1]).text(),
                    nic_subnet: $(this.cells[2]).text(),
                    nic_gateway: $(this.cells[3]).text(),
                    nic_macaddress: $(this.cells[4]).text(),
                    purpose: $(this.cells[5]).text(),
                    nic: getnic($(this))
                };


                $.ajax({
                    type: "POST",
                    url: 'default.aspx/AddUpdateMSNetworks',
                    async: false,
                    dataType: "json",
                    data: JSON.stringify({ "msn": msn }),
                    contentType: "application/json; charset=utf-8",
                    success: function (result) {
                        r = result.d;
                    },
                    failure: function (response) {
                        alert("Unable to get Data:");
                    }
                });

            });
        }

        function AddUpdateMSUsers(server_id) {


            var msn = $('#microsoft_server_users-table tbody tr').each(function () {

                var id = $(this).attr("id");
                if (typeof (id) == "undefined") {
                    id = "";
                }
                else {
                    id = id.replace("msu", "");
                }
                var msu = {

                    id: id,
                    server_id: server_id,
                    client_id: $('#client_id').val(),
                    username: $(this.cells[0]).text(),
                    password: $(this.cells[1]).text(),
                    permissions: $(this.cells[2]).text(),
                    purpose: $(this.cells[3]).text()
                  
                };


                $.ajax({
                    type: "POST",
                    url: 'default.aspx/AddUpdateMSusers',
                    async: false,
                    dataType: "json",
                    data: JSON.stringify({ "msu": msu }),
                    contentType: "application/json; charset=utf-8",
                    success: function (result) {
                        r = result.d;
                    },
                    failure: function (response) {
                        alert("Unable to get Data:");
                    }
                });

            });
        }
        function getnicid(tr) {
            var str = tr.id;
            return str.replace("windows_servers", "");
        }
        function getnic(tr) {
            var ch = tr.find('input[type=checkbox]');
            return (ch.is(':checked')) ? "1" : "0";
        }
        function AddUpdateClient() {
                var data="{";
                var procedure = "";
                if ($('#client_id').val() == "") {
                    procedure = "AddClient";
                }
                else
                {
                    procedure = "UpdateClient";
                    data += '"client_id":"' + $('#client_id').val() + '","location_id":"' + $('#<%=location_id.ClientID %>').val() + '",';
                
            
                }
                data +='"primary_location":"' + $('#<%=primary_location.ClientID %>').val()+'","companyname":"'+ $('#<%=companyname.ClientID %>').val()+'"';
                data += ',"contactname":"' + $('#<%=contactname.ClientID %>').val() + '"';
                data += ',"phone":"' + $('#<%=phone.ClientID %>').val() + '"';
                data += ',"email":"' + $('#<%=email.ClientID %>').val() + '"';
                data += ',"address":"' + $('#<%=address.ClientID %>').val() + '"';
                data += ',"city":"' + $('#<%=city.ClientID %>').val() + '"';
                data += ',"state":"' + $('#<%=state.ClientID %>').val() + '"';
                data += ',"zipcode":"' + $('#<%=zipcode.ClientID %>').val() + '"';
                data += ',"notes":"' + $('#<%=comments.ClientID %>').val() + '"';
                data+='}';
                var d = JSON.parse(ajaxhelper(data, procedure));
                //var d = ajaxhelper(data, procedure);

                var client_id = d.client_id;
                var location_id=d.location_id;

                getclient(client_id);

            }

            function addnewclient() {
                $('#client_id').val('')
                editLocation('','',0);
            }

            function AddUpdateClientEmergencyContact() {

                var data = "{";
                var procedure = 'AddUpdateClientEmergencyContact';
                data += '"id":"' + $('#emergencycontacts_id').val() + '"';
                data += ',"client_id":"' + $('#client_id').val() + '"';
                data += ',"emergencycontact":"' + $('#emergencycontact').val() + '"';
                data += ',"emergencyphone":"' + $('#emergencyphone').val() + '"';
                data += ',"emergencyemail":"' + $('#emergencyemail').val() + '"';
                data += '}';

                //var d = JSON.parse(ajaxhelper(data, procedure));

                ajaxhelper(data, procedure);
                getclient($('#client_id').val());
                $('#emergencycontactsModal').modal('hide');
            
            }
            function addupdateclientnetworks(){
                var data = "{";
                var procedure = 'addupdateclientnetworks';
                data += '"id":"' + $('#clientnetworks_id').val() + '"';
                data += ',"client_id":"' + $('#client_id').val() + '"';
                data += ',"subnet":"' + $('#clientnetworks_subnet').val() + '"';
                data += ',"ipaddress":"' + $('#clientnetworks_ipaddress').val() + '"';
                data += ',"gateway":"' + $('#clientnetworks_gateway').val() + '"';
                data += ',"purpose":"' + $('#clientnetworks_purpose').val() + '"';
                data += '}';

                ajaxhelper(data, procedure);
                getclient($('#client_id').val());
                $('#clientnetworksModal').modal('hide');
            }
            function addupdateusermanagement() {

                var data = "{";
                var procedure = 'addupdateusermanagement';
                data += '"id":"' + $('#usermanagement_id').val() + '"';
                data += ',"client_id":"' + $('#client_id').val() + '"';
                data += ',"fname":"' + $('#usermanagement_fname').val() + '"';
                data += ',"lname":"' + $('#usermanagement_lname').val() + '"';
                data += ',"phone":"' + $('#usermanagement_phone').val() + '"';
                data += ',"email":"' + $('#usermanagement_email').val() + '"';
                data += ',"username":"' + $('#usermanagement_username').val() + '"';
                data += ',"password":"' + $('#usermanagement_password').val() + '"';
                data += ',"position":"' + $('#usermanagement_position').val() + '"';
                data += ',"location":"' + $('#usermanagement_location').val() + '"';
                data += ',"notes":"' + $('#usermanagement_notes').val() + '"';
                if ($('#usermanagement_status').is(':checked')) {
                    data += ',"status":"1"';
                }
                else
                {
                    data += ',"status":"0"';
                }
                data += '}';
                ajaxhelper(data, procedure);
                getdata($('#client_id').val(), 'usermanagement');
                $('#usermanagementModal').modal('hide');

            }
            function addupdatehelpdeskemailaccounts() {
                var data = "{";
                var procedure = 'addupdatehelpdeskemailaccounts';
                data += '"id":"' + $('#helpdeskemailaccounts_id').val() + '"';
                data += ',"client_id":"' + $('#client_id').val() + '"';
                data += ',"fname":"' + $('#helpdeskemailaccounts_fname').val() + '"';
                data += ',"lname":"' + $('#helpdeskemailaccounts_lname').val() + '"';
                data += ',"phone":"' + $('#helpdeskemailaccounts_phone').val() + '"';
                data += ',"email":"' + $('#helpdeskemailaccounts_email').val() + '"';
                data += ',"username":"' + $('#helpdeskemailaccounts_username').val() + '"';
                data += ',"password":"' + $('#helpdeskemailaccounts_password').val() + '"';

                data += ',"in_mail_server":"' + $('#helpdeskemailaccounts_in_mail_server').val() + '"';
                data += ',"in_mail_server_port":"' + $('#helpdeskemailaccounts_in_mail_server_port').val() + '"';
                data += ',"in_mail_server_password":"' + $('#helpdeskemailaccounts_in_mail_server_password').val() + '"';
                data += ',"out_mail_server":"' + $('#helpdeskemailaccounts_out_mail_server').val() + '"';
                data += ',"out_mail_server_port":"' + $('#helpdeskemailaccounts_out_mail_server_port').val() + '"';
                data += ',"out_mail_server_password":"' + $('#helpdeskemailaccounts_out_mail_server_password').val() + '"';

                var nameString = $('#helpdeskemailaccounts_signature').val();
                var nameArray = nameString.split('\\');
                var signature = nameArray[nameArray.length - 1];

                data += ',"signature":"' + signature + '"';


                if ($('#helpdeskemailaccounts_status').is(':checked')) {
                    data += ',"status":"1"';
                }
                else {
                    data += ',"status":"0"';
                }
                data += '}';
                var email_id = ajaxhelper(data, procedure);

                if ($('#helpdeskemailaccounts_signature').val() != '') {
                    sendFile(email_id, "helpdeskemailaccounts_signature", "helpdeskemailaccounts");
                }
                getdata($('#client_id').val(), 'helpdeskemailaccounts');
                $('#helpdeskemailaccountsModal').modal('hide');
            }

            function addupdatehelpdesksoftwarelicenses() {
                var data = "{";
                var procedure = 'addupdatehelpdesksoftwarelicenses';
                data += '"id":"' + $('#helpdesksoftwarelicenses_id').val() + '"';
                data += ',"client_id":"' + $('#client_id').val() + '"';
                data += ',"software_name":"' + $('#helpdesksoftwarelicenses_software_name').val() + '"';
                data += ',"url":"' + $('#helpdesksoftwarelicenses_url').val() + '"';
                data += ',"license_number":"' + $('#helpdesksoftwarelicenses_license_number').val() + '"';
                data += ',"software_function":"' + $('#helpdesksoftwarelicenses_software_function').val() + '"';
                data += ',"software_version":"' + $('#helpdesksoftwarelicenses_software_version').val() + '"';
                data += ',"license_type":"' + $('#helpdesksoftwarelicenses_license_type').val() + '"';
                data += ',"username":"' + $('#helpdesksoftwarelicenses_username').val() + '"';
                data += ',"password":"' + $('#helpdesksoftwarelicenses_password').val() + '"';
                data += ',"installed_device":"' + $('#helpdesksoftwarelicenses_installed_device').val() + '"';
                data += ',"installed_date":"' + $('#helpdesksoftwarelicenses_installed_date').val() + '"';
                data += ',"notes":"' + $('#helpdesksoftwarelicenses_notes').val() + '"';
            
                var nameString = $('#helpdesksoftwarelicenses_filename').val();
                var nameArray = nameString.split('\\');
                var filename = nameArray[nameArray.length - 1];

                data += ',"filename":"' + filename + '"';
                data += '}';


                var id= ajaxhelper(data, procedure);

                if ($('#helpdesksoftwarelicenses_filename').val() != '') {
                    sendFile(id, "helpdesksoftwarelicenses_filename", "helpdesksoftwarelicenses");
                }
                getdata($('#client_id').val(), 'helpdesksoftwarelicenses');
                $('#helpdesksoftwarelicensesModal').modal('hide');

            }
            function addupdatehelpdeskhardware() {
                var data = "{";
                var procedure = 'addupdatehelpdeskhardware';
                data += '"id":"' + $('#helpdeskhardware_id').val() + '"';
                data += ',"client_id":"' + $('#client_id').val() + '"';
                data += ',"hostname":"' + $('#helpdeskhardware_hostname').val() + '"';
                data += ',"model":"' + $('#helpdeskhardware_model').val() + '"';
                data += ',"deviceip":"' + $('#helpdeskhardware_deviceip').val() + '"';
                data += ',"macaddress":"' + $('#helpdeskhardware_macaddress').val() + '"';
                data += ',"purchased_from":"' + $('#helpdeskhardware_purchased_from').val() + '"';
                data += ',"purchased_date":"' + $('#helpdeskhardware_purchased_date').val() + '"';
                data += ',"serial":"' + $('#helpdeskhardware_serial').val() + '"';
                data += ',"location":"' + $('#helpdeskhardware_location').val() + '"';
                data += ',"installed_for":"' + $('#helpdeskhardware_installed_for').val() + '"';
            
                var nameString = $('#helpdeskhardware_filename').val();
                var nameArray = nameString.split('\\');
                var filename = nameArray[nameArray.length - 1];
                data += ',"filename":"' + filename + '"';


                data += '}';
                var id = ajaxhelper(data, procedure);
                if ($('#helpdeskhardware_filename').val() != '') {
                    sendFile(id, "helpdeskhardware_filename", "helpdeskhardware");
                }
                getdata($('#client_id').val(), 'helpdeskhardware');
                $('#helpdeskhardwareModal').modal('hide');
            }

            function addupdatehelpdeskwebsiteaccess() {
                var data = "{";
                var procedure = 'addupdatehelpdeskwebsiteaccess';
                data += '"id":"' + $('#helpdeskwebsiteaccess_id').val() + '"';
                data += ',"client_id":"' + $('#client_id').val() + '"';
                data += ',"name":"' + $('#helpdeskwebsiteaccess_name').val() + '"';
                data += ',"username":"' + $('#helpdeskwebsiteaccess_username').val() + '"';
                data += ',"password":"' + $('#helpdeskwebsiteaccess_password').val() + '"';
                data += ',"website":"' + $('#helpdeskwebsiteaccess_website').val() + '"';
                data += ',"url":"' + $('#helpdeskwebsiteaccess_url').val() + '"';
                data += ',"location":"' + $('#helpdeskwebsiteaccess_location').val() + '"';
                data += ',"defaultbrowser":"' + $('#helpdeskwebsiteaccess_defaultbrowser').val() + '"';
            

                var nameString = $('#helpdeskwebsiteaccess_bookmarks').val();
                var nameArray = nameString.split('\\');
                var filename = nameArray[nameArray.length - 1];
                data += ',"bookmarks":"' + filename + '"';

                data += '}';
                var id= ajaxhelper(data, procedure);
                if ($('#helpdeskwebsiteaccess_bookmarks').val() != '') {
                    sendFile(id, "helpdeskwebsiteaccess_bookmarks", "helpdeskwebsiteaccess");
                }
                getdata($('#client_id').val(), 'helpdeskwebsiteaccess');
                $('#helpdeskwebsiteaccessModal').modal('hide');
            }
            function addupdatehelpdeskcloudapplications(){
                var data = "{";
                var procedure = 'addupdatehelpdeskcloudapplications';
                data += '"id":"' + $('#helpdeskcloudapplications_id').val() + '"';
                data += ',"client_id":"' + $('#client_id').val() + '"';
                data += ',"application_name":"' + $('#helpdeskcloudapplications_application_name').val() + '"';
                data += ',"license_type":"' + $('#helpdeskcloudapplications_license_type').val() + '"';
                data += ',"url":"' + $('#helpdeskcloudapplications_url').val() + '"';
                data += ',"username":"' + $('#helpdeskcloudapplications_username').val() + '"';
                data += ',"password":"' + $('#helpdeskcloudapplications_password').val() + '"';
                data += ',"registered_to":"' + $('#helpdeskcloudapplications_registered_to').val() + '"';
                data += ',"license_key":"' + $('#helpdeskcloudapplications_license_key').val() + '"';
                data += ',"location":"' + $('#helpdeskcloudapplications_location').val() + '"';
            
                var nameString = $('#helpdeskcloudapplications_filename').val();
                var nameArray = nameString.split('\\');
                var filename = nameArray[nameArray.length - 1];
                data += ',"filename":"' + filename + '"';

                data += '}';
                var id = ajaxhelper(data, procedure);
                if ($('#helpdeskcloudapplications_filename').val() != '') {
                    sendFile(id, "helpdeskcloudapplications_filename", "helpdeskcloudapplications");
                }
                getdata($('#client_id').val(), 'helpdeskcloudapplications');
                $('#helpdeskcloudapplicationsModal').modal('hide')
            }

            function addupdatehelpdeskfileaccesssharing(id) {
                var data = "{";
                var procedure = 'addupdatehelpdeskfileaccesssharing';
                data += '"id":"' + $('#helpdeskfileaccesssharing_id').val() + '"';
                data += ',"client_id":"' + $('#client_id').val() + '"';
                data += ',"sharename":"' + $('#helpdeskfileaccesssharing_sharename').val() + '"';
                data += ',"ipaddress":"' + $('#helpdeskfileaccesssharing_ipaddress').val() + '"';
                data += ',"url":"' + $('#helpdeskfileaccesssharing_url').val() + '"';
                data += ',"usergroup":"' + $('#helpdeskfileaccesssharing_usergroup').val() + '"';
                data += ',"username":"' + $('#helpdeskfileaccesssharing_username').val() + '"';
                data += ',"password":"' + $('#helpdeskfileaccesssharing_password').val() + '"';
                data += ',"location":"' + $('#helpdeskfileaccesssharing_location').val() + '"';
                data += ',"purpose":"' + $('#helpdeskfileaccesssharing_purpose').val() + '"';

                data += '}';
                ajaxhelper(data, procedure);
                getdata($('#client_id').val(), 'helpdeskfileaccesssharing');
                $('#helpdeskfileaccesssharingModal').modal('hide')
            }

            //end function to end records

            function ajaxhelper(data, f) {
                var r = "";
                var d = {};
                if (data != '' || data) {
                    d = JSON.parse(data);
                }
                $.ajax({
                    type: "POST",
                    url: 'default.aspx/' + f,
                    async: false,
                    data: JSON.stringify(d),
                    contentType: "application/json; charset=utf-8",
                    success: function (result) {
                        r = result.d;
                    },
                    failure: function (response) {
                        alert("Unable to get Data:" + f);
                    }
                });
                return r;
                ajaxhelper(data, procedure);
                getdata()
            }
        
            function getCounter(tablename) {
                var $table = $('#' + tablename + '-data tr');
                var rowCount = 0;
                if($table.find('.dataTables_empty').length>0){
                    rowCount = 0;  
                }else
                {
                    rowCount = $('#' + tablename + '-data tr').length;
                
                }
            
                $('#' + tablename + '_counter').html(rowCount);
            }


        
            function AddUpdateClientFiles() {
                sendFile("", "client_file", "AddUpdateClientFiles")
                getclient($('#client_id').val());
                $('#client-file').val();

            }
       
            function sendFile(id,control,procedure) {
                var formData = new FormData();
                var totalFiles = document.getElementById(control).files.length;
                //alert(totalFiles);
                for (var i = 0; i < totalFiles; i++) {
                    var file = document.getElementById(control).files[i];

                    formData.append("FileUpload", file);
                    formData.append("client_id", $('#client_id').val());
                    formData.append("record_id", id);
                    formData.append("procedure", procedure);
                }

                $.ajax({
                    type: 'post',
                    url: '/api/AjaxFileHandler.ashx',
                    async: false,
                    data: formData,
                    dataType: 'json',
                    contentType: false,
                    processData: false,
                    success: function (response) {
                        //alert('succes!!');
                    },
                    error: function (error) {
                        alert("errror uploading file");
                    }
                });
            }

            function sendMSfiles(server_id, control,field_name) {
                var formData = new FormData();
                var totalFiles = document.getElementById(control).files.length;
                //alert(totalFiles);
                for (var i = 0; i < totalFiles; i++) {
                    var file = document.getElementById(control).files[i];

                    formData.append("FileUpload", file);
                    formData.append("server_id", server_id);
                    formData.append("field_name", field_name);
                    
                }

                $.ajax({
                    type: 'post',
                    url: '/api/AjaxMSFileHandler.ashx',
                    async: false,
                    data: formData,
                    dataType: 'json',
                    contentType: false,
                    processData: false,
                    success: function (response) {
                        //alert('succes!!');
                    },
                    error: function (error) {
                        alert("errror uploading file");
                    }
                });
            }

            function uploadFile( control, procedure) {
                var formData = new FormData();
                var totalFiles = document.getElementById(control).files.length;
                //alert(totalFiles);
                for (var i = 0; i < totalFiles; i++) {
                    var file = document.getElementById(control).files[i];

                    formData.append("FileUpload", file);
                    formData.append("client_id", $('#client_id').val());
                    formData.append("procedure", procedure);
                }

                $.ajax({
                    type: 'post',
                    url: '/api/importdata.ashx',
                    async: false,
                    data: formData,
                    dataType: 'json',
                    contentType: false,
                    processData: false,
                    success: function (response) {
                        //alert('succes!!');
                    },
                    error: function (error) {
                        alert("errror uploading file");
                    }
                });
            }
            function exportFile(procedure) {
                window.location.href="api/exportdata.ashx?procedure=" + procedure + "&client_id=" + $('#client_id').val();
            }
            function getHelpdeskCounts(client_id) {
                var data = ajaxhelper('{"id":' + client_id + ',"f":"getHelpdeskCounts"}', 'getdata');

                var d = data.split(',');
                $('#usermanagement_counter').html(d[0]);
                $('#helpdeskemailaccounts_counter').html(d[1]);
                $('#helpdesksoftwarelicenses_counter').html(d[2]);
                $('#helpdeskhardware_counter').html(d[3]);
                $('#helpdeskfilesccesssharing_counter').html(d[4]);
                $('#helpdeskwebsiteaccess_counter').html(d[5]);
                $('#helpdeskcloudapplications_counter').html(d[6]);
                $('#microsoft_servers_counter').html(d[7]);
            }

            function updateClientStatus() {
                var active ="0";
                if ($('input.checkbox_check').is(':checked')) {
                    active = "1";
                }
                var data = ajaxhelper('{"client_id":' + $('#client_id').val() + ',"active":"' + active + '"}', 'updateClientStatus');
            }


            function addwsservernic() {
                var strcheck = '<input type="checkbox"/>';
                if ($('#ws_nic').is(':checked')) {
                    strcheck = '<input type="checkbox" checked />';
                }

                $('#microsoft_server_network tbody').append('<tr><td>' + $('#ws_nic_name').val() + '</td><td>' + $('#ws_nic_ip').val() + '</td><td>' + $('#ws_nic_subnet').val() + '</td><td>' + $('#ws_nic_gateway').val() + '</td><td>' + $('#ws_nic_macaddress').val() + '</td><td>' + $('#ws_nic_purpose').val() + '</td><td>' + strcheck + '</td><td><button class="btn btn-success" type="button" onclick="editwsnic($(this));">Edit</button>&nbsp;<button class="btn btn-success" type="button" onclick="deletewsnic($(this));">Delete</button></td></tr>');
            }
            function deletewsnic(row) {
                var tr = row.closest('tr');
                var rowid = tr.attr("id");
                

                if (typeof(rowid) != 'undefined') {
                    var id = rowid.replace('msn', '');
                    ajaxhelper('{"id":' + id + ',"client_id":"' + $('#client_id').val() + '","procedure":"delete_microsoft_server_networks"}', 'deleteRecord');

                }
                tr.remove();

            }
            function editwsnic(row) {
                var tr = row.closest('tr');
                var rowid = tr.attr("id");

                if (typeof (rowid) != 'undefined') {
                    oldNic.id = rowid.replace("msn", "");


                }
                oldNic.name  = tr.find("td:eq(0)").text();
                oldNic.ip = tr.find("td:eq(1)").text();
                oldNic.subnet = tr.find("td:eq(2)").text();
                oldNic.gateway = tr.find("td:eq(3)").text();
                oldNic.macaddress = tr.find("td:eq(4)").text();
                oldNic.purpose = tr.find("td:eq(5)").text();

                var nic = tr.find('input[type="checkbox"]:checked')
                if (nic.is(':checked')) {
                    oldNic.status = 1;
                    strcheck = '<input type="checkbox" checked id="edit_ws_nic" />';
                }
                else
                {
                    oldNic.status = 0;
                    strcheck = '<input type="checkbox" id="edit_ws_nic" />';
                }
                
                var new_row = '<tr class="edit_row"><td><input type="text" id="edit_ws_nic_name" class="form-control" value="' + oldNic.name + '"/></td><td><input type="text" id="edit_ws_nic_ip" class="form-control" value="' + oldNic.ip + '"/></td><td><input type="text" id="edit_ws_nic_subnet" class="form-control" value="' + oldNic.subnet + '"/></td><td><input type="text" id="edit_ws_nic_gateway" class="form-control" value="' + oldNic.gateway + '"/></td><td><input type="text" id="edit_ws_nic_macaddress" class="form-control" value="' + oldNic.macaddress + '"/></td><td><input type="text" id="edit_ws_nic_purpose" class="form-control" value="' + oldNic.purpose + '"/></td><td>' + strcheck + '</td><td><button class="btn btn-success" type="button" onclick="savewsnic($(this));">Save</button>&nbsp;<button class="btn btn-success" type="button" onclick="cancelwsnic($(this));">Cancel</button></td></tr>';
                tr.replaceWith(new_row);

            }
            function savewsnic(row) {
                var tr = row.closest('tr');
                var rowid = "";
                if (oldNic.id != '') {
                    rowid = "id='" + oldNic.id + "'";
                }

                var nic = tr.find('input[type="checkbox"]:checked')
                if (nic.is(':checked')) {
                    
                    strcheck = '<input type="checkbox" checked id="edit_ws_nic" />';
                }
                else {
                    
                    strcheck = '<input type="checkbox" id="edit_ws_nic" />';
                }


                var new_row = '<tr class="edit_row" ' + rowid + '><td>' + $('#edit_ws_nic_name').val() + '</td><td>' + $('#edit_ws_nic_ip').val() + '</td><td>' + $('#edit_ws_nic_subnet').val() + '</td><td>' + $('#edit_ws_nic_gateway').val() + '</td><td>' + $('#edit_ws_nic_macaddress').val() + '</td><td>' + $('#edit_ws_nic_purpose').val() + '</td><td>' + strcheck + '</td><td><button class="btn btn-success" type="button" onclick="editwsnic($(this));">Edit</button>&nbsp;<button class="btn btn-success" type="button" onclick="deletewsnic($(this));">Delete</button></td></tr>';
                tr.replaceWith(new_row);
            }
            function cancelwsnic(row) {
                var tr = row.closest('tr');
                var rowid = "";
                if (oldNic.id != '') {
                    rowid = "id='" + oldNic.id + "'";
                }
                strcheck = "";
                if (oldNic.status==1) {

                    strcheck = '<input type="checkbox" checked id="edit_ws_nic" />';
                }
                else {

                    strcheck = '<input type="checkbox" id="edit_ws_nic" />';
                }
                var new_row = '<tr class="" ' + rowid + '><td>' + oldNic.name + '</td><td>' + oldNic.ip + '</td><td>' + oldNic.subnet + '</td><td>' + oldNic.gateway + '</td><td>' + oldNic.macaddress + '</td><td>' + oldNic.purpose + '</td><td>'+ strcheck+'</td><td><button class="btn btn-success" type="button" onclick="editwsnic($(this));">Edit</button>&nbsp;<button class="btn btn-success" type="button" onclick="deletewsnic($(this));">Delete</button></td></tr>';
                tr.replaceWith(new_row);
            }


            function addwsuser() {
                $('#microsoft_server_users tbody').append('<tr><td>' + $('#msu_username').val() + '</td><td>' + $('#msu_password').val() + '</td><td>' + $('#msu_permissions').val() + '</td><td>' + $('#msu_purpose').val() + '</td><td><button class="btn btn-success" type="button" onclick="editwsuser($(this));">Edit</button>&nbsp;<button class="btn btn-success" type="button" onclick="deletewsuser($(this));">Delete</button></td></tr>');

            }
            function deletewsuser(row) {

                var tr = row.closest('tr');
                var rowid = tr.attr("id");


                if (typeof (rowid) != 'undefined') {
                    var id = rowid.replace("msu", "");
                    ajaxhelper('{"id":' + id + ',"client_id":"' + $('#client_id').val() + '","procedure":"delete_microsoft_server_users"}', 'deleteRecord');

                }
                tr.remove();


            }
            function editwsuser(row) {
                
                var tr = row.closest('tr');
                var rowid = tr.attr("id");

                if (typeof (rowid) != 'undefined') {
                    oldUser.id = rowid.replace("msu", "");


                }
                oldUser.username = tr.find("td:eq(0)").text();
                oldUser.password= tr.find("td:eq(1)").text();
                oldUser.permissions = tr.find("td:eq(2)").text();
                oldUser.purpose = tr.find("td:eq(3)").text();
                
                

                var new_row = '<tr class="edit_row"><td><input type="text" id="edit_wsu_username" class="form-control" value="' + oldUser.username + '"/></td><td><input type="text" id="edit_wsu_password" class="form-control" value="' + oldUser.password + '"/></td><td><input type="text" id="edit_wsu_permissions" class="form-control" value="' + oldUser.permissions + '"/></td><td><input type="text" id="edit_wsu_purpose" class="form-control" value="' + oldUser.purpose + '"/></td><td><button class="btn btn-success" type="button" onclick="savewsuser($(this));">Save</button>&nbsp;<button class="btn btn-success" type="button" onclick="cancelwsuser($(this));">Cancel</button></td></tr>';
                tr.replaceWith(new_row);
            }
            function savewsuser(row) {
                var tr = row.closest('tr');
                var rowid = "";
                if (oldUser.id != '') {
                    rowid = "id='" + oldUser.id + "'";
                }

                
                var new_row = '<tr class="edit_row" ' + rowid + '><td>' + $('#edit_wsu_username').val() + '</td><td>' + $('#edit_wsu_password').val() + '</td><td>' + $('#edit_wsu_permissions').val() + '</td><td>' + $('#edit_wsu_purpose').val() + '</td><td><button class="btn btn-success" type="button" onclick="editwsuser($(this));">Edit</button>&nbsp;<button class="btn btn-success" type="button" onclick="deletewsuser($(this));">Delete</button></td></tr>';
                tr.replaceWith(new_row);
            }
            function cancelwsuser(row) {
                var tr = row.closest('tr');
                var rowid = "";
                if (oldUser.id != '') {
                    rowid = "id='" + oldUser.id + "'";
                }


                var new_row = '<tr class="edit_row" ' + rowid + '><td>' + $('#edit_wsu_username').val() + '</td><td>' + $('#edit_wsu_password').val() + '</td><td>' + $('#edit_wsu_permissions').val() + '</td><td>' + $('#edit_wsu_purpose').val() + '</td><td><button class="btn btn-success" type="button" onclick="editwsuser($(this));">Edit</button>&nbsp;<button class="btn btn-success" type="button" onclick="deletewsuser($(this));">Delete</button></td></tr>';
                tr.replaceWith(new_row);
            }


            function getManuals(manual_type) {
                
                hideall();
                $('#manual_type').val(manual_type);
                var data = ajaxhelper('{"manual_type":"' + manual_type + '"}', 'getManuals');

                $('#manuals-table').DataTable().clear().destroy();
                $('#manuals-data').html(data);
                $('#manuals-box').show();
                $('#manuals-table').DataTable({
                    dom: 'Bfrtip',
                    retrieve: true,
                    scrollX: true

                });

                $('#manual_header').text(manual_type);
                
            }
            function AddUpdateManual(control) {
                var formData = new FormData();
                var totalFiles = document.getElementById(control).files.length;
                //alert(totalFiles);
                var filename="";
                
                for (var i = 0; i < totalFiles; i++) {
                    var file = document.getElementById(control).files[i];

                    formData.append("FileUpload", file);
                    formData.append("manual_name", $('#manual_name').val());
                    formData.append("manual_type", $('#manual_type').val());


                    var fileNameIndex = $('#' + control).val().lastIndexOf("\\") + 1;
                    filename = $('#' + control).val().substr(fileNameIndex);
                }

                var r=""

                $.ajax({
                    type: 'post',
                    url: '/api/AddUpdateManual.ashx',
                    async: false,
                    data: formData,
                    dataType: 'json',
                    contentType: false,
                    processData: false,
                    success: function (response) {

                        r = response.d;
                        //alert(r);
                    },
                    error: function (error) {
                        alert("errror uploading file");
                    }
                });

                $('#manuals-table tbody').append("<tr id='manual" + r + "'><td><a href='manuals/"+ filename + "' target='_blank'>" + $('#manual_name').val() + "</a></td><td></td><td><span style='cursor:pointer;' onclick=\"if (confirm('Are you sure?')) {deleteRecord('" + r + "','manual')}\">delete</span></td></tr>");


            }
                </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="hidden" id="client_id" />
    
    <div class="col-xl-12 databox" id="clientsbox">
        <section class="box ">
            <header class="panel_header">
                <h2 class="title float-left">Clients</h2>
                <%--<div class="actions panel_actions float-right">
                                    <i class="box_toggle fa fa-chevron-down"></i>
                                    <i class="box_setting fa fa-cog" data-toggle="modal" href="#section-settings"></i>
                                    <i class="box_close fa fa-times"></i>
                                </div>--%>
            </header>
            <div class="content-body">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-12 padding-0">

                        <table id="clients-table" class="table table-striped dt-responsive display" cellspacing="0" width="100%" data-page-length='35'>
                            <thead>
                                <tr>
                                    <th>Company Name</th>
                                    <th>Contact Name</th>
                                    <th>Address</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tfoot>
                                <tr>
                                    <th>Company Name</th>
                                    <th>Contact Name</th>
                                    <th>Address</th>
                                    <th>Status</th>
                                </tr>
                            </tfoot>
                            <tbody id="clients-data">
                            </tbody>
                        </table>

                    </div>
                </div>
            </div>
        </section>

    </div>
    <div class="col-xl-12 databox" style="display: inline;" id="client-info">
        <section class="box ">
            <header class="panel_header">
                <h2 class="title float-left">Client Info</h2>
                
            </header>
            <div class="content-body">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-12 padding-0">
                        <!-- Horizontal - start -->
                        <div class="row">
                            <div class="col-lg-12">

                                <h4>Company Info</h4>

                                <ul class="nav nav-tabs primary" id="myTab1" role="tablist">
                                    <li class="nav-item">
                                        <a class="nav-link active" href="#home-1" role="tab" data-toggle="tab">
                                            <i class="fa fa-home"></i>Locations
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" role="tab" href="#emergency_contacts-1" data-toggle="tab">
                                            <i class="fa fa-user"></i>Emergency Contacts 
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" role="tab" href="#client-networks-1" data-toggle="tab">
                                            <i class="fa fa-user"></i>Networks 
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" role="tab" href="#client-files-1" data-toggle="tab">
                                            <i class="fa fa-file"></i>Files
                                        </a>
                                    </li>

                                </ul>

                                <div class="tab-content primary" id="myTabContent1">
                                    <div class="tab-pane fade show active" id="home-1">
                                        <div id="client-locations" class="table-responsive">
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="emergency_contacts-1">
                                        <div id="client-emergency_contacts" class="table-responsive">
                                        </div>
                                        <div class="row float-right col-lg-12 col-md-12 col-12 padding-0" style="padding-top:30px;">
                                            <div class="col-md-8"></div>
                                            <div class="col-md-1 pr-1 pl-1">
                                                <button class="btn btn-success btn-sm w-100" type="button" onclick="exportFile('clientemergencycontacts')" >Export</button>

                                            </div>
                                            <div class="col-md-1 pr-1 pl-1">
                                                <div class="file-input" style="padding: 6%;">
                                                    <input type="file" id="clientemergencycontactsfile" class="form-control-file" class="w-100 btn-sm" style="padding: 0;" />
                                                
                                               </div>
                                            </div>
                                            <div class="col-md-1 pr-1 pl-1">
                                                <button class="btn btn-success w-100 btn-sm" type="button" onclick="uploadFile('clientemergencycontactsfile','clientemergencycontacts');">Upload File</button>
                                                
                                            </div>
                                            <div class="col-md-1 pr-1 pl-1">
                                                <button class='btn btn-success w-100 btn-sm' type='button' onclick='editemergencycontacts();'>Add New</button>
                                            </div>
                                        </div>
                                           
                                    </div>
                                    <div class="tab-pane fade" id="client-networks-1">
                                        <div id="client-networks" class="table-responsive">
                                        </div>
                                        <div class="row float-right col-lg-12 col-md-12 col-12 padding-0" style="padding-top:30px;">
                                            <div class="col-md-8"></div>
                                            <div class="col-md-1 pr-1 pl-1">
                                                <button class="btn btn-success btn-sm w-100" type="button" onclick="exportFile('clientnetworks')" >Export</button>

                                            </div>
                                            <div class="col-md-1 pr-1 pl-1">
                                                <div class="file-input" style="padding: 6%;">
                                                    <input type="file" id="clientnetworksfile" class="form-control-file" class="w-100 btn-sm" style="padding: 0;" />
                                                
                                               </div>
                                            </div>
                                            <div class="col-md-1 pr-1 pl-1">
                                                <button class="btn btn-success w-100 btn-sm" type="button" onclick="uploadFile('clientnetworksfile','clientnetworks');">Upload File</button>
                                                
                                            </div>
                                            <div class="col-md-1 pr-1 pl-1">
                                                <button class='btn btn-success w-100 btn-sm' type='button' onclick='editclientnetworks();'>Add New</button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="client-files-1">
                                        <div id="client-files" class="table-responsive">
                                        </div>
                                        <div>
                                        </div>
                                    </div>

                                </div>

                            </div>
                            <br>
                            <div class="spacer"></div>
                            <div class="spacer"></div>

                        </div>

                        <!-- Horizontal - end -->
                    </div>
                </div>
            </div>
        </section>
    </div>


    <!-- help desk usermanagment box -->
    <div class="col-xl-12 databox" style="display: inline;" id="usermanagement-box">
        <section class="box ">
            <header class="panel_header">
                <h2 class="title float-left">User Management</h2>

            </header>
            <div class="content-body">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-12 padding-0">
                        <!-- Horizontal - start -->
                        <table id="usermanagement-table" class="table table-striped dt-responsive display" cellspacing="0" width="100%" data-page-length='35'>
                            <thead>
                                <tr>
                                    <th>First Name</th>
                                    <th>Last Name</th>
                                    <th>Phone</th>
                                    <th>Email</th>
                                    <th>User Name</th>
                                    <th>Password</th>
                                    <th>Position</th>
                                    <th>Location</th>
                                    <th>Notes</th>
                                    <th>Status</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tfoot>
                                <tr>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th><%--<button class="btn btn-success" type="button" onclick="exportFile('usermanagement')" >Export</button>--%></th>
                                    <th><%--<input type="file" id="usermanagementfile" class="form-control-file" />--%></th>
                                    <th><%--<button class="btn btn-success" type="button" onclick="uploadFile('usermanagementfile','usermanagement');">Upload File</button>--%></th>
                                    
                                    <th>
                                        <%--<button class="btn btn-success" type="button" onclick="editusermanagement();">Add New</button>--%>

                                    </th>
                                </tr>
                            </tfoot>
                            <tbody id="usermanagement-data">
                            </tbody>
                        </table>
                        <!-- Horizontal - end -->
                         
                    </div>

                    <div class="row float-right col-lg-12 col-md-12 col-12 padding-0" style="padding-top:30px;">
                            <div class="col-md-8"></div>
                            <div class="col-md-1 pr-1 pl-1">
                                <button class="btn w-100 btn-sm btn-success btn-sm" type="button" onclick="exportFile('usermanagement')">Export</button>
                            </div>
                            <div class="col-md-1 pr-1 pl-1">
                                <div class="file-input" style="padding: 6%;">
                                <input style="padding: 0;" type="file" id="usermanagementfile" class="w-100 btn-sm" />
                                    </div>
                            </div>
                            <div class="col-md-1 pr-1 pl-1">
                                <button class="btn btn-success w-100 btn-sm" type="button" onclick="uploadFile('usermanagementfile','usermanagement');">Upload File</button>
                            </div>
                            <div class="col-md-1 pr-1 pl-1">
                                <button class="btn btn-success w-100 btn-sm" type="button" onclick="editusermanagement();">Add New</button>
                            </div>
                        </div>
                </div>
            </div>
        </section>
    </div>
    <!-- end box -->
    <!--helpdesk email account box -->
    <div class="col-xl-12 databox" style="display: inline;" id="helpdeskemailaccounts-box">
        <section class="box ">
            <header class="panel_header">
                <h2 class="title float-left">Email Accounts</h2>

            </header>
            <div class="content-body">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-12 padding-0">
                        <table id="helpdeskemailaccounts-table" class="table table-striped dt-responsive display" cellspacing="0" width="100%" data-page-length='35'>
                        <thead>
                            <tr>
                                <th>First Name</th>
                                <th>Last Name</th>
                                <th>Phone</th>
                                <th>User Name</th>
                                <th>Password</th>
                                <th>Email</th>
                                <th>Incoming Mail Server</th>
                                <th>Port</th>
                                <th>Password / Encryption</th>
                                <th>Outgoing Mail Server</th>
                                <th>Port</th>
                                <th>Password / Encryption</th>
                                <th>Signature</th>
                                <th>Status</th>
                                <th></th>
                                
                            </tr>
                        </thead>
                        <tfoot>
                            <tr>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                            </tr>

                        </tfoot>
                        <tbody id="helpdeskemailaccounts-data">
                        </tbody>
                    </table>
                    </div> 
                    <div class="row float-right col-lg-12 col-md-12 col-12 padding-0" style="padding-top:30px;">
                        <div class="col-md-8"></div>
                             <div class="col-md-1 pr-1 pl-1">
                                  <button class="btn w-100 btn btn-success btn-sm" type="button" onclick="exportFile('helpdeskemailaccounts')" >Export</button>

                              </div>
                              <div class="col-md-1 pr-1 pl-1">
                                   <div class="file-input" style="padding: 6%;">
                                        <input type="file" id="helpdeskemailaccountsfile" class="form-control-file" class="w-100 btn-sm" style="padding: 0;" />
                                   </div>
                             </div>
                             <div class="col-md-1 pr-1 pl-1">
                                   <button class="btn btn-success w-100 btn-sm" type="button" onclick="uploadFile('helpdeskemailaccountsfile','helpdeskemailaccounts');">Upload File</button>
                                                
                             </div>
                             <div class="col-md-1 pr-1 pl-1">
                                  <button class='btn btn-success w-100 btn-sm' type='button' onclick="edithelpdeskemailaccounts();">Add New</button>
                         </div>
                    </div>
                </div>
                
            </div>
        </section>
    </div>
    <!--end helpdesk email account box -->


    <!--helpdesk software licenses box -->
    <div class="col-xl-12 databox" style="display: inline;" id="helpdesksoftwarelicenses-box">
        <section class="box ">
            <header class="panel_header">
                <h2 class="title float-left">Software Licenses</h2>

            </header>
            <div class="content-body">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-12 padding-0">
                        <table id="helpdesksoftwarelicenses-table" class="table table-striped dt-responsive display" cellspacing="0" width="100%" data-page-length='35'>
                        <thead>
                            <tr>
                                <th>Software Name</th>
                                <th>URL</th>
                                <th>license # </th>
                                <th>Software Function</th>
                                <th>Software Version</th>
                                <th>License Type</th>
                                <th>User Name</th>
                                <th>Password</th>
                                <th>Installed on Device</th>
                                <th>Installed Date</th>
                                <th>Notes</th>
                                <th>File</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tfoot>
                            <tr>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                            </tr>

                        </tfoot>
                        <tbody id="helpdesksoftwarelicenses-data">
                        </tbody>
                    </table>
                    </div> 
                    <div class="row float-right col-lg-12 col-md-12 col-12 padding-0" style="padding-top:30px;">
                            <div class="col-md-8"></div>
                             <div class="col-md-1 pr-1 pl-1">
                                  <button class="btn w-100 btn btn-success btn-sm" type="button" onclick="exportFile('helpdesksoftwarelicenses')" >Export</button>

                              </div>
                              <div class="col-md-1 pr-1 pl-1">
                                   <div class="file-input" style="padding: 6%;">
                                        <input type="file" id="helpdesksoftwarelicensesfile" class="form-control-file" class="w-100 btn-sm" style="padding: 0;" />
                                   </div>
                             </div>
                             <div class="col-md-1 pr-1 pl-1">
                                   <button class="btn btn-success w-100 btn-sm" type="button" onclick="uploadFile('helpdesksoftwarelicensesfile','helpdesksoftwarelicenses');">Upload File</button>
                                                
                             </div>
                             <div class="col-md-1 pr-1 pl-1">
                                  <button class='btn btn-success w-100 btn-sm' type='button' onclick="edithelpdesksoftwarelicenses();">Add New</button>
                             </div>
                    </div>
                </div>
                
            </div>
        </section>
    </div>
    <!--end helpdesk software licenses box -->

    <!--helpdesk hardware box -->
    <div class="col-xl-12 databox " style="display: inline;" id="helpdeskhardware-box">
        <section class="box ">
            <header class="panel_header">
                <h2 class="title float-left">Printer, Scanner & Fax </h2>

            </header>
            <div class="content-body">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-12 padding-0">
                    <table id="helpdeskhardware-table" class="table table-striped dt-responsive display" cellspacing="0" width="100%" data-page-length='35'>
                        <thead>
                            <tr>
                                <th>Host Name</th>
                                <th>Model</th>
                                <th>Device IP</th>
                                <th>Mac Address</th>
                                <th>Purchased From</th>
                                <th>Purchased Date</th>
                                <th>Serial #</th>
                                <th>Location</th>
                                <th>Istalled For</th>
                                <th>File Name</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tfoot>
                            <tr>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                            </tr>

                        </tfoot>
                        <tbody id="helpdeskhardware-data">
                        </tbody>
                    </table>

                    </div>
                    <div class="row float-right col-lg-12 col-md-12 col-12 padding-0" style="padding-top:30px;">
                        <div class="col-md-8"></div>
                             <div class="col-md-1 pr-1 pl-1">
                                  <button class="btn w-100 btn btn-success btn-sm" type="button" onclick="exportFile('helpdeskhardware')" >Export</button>

                              </div>
                              <div class="col-md-1 pr-1 pl-1">
                                   <div class="file-input" style="padding: 6%;">
                                        <input type="file" id="helpdeskhardwarefile" class="form-control-file" class="w-100 btn-sm" style="padding: 0;" />
                                   </div>
                             </div>
                             <div class="col-md-1 pr-1 pl-1">
                                   <button class="btn btn-success w-100 btn-sm" type="button" onclick="uploadFile('helpdeskhardwarefile','helpdeskhardware');">Upload File</button>
                                                
                             </div>
                             <div class="col-md-1 pr-1 pl-1">
                                  <button class='btn btn-success w-100 btn-sm' type='button' onclick="edithelpdeskhardware();">Add New</button>
                             </div>
                    </div>
                </div> 
            </div>
        </section>
    </div>
    <!--end helpdesk hardware box -->

    <!--helpdesk helpdeskfileaccesssharing box -->
    <div class="col-xl-12 databox" style="display: inline;" id="helpdeskfileaccesssharing-box">
        <section class="box ">
            <header class="panel_header">
                <h2 class="title float-left">File Access Shering</h2>

            </header>
            <div class="content-body">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-12 padding-0">
                        <table id="helpdeskfileaccesssharing-table" class="table table-striped dt-responsive display" cellspacing="0" width="100%" data-page-length='35'>
                        <thead>
                            <tr>
                                <th>Share Name</th>
                                <th>IP Address</th>
                                <th>Location(URL)</th>
                                <th>User Group</th>
                                <th>User Name</th>
                                <th>Password</th>
                                <th>Location</th>
                                <th>Purpose</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tfoot>
                            <tr>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                            </tr>

                        </tfoot>
                        <tbody id="helpdeskfileaccesssharing-data">
                        </tbody>
                    </table>

                    </div>
                    <div class="row float-right col-lg-12 col-md-12 col-12 padding-0" style="padding-top:30px;">
                        <div class="col-md-8"></div>
                             <div class="col-md-1 pr-1 pl-1">
                                  <button class="btn w-100 btn btn-success btn-sm" type="button" onclick="exportFile('helpdeskfileaccesssharing')" >Export</button>

                              </div>
                              <div class="col-md-1 pr-1 pl-1">
                                   <div class="file-input" style="padding: 6%;">
                                        <input type="file" id="helpdeskfileaccesssharingfile" class="form-control-file" class="w-100 btn-sm" style="padding: 0;" />
                                   </div>
                             </div>
                             <div class="col-md-1 pr-1 pl-1">
                                   <button class="btn btn-success w-100 btn-sm" type="button" onclick="uploadFile('helpdeskfileaccesssharingfile','helpdeskfileaccesssharing');">Upload File</button>
                                                
                             </div>
                             <div class="col-md-1 pr-1 pl-1">
                                  <button class='btn btn-success w-100 btn-sm' type='button' onclick="edithelpdeskfileaccesssharing();">Add New</button>
                             </div>
                    </div>
                </div> 
            </div>
        </section>
    </div>
    <!--end helpdesk helpdeskfileaccesssharing box -->

    <!--helpdesk helpdeskwebsiteaccess box -->
    <div class="col-xl-12 databox" style="display: inline;" id="helpdeskwebsiteaccess-box">
        <section class="box ">
            <header class="panel_header">
                <h2 class="title float-left">Website Access</h2>

            </header>
            <div class="content-body">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-12 padding-0">
                        <table id="helpdeskwebsiteaccess-table" class="table table-striped dt-responsive display" cellspacing="0" width="100%" data-page-length='35'>
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>User Name</th>
                                <th>Password</th>
                                <th>WebSite</th>
                                <th>URL</th>
                                <th>Location</th>
                                <th>Default Browser</th>
                                <th>Bookmarks</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tfoot>
                            <tr>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                            </tr>

                        </tfoot>
                        <tbody id="helpdeskwebsiteaccess-data">
                        </tbody>
                    </table>

                    </div>
                    <div class="row float-right col-lg-12 col-md-12 col-12 padding-0" style="padding-top:30px;">
                    <div class="col-md-8"></div>
                         <div class="col-md-1 pr-1 pl-1">
                              <button class=" btn w-100 btn btn-success btn-sm" type="button" onclick="exportFile('helpdeskwebsiteaccess')">Export</button>

                          </div>
                          <div class="col-md-1 pr-1 pl-1">
                               <div class="file-input" style="padding: 6%;">
                                    <input type="file" id="helpdeskwebsiteaccessfile" class="form-control-file" class="w-100 btn-sm" style="padding: 0;" />
                               </div>
                         </div>
                         <div class="col-md-1 pr-1 pl-1">
                               <button class="btn btn-success w-100 btn-sm" type="button" onclick="uploadFile('helpdeskwebsiteaccessfile','helpdeskwebsiteaccess');">Upload File</button>
                                                
                         </div>
                         <div class="col-md-1 pr-1 pl-1">
                              <button class='btn btn-success w-100 btn-sm' type='button' onclick="edithelpdeskwebsiteaccess();">Add New</button>
                         </div>
                </div>
                </div> 
            </div>
        </section>
    </div>
    <!--end helpdesk helpdeskwebsiteaccess box -->

    <!--helpdesk helpdeskcloudapplications box -->
    <div class="col-xl-12 databox" style="display: inline;" id="helpdeskcloudapplications-box">
        <section class="box ">
            <header class="panel_header">
                <h2 class="title float-left">Cloud Applications</h2>

            </header>
            <div class="content-body">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-12 padding-0">
                        <table id="helpdeskcloudapplications-table" class="table table-striped dt-responsive display" cellspacing="0" width="100%" data-page-length='35'>
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>License type</th>
                                <th>URL</th>
                                <th>User name</th>
                                <th>Password</th>
                                <th>Registered to</th>
                                <th>License Key</th>
                                <th>Location</th>
                                <th>File</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tfoot>
                            <tr>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                            </tr>

                        </tfoot>
                        <tbody id="helpdeskcloudapplications-data">
                        </tbody>
                    </table>

                    </div>
                    <div class="row float-right col-lg-12 col-md-12 col-12 padding-0" style="padding-top:30px;">
                    <div class="col-md-8"></div>
                         <div class="col-md-1 pr-1 pl-1">
                              <button class="btn w-100 btn btn-success btn-sm" type="button" onclick="exportFile('helpdeskcloudapplications')" >Export</button>

                          </div>
                          <div class="col-md-1 pr-1 pl-1">
                               <div class="file-input" style="padding: 6%;">
                                    <input type="file" id="helpdeskcloudapplicationsfile" class="form-control-file" class="w-100 btn-sm" style="padding: 0;" />
                               </div>
                         </div>
                         <div class="col-md-1 pr-1 pl-1">
                               <button class="btn btn-success w-100 btn-sm" type="button" onclick="uploadFile('helpdeskcloudapplicationsfile','helpdeskcloudapplications');">Upload File</button>
                                                
                         </div>
                         <div class="col-md-1 pr-1 pl-1">
                              <button class='btn btn-success w-100 btn-sm' type='button' onclick="edithelpdeskcloudapplications();">Add New</button>
                         </div>
                </div>
                </div> 
            </div>
        </section>
    </div>
    <!--end helpdesk helpdeskcloudapplications box -->

    <!--helpdesk microsoft_servers box -->
     <div class="col-xl-12 databox" style="display: inline;" id="microsoft_servers-box">
        <section class="box ">
            <header class="panel_header">
                <h2 class="title float-left">Microsoft Servers</h2>

            </header>
            <div class="content-body">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-12 padding-0">
                        <!-- Horizontal - start -->
                        <table id="microsoft_servers-table" class="table table-striped dt-responsive display" cellspacing="0" width="100%" data-page-length='35'>
                            <thead>
                                <tr>
                                    <th>Version</th>
                                    <th>Host Name</th>
                                    <th>IP Address</th>
                                    <th>Domain</th>
                                    <th>License Key</th>
                                    <th>User Name</th>
                                    <th>Password</th>
                                    <th>Mac Address</th>
                                    <th>Locaton</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tfoot>
                                <tr>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </tfoot>
                            <tbody id="microsoft_servers-data">
                            </tbody>
                        </table>
                        <!-- Horizontal - end -->
                         
                    </div>

                    <div class="row float-right col-lg-12 col-md-12 col-12 padding-0" style="padding-top:30px;">
                            <div class="col-md-8"></div>
                            <div class="col-md-1 pr-1 pl-1">
                                <%--<button class="btn w-100 btn-sm btn-success btn-sm" type="button" onclick="exportFile('usermanagement')">Export</button>--%>
                            </div>
                            <div class="col-md-1 pr-1 pl-1">
                                <div class="file-input" style="padding: 6%;">
                                <%--<input style="padding: 0;" type="file" id="usermanagementfile" class="w-100 btn-sm" />--%>
                                    </div>
                            </div>
                            <div class="col-md-1 pr-1 pl-1">
                                <%--<button class="btn btn-success w-100 btn-sm" type="button" onclick="uploadFile('usermanagementfile','usermanagement');">Upload File</button>--%>
                            </div>
                            <div class="col-md-1 pr-1 pl-1">
                                <button class="btn btn-success w-100 btn-sm" type="button" onclick="editmicrosoft_server('');">Add New</button>
                            </div>
                        </div>
                </div>
            </div>
        </section>
    </div>
    <!--end helpdesk microsoft_servers box -->

     <!--helpdesk helpdeskcloudapplications box -->
    <div class="col-xl-12 databox" style="display: inline;" id="manuals-box">
        <section class="box ">
            <header class="panel_header">
                <h2 class="title float-left" id="manual_header"></h2>

            </header>
            <div class="content-body" style="background-color:white">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-12 padding-0">
                        <table id="manuals-table" class="table table-striped dt-responsive display" cellspacing="0" width="100%" data-page-length='35'>
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>File</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tfoot>
                            <tr>
                                <th></th>
                                <th></th>
                                <th></th>
                            </tr>

                        </tfoot>
                        <tbody id="manuals-data">
                        </tbody>
                    </table>

                    </div>
                 </div>   

                <div class="row col-lg-12 col-md-12 col-12 padding-0" style="padding-top:30px; background-color:white">
                        
                             <div class="col-md-2 pr-2 pl-2"><label>File Name: </label>
                                  <input type="text" class="form_control" id="manual_name" />

                              </div>
                              <div class="col-md-1 pr-1 pl-1">
                                   <div class="file-input" >
                                        <input type="file" id="manualfilename" class="form-control " />
                                   </div>
                             </div>
                             
                             <div class="col-md-1 pr-1 pl-1">
                                 <div>
                                     <button class="btn btn-success w-100 btn-sm" type="button" onclick="AddUpdateManual('manualfilename');">Save</button>

                                 </div>
                                  
                            </div>
                    <div class="col-md-8"></div>
                    </div>
                <div class="row">
                    <input type="hidden" class="form_control" id="manual_type" />
                      
                </div>
                
            </div>
        </section>
    </div>
    <!--end helpdesk helpdeskcloudapplications box -->



    <!-- modal start -->
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="locationModal" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="title float-left">Client Info</h2>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                </div>
                <div class="modal-body">

                    <asp:HiddenField ID="location_id" runat="server" />
                    <asp:HiddenField ID="primary_location" runat="server" />
                    <div class="row">
                        <div class="form-group col-lg-6">
                            <label>Company Name</label>
                            <asp:TextBox ID="companyname" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group col-lg-6">
                            <label>Contact Name</label>
                            <asp:TextBox ID="contactname" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-lg-6">
                            <label>Phone</label>
                            <asp:TextBox ID="phone" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                        <div class="form-group col-lg-6">
                            <label>Email</label>
                            <asp:TextBox ID="email" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">


                        <div class="form-group col-lg-12">
                            <label>Address</label>
                            <asp:TextBox ID="address" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-lg-6 ">
                            <label>City</label>
                            <asp:TextBox ID="city" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                        <div class="form-group col-lg-3">
                            <label>State</label>
                            <asp:TextBox ID="state" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                        <div class="form-group col-lg-3">
                            <label>Zip code</label>
                            <asp:TextBox ID="zipcode" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-lg-12">
                            <label>Notes</label>
                            <asp:TextBox ID="comments" CssClass="form-control" runat="server" TextMode="MultiLine" Rows="5"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-lg-12">
                            <label>Active </label>
                            <asp:CheckBox ID="active" runat="server" CssClass="form-control" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-lg-2">
                        </div>
                    </div>

                </div>
                <div class="modal-footer">
                    <button data-dismiss="modal" class="btn btn-default" type="button">Cancel</button>
                    <button class="btn btn-success" type="button" onclick="AddUpdateClient();">Save</button>
                </div>
            </div>
        </div>
    </div>
    <!-- modal end -->

    <!-- modal start emergency contacts-->
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="emergencycontactsModal" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="title float-left">Emergency Contact</h2>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                </div>
                <div class="modal-body">

                    <input type="hidden" id="emergencycontacts_id" />
                    <div class="row">
                        <div class="form-group col-lg-12">
                            <label>emergency Contact</label>
                            <input type="text" id="emergencycontact" class="form-control " />
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-lg-12">
                            <label>emergency Phone</label>
                            <input type="text" id="emergencyphone" class="form-control " />
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-lg-12">
                            <label>emergency Email</label>
                            <input type="text" id="emergencyemail" class="form-control " />
                        </div>

                    </div>

                </div>
                <div class="modal-footer">
                    <button data-dismiss="modal" class="btn btn-default" type="button">Cancel</button>
                    <button class="btn btn-success" type="button" onclick="AddUpdateClientEmergencyContact();">Save</button>
                </div>
            </div>
        </div>
    </div>
    <!-- modal end -->
    <!-- modal start client_networks -->
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="clientnetworksModal" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="title float-left">Network</h2>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                </div>
                <div class="modal-body">

                    <input type="hidden" id="clientnetworks_id" />
                    <div class="row">
                        <div class="form-group col-lg-12">
                            <label>Subnet</label>
                            <input type="text" id="clientnetworks_subnet" class="form-control " />
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-lg-12">
                            <label>IP Address</label>
                            <input type="text" id="clientnetworks_ipaddress" class="form-control " />
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-lg-12">
                            <label>Gateway</label>
                            <input type="text" id="clientnetworks_gateway" class="form-control " />
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-lg-12">
                            <label>Purpose</label>
                            <input type="text" id="clientnetworks_purpose" class="form-control " />
                        </div>
                    </div>

                </div>
                <div class="modal-footer">
                    <button data-dismiss="modal" class="btn btn-default" type="button">Cancel</button>
                    <button class="btn btn-success" type="button" onclick="addupdateclientnetworks();;">Save</button>
                </div>
            </div>
        </div>
    </div>
    <!-- modal end -->

    <!-- modal start helpdesk usermanagement -->
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="usermanagementModal" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="title float-left">User Management</h2>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                </div>
                <div class="modal-body">

                    <input type="hidden" id="usermanagement_id" />
                    <div class="row">
                        <div class="form-group col-lg-6">
                            <label>First Name</label>
                            <input type="text" id="usermanagement_fname" class="form-control " />
                        </div>

                        <div class="form-group col-lg-6">
                            <label>Last Name</label>
                            <input type="text" id="usermanagement_lname" class="form-control " />
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-lg-6">
                            <label>Phone</label>
                            <input type="text" id="usermanagement_phone" class="form-control " />
                        </div>

                        <div class="form-group col-lg-6">
                            <label>Email</label>
                            <input type="text" id="usermanagement_email" class="form-control " />
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-lg-6">
                            <label>User Name</label>
                            <input type="text" id="usermanagement_username" class="form-control " />
                        </div>

                        <div class="form-group col-lg-6">
                            <label>Password</label>
                            <input type="text" id="usermanagement_password" class="form-control " />
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-lg-6">
                            <label>Position</label>
                            <input type="text" id="usermanagement_position" class="form-control " />
                        </div>

                        <div class="form-group col-lg-6">
                            <label>Location</label>
                            <%--<input type="text" id="usermanagement_location" class="form-control " />--%>
                            <select id="usermanagement_location" class="form-control "></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group col-lg-12">
                            <label>Notes</label>
                            <input type="text" id="usermanagement_notes" class="form-control " />
                        </div>

                    </div>
                    <div class="row">
                        <div class="form-group col-lg-12">
                            <label>Status</label>
                            <input type="checkbox" id="usermanagement_status" class="" />

                        </div>

                    </div>
                </div>
                <div class="modal-footer">
                    <button data-dismiss="modal" class="btn btn-default" type="button">Cancel</button>
                    <button class="btn btn-success" type="button" onclick="addupdateusermanagement();">Save</button>
                </div>
            </div>
        </div>
    </div>
    <!-- modal end -->

    <!-- modal start helpdesk helpdeskemailaccounts -->
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="helpdeskemailaccountsModal" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="title float-left">Email Accounts</h2>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                </div>
                <div class="modal-body">

                    <input type="hidden" id="helpdeskemailaccounts_id" />
                    <div class="row">
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>First Name</label>
                                    <input type="text" id="helpdeskemailaccounts_fname" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Last Name</label>
                                    <input type="text" id="helpdeskemailaccounts_lname" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Phone</label>
                                    <input type="text" id="helpdeskemailaccounts_phone" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Email</label>
                                    <input type="text" id="helpdeskemailaccounts_email" class="form-control " />
                                </div>
                            </div>
                        </div>
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Status</label>
                                    <input type="checkbox" id="helpdeskemailaccounts_status" class="form-check" />
                                </div>

                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>&nbsp;</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>User Name</label>
                                    <input type="text" id="helpdeskemailaccounts_username" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label for="helpdeskemailaccounts_password">Password</label>
                                    <div class="input-group mb-3">
                                        <input type="password" id="helpdeskemailaccounts_password" class="form-control " />
                                        <div class="input-group-append">
                                            <button id="helpdeskemailaccounts_password_btn" onclick="togglePassword()" class="btn btn-outline-secondary" type="button"><i class="fa fa-eye-slash"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Incomming Mail Server</label>
                                    <select id="helpdeskemailaccounts_in_mail_server" class="form-control ">
                                        <option></option>
                                        <option value="IMAP">IMAP</option>
                                        <option value="POP">POP</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Port</label>
                                    <select id="helpdeskemailaccounts_in_mail_server_port" class="form-control ">
                                        <option></option>
                                        <option value="SSL">SSL</option>
                                        <option value="TSL">TSL</option>
                                    </select>

                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Password encription</label>
                                    <select id="helpdeskemailaccounts_in_mail_server_password" class="form-control ">
                                        <option></option>
                                        <option value="SSL">SSL</option>
                                        <option value="TSL">TSL</option>
                                    </select>

                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>signature</label>
                                    <input type="file" id="helpdeskemailaccounts_signature" class="form-control " />
                                </div>
                            </div>
                        </div>
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Outgoing Mail Server</label>
                                    <select id="helpdeskemailaccounts_out_mail_server" class="form-control ">
                                        <option></option>
                                        <option value="IMAP">IMAP</option>
                                        <option value="POP">POP</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Port</label>
                                    <select id="helpdeskemailaccounts_out_mail_server_port" class="form-control ">
                                        <option></option>
                                        <option value="SSL">SSL</option>
                                        <option value="TSL">TSL</option>
                                    </select>

                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Password encription</label>
                                    <select id="helpdeskemailaccounts_out_mail_server_password" class="form-control ">
                                        <option></option>
                                        <option value="SSL">SSL</option>
                                        <option value="TSL">TSL</option>
                                    </select>

                                </div>
                            </div>
                        </div>
                    </div>

                </div>
                <div class="modal-footer">
                    <button data-dismiss="modal" class="btn btn-default" type="button">Cancel</button>
                    <button class="btn btn-success" type="button" onclick="addupdatehelpdeskemailaccounts();">Save</button>
                </div>
            </div>
        </div>
    </div>
    <!-- modal end -->

    <!-- modal start helpdesk helpdesksoftwarelicenses -->
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="helpdesksoftwarelicensesModal" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="title float-left">Software Licenses</h2>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                </div>
                <div class="modal-body">

                    <input id="helpdesksoftwarelicenses_id" type="hidden" />
                    <div class="row">
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Software Name</label>
                                    <input type="text" id="helpdesksoftwarelicenses_software_name" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>URL</label>
                                    <input type="text" id="helpdesksoftwarelicenses_url" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>License Number</label>
                                    <input type="text" id="helpdesksoftwarelicenses_license_number" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Software function</label>
                                    <input type="text" id="helpdesksoftwarelicenses_software_function" class="form-control " />
                                </div>
                            </div>
                        </div>
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Software Version</label>
                                    <input type="text" id="helpdesksoftwarelicenses_software_version" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>License Type</label>
                                    <select id="helpdesksoftwarelicenses_license_type" class="form-control ">
                                        <option></option>
                                        <option value="One Time">One Time</option>
                                        <option value="Annual">Annual</option>
                                        <option value="Monthly">Monthly</option>
                                    </select>

                                </div>
                            </div>
                        </div>

                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>User Name</label>
                                    <input type="text" id="helpdesksoftwarelicenses_username" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Password</label>
                                    <input type="text" id="helpdesksoftwarelicenses_password" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Installed on Device</label>
                                    <input type="text" id="helpdesksoftwarelicenses_installed_device" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Installed Date</label>
                                    <input type="text" id="helpdesksoftwarelicenses_installed_date" class="form-control " />
                                </div>
                            </div>
                        </div>
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>File</label>
                                    <input type="file" id="helpdesksoftwarelicenses_filename" class="form-control " />
                                </div>
                            </div>

                            <div class="row">

                                <div class="form-group col-lg-12">
                                    <label>Notes</label>
                                    <textarea id="helpdesksoftwarelicenses_notes" class="form-control " rows="8"></textarea>
                                </div>

                            </div>

                        </div>
                    </div>

                </div>
                <div class="modal-footer">
                    <button data-dismiss="modal" class="btn btn-default" type="button">Cancel</button>
                    <button class="btn btn-success" type="button" onclick="addupdatehelpdesksoftwarelicenses();">Save</button>
                </div>
            </div>
        </div>
    </div>

    <!-- modal end -->


    <!-- modal start helpdesk helpdeskhardware -->
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="helpdeskhardwareModal" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="title float-left">Hardware</h2>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                </div>
                <div class="modal-body">

                    <input type="hidden" id="helpdeskhardware_id" />
                    <div class="row">
                        <div class="form-group col-lg-4">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Host Name</label>
                                    <input type="text" id="helpdeskhardware_hostname" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Model #</label>
                                    <input type="text" id="helpdeskhardware_model" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Device IP</label>
                                    <input type="text" id="helpdeskhardware_deviceip" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Mac Address</label>
                                    <input type="text" id="helpdeskhardware_macaddress" class="form-control " />
                                </div>
                            </div>
                        </div>
                        <div class="form-group col-lg-4">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Purchased From</label>
                                    <input type="text" id="helpdeskhardware_purchased_from" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Purchased Date</label>
                                    <input type="text" id="helpdeskhardware_purchased_date" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Serial #</label>
                                    <input type="text" id="helpdeskhardware_serial" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Location</label>
                                    <%--<input type="text" id="helpdeskhardware_location" class="form-control " />--%>
                                    <select id="helpdeskhardware_location" class="form-control "></select>
                                </div>
                            </div>
                        </div>
                        <div class="form-group col-lg-4">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Installed for</label>
                                    <input type="text" id="helpdeskhardware_installed_for" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Upload Driver</label>
                                    <input type="file" id="helpdeskhardware_filename" class="form-control " />
                                </div>
                            </div>

                        </div>
                    </div>

                </div>
                <div class="modal-footer">
                    <button data-dismiss="modal" class="btn btn-default" type="button">Cancel</button>
                    <button class="btn btn-success" type="button" onclick="addupdatehelpdeskhardware();">Save</button>
                </div>
            </div>
        </div>
    </div>
    <!-- modal end -->

    <!-- modal start helpdesk helpdeskfileaccesssharing -->
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="helpdeskfileaccesssharingModal" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="title float-left">File sharing access</h2>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                </div>
                <div class="modal-body">

                    <input type="hidden" id="helpdeskfileaccesssharing_id" />
                    <div class="row">
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Share Name</label>
                                    <input type="text" id="helpdeskfileaccesssharing_sharename" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>IP Address</label>
                                    <input type="text" id="helpdeskfileaccesssharing_ipaddress" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Location (URL)</label>
                                    <input type="text" id="helpdeskfileaccesssharing_url" class="form-control " />
                                </div>
                            </div>

                        </div>
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>User Group</label>
                                    <input type="text" id="helpdeskfileaccesssharing_usergroup" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>UserName</label>
                                    <input type="text" id="helpdeskfileaccesssharing_username" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Password</label>
                                    <input type="text" id="helpdeskfileaccesssharing_password" class="form-control " />
                                </div>
                            </div>
                        </div>
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Location</label>
                                    <%--<input type="text" id="helpdeskfileaccesssharing_usergroup" class="form-control " />--%>
                                    <select id="helpdeskfileaccesssharing_location" class="form-control "></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Purpose</label>
                                    <textarea id="helpdeskfileaccesssharing_purpose" class="form-control " rows="8"></textarea>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>
                <div class="modal-footer">
                    <button data-dismiss="modal" class="btn btn-default" type="button">Cancel</button>
                    <button class="btn btn-success" type="button" onclick="addupdatehelpdeskfileaccesssharing();">Save</button>
                </div>
            </div>
        </div>

    </div>
    <!-- modal end -->

    <!-- modal start helpdesk helpdeskwebsiteaccess -->
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="helpdeskwebsiteaccessModal" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="title float-left">Website Access</h2>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                </div>
                <div class="modal-body">
                    <input type="hidden" id="helpdeskwebsiteaccess_id" />
                    <div class="row">
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Name</label>
                                    <input type="text" id="helpdeskwebsiteaccess_name" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>User Name</label>
                                    <input type="text" id="helpdeskwebsiteaccess_username" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Password</label>
                                    <input type="text" id="helpdeskwebsiteaccess_password" class="form-control " />
                                </div>
                            </div>

                        </div>
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Website</label>
                                    <input type="text" id="helpdeskwebsiteaccess_website" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Url</label>
                                    <input type="text" id="helpdeskwebsiteaccess_url" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Default Browser</label>
                                    <select id="helpdeskwebsiteaccess_defaultbrowser" class="form-control ">
                                        <option></option>
                                        <option value="Mazila">Mazila</option>
                                        <option value="Chrome">Chrome</option>
                                        <option value="IE">IE</option>
                                        <option value="Edge">Edge</option>
                                        <option value="Opera">Opera</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Location</label>
                                    <input type="text" id="helpdeskwebsiteaccess_location" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>BookMarks</label>
                                    <input type="file" id="helpdeskwebsiteaccess_bookmarks" class="form-control " />
                                </div>
                            </div>
                        </div>
                    </div>



                </div>
                <div class="modal-footer">
                    <button data-dismiss="modal" class="btn btn-default" type="button">Cancel</button>
                    <button class="btn btn-success" type="button" onclick="addupdatehelpdeskwebsiteaccess()">Save</button>
                </div>
            </div>
        </div>
    </div>

    <!-- modal end -->

    <!-- modal start helpdesk helpdeskcloudapplications -->
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="helpdeskcloudapplicationsModal" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="title float-left">Cloud Applications</h2>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                </div>
                <div class="modal-body">
                    <input type="hidden" id="helpdeskcloudapplications_id" />
                    <div class="row">
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Name</label>
                                    <input type="text" id="helpdeskcloudapplications_application_name" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>License Type</label>
                                    <select id="helpdeskcloudapplications_license_type" class="form-control ">
                                        <option></option>
                                        <option value="One Time">One Time</option>
                                        <option value="Annual">Annual</option>
                                        <option value="Monthly">Monthly</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>URL</label>
                                    <input type="text" id="helpdeskcloudapplications_url" class="form-control " />
                                </div>
                            </div>

                        </div>
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>User Name</label>
                                    <input type="text" id="helpdeskcloudapplications_username" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Password</label>
                                    <input type="text" id="helpdeskcloudapplications_password" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Registered To</label>
                                    <input type="text" id="helpdeskcloudapplications_registered_to" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>License Key</label>
                                    <input type="text" id="helpdeskcloudapplications_license_key" class="form-control " />
                                </div>
                            </div>

                        </div>
                        <div class="form-group col-lg-3">
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Location</label>
                                    <input type="text" id="helpdeskcloudapplications_location" class="form-control " />
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-lg-12">
                                    <label>Upload</label>
                                    <input type="file" id="helpdeskcloudapplications_filename" class="form-control " />
                                </div>
                            </div>
                        </div>
                    </div>



                </div>
                <div class="modal-footer">
                    <button data-dismiss="modal" class="btn btn-default" type="button">Cancel</button>
                    <button class="btn btn-success" type="button" onclick="addupdatehelpdeskcloudapplications()">Save</button>
                </div>
            </div>
        </div>
    </div>

    <!-- modal start helpdesk microsoft_servers -->
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="microsoft_serverModal" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="title float-left">Microsoft Server Information</h2>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                </div>
                <div class="modal-body">
                    <input type="hidden" id="ws_server_id" />
                    
                    <div class="row">
                    <div class="col-lg-12 col-md-12 col-12 padding-0">
                        <!-- Horizontal - start -->
                        <div class="row">
                            <div class="col-lg-12">
                                <ul class="nav nav-tabs primary" id="microsoft_servers_tabs" role="tablist">
                                    <li class="nav-item">
                                        <a class="nav-link active" href="#microsoft_server_info" role="tab" data-toggle="tab">
                                            <i class="fa fa-home"></i>Server Information
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" role="tab" href="#microsoft_server_dns" data-toggle="tab">
                                            <i class="fa fa-user"></i>DHCP / DNS Server 
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" role="tab" href="#microsoft_server_domain" data-toggle="tab">
                                            <i class="fa fa-user"></i>Domain Controller 
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" role="tab" href="#microsoft_server_iis" data-toggle="tab">
                                            <i class="fa fa-file"></i>IIS Server
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" role="tab" href="#microsoft_server_network" data-toggle="tab">
                                            <i class="fa fa-file"></i>Network Information
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" role="tab" href="#microsoft_server_hardware" data-toggle="tab">
                                            <i class="fa fa-file"></i>Hardware
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" role="tab" href="#microsoft_server_users" data-toggle="tab">
                                            <i class="fa fa-file"></i>Users
                                        </a>
                                    </li>

                                </ul>

                                <div class="tab-content primary" id="microsoft_server_Content">
                                    <div class="tab-pane fade show active" id="microsoft_server_info">
                                        <div class="row">
                                            <div class="form-group col-lg-3">
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Version</label>
                                                        <select id="ws_server_version" class="form-control " >
                                                            <option value=""></option>
                                                            <option value="Server2003">Server2003</option>
                                                            <option value="Server2008">Server2008</option>
                                                            <option value="Server2008 SP1">Server2008 SP1</option>
                                                            <option value="Server2012">Server2012</option>
                                                            <option value="Server2016">Server2016</option>
                                                            <option value="Other">Other</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Other Version</label>
                                                        <input type="text" id="ws_server_version_other" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Location</label>
                                                        <input type="text" id="ws_location" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Operating Roles</label>
                                                        <textarea id="ws_operating_roles" class="form-control " rows="5" ></textarea>
                                                    </div>
                                                </div>

                                            </div>
                                            <div class="form-group col-lg-3">
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Host Name</label>
                                                        <input type="text" id="ws_hostname" class="form-control " />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>IP Address</label>
                                                        <input type="text" id="ws_ipaddress" class="form-control " />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Domain</label>
                                                        <input type="text" id="ws_domain" class="form-control " />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Mac Address</label>
                                                        <input type="text" id="ws_macaddress" class="form-control " />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>DNS Entry</label>
                                                        <input type="text" id="ws_dns_entry" class="form-control " />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group col-lg-3">
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>User Name</label>
                                                        <input type="text" id="ws_username" class="form-control " />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Password</label>
                                                        <input type="text" id="ws_password" class="form-control " />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Date of Install</label>
                                                        <input type="text" id="ws_install_date" class="form-control " />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>License #</label>
                                                        <input type="text" id="ws_license" class="form-control " />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Upload</label>
                                                        <input type="file" id="ws_filename" class="form-control " />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <span id="ws_filename_download" ></span>
                                                    </div>
                                                </div>

                                            </div>
                                         </div>
                                        
                                    </div>
                                    <div class="tab-pane fade" id="microsoft_server_dns">
                                        <div class="row">
                                            <div class="form-group col-lg-3">
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>DHCP Server</label>
                                                        <input type="checkbox" id="ws_dhcp_server" class="iswitch iswitch-sm iswitch-primary " />
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>DHCP Primary Pool</label>
                                                        <input type="text" id="ws_dhcp_primary_pool" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Primary Lease Time</label>
                                                        <input type="text" id="ws_dhcp_primary_lease_time" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>DHCP Aditinal pool</label>
                                                        <input type="text" id="ws_dhcp_additinal_pool" class="form-control " />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Additinal Lease Time</label>
                                                        <input type="text" id="ws_dhcp_additinal_lease_time" class="form-control " />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group col-lg-3">
                                                
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>DNS Server</label>
                                                        <input type="checkbox" id="ws_dns_server" class="iswitch iswitch-sm iswitch-primary" />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Primary IP</label>
                                                        <input type="text" id="ws_dns_primary_server_ip" class="form-control " />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Secondary Server IP</label>
                                                        <input type="text" id="ws_dns_secondary_server_ip" class="form-control " />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Upload</label>
                                                        <input type="file" id="ws_dhcp_filename" class="form-control " />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                       <span id="ws_dhcp_filename_download"></span> 
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group col-lg-3">
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Static DNS Entry</label>
                                                        <textarea id="ws_dns_static_entry" class="form-control" rows="3"></textarea>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>DHCP Reservations Entry</label>
                                                        <textarea id="ws_dhcp_reservations" class="form-control" rows="3"></textarea>
                                                    </div>
                                                </div>
                                                                                                
                                            </div>
                                         </div>
                                    </div>
                                    <div class="tab-pane fade" id="microsoft_server_domain">
                                         <div class="row">
                                            <div class="form-group col-lg-3">
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Domain Controller</label>
                                                        <input type="checkbox" id="ws_domain_controller" class="iswitch iswitch-sm iswitch-primary " />
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Primary Controller</label>
                                                        <input type="text" id="ws_domain_primary_controller" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Secondary Controller</label>
                                                        <input type="text" id="ws_domain_secondary_controller" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Domain Name</label>
                                                        <input type="text" id="ws_domain_name" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group col-lg-3">
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Distributed File System (DFS)</label>
                                                        <input type="checkbox" id="ws_dfs" class="iswitch iswitch-sm iswitch-primary " />
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Primary Controller IP</label>
                                                        <input type="text" id="ws_dfs_primary_controller_ip" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Secondary Controller IP</label>
                                                        <input type="text" id="ws_dfs_secondary_controller_ip" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Upload</label>
                                                        <input type="file" id="ws_dfs_filename" class="form-control "/>
                                                        
                                                    </div>
                                                    <div class="form-group col-lg-12">
                                                        <span id="ws_dfs_filename_download"></span> 
                                                        
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group col-lg-3">
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Active Directory</label>
                                                        <input type="checkbox" id="ws_ad" class="iswitch iswitch-sm iswitch-primary " />
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Primary Controller IP</label>
                                                        <input type="text" id="ws_ad_primary_controller" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Secondary Controller IP</label>
                                                        <input type="text" id="ws_ad_secondary_controller" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                            </div>
                                         </div>
                                    </div>
                                    <div class="tab-pane fade" id="microsoft_server_iis">
                                        <div class="row">
                                            <div class="form-group col-lg-3">
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>IIS Server</label>
                                                        <input type="checkbox" id="ws_iis_server" class="iswitch iswitch-sm iswitch-primary " />
                                                        
                                                    </div>
                                                </div>
                                                 <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Web Application</label>
                                                        <input type="text" id="ws_web_application" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Application Location</label>
                                                        <input type="text" id="ws_application_location" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>ASP.NET Version</label>
                                                        <input type="text" id="ws_asp_version" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group col-lg-3">
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>IIS Version</label>
                                                        <input type="text" id="ws_iis_version" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Certificate</label>
                                                        <input type="file" id="ws_certificate" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        
                                                        <span id="ws_certificate_download"></span> 
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>IIS Backup</label>
                                                        <input type="file" id="ws_iis_backup" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <span id="ws_iis_backup_download"></span> 
                                                        
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group col-lg-3">
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Additinal Web Applications</label>
                                                        <textarea id="ws_additinal_web_applications" class="form-control " rows="7"></textarea> 
                                                        
                                                    </div>
                                                </div>
                                            </div>
                                         </div>
                                        
                                    </div>
                                    <div class="tab-pane fade" id="microsoft_server_network">
                                        <table id="microsoft_server_network-table" class="table table-striped dt-responsive display" cellspacing="0" width="100%">
                                            <thead ><tr>
                                                
                                                <th>NIC Name</th>
                                                <th>IP Addess</th>
                                                <th>Subnet</th>
                                                <th>Gateway</th>
                                                <th>Mac Address</th>
                                                <th>Purpose</th>
                                                <th>NIC</th>
                                                <th></th>
                                            </tr></thead>
                                            <tbody id="microsoft_server_network-data">

                                            </tbody>
                                            <tfoot >
                                                <tr>
                                                    <th><input type="text" id="ws_nic_name" class="form-control " /></th>
                                                    <th><input type="text" id="ws_nic_ip" class="form-control " /></th>
                                                    <th><input type="text" id="ws_nic_subnet" class="form-control " /></th>
                                                    <th><input type="text" id="ws_nic_gateway" class="form-control " /></th>
                                                    <th><input type="text" id="ws_nic_macaddress" class="form-control " /></th>
                                                    <th><input type="text" id="ws_nic_purpose" class="form-control " /></th>
                                                    <th><input type="checkbox" id="ws_nic" class="form-control " /></th>
                                                    <th><button class="btn btn-success" type="button" onclick="addwsservernic()">Add</button></th>
                                                </tr>
                                                

                                            </tfoot>
                                        </table>
                                        
                                    </div>
                                    <div class="tab-pane fade" id="microsoft_server_hardware">
                                        <div class="row">
                                            <div class="form-group col-lg-3">
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Raid</label>
                                                        <input type="checkbox" id="ws_raid" class="iswitch iswitch-sm iswitch-primary " />
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Raid Controller Model</label>
                                                        <input type="text" id="ws_raid_controller_model" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Raid Controller Version</label>
                                                        <input type="text" id="ws_raid_controller_version" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                 <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Raid serial</label>
                                                        <input type="text" id="ws_raid_serial" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Raid Function</label>
                                                        <select id="ws_raid_function" class="form-control ">
                                                            <option value=""></option>
                                                            <option value="RAID 0">RAID 0</option>
                                                            <option value="RAID 1">RAID 1</option>
                                                            <option value="RAID 5">RAID 5</option>
                                                            <option value="RAID 6">RAID 6</option>
                                                            <option value="RAID 10">RAID 10</option>
                                                            <option value="RAID 50">RAID 50</option>
                                                            <option value="Soft RAID">Soft RAID</option>
                                                            <option value="Hybrid RAID">Hybrid RAID</option>
                                                        </select>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Type of Drived</label>
                                                        <select id="ws_type_of_drives" class="form-control ">
                                                            <option value=""></option>
                                                            <option value="2.5">2.5</option>
                                                            <option value="3.5">3.5</option>
                                                            
                                                        </select>
                                                        
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group col-lg-3">
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Storage Size</label>
                                                        <input type="text" id="ws_storage_size" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Disk Size</label>
                                                        <input type="text" id="ws_disk_size_amount" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Valumes</label>
                                                        <input type="text" id="ws_valumes" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Storage Notes</label>
                                                        <textarea id="ws_storage_notes" class="form-control "></textarea>
                                                        
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group col-lg-3">
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>CPU Model</label>
                                                        <input type="text"  id="ws_cpu_model" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>CPU Socet</label>
                                                        <input type="text" id="ws_cpu_socet" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Memory Information</label>
                                                        <input type="text" id="ws_memory_information" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Memory GB Per Module</label>
                                                        <input type="text" id="ws_memory_per_module" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Total Memory</label>
                                                        <input type="text" id="ws_total_memory" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="form-group col-lg-12">
                                                        <label>Hardware Drivers</label>
                                                        <input type="text" id="ws_hardware_drivers" class="form-control "/>
                                                        
                                                    </div>
                                                </div>
                                            </div>
                                         </div>
                                        
                                    </div>
                                    <div class="tab-pane fade" id="microsoft_server_users">
                                        <table id="microsoft_server_users-table" class="table table-striped dt-responsive display" cellspacing="0" width="100%">
                                            <thead ><tr>
                                                
                                                <th>User Name</th>
                                                <th>Password</th>
                                                <th>Permissions</th>
                                                <th>Purpose</th>
                                                <th></th>
                                            </tr></thead>
                                            <tbody id="microsoft_server_users-data">

                                            </tbody>
                                            <tfoot >
                                                <tr>
                                                    <th><input type="text" id="msu_username" class="form-control " /></th>
                                                    <th><input type="text" id="msu_password" class="form-control " /></th>
                                                    <th><input type="text" id="msu_permissions" class="form-control " /></th>
                                                    <th><input type="text" id="msu_purpose" class="form-control " /></th>
                                                    <th><button class="btn btn-success" type="button" onclick="addwsuser()">Add</button></th>
                                                </tr>
                                                

                                            </tfoot>
                                        </table>
                                        
                                    </div>

                                </div>

                            </div>
                            <br>
                            <div class="spacer"></div>
                            <div class="spacer"></div>

                        </div>

                        <!-- Horizontal - end -->
                    </div>
                </div>


                </div>
                <div class="modal-footer">
                    <button data-dismiss="modal" class="btn btn-default" type="button">Cancel</button>
                    <button class="btn btn-success" type="button" onclick="AddUpdateWServer()">Save</button>
                </div>
            </div>
        </div>
    </div>

        <script>
            function togglePassword() {
                if ($('#helpdeskemailaccounts_password_btn .fa').hasClass('fa-eye-slash')) {
                    $('#helpdeskemailaccounts_password_btn .fa').removeClass('fa-eye-slash').addClass('fa-eye');
                    $('#helpdeskemailaccounts_password').attr('type', 'text');
                } else {
                    $('#helpdeskemailaccounts_password_btn .fa').removeClass('fa-eye').addClass('fa-eye-slash');
                    $('#helpdeskemailaccounts_password').attr('type', 'password');
                }
            }

            function passwordToDefaultState() {
                $('#helpdeskemailaccounts_password_btn .fa').removeClass('fa-eye').addClass('fa-eye-slash');
                $('#helpdeskemailaccounts_password').attr('type', 'password')
            }
    </script>
    <!-- modal end helpdeskcloudapplications-->

</asp:Content>
