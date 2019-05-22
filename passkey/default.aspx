<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="passkey._default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .modal-lg {
            max-width: 80% !important;
        }
    </style>
    <script>

        

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
                retrieve: true
            });
            getCounter(f);

        }

        
        //delete functions goes here
        function deleteRecord(id,procedure) {
            ajaxhelper('{"id":' + id + ',"procedure":"delete' + procedure + '"}', 'deleteRecord');
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
        
            </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="hidden" id="client_id" />
    <div class="form-block">
        <input type="checkbox" id="client_status" class="iswitch iswitch-lg iswitch-primary" /></div>
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

                                <h4>Primary</h4>

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
                                    </div>
                                    <div class="tab-pane fade" id="client-networks-1">
                                        <div id="client-networks" class="table-responsive">
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
                                    <th><button class="btn btn-success" type="button" onclick="exportFile('usermanagement')" >Export</button></th>
                                    <th><input type="file" id="usermanagementfile" class="form-control-file" /></th>
                                    <th><button class="btn btn-success" type="button" onclick="uploadFile('usermanagementfile','usermanagement');">Upload File</button></th>
                                    
                                    <th>
                                        <button class="btn btn-success" type="button" onclick="editusermanagement();">Add New</button>

                                    </th>
                                </tr>
                            </tfoot>
                            <tbody id="usermanagement-data">
                            </tbody>
                        </table>
                        <!-- Horizontal - end -->
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
                                <th><button class="btn btn-success" type="button" onclick="exportFile('helpdeskemailaccounts')" >Export</button></th>
                                    <th><input type="file" id="helpdeskemailaccountsfile" class="form-control-file" /></th>
                                    <th><button class="btn btn-success" type="button" onclick="uploadFile('helpdeskemailaccountsfile','helpdeskemailaccounts');">Upload File</button></th>
                                    
                                <th>
                                    <button class="btn btn-success" type="button" onclick="edithelpdeskemailaccounts();">Add New</button>
                                </th>
                            </tr>

                        </tfoot>
                        <tbody id="helpdeskemailaccounts-data">
                        </tbody>
                    </table>

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
                                <th><button class="btn btn-success" type="button" onclick="exportFile('helpdesksoftwarelicenses')" >Export</button></th>
                                <th><input type="file" id="helpdesksoftwarelicensesfile" class="form-control-file" /></th>
                                <th><button class="btn btn-success" type="button" onclick="uploadFile('helpdesksoftwarelicensesfile','helpdesksoftwarelicenses');">Upload File</button></th>
                                <th>
                                    <button class="btn btn-success" type="button" onclick="edithelpdesksoftwarelicenses();">Add New</button></th>
                            </tr>

                        </tfoot>
                        <tbody id="helpdesksoftwarelicenses-data">
                        </tbody>
                    </table>

                </div>
            </div>
        </section>
    </div>
    <!--end helpdesk software licenses box -->

    <!--helpdesk hardware box -->
    <div class="col-xl-12 databox" style="display: inline;" id="helpdeskhardware-box">
        <section class="box ">
            <header class="panel_header">
                <h2 class="title float-left">Printer, Scanner & Fax </h2>

            </header>
            <div class="content-body">
                <div class="row">
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
                                <th><button class="btn btn-success" type="button" onclick="exportFile('helpdeskhardware')" >Export</button></th>
                                <th><input type="file" id="helpdeskhardwarefile" class="form-control-file" /></th>
                                <th><button class="btn btn-success" type="button" onclick="uploadFile('helpdeskhardwarefile','helpdeskhardware');">Upload File</button></th>
                                
                                <th>
                                    <button class="btn btn-success" type="button" onclick="edithelpdeskhardware();">Add New</button></th>
                            </tr>

                        </tfoot>
                        <tbody id="helpdeskhardware-data">
                        </tbody>
                    </table>

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
                                <th><button class="btn btn-success" type="button" onclick="exportFile('helpdeskfileaccesssharing')" >Export</button></th>
                                <th><input type="file" id="helpdeskfileaccesssharingfile" class="form-control-file" /></th>
                                <th><button class="btn btn-success" type="button" onclick="uploadFile('helpdeskfileaccesssharingfile','helpdeskfileaccesssharing');">Upload File</button></th>
                                <th>
                                    <button class="btn btn-success" type="button" onclick="edithelpdeskfileaccesssharing()">Add New</button></th>
                            </tr>

                        </tfoot>
                        <tbody id="helpdeskfileaccesssharing-data">
                        </tbody>
                    </table>

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
                                <th><button class="btn btn-success" type="button" onclick="exportFile('helpdeskwebsiteaccess')" >Export</button></th>
                                <th><input type="file" id="helpdeskwebsiteaccessfile" class="form-control-file" /></th>
                                <th><button class="btn btn-success" type="button" onclick="uploadFile('helpdeskwebsiteaccessfile','helpdeskwebsiteaccess');">Upload File</button></th>
                                <th>
                                    <button class="btn btn-success" type="button" onclick="edithelpdeskwebsiteaccess();">Add New</button></th>
                            </tr>

                        </tfoot>
                        <tbody id="helpdeskwebsiteaccess-data">
                        </tbody>
                    </table>

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
                                <th><button class="btn btn-success" type="button" onclick="exportFile('helpdeskcloudapplications')" >Export</button></th>
                                <th><input type="file" id="helpdeskcloudapplicationsfile" class="form-control-file" /></th>
                                <th><button class="btn btn-success" type="button" onclick="uploadFile('helpdeskcloudapplicationsfile','helpdeskcloudapplications');">Upload File</button></th>
                                <th>
                                    <button class="btn btn-success" type="button" onclick="edithelpdeskcloudapplications();">Add New</button></th>
                            </tr>

                        </tfoot>
                        <tbody id="helpdeskcloudapplications-data">
                        </tbody>
                    </table>

                </div>
            </div>
        </section>
    </div>
    <!--end helpdesk helpdeskcloudapplications box -->


    <!-- modal start -->
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="locationModal">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
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
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="emergencycontactsModal">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
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
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="clientnetworksModal">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
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
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="usermanagementModal">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
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
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="helpdeskemailaccountsModal">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
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
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="helpdesksoftwarelicensesModal">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
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
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="helpdeskhardwareModal">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
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
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="helpdeskfileaccesssharingModal">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
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
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="helpdeskwebsiteaccessModal">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
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
    <div class="modal" tabindex="-1" role="dialog" aria-labelledby="ultraModal-Label" aria-hidden="true" id="helpdeskcloudapplicationsModal">
        <div class="modal-dialog modal-lg animated bounceInDown">
            <div class="modal-content">
                <div class="modal-header">
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
