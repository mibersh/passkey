<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="testtable.aspx.cs" Inherits="passkey.testtable" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script >
        $(document).ready(function () {
            $('#testtable').dataTable({
                "processing": true,
                "serverSide": true,
                "ajax": "test.ashx"
            });
        })
    </script>
    <div class="form-block">
    
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

                        <table id="testtable" class="table table-striped dt-responsive display" cellspacing="0" width="100%" data-page-length='35'>
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
    </div> 
</asp:Content>
