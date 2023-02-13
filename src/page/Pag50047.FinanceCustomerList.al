page 50047 "Finance_Customer List"
{
    // version NAVW19.00.00.48466,CCIT-Fortune

    CaptionML = ENU = 'Customer List',
                ENN = 'Customer List';
    CardPageID = "Finance_Customers Card";
    Editable = false;
    PageType = List;
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approve',
                                 ENN = 'New,Process,Report,Approve';
    SourceTable = Customer;
    ApplicationArea = all;
    UsageCategory = lists;

    layout
    {
        area(content)
        {
            repeater(Group001)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
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
                field(City; City)
                {
                    ApplicationArea = All;
                }


                field("Responsibility Center"; "Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; "Post Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Fax No."; "Fax No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("IC Partner Code"; "IC Partner Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Sales Person Name"; "Sales Person Name")
                {
                    ApplicationArea = All;
                }
                field("Customer Posting Group"; "Customer Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Outlet Area"; "Outlet Area")
                {
                    ApplicationArea = All;
                }
                field("Business Format / Outlet Name"; "Business Format / Outlet Name")
                {
                    ApplicationArea = All;
                }
                field("Customer Price Group"; "Customer Price Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Customer Disc. Group"; "Customer Disc. Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Reminder Terms Code"; "Reminder Terms Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Fin. Charge Terms Code"; "Fin. Charge Terms Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Language Code"; "Language Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Net Change"; "Net Change")
                {
                    ApplicationArea = All;
                }
                field("Net Change (LCY)"; "Net Change (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Search Name"; "Search Name")
                {
                    ApplicationArea = All;
                }
                field(Balance; Balance)
                {
                    ApplicationArea = All;
                }
                field("Credit Limit (LCY)"; "Credit Limit (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Application Method"; "Application Method")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Combine Shipments"; "Combine Shipments")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Reserve; Reserve)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shipping Advice"; "Shipping Advice")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("EAN Code"; "EAN Code")
                {
                    ApplicationArea = All;
                }
                field("State Code"; "State Code")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Base Calendar Code"; "Base Calendar Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Telex No."; "Telex No.")
                {
                    ApplicationArea = All;
                }
                field("Document Sending Profile"; "Document Sending Profile")
                {
                    ApplicationArea = All;
                }
                field("Our Account No."; "Our Account No.")
                {
                    ApplicationArea = All;
                }
                field("Territory Code"; "Territory Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Chain Name"; "Chain Name")
                {
                    ApplicationArea = All;
                }
                field("Budgeted Amount"; "Budgeted Amount")
                {
                    ApplicationArea = All;
                }
                field("Statistics Group"; "Statistics Group")
                {
                    ApplicationArea = All;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Place of Export"; "Place of Export")
                {
                    ApplicationArea = All;
                }
                field("Invoice Disc. Code"; "Invoice Disc. Code")
                {
                    ApplicationArea = All;
                }
                field("Collection Method"; "Collection Method")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                }
                field("Invoice Copies"; "Invoice Copies")
                {
                    ApplicationArea = All;
                }
                field("Last Statement No."; "Last Statement No.")
                {
                    ApplicationArea = All;
                }
                field("Print Statements"; "Print Statements")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field(Priority; Priority)
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Date Filter"; "Date Filter")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Filter"; "Global Dimension 1 Filter")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Filter"; "Global Dimension 2 Filter")
                {
                    ApplicationArea = All;
                }

                field("Sales (LCY)"; "Sales (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Profit (LCY)"; "Profit (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Inv. Discounts (LCY)"; "Inv. Discounts (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Pmt. Discounts (LCY)"; "Pmt. Discounts (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Balance Due"; "Balance Due")
                {
                    ApplicationArea = All;
                }
                field("Balance Due (LCY)"; "Balance Due (LCY)")
                {
                    ApplicationArea = All;
                }
                field(Payments; Payments)
                {
                    ApplicationArea = All;
                }
                field("Invoice Amounts"; "Invoice Amounts")
                {
                    ApplicationArea = All;
                }
                field("Cr. Memo Amounts"; "Cr. Memo Amounts")
                {
                    ApplicationArea = All;
                }
                field("Finance Charge Memo Amounts"; "Finance Charge Memo Amounts")
                {
                    ApplicationArea = All;
                }
                field("Payments (LCY)"; "Payments (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Inv. Amounts (LCY)"; "Inv. Amounts (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Cr. Memo Amounts (LCY)"; "Cr. Memo Amounts (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Fin. Charge Memo Amounts (LCY)"; "Fin. Charge Memo Amounts (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Orders"; "Outstanding Orders")
                {
                    ApplicationArea = All;
                }
                field("Shipped Not Invoiced"; "Shipped Not Invoiced")
                {
                    ApplicationArea = All;
                }
                field("Prices Including VAT"; "Prices Including VAT")
                {
                    ApplicationArea = All;
                }
                field("Telex Answer Back"; "Telex Answer Back")
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = All;
                }
                // field(Picture; Picture)
                // {
                //     ApplicationArea = All;
                // }
                field(GLN; GLN)
                {
                    ApplicationArea = All;
                }
                field(County; County)
                {
                    ApplicationArea = All;
                }
                field("Debit Amount"; "Debit Amount")
                {
                    ApplicationArea = All;
                }
                field("Credit Amount"; "Credit Amount")
                {
                    ApplicationArea = All;
                }
                field("Debit Amount (LCY)"; "Debit Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Credit Amount (LCY)"; "Credit Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Home Page"; "Home Page")
                {
                    ApplicationArea = All;
                }
                field("Reminder Amounts"; "Reminder Amounts")
                {
                    ApplicationArea = All;
                }
                field("Reminder Amounts (LCY)"; "Reminder Amounts (LCY)")
                {
                    ApplicationArea = All;
                }
                field("No. Series"; "No. Series")
                {
                    ApplicationArea = All;
                }
                field("Tax Area Code"; "Tax Area Code")
                {
                    ApplicationArea = All;
                }
                field("Tax Liable"; "Tax Liable")
                {
                    ApplicationArea = All;
                }
                field("Currency Filter"; "Currency Filter")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Orders (LCY)"; "Outstanding Orders (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Shipped Not Invoiced (LCY)"; "Shipped Not Invoiced (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Block Payment Tolerance"; "Block Payment Tolerance")
                {
                    ApplicationArea = All;
                }
                field("Pmt. Disc. Tolerance (LCY)"; "Pmt. Disc. Tolerance (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Pmt. Tolerance (LCY)"; "Pmt. Tolerance (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Refunds (LCY)"; "Refunds (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Other Amounts"; "Other Amounts")
                {
                    ApplicationArea = All;
                }
                field("Other Amounts (LCY)"; "Other Amounts (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Prepayment %"; "Prepayment %")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Invoices (LCY)"; "Outstanding Invoices (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Invoices"; "Outstanding Invoices")
                {
                    ApplicationArea = All;
                }
                field("Bill-to No. Of Archived Doc."; "Bill-to No. Of Archived Doc.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to No. Of Archived Doc."; "Sell-to No. Of Archived Doc.")
                {
                    ApplicationArea = All;
                }
                field("Partner Type"; "Partner Type")
                {
                    ApplicationArea = All;
                }

                field("Cash Flow Payment Terms Code"; "Cash Flow Payment Terms Code")
                {
                    ApplicationArea = All;
                }
                field("Primary Contact No."; "Primary Contact No.")
                {
                    ApplicationArea = All;
                }
                field("Shipping Time"; "Shipping Time")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Service Code"; "Shipping Agent Service Code")
                {
                    ApplicationArea = All;
                }
                field("Service Zone Code"; "Service Zone Code")
                {
                    ApplicationArea = All;
                }
                field("Contract Gain/Loss Amount"; "Contract Gain/Loss Amount")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Filter"; "Ship-to Filter")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Serv. Orders (LCY)"; "Outstanding Serv. Orders (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Serv Shipped Not Invoiced(LCY)"; "Serv Shipped Not Invoiced(LCY)")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Serv.Invoices(LCY)"; "Outstanding Serv.Invoices(LCY)")
                {
                    ApplicationArea = All;
                }
                field("Allow Line Disc."; "Allow Line Disc.")
                {
                    ApplicationArea = All;
                }
                field("No. of Quotes"; "No. of Quotes")
                {
                    ApplicationArea = All;
                }
                field("No. of Blanket Orders"; "No. of Blanket Orders")
                {
                    ApplicationArea = All;
                }
                field("No. of Orders"; "No. of Orders")
                {
                    ApplicationArea = All;
                }
                field("No. of Invoices"; "No. of Invoices")
                {
                    ApplicationArea = All;
                }
                field("No. of Return Orders"; "No. of Return Orders")
                {
                    ApplicationArea = All;
                }
                field("No. of Credit Memos"; "No. of Credit Memos")
                {
                    ApplicationArea = All;
                }
                field("No. of Pstd. Shipments"; "No. of Pstd. Shipments")
                {
                    ApplicationArea = All;
                }
                field("No. of Pstd. Invoices"; "No. of Pstd. Invoices")
                {
                    ApplicationArea = All;
                }
                field("No. of Pstd. Return Receipts"; "No. of Pstd. Return Receipts")
                {
                    ApplicationArea = All;
                }
                field("No. of Pstd. Credit Memos"; "No. of Pstd. Credit Memos")
                {
                    ApplicationArea = All;
                }
                field("No. of Ship-to Addresses"; "No. of Ship-to Addresses")
                {
                    ApplicationArea = All;
                }
                field("Bill-To No. of Quotes"; "Bill-To No. of Quotes")
                {
                    ApplicationArea = All;
                }
                field("Bill-To No. of Blanket Orders"; "Bill-To No. of Blanket Orders")
                {
                    ApplicationArea = All;
                }
                field("Bill-To No. of Orders"; "Bill-To No. of Orders")
                {
                    ApplicationArea = All;
                }
                field("Bill-To No. of Invoices"; "Bill-To No. of Invoices")
                {
                    ApplicationArea = All;
                }
                field("Bill-To No. of Return Orders"; "Bill-To No. of Return Orders")
                {
                    ApplicationArea = All;
                }
                field("Bill-To No. of Credit Memos"; "Bill-To No. of Credit Memos")
                {
                    ApplicationArea = All;
                }
                field("Bill-To No. of Pstd. Shipments"; "Bill-To No. of Pstd. Shipments")
                {
                    ApplicationArea = All;
                }
                field("Bill-To No. of Pstd. Invoices"; "Bill-To No. of Pstd. Invoices")
                {
                    ApplicationArea = All;
                }
                field("Bill-To No. of Pstd. Return R."; "Bill-To No. of Pstd. Return R.")
                {
                    ApplicationArea = All;
                }
                field("Bill-To No. of Pstd. Cr. Memos"; "Bill-To No. of Pstd. Cr. Memos")
                {
                    ApplicationArea = All;
                }
                field("Copy Sell-to Addr. to Qte From"; "Copy Sell-to Addr. to Qte From")
                {
                    ApplicationArea = All;
                }

                field("Route Days Applicable"; "Route Days Applicable")
                {
                    ApplicationArea = All;
                }
                field(Sunday; Sunday)
                {
                    ApplicationArea = All;
                }
                field(Monday; Monday)
                {
                    ApplicationArea = All;
                }
                field(Tuesday; Tuesday)
                {
                    ApplicationArea = All;
                }
                field(Wednesday; Wednesday)
                {
                    ApplicationArea = All;
                }
                field(Thursday; Thursday)
                {
                    ApplicationArea = All;
                }
                field(Friday; Friday)
                {
                    ApplicationArea = All;
                }
                field(Saturday; Saturday)
                {
                    ApplicationArea = All;
                }
                field("Contact No.(Sales)"; "Contact No.(Sales)")
                {
                    ApplicationArea = All;
                }
                field("Contact No.(Purchase)"; "Contact No.(Purchase)")
                {
                    ApplicationArea = All;
                }
                field("Contact No.(Accounts)"; "Contact No.(Accounts)")
                {
                    ApplicationArea = All;
                }
                field("Sales E-Mail"; "Sales E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Purchase E-Mail"; "Purchase E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Accounts E-Mail"; "Accounts E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Address 3"; "Address 3")
                {
                    ApplicationArea = All;
                }
                field("Address 4"; "Address 4")
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
                field("Responsible Collection Person"; "Responsible Collection Person")
                {
                    ApplicationArea = All;
                }
                field("BOND Dispatch"; "BOND Dispatch")
                {
                    ApplicationArea = All;
                }
                field("Duty Free"; "Duty Free")
                {
                    ApplicationArea = All;
                }
                field("Customer Category"; "Customer Category")
                {
                    ApplicationArea = All;
                }
                field("Sales Reporting Field"; "Sales Reporting Field")
                {
                    ApplicationArea = All;
                }
                field(Referance; Referance)
                {
                    ApplicationArea = All;
                }
                field("Minimum Shelf Life %"; "Minimum Shelf Life %")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(sys; 5360)
            {
                SubPageLink = "No." = FIELD("No.");
                Visible = CRMIsCoupledToRecord;
            }
            part(sys1; 875)
            {
                SubPageLink = "Source Type" = CONST(Customer),
                              "Source No." = FIELD("No.");
                Visible = SocialListeningVisible;
            }
            part(sys2; 876)
            {
                SubPageLink = "Source Type" = CONST(Customer),
                              "Source No." = FIELD("No.");
                UpdatePropagation = Both;
                Visible = SocialListeningSetupVisible;
            }
            part(sys3; 9080)
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = true;
            }
            part(sys4; 9081)
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            part(sys5; 9082)
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = true;
            }
            part(sys6; 9084)
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            part(sys7; 9085)
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            part(sys8; 9086)
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            systempart(sys9; Links)
            {
                Visible = true;
            }
            systempart(sys10; Notes)
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
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                ENN = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST(Customer),
                                  "No." = FIELD("No.");
                }
                group(Dimensions)
                {
                    CaptionML = ENU = 'Dimensions',
                                ENN = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        CaptionML = ENU = 'Dimensions-Single',
                                    ENN = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(18),
                                      "No." = FIELD("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData 348 = R;
                        CaptionML = ENU = 'Dimensions-&Multiple',
                                    ENN = 'Dimensions-&Multiple';
                        Image = DimensionSets;

                        trigger OnAction();
                        var
                            Cust: Record 18;
                            DefaultDimMultiple: Page 542;
                        begin
                            CurrPage.SETSELECTIONFILTER(Cust);
                            //DefaultDimMultiple.SetMultiCust(Cust);
                            DefaultDimMultiple.RUNMODAL;
                        end;
                    }
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
                    Image = list;
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
                        Customer: Record 18;
                        CRMIntegrationManagement: Codeunit 5330;
                        CustomerRecordRef: RecordRef;
                    begin
                        CurrPage.SETSELECTIONFILTER(Customer);
                        Customer.NEXT;

                        IF Customer.COUNT = 1 THEN
                            CRMIntegrationManagement.UpdateOneNow(Customer.RECORDID)
                        ELSE BEGIN
                            CustomerRecordRef.GETTABLE(Customer);
                            CRMIntegrationManagement.UpdateMultipleNow(CustomerRecordRef);
                        END
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
                group(Create)
                {
                    CaptionML = ENU = 'Create',
                                ENN = 'Create';
                    Image = NewCustomer;
                    action(CreateInCRM)
                    {
                        CaptionML = ENU = 'Create Account in Dynamics CRM',
                                    ENN = 'Create Account in Dynamics CRM';
                        Image = NewCustomer;

                        trigger OnAction();
                        var
                            Customer: Record 18;
                            CRMIntegrationManagement: Codeunit 5330;
                            CustomerRecordRef: RecordRef;
                        begin
                            CurrPage.SETSELECTIONFILTER(Customer);
                            Customer.NEXT;
                            CustomerRecordRef.GETTABLE(Customer);
                            CRMIntegrationManagement.CreateNewRecordsInCRM(CustomerRecordRef);
                        end;
                    }
                    action(CreateFromCRM)
                    {
                        CaptionML = ENU = 'Create Customer in Dynamics NAV',
                                    ENN = 'Create Customer in Dynamics NAV';
                        Image = NewCustomer;

                        trigger OnAction();
                        var
                            CRMIntegrationManagement: Codeunit 5330;
                        begin
                            CRMIntegrationManagement.ManageCreateNewRecordFromCRM(DATABASE::Customer);
                        end;
                    }
                }
            }
            group(History)
            {
                CaptionML = ENU = 'History',
                            ENN = 'History';
                Image = History;
                action(CustomerLedgerEntries)
                {
                    CaptionML = ENU = 'Ledger E&ntries',
                                ENN = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Process;
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
            }
            group("S&ales1")
            {
                CaptionML = ENU = 'S&ales',
                            ENN = 'S&ales';
                Image = Sales;
                action(Sales_InvoiceDiscounts)
                {
                    CaptionML = ENU = 'Invoice &Discounts',
                                ENN = 'Invoice &Discounts';
                    Image = CalculateInvoiceDiscount;
                    RunObject = Page 23;
                    RunPageLink = Code = FIELD("Invoice Disc. Code");
                }
                action(Sales_Prices)
                {
                    CaptionML = ENU = 'Prices',
                                ENN = 'Prices';
                    Image = Price;
                    RunObject = Page 7002;
                    RunPageLink = "Sales Type" = CONST(Customer),
                                  "Sales Code" = FIELD("No.");
                    RunPageView = SORTING("Sales Type", "Sales Code");
                }
                action(Sales_LineDiscounts)
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
                action("License Details")
                {
                    Promoted = true;
                    RunObject = Page 50128;
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = ORDER(Ascending);
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
                    RunPageView = SORTING("Sell-to Customer No.");
                }
                action(Orders)
                {
                    CaptionML = ENU = 'Orders',
                                ENN = 'Orders';
                    Image = Document;
                    RunObject = Page 9305;
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Sell-to Customer No.");
                }
                action("Return Orders")
                {
                    CaptionML = ENU = 'Return Orders',
                                ENN = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page 9304;
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Sell-to Customer No.");
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
                    RunObject = Page "Service Orders";
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
            action("Blanket Sales Order")
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
            action("Sales Quote")
            {
                CaptionML = ENU = 'Sales Quote',
                            ENN = 'Sales Quote';
                Image = Quote;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page 41;
                RunPageLink = "Sell-to Customer No." = FIELD("No.");
                RunPageMode = Create;
            }
            action("Sales Invoice")
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
            action("Sales Order")
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
            action("Sales Credit Memo")
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
            action("Sales Return Order")
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

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        ApprovalsMgmt.OnCancelCustomerApprovalRequest(Rec);
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
            // action(Items)
            // {
            //     Caption = 'Items';
            //     Image = Item;
            //     RunObject = Page 114;
            //     RunPageLink = "Vendor/Customer No." = FIELD("No.");
            //     RunPageView = SORTING("Vendor/Customer No.");
            // }
        }
        area(reporting)
        {
            group(General)
            {
                CaptionML = ENU = 'General',
                            ENN = 'General';
                action("Customer List")
                {
                    CaptionML = ENU = 'Customer List',
                                ENN = 'Customer List';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 101;
                }
                action("Customer Register")
                {
                    CaptionML = ENU = 'Customer Register',
                                ENN = 'Customer Register';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 103;
                }
                action("Customer - Top 10 List")
                {
                    CaptionML = ENU = 'Customer - Top 10 List',
                                ENN = 'Customer - Top 10 List';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report 111;
                }
            }
            group(Sales)
            {
                CaptionML = ENU = 'Sales',
                            ENN = 'Sales';
                Image = Sales;
                action("Customer - Order Summary")
                {
                    CaptionML = ENU = 'Customer - Order Summary',
                                ENN = 'Customer - Order Summary';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report 107;
                }
                action("Customer - Order Detail")
                {
                    CaptionML = ENU = 'Customer - Order Detail',
                                ENN = 'Customer - Order Detail';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 108;
                }
                action("Customer - Sales List")
                {
                    CaptionML = ENU = 'Customer - Sales List',
                                ENN = 'Customer - Sales List';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report 119;
                }
                action("Sales Statistics")
                {
                    CaptionML = ENU = 'Sales Statistics',
                                ENN = 'Sales Statistics';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 112;
                }
                action("Customer/Item Sales")
                {
                    CaptionML = ENU = 'Customer/Item Sales',
                                ENN = 'Customer/Item Sales';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 113;
                }
            }
            group("Financial Management")
            {
                CaptionML = ENU = 'Financial Management',
                            ENN = 'Financial Management';
                Image = "Report";
                action("Customer - Detail Trial Bal.")
                {
                    CaptionML = ENU = 'Customer - Detail Trial Bal.',
                                ENN = 'Customer - Detail Trial Bal.';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 104;
                }
                action("Customer - Summary Aging")
                {
                    CaptionML = ENU = 'Customer - Summary Aging',
                                ENN = 'Customer - Summary Aging';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 105;
                }
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
                action(Statement)
                {
                    CaptionML = ENU = 'Statement',
                                ENN = 'Statement';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Codeunit 8810;
                }
                action(Reminder1)
                {
                    CaptionML = ENU = 'Reminder1',
                                ENN = 'Reminder1';
                    Image = Reminder;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 117;
                }
                action("Aged Accounts Receivable")
                {
                    CaptionML = ENU = 'Aged Accounts Receivable',
                                ENN = 'Aged Accounts Receivable';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report 120;
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
                action("Customer - Trial Balance")
                {
                    CaptionML = ENU = 'Customer - Trial Balance',
                                ENN = 'Customer - Trial Balance';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report 129;
                }
                action("Customer - Payment Receipt")
                {
                    CaptionML = ENU = 'Customer - Payment Receipt',
                                ENN = 'Customer - Payment Receipt';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report 211;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    var
        CRMCouplingManagement: Codeunit 5331;
    begin
        SetSocialListeningFactboxVisibility;

        CRMIsCoupledToRecord :=
          CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID) AND CRMIntegrationEnabled;
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
    end;

    trigger OnAfterGetRecord();
    begin
        SetSocialListeningFactboxVisibility;
    end;

    trigger OnOpenPage();
    var
        CRMIntegrationManagement: Codeunit 5330;
    begin
        RecuserSet.GET(USERID);
        IF RecuserSet."Finance Customer" = FALSE THEN BEGIN
            ERROR('You Do not Have Permision');
        END;//CCIT
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

        //CCIT-SG-05062018
        LocCode := '';
        RecUserBranch.RESET;
        RecUserBranch.SETRANGE(RecUserBranch."User ID", USERID);
        IF RecUserBranch.FINDFIRST THEN
            REPEAT
                //IF RecUserBranch."Location Code" <> '' THEN
                LocCode := LocCode + RecUserBranch."Location Code" + '|';
            UNTIL RecUserBranch.NEXT = 0;
        LocCodeText := DELSTR(LocCode, STRLEN(LocCode), 1);
        IF LocCodeText <> '' THEN BEGIN
            SETFILTER("Location Code", LocCodeText);
        END;
        IF LocCodeText <> '' THEN
            ClearHide := FALSE
        ELSE
            ClearHide := TRUE;
        //CCIT-SG-05062018
        //CCIT-SG
        IF RecUserSetup.GET(USERID) THEN BEGIN
            IF RecUserSetup.Location <> '' THEN BEGIN
                FILTERGROUP(2);
                SETRANGE("State Code", RecUserSetup.Location);
                FILTERGROUP(0);
            END;
        END;
        //CCIT-SG
    end;

    var
        RecuserSet: Record 91;
        ApprovalsMgmt: Codeunit 1535;
        SocialListeningSetupVisible: Boolean;
        SocialListeningVisible: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        OpenApprovalEntriesExist: Boolean;
        RecUserSetup: Record 91;
        LocCode: Code[1024];
        LocCodeText: Text[1024];
        ClearHide: Boolean;
        RecUserBranch: Record 50029;

    procedure GetSelectionFilter(): Text;
    var
        Cust: Record 18;
        SelectionFilterManagement: Codeunit 46;
    begin
        CurrPage.SETSELECTIONFILTER(Cust);
        EXIT(SelectionFilterManagement.GetSelectionFilterForCustomer(Cust));
    end;

    procedure SetSelection(var Cust: Record 18);
    begin
        CurrPage.SETSELECTIONFILTER(Cust);
    end;

    local procedure SetSocialListeningFactboxVisibility();
    var
        SocialListeningMgt: Codeunit 871;
    begin
        SocialListeningMgt.GetCustFactboxVisibility(Rec, SocialListeningSetupVisible, SocialListeningVisible);
    end;
}

