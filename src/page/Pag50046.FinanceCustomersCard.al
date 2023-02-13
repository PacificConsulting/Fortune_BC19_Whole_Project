page 50046 "Finance_Customers Card"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067,CCIT-Fortune

    CaptionML = ENU = 'Customer Card',
                ENN = 'Customer Card';
    PageType = Card;
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approve,Request Approval',
                                 ENN = 'New,Process,Report,Approve,Request Approval';
    RefreshOnActivate = true;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General',
                            ENN = 'General';
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;

                    trigger OnAssistEdit();
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("Name 2"; "Name 2")
                {
                    ApplicationArea = All;
                }
                field(Address; Address)
                {
                    ApplicationArea = All;
                }
                field("Address 2"; "Address 2")
                {
                    ApplicationArea = All;
                }
                field("Address 3"; "Address 3")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Address 4"; "Address 4")
                {
                    ApplicationArea = All;
                }
                field(City; City)
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("State Code"; "State Code")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; "Post Code")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Primary Contact No."; "Primary Contact No.")
                {
                    ApplicationArea = All;
                }
                field(Contact; Contact)
                {
                    ApplicationArea = All;
                    Editable = ContactEditable;
                    Importance = Promoted;

                    trigger OnValidate();
                    begin
                        ContactOnAfterValidate;
                    end;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                }
                field("Credit Limit (LCY)"; "Credit Limit (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Search Name"; "Search Name")
                {
                    ApplicationArea = All;
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    var
                        DtldCustLedgEntry: Record 379;
                        CustLedgEntry: Record 21;
                    begin
                        DtldCustLedgEntry.SETRANGE("Customer No.", "No.");
                        COPYFILTER("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                        COPYFILTER("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                        COPYFILTER("Currency Filter", DtldCustLedgEntry."Currency Code");
                        CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
                    end;
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Service Zone Code"; "Service Zone Code")
                {
                    ApplicationArea = All;
                }

                field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = All;
                }
                field("FSSAI License No"; "FSSAI License No")
                {
                    ApplicationArea = All;
                }
                field("FSSAI License Start Date"; "FSSAI License Start Date")
                {
                    ApplicationArea = All;
                }
                field("FSSAI License End Date"; "FSSAI License End Date")
                {
                    ApplicationArea = All;
                }
                field("Accepted Product Shelf Life"; "Accepted Product Shelf Life")
                {
                    ApplicationArea = All;
                }
                field("Sales Return Allowed"; "Sales Return Allowed")
                {
                    ApplicationArea = All;
                }
                field("Contact No.(Sales)"; "Contact No.(Sales)")
                {
                    ApplicationArea = All;
                }
                field("Sales E-Mail"; "Sales E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Contact No.(Purchase)"; "Contact No.(Purchase)")
                {
                    ApplicationArea = All;
                }
                field("Purchase E-Mail"; "Purchase E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Contact No.(Accounts)"; "Contact No.(Accounts)")
                {
                    ApplicationArea = All;
                }
                field("Accounts E-Mail"; "Accounts E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Vertical Category"; "Vertical Category")
                {
                    ApplicationArea = All;
                }
                field("Vertical Sub Category"; "Vertical Sub Category")
                {
                    ApplicationArea = All;
                }
                field("Outlet Area"; "Outlet Area")
                {
                    ApplicationArea = All;
                }
                field("Business Format / Outlet Name"; "Business Format / Outlet Name")
                {
                    ApplicationArea = All;
                }
                field("Responsible Collection Person"; "Responsible Collection Person")
                {
                    ApplicationArea = All;
                }
                field("Duty Free"; "Duty Free")
                {
                    ApplicationArea = All;
                }
                field(Referance; Referance)
                {
                    ApplicationArea = All;
                }
                field("EAN Code"; "EAN Code")
                {
                    ApplicationArea = All;
                }
                field("BOND Dispatch"; "BOND Dispatch")
                {
                    ApplicationArea = All;
                }
                field("Sales Reporting Field"; "Sales Reporting Field")
                {
                    ApplicationArea = All;
                }
            }
            group(Communication)
            {
                CaptionML = ENU = 'Communication',
                            ENN = 'Communication';
                field("Phone No.2"; "Phone No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Fax No."; "Fax No.")
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Home Page"; "Home Page")
                {
                    ApplicationArea = All;
                }
                field("IC Partner Code"; "IC Partner Code")
                {
                    ApplicationArea = All;
                }
                field("Document Sending Profile"; "Document Sending Profile")
                {
                    ApplicationArea = All;
                }
            }
            group(Invoicing)
            {
                CaptionML = ENU = 'Invoicing',
                            ENN = 'Invoicing';
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    var
                        VATRegistrationLogMgt: Codeunit 249;
                    begin
                        VATRegistrationLogMgt.AssistEditCustomerVATReg(Rec);
                    end;
                }
                field(GLN; GLN)
                {
                    ApplicationArea = All;
                }
                field("Invoice Copies"; "Invoice Copies")
                {
                    ApplicationArea = All;
                }
                field("Invoice Disc. Code"; "Invoice Disc. Code")
                {
                    ApplicationArea = All;
                    NotBlank = true;
                }
                field("Copy Sell-to Addr. to Qte From"; "Copy Sell-to Addr. to Qte From")
                {
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }

                field("Customer Posting Group"; "Customer Posting Group")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("Customer Price Group"; "Customer Price Group")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Customer Disc. Group"; "Customer Disc. Group")
                {
                    ApplicationArea = All;
                    Importance = Promoted;

                }
                field("Allow Line Disc."; "Allow Line Disc.")
                {
                    ApplicationArea = All;
                }
                field("Prices Including VAT"; "Prices Including VAT")
                {
                    ApplicationArea = All;
                }
                field("Prepayment %"; "Prepayment %")
                {
                    ApplicationArea = All;
                }
                field("Line Discount Allow"; "Line Discount Allow")
                {
                    ApplicationArea = All;
                }
            }
            group(Payments)
            {
                CaptionML = ENU = 'Payments',
                            ENN = 'Payments';
                field("Application Method"; "Application Method")
                {
                    ApplicationArea = All;
                }
                field("Partner Type"; "Partner Type")
                {
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Reminder Terms Code"; "Reminder Terms Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Fin. Charge Terms Code"; "Fin. Charge Terms Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Cash Flow Payment Terms Code"; "Cash Flow Payment Terms Code")
                {
                    ApplicationArea = All;
                }
                field("Print Statements"; "Print Statements")
                {
                    ApplicationArea = All;
                }
                field("Last Statement No."; "Last Statement No.")
                {
                    ApplicationArea = All;
                }
                field("Block Payment Tolerance"; "Block Payment Tolerance")
                {
                    ApplicationArea = All;
                }

            }
            group(Shipping)
            {
                CaptionML = ENU = 'Shipping',
                            ENN = 'Shipping';
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Combine Shipments"; "Combine Shipments")
                {
                    ApplicationArea = All;
                }
                field(Reserve; Reserve)
                {
                    ApplicationArea = All;
                }
                field("Shipping Advice"; "Shipping Advice")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Shipping Agent Service Code"; "Shipping Agent Service Code")
                {
                    ApplicationArea = All;
                }
                field("Shipping Time"; "Shipping Time")
                {
                    ApplicationArea = All;
                }
                field("Base Calendar Code"; "Base Calendar Code")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
                // field("Customized Calendar"; CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar."Source Type"::Customer, "No.", '', "Base Calendar Code"))
                // {
                //     ApplicationArea = All;
                //     CaptionML = ENU = 'Customized Calendar',
                //                 ENN = 'Customized Calendar';
                //     Editable = false;

                //     trigger OnDrillDown();
                //     begin
                //         CurrPage.SAVERECORD;
                //         TESTFIELD("Base Calendar Code");
                //         CalendarMgmt.ShowCustomizedCalendar(CustomizedCalEntry."Source Type"::Customer, "No.", '', "Base Calendar Code");
                //     end;
                // }
                field("Minimum Shelf Life %"; "Minimum Shelf Life %")
                {
                    ApplicationArea = All;
                }
            }
            group("Route Days")
            {
                Caption = 'Route Days';
                field("Route Days Applicable"; "Route Days Applicable")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Sunday; Sunday)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //CCIT-JAGA
                        IF Sunday = TRUE THEN
                            "Route Days Applicable" := TRUE;
                        //CCIT-JAGA
                    end;
                }
                field(Monday; Monday)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //CCIT-JAGA
                        IF Monday = TRUE THEN
                            "Route Days Applicable" := TRUE;
                        //CCIT-JAGA
                    end;
                }
                field(Tuesday; Tuesday)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //CCIT-JAGA
                        IF Tuesday = TRUE THEN
                            "Route Days Applicable" := TRUE;
                        //CCIT-JAGA
                    end;
                }
                field(Wednesday; Wednesday)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //CCIT-JAGA
                        IF Wednesday = TRUE THEN
                            "Route Days Applicable" := TRUE;
                        //CCIT-JAGA
                    end;
                }
                field(Thursday; Thursday)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //CCIT-JAGA
                        IF Thursday = TRUE THEN
                            "Route Days Applicable" := TRUE;
                        //CCIT-JAGA
                    end;
                }
                field(Friday; Friday)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //CCIT-JAGA
                        IF Friday = TRUE THEN
                            "Route Days Applicable" := TRUE;
                        //CCIT-JAGA
                    end;
                }
                field(Saturday; Saturday)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        //CCIT-JAGA
                        IF Saturday = TRUE THEN
                            "Route Days Applicable" := TRUE;
                        //CCIT-JAGA
                    end;
                }
            }
            group("Foreign Trade")
            {
                CaptionML = ENU = 'Foreign Trade',
                            ENN = 'Foreign Trade';
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Language Code"; "Language Code")
                {
                    ApplicationArea = All;
                }
            }
            group("Tax Information")
            {
                CaptionML = ENU = 'Tax Information',
                            ENN = 'Tax Information';
                group(Tax)
                {
                    CaptionML = ENU = 'Tax',
                                ENN = 'Tax';

                    // field("Tax Liable"; "Tax Liable")
                    // {
                    //     ApplicationArea = All;
                    // }
                }

                group(GST)
                {
                    CaptionML = ENU = 'GST',
                                ENN = 'GST';
                    field("GST Customer Type"; "GST Customer Type")
                    {
                        ApplicationArea = All;
                    }
                    field("GST Registration Type"; "GST Registration Type")
                    {
                        ApplicationArea = All;
                    }
                    field("GST Registration No."; "GST Registration No.")
                    {
                        ApplicationArea = All;
                    }
                    field("UIN Number"; "UIN Number")
                    {
                        ApplicationArea = All;
                    }
                    field("e-Commerce Operator"; "e-Commerce Operator")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Income Tax")
                {
                    CaptionML = ENU = 'Income Tax',
                                ENN = 'Income Tax';
                    field("P.A.N. No."; "P.A.N. No.")
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                    }
                    field("P.A.N. Status"; "P.A.N. Status")
                    {
                        ApplicationArea = All;
                    }
                    field("P.A.N. Reference No."; "P.A.N. Reference No.")
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'P.A.N. Reference No.',
                                    ENN = 'P.A.N. Reference No.';
                    }
                }

            }
        }
        area(factboxes)
        {
            part(FIN; 5360)
            {
                SubPageLink = "No." = FIELD("No.");
                Visible = CRMIsCoupledToRecord;
            }
            part(FIN1; 875)
            {
                SubPageLink = "Source Type" = CONST(Customer),
                              "Source No." = FIELD("No.");
                Visible = SocialListeningVisible;
            }
            part(FIN2; 876)
            {
                SubPageLink = "Source Type" = CONST(Customer),
                              "Source No." = FIELD("No.");
                UpdatePropagation = Both;
                Visible = SocialListeningSetupVisible;
            }
            part(FIN3; 9080)
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = true;
            }
            part(FIN4; 9081)
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            part(FIN5; 9082)
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = true;
            }
            part(FIN6; 9083)
            {
                SubPageLink = "Table ID" = CONST(18),
                              "No." = FIELD("No.");
                Visible = false;
            }
            part(Sys1; 9085)
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            part(Sys2; 9086)
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            part(WorkflowStatus; 1528)
            {
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(Sys3; Links)
            {
                Visible = true;
            }
            systempart(Sys4; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Customer")
            {
                CaptionML = ENU = '&Customer',
                            ENN = '&Customer';
                Image = Customer;
                action(Dimensions)
                {
                    CaptionML = ENU = 'Dimensions',
                                ENN = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(18),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("Bank Accounts")
                {
                    CaptionML = ENU = 'Bank Accounts',
                                ENN = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page 424;
                    RunPageLink = "Customer No." = FIELD("No.");
                }
                action("PDC Cheques")
                {
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page 50067;
                    RunPageLink = "Cust.Code" = FIELD("No.");
                }
                action("Direct Debit Mandates")
                {
                    CaptionML = ENU = 'Direct Debit Mandates',
                                ENN = 'Direct Debit Mandates';
                    Image = MakeAgreement;
                    RunObject = Page 1230;
                    RunPageLink = "Customer No." = FIELD("No.");
                }
                action("Ship-&to Addresses")
                {
                    CaptionML = ENU = 'Ship-&to Addresses',
                                ENN = 'Ship-&to Addresses';
                    Image = ShipAddress;
                    RunObject = Page 301;
                    RunPageLink = "Customer No." = FIELD("No.");
                }
                action("C&ontact")
                {
                    AccessByPermission = TableData 5050 = R;
                    CaptionML = ENU = 'C&ontact',
                                ENN = 'C&ontact';
                    Image = ContactPerson;

                    trigger OnAction();
                    begin
                        ShowContact;
                    end;
                }
                action("Cross Re&ferences")
                {
                    CaptionML = ENU = 'Cross Re&ferences',
                                ENN = 'Cross Re&ferences';
                    Image = Change;
                    RunObject = Page 5723;
                    RunPageLink = "Cross-Reference Type" = CONST(Customer),
                                  "Cross-Reference Type No." = FIELD("No.");
                    RunPageView = SORTING("Cross-Reference Type", "Cross-Reference Type No.");
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                ENN = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST(Customer),
                                  "No." = FIELD("No.");
                }
                action(ApprovalEntries)
                {
                    CaptionML = ENU = 'Approvals',
                                ENN = 'Approvals';
                    Image = Approvals;

                    trigger OnAction();
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(RECORDID);
                    end;
                }
                action("Online Map")
                {
                    CaptionML = ENU = 'Online Map',
                                ENN = 'Online Map';
                    Image = Map;

                    trigger OnAction();
                    begin
                        DisplayMap;
                    end;
                }
                action(CustomerReportSelections)
                {
                    CaptionML = ENU = 'Document Layouts',
                                ENN = 'Document Layouts';
                    Image = Quote;

                    trigger OnAction();
                    var
                        CustomReportSelection: Record 9657;
                    begin
                        CustomReportSelection.SETRANGE("Source Type", DATABASE::Customer);
                        CustomReportSelection.SETRANGE("Source No.", "No.");
                        PAGE.RUNMODAL(PAGE::"Customer Report Selections", CustomReportSelection);
                    end;
                }
                // action("e-Commerce Merchant Id")
                // {
                //     CaptionML = ENU = 'e-Commerce Merchant Id',
                //                 ENN = 'e-Commerce Merchant Id';
                //     RunObject = Page 16423;
                //     RunPageLink = "Customer No." = FIELD("No.");
                // }
                action("License Details")
                {
                    Promoted = true;
                    RunObject = Page 50128;
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = ORDER(Ascending);
                }
            }
            group(ActionGroupCRM)
            {
                CaptionML = ENU = 'Dynamics CRM',
                            ENN = 'Dynamics CRM';
                Visible = CRMIntegrationEnabled;
                action(CRMGotoAccount)
                {
                    CaptionML = ENU = 'Account',
                                ENN = 'Account';
                    Image = CoupledCustomer;
                    ToolTipML = ENU = 'Open the coupled Microsoft Dynamics CRM account.',
                                ENN = 'Open the coupled Microsoft Dynamics CRM account.';

                    trigger OnAction();
                    var
                        CRMIntegrationManagement: Codeunit 5330;
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(RECORDID);
                    end;
                }
                action(CRMSynchronizeNow)
                {
                    AccessByPermission = TableData 5331 = IM;
                    CaptionML = ENU = 'Synchronize Now',
                                ENN = 'Synchronize Now';
                    Image = Refresh;
                    ToolTipML = ENU = 'Send or get updated data to or from Microsoft Dynamics CRM.',
                                ENN = 'Send or get updated data to or from Microsoft Dynamics CRM.';

                    trigger OnAction();
                    var
                        CRMIntegrationManagement: Codeunit 5330;
                    begin
                        CRMIntegrationManagement.UpdateOneNow(RECORDID);
                    end;
                }
                action(UpdateStatisticsInCRM)
                {
                    CaptionML = ENU = 'Update Account Statistics',
                                ENN = 'Update Account Statistics';
                    Enabled = CRMIsCoupledToRecord;
                    Image = UpdateXML;
                    ToolTipML = ENU = 'Send Customer Statistics data to Microsoft Dynamics CRM to update the Account Statistics factbox',
                                ENN = 'Send Customer Statistics data to Microsoft Dynamics CRM to update the Account Statistics factbox';

                    trigger OnAction();
                    var
                        CRMIntegrationManagement: Codeunit 5330;
                    begin
                        CRMIntegrationManagement.CreateOrUpdateCRMAccountStatistics(Rec);
                    end;
                }
                group(Coupling)
                {
                    CaptionML = Comment = 'Coupling is a noun',
                                ENU = 'Coupling',
                                ENN = 'Coupling';
                    Image = LinkAccount;
                    ToolTipML = ENU = 'Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Microsoft Dynamics CRM record.',
                                ENN = 'Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Microsoft Dynamics CRM record.';
                    action(ManageCRMCoupling)
                    {
                        AccessByPermission = TableData 5331 = IM;
                        CaptionML = ENU = 'Set Up Coupling',
                                    ENN = 'Set Up Coupling';
                        Image = LinkAccount;
                        ToolTipML = ENU = 'Create or modify the coupling to a Microsoft Dynamics CRM account.',
                                    ENN = 'Create or modify the coupling to a Microsoft Dynamics CRM account.';

                        trigger OnAction();
                        var
                            CRMIntegrationManagement: Codeunit 5330;
                        begin
                            //CRMIntegrationManagement.CreateOrUpdateCoupling(RECORDID);
                        end;
                    }
                    action(DeleteCRMCoupling)
                    {
                        AccessByPermission = TableData 5331 = IM;
                        CaptionML = ENU = 'Delete Coupling',
                                    ENN = 'Delete Coupling';
                        Enabled = CRMIsCoupledToRecord;
                        Image = UnLinkAccount;
                        ToolTipML = ENU = 'Delete the coupling to a Microsoft Dynamics CRM account.',
                                    ENN = 'Delete the coupling to a Microsoft Dynamics CRM account.';

                        trigger OnAction();
                        var
                            CRMCouplingManagement: Codeunit 5331;
                        begin
                            CRMCouplingManagement.RemoveCoupling(RECORDID);
                        end;
                    }
                }
            }
            group(History)
            {
                CaptionML = ENU = 'History',
                            ENN = 'History';
                Image = History;
                action("Ledger E&ntries")
                {
                    CaptionML = ENU = 'Ledger E&ntries',
                                ENN = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 25;
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = SORTING("Customer No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action(Statistics)
                {
                    CaptionML = ENU = 'Statistics',
                                ENN = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 151;
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                }
                action("S&ales")
                {
                    CaptionML = ENU = 'S&ales',
                                ENN = 'S&ales';
                    Image = Sales;
                    RunObject = Page 155;
                    RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                }
                action("Entry Statistics")
                {
                    CaptionML = ENU = 'Entry Statistics',
                                ENN = 'Entry Statistics';
                    Image = EntryStatistics;
                    RunObject = Page 302;
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                }
                action("Statistics by C&urrencies")
                {
                    CaptionML = ENU = 'Statistics by C&urrencies',
                                ENN = 'Statistics by C&urrencies';
                    Image = Currencies;
                    RunObject = Page 486;
                    RunPageLink = "Customer Filter" = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "Date Filter" = FIELD("Date Filter");
                }
                action("Item &Tracking Entries")
                {
                    CaptionML = ENU = 'Item &Tracking Entries',
                                ENN = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction();
                    var
                        ItemTrackingDocMgt: Codeunit 6503;
                    begin
                        ItemTrackingDocMgt.ShowItemTrackingForMasterData(1, "No.", '', '', '', '', '');
                    end;
                }
                separator(Action001)
                {
                }
            }
            group("S&ales1")
            {
                CaptionML = ENU = 'S&ales',
                            ENN = 'S&ales';
                Image = Sales;
                // action(Items)
                // {
                //     CaptionML = ENU = 'Items',
                //                 ENN = 'Items';
                //     Image = Item;
                //     RunObject = Page 114;
                //     RunPageLink = "Vendor/Customer No." = FIELD("No.");
                //     RunPageView = SORTING("Vendor/Customer No.", "Item No.");
                // }
                action("Invoice &Discounts")
                {
                    CaptionML = ENU = 'Invoice &Discounts',
                                ENN = 'Invoice &Discounts';
                    Image = CalculateInvoiceDiscount;
                    RunObject = Page 23;
                    RunPageLink = Code = FIELD("Invoice Disc. Code");
                }
                action(Prices)
                {
                    CaptionML = ENU = 'Prices',
                                ENN = 'Prices';
                    Image = Price;
                    RunObject = Page 7002;
                    RunPageLink = "Sales Type" = CONST(Customer),
                                  "Sales Code" = FIELD("No.");
                    RunPageView = SORTING("Sales Type", "Sales Code");
                }
                action("Line Discounts")
                {
                    CaptionML = ENU = 'Line Discounts',
                                ENN = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page 7004;
                    RunPageLink = "Sales Type" = CONST(Customer),
                                  "Sales Code" = FIELD("No.");
                    RunPageView = SORTING("Sales Type", "Sales Code");
                }
                action("Prepa&yment Percentages")
                {
                    CaptionML = ENU = 'Prepa&yment Percentages',
                                ENN = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page 664;
                    RunPageLink = "Sales Type" = CONST(Customer),
                                  "Sales Code" = FIELD("No.");
                    RunPageView = SORTING("Sales Type", "Sales Code");
                }
                action("S&td. Cust. Sales Codes")
                {
                    CaptionML = ENU = 'S&td. Cust. Sales Codes',
                                ENN = 'S&td. Cust. Sales Codes';
                    Image = CodesList;
                    RunObject = Page 173;
                    RunPageLink = "Customer No." = FIELD("No.");
                }
            }
            group(Documents)
            {
                CaptionML = ENU = 'Documents',
                            ENN = 'Documents';
                Image = Documents;
                action(Quotes)
                {
                    CaptionML = ENU = 'Quotes',
                                ENN = 'Quotes';
                    Image = Quote;
                    RunObject = Page 9300;
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Sell-to Customer No.");
                }
                action(Orders)
                {
                    CaptionML = ENU = 'Orders',
                                ENN = 'Orders';
                    Image = Document;
                    RunObject = Page 9305;
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Sell-to Customer No.");
                }
                action("Return Orders")
                {
                    CaptionML = ENU = 'Return Orders',
                                ENN = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page 9304;
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Sell-to Customer No.");
                }
                group("Issued Documents")
                {
                    CaptionML = ENU = 'Issued Documents',
                                ENN = 'Issued Documents';
                    Image = Documents;
                    action("Issued &Reminders")
                    {
                        CaptionML = ENU = 'Issued &Reminders',
                                    ENN = 'Issued &Reminders';
                        Image = OrderReminder;
                        RunObject = Page 440;
                        RunPageLink = "Customer No." = FIELD("No.");
                        RunPageView = SORTING("Customer No.", "Posting Date");
                    }
                    action("Issued &Finance Charge Memos")
                    {
                        CaptionML = ENU = 'Issued &Finance Charge Memos',
                                    ENN = 'Issued &Finance Charge Memos';
                        Image = FinChargeMemo;
                        RunObject = Page 452;
                        RunPageLink = "Customer No." = FIELD("No.");
                        RunPageView = SORTING("Customer No.", "Posting Date");
                    }
                }
                action("Blanket Orders")
                {
                    CaptionML = ENU = 'Blanket Orders',
                                ENN = 'Blanket Orders';
                    Image = BlanketOrder;
                    RunObject = Page 9303;
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Sell-to Customer No.");
                }
                action("&Jobs")
                {
                    CaptionML = ENU = '&Jobs',
                                ENN = '&Jobs';
                    Image = Job;
                    RunObject = Page 89;
                    RunPageLink = "Bill-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Bill-to Customer No.");
                }
            }
            group("Credit Card")
            {
                CaptionML = ENU = 'Credit Card',
                            ENN = 'Credit Card';
                Image = CreditCard;
                group("Credit Cards")
                {
                    CaptionML = ENU = 'Credit Cards',
                                ENN = 'Credit Cards';
                    Image = CreditCard;
                    // action("C&redit Cards")
                    // {
                    //     CaptionML = ENU = 'C&redit Cards',
                    //                 ENN = 'C&redit Cards';
                    //     Image = CreditCard;
                    //     RunObject = Page 828;
                    //     RunPageLink = "Customer No." = FIELD("No.");
                    // }
                    // action("Credit Cards Transaction Lo&g Entries")
                    // {
                    //     CaptionML = ENU = 'Credit Cards Transaction Lo&g Entries',
                    //                 ENN = 'Credit Cards Transaction Lo&g Entries';
                    //     Image = CreditCardLog;
                    //     RunObject = Page 829;
                    //     RunPageLink = "Customer No." = FIELD("No.");
                    // }
                }
            }
            group(Service)
            {
                CaptionML = ENU = 'Service',
                            ENN = 'Service';
                Image = ServiceItem;
                action("Service Orders")
                {
                    CaptionML = ENU = 'Service Orders',
                                ENN = 'Service Orders';
                    Image = Document;
                    RunObject = Page 9318;
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Customer No.");
                }
                action("Ser&vice Contracts")
                {
                    CaptionML = ENU = 'Ser&vice Contracts',
                                ENN = 'Ser&vice Contracts';
                    Image = ServiceAgreement;
                    RunObject = Page 6065;
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = SORTING("Customer No.", "Ship-to Code");
                }
                action("Service &Items")
                {
                    CaptionML = ENU = 'Service &Items',
                                ENN = 'Service &Items';
                    Image = ServiceItem;
                    RunObject = Page 5988;
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = SORTING("Customer No.", "Ship-to Code", "Item No.", "Serial No.");
                }
            }
        }
        area(creation)
        {
            action(NewBlanketSalesOrder)
            {
                CaptionML = ENU = 'Blanket Sales Order',
                            ENN = 'Blanket Sales Order';
                Image = BlanketOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 507;
                RunPageLink = "Sell-to Customer No." = FIELD("No.");
                RunPageMode = Create;
            }
            action(NewSalesQuote)
            {
                CaptionML = ENU = 'Sales Quote',
                            ENN = 'Sales Quote';
                Image = Quote;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 41;
                RunPageLink = "Sell-to Customer No." = FIELD("No.");
                RunPageMode = Create;
            }
            action(NewSalesInvoice)
            {
                CaptionML = ENU = 'Sales Invoice',
                            ENN = 'Sales Invoice';
                Image = Invoice;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page 43;
                RunPageLink = "Sell-to Customer No." = FIELD("No.");
                RunPageMode = Create;
            }
            action(NewSalesOrder)
            {
                CaptionML = ENU = 'Sales Order',
                            ENN = 'Sales Order';
                Image = Document;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page 42;
                RunPageLink = "Sell-to Customer No." = FIELD("No.");
                RunPageMode = Create;
            }
            action(NewSalesCreditMemo)
            {
                CaptionML = ENU = 'Sales Credit Memo',
                            ENN = 'Sales Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 44;
                RunPageLink = "Sell-to Customer No." = FIELD("No.");
                RunPageMode = Create;
            }
            action(NewSalesReturnOrder)
            {
                CaptionML = ENU = 'Sales Return Order',
                            ENN = 'Sales Return Order';
                Image = ReturnOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 6630;
                RunPageLink = "Sell-to Customer No." = FIELD("No.");
                RunPageMode = Create;
            }
            action("Service Quote")
            {
                CaptionML = ENU = 'Service Quote',
                            ENN = 'Service Quote';
                Image = Quote;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 5964;
                RunPageLink = "Customer No." = FIELD("No.");
                RunPageMode = Create;
            }
            action("Service Invoice")
            {
                CaptionML = ENU = 'Service Invoice',
                            ENN = 'Service Invoice';
                Image = Invoice;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 5933;
                RunPageLink = "Customer No." = FIELD("No.");
                RunPageMode = Create;
            }
            action("Service Order")
            {
                CaptionML = ENU = 'Service Order',
                            ENN = 'Service Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 5900;
                RunPageLink = "Customer No." = FIELD("No.");
                RunPageMode = Create;
            }
            action("Service Credit Memo")
            {
                CaptionML = ENU = 'Service Credit Memo',
                            ENN = 'Service Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 5935;
                RunPageLink = "Customer No." = FIELD("No.");
                RunPageMode = Create;
            }
            action(Reminder)
            {
                CaptionML = ENU = 'Reminder',
                            ENN = 'Reminder';
                Image = Reminder;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page 434;
                RunPageLink = "Customer No." = FIELD("No.");
                RunPageMode = Create;
            }
            action("Finance Charge Memo")
            {
                CaptionML = ENU = 'Finance Charge Memo',
                            ENN = 'Finance Charge Memo';
                Image = FinChargeMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = New;
                RunObject = Page 446;
                RunPageLink = "Customer No." = FIELD("No.");
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            group(Approval)
            {
                CaptionML = ENU = 'Approval',
                            ENN = 'Approval';
                action(Approve)
                {
                    CaptionML = ENU = 'Approve',
                                ENN = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Reject)
                {
                    CaptionML = ENU = 'Reject',
                                ENN = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Delegate)
                {
                    CaptionML = ENU = 'Delegate',
                                ENN = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                    end;
                }
            }
            group("Request Approval")
            {
                CaptionML = ENU = 'Request Approval',
                            ENN = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    CaptionML = ENU = 'Send A&pproval Request',
                                ENN = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        IF ApprovalsMgmt.CheckCustomerApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmt.OnSendCustomerForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    CaptionML = ENU = 'Cancel Approval Re&quest',
                                ENN = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        ApprovalsMgmt.OnCancelCustomerApprovalRequest(Rec);
                    end;
                }
            }
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions',
                            ENN = 'F&unctions';
                Image = "Action";
                action("Apply Template")
                {
                    CaptionML = ENU = 'Apply Template',
                                ENN = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        ConfigTemplateMgt: Codeunit 8612;
                        RecRef: RecordRef;
                    begin
                        RecRef.GETTABLE(Rec);
                        ConfigTemplateMgt.UpdateFromTemplateSelection(RecRef);
                    end;
                }
            }
            action("Cash Receipt Journal")
            {
                CaptionML = ENU = 'Cash Receipt Journal',
                            ENN = 'Cash Receipt Journal';
                Image = CashReceiptJournal;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 255;
            }
            action("Sales Journal")
            {
                CaptionML = ENU = 'Sales Journal',
                            ENN = 'Sales Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 253;
            }
        }
        area(reporting)
        {
            action("Customer Detailed Aging")
            {
                CaptionML = ENU = 'Customer Detailed Aging',
                            ENN = 'Customer Detailed Aging';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 106;
            }
            action("Customer - Labels")
            {
                CaptionML = ENU = 'Customer - Labels',
                            ENN = 'Customer - Labels';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 110;
            }
            action("Customer - Balance to Date")
            {
                CaptionML = ENU = 'Customer - Balance to Date',
                            ENN = 'Customer - Balance to Date';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 121;
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    var
        CRMCouplingManagement: Codeunit 5331;
    begin
        ActivateFields;
        StyleTxt := SetStyle;
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
        CRMIsCoupledToRecord := CRMIntegrationEnabled AND CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
    end;

    trigger OnAfterGetRecord();
    begin
        ActivateFields;
        StyleTxt := SetStyle;
    end;

    trigger OnInit();
    begin
        ContactEditable := TRUE;
        MapPointVisible := TRUE;
    end;

    trigger OnOpenPage();
    var
        MapMgt: Codeunit 802;
        CRMIntegrationManagement: Codeunit 5330;
    begin
        ActivateFields;

        IF NOT MapMgt.TestSetup THEN
            MapPointVisible := FALSE;

        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        //CCIT-SG-21062018
        //TESTFIELD(Structure);
        TESTFIELD("Location Code");
        //CCIT-SG-21062018
    end;

    var
        CustomizedCalEntry: Record 7603;
        CustomizedCalendar: Record 7602;
        CalendarMgmt: Codeunit 7600;
        ApprovalsMgmt: Codeunit 1535;
        StyleTxt: Text;
        [InDataSet]
        MapPointVisible: Boolean;
        [InDataSet]
        ContactEditable: Boolean;
        [InDataSet]
        SocialListeningSetupVisible: Boolean;
        [InDataSet]
        SocialListeningVisible: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;

    local procedure ActivateFields();
    begin
        SetSocialListeningFactboxVisibility;
        ContactEditable := "Primary Contact No." = '';
    end;

    local procedure ContactOnAfterValidate();
    begin
        ActivateFields;
    end;

    local procedure SetSocialListeningFactboxVisibility();
    var
        SocialListeningMgt: Codeunit 871;
    begin
        SocialListeningMgt.GetCustFactboxVisibility(Rec, SocialListeningSetupVisible, SocialListeningVisible);
    end;
}

