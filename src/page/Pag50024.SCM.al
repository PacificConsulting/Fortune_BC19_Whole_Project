page 50024 "SCM"
{
    // version NAVW19.00.00.48067,NAVIN9.00.00.48067,CCIT-Fortune

    CaptionML = ENU = 'Sales Credit Memo',
                ENN = 'Sales Credit Memo';
    PageType = Document;
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approve,Release,Posting,Prepare,Credit Memo,Request Approval',
                                 ENN = 'New,Process,Report,Approve,Release,Posting,Prepare,Credit Memo,Request Approval';
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = FILTER("Credit Memo"));
    ApplicationArea = all;
    UsageCategory = Documents;

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
                    Importance = Promoted;
                    Visible = DocNoVisible;
                    ApplicationArea = all;

                    trigger OnAssistEdit();
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    Importance = Promoted;
                    ShowMandatory = true;
                    ApplicationArea = all;

                    trigger OnValidate();
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Sell-to Contact No."; "Sell-to Contact No.")
                {

                    ApplicationArea = all;
                    trigger OnValidate();
                    begin
                        IF GETFILTER("Sell-to Contact No.") = xRec."Sell-to Contact No." THEN
                            IF "Sell-to Contact No." <> xRec."Sell-to Contact No." THEN
                                SETRANGE("Sell-to Contact No.");
                    end;
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Address"; "Sell-to Address")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Sell-to Address 2"; "Sell-to Address 2")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Sell-to City"; "Sell-to City")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                    ApplicationArea = all;
                }

                field("Location Code"; "Location Code")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = all;
                }
                field("Incoming Document Entry No."; "Incoming Document Entry No.")
                {
                    Visible = false;
                    ApplicationArea = all;
                }
                field("External Document No."; "External Document No.")
                {
                    CaptionML = ENU = 'Customer Cr.Order No.',
                                ENN = 'External Document No.';
                    Importance = Promoted;
                    ShowMandatory = ExternalDocNoMandatory;
                    ApplicationArea = all;
                }
                field("Order Date"; "Order Date")
                {
                    CaptionML = ENU = 'Customer Cr.Memo Date',
                                ENN = 'Order Date';
                    ApplicationArea = all;
                }
                field("Posting No. Series"; "Posting No. Series")
                {
                    ApplicationArea = all;
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    ApplicationArea = all;
                    trigger OnValidate();
                    begin
                        //CCIT-JAGA 29/10/2018
                        IF RecSaleaPerson.GET("Salesperson Code") THEN BEGIN
                            SalesPersonName := RecSaleaPerson.Name;
                        END;
                        //CCIT-JAGA 29/10/2018
                        SalespersonCodeOnAfterValidate;
                    end;
                }
                field("Sales Person Name"; SalesPersonName)
                {
                    ApplicationArea = all;
                }
                field("Tally Invoice No."; "Tally Invoice No.")
                {
                    ApplicationArea = all;
                }
                field("Campaign No."; "Campaign No.")
                {
                    Importance = Additional;
                    ApplicationArea = all;
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    Importance = Additional;
                    ApplicationArea = all;
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                    Importance = Additional;
                    ApplicationArea = all;
                }
                field("Job Queue Status"; "Job Queue Status")
                {
                    Importance = Additional;
                    ApplicationArea = all;
                }
                field(Status; Status)
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                }
                field("Applies-to Doc. Type"; "Applies-to Doc. Type")
                {
                    ApplicationArea = all;
                }
                field("Applies-to Doc. No."; "Applies-to Doc. No.")
                {
                    CaptionML = ENU = 'ERP INV.NO',
                                ENN = 'Applies-to Doc. No.';
                    ApplicationArea = all;
                }
                field("Vertical Category"; "Vertical Category")
                {
                    ApplicationArea = all;
                }
                field("Vertical Sub Category"; "Vertical Sub Category")
                {
                    ApplicationArea = all;
                }
                field("Outlet Area"; "Outlet Area")
                {
                    ApplicationArea = all;
                }
            }
            part(SalesLines; 96)
            {
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;

            }
            group(Invoicing)
            {
                CaptionML = ENU = 'Invoicing',
                            ENN = 'Invoicing';

                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    Importance = Promoted;

                    trigger OnValidate();
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No."; "Bill-to Contact No.")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Address"; "Bill-to Address")
                {
                    Importance = Additional;
                    ApplicationArea = all;
                }
                field("Bill-to Address 2"; "Bill-to Address 2")
                {
                    Importance = Additional;
                    ApplicationArea = all;
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                    Importance = Additional;
                    ApplicationArea = all;
                }
                field("Bill-to City"; "Bill-to City")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Contact"; "Bill-to Contact")
                {
                    Importance = Additional;
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    trigger OnValidate();
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    trigger OnValidate();
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                }
                field("Due Date"; "Due Date")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                }
                field("Payment Discount %"; "Payment Discount %")
                {
                    ApplicationArea = all;
                }
                field("Pmt. Discount Date"; "Pmt. Discount Date")
                {
                    Importance = Additional;
                    ApplicationArea = all;
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    ApplicationArea = all;
                }
                field("Prices Including VAT"; "Prices Including VAT")
                {
                    ApplicationArea = all;
                    trigger OnValidate();
                    begin
                        PricesIncludingVATOnAfterValid;
                    end;
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                }

            }
            group(Shipping)
            {
                CaptionML = ENU = 'Shipping',
                            ENN = 'Shipping';

                field("Ship-to Code"; "Ship-to Code")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Name"; "Ship-to Name")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                }
                field("Ship-to Address"; "Ship-to Address")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Ship-to Address 2"; "Ship-to Address 2")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Ship-to Post Code"; "Ship-to Post Code")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                }
                field("Ship-to City"; "Ship-to City")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Contact"; "Ship-to Contact")
                {
                    ApplicationArea = all;
                    Importance = Additional;
                }
                field("Shipment Date"; "Shipment Date")
                {
                    Importance = Promoted;
                    ApplicationArea = all;
                }
            }
            group("Foreign Trade")
            {
                CaptionML = ENU = 'Foreign Trade',
                            ENN = 'Foreign Trade';
                field("Currency Code"; "Currency Code")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit();
                    begin
                        CLEAR(ChangeExchangeRate);
                        IF "Posting Date" <> 0D THEN
                            ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", "Posting Date")
                        ELSE
                            ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", WORKDATE);
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                            VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.UPDATE;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                        SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0, Rec);
                    end;
                }
                field("EU 3-Party Trade"; "EU 3-Party Trade")
                {
                    ApplicationArea = all;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = all;
                }
                field("Transaction Specification"; "Transaction Specification")
                {
                    ApplicationArea = all;
                }
                field("Transport Method"; "Transport Method")
                {
                    ApplicationArea = all;
                }
                field("Exit Point"; "Exit Point")
                {
                    ApplicationArea = all;
                }
                field(Area_1; Area)
                {
                    ApplicationArea = all;
                }
            }
            group(Application)
            {
                CaptionML = ENU = 'Application',
                            ENN = 'Application';
                field("Applies-to ID"; "Applies-to ID")
                {
                    ApplicationArea = all;
                }
            }
            group("Tax Information")
            {
                CaptionML = ENU = 'Tax Information',
                            ENN = 'Tax Information';

                field(Trading; Trading)
                {
                    ApplicationArea = all;
                }

                group(GST)
                {
                    CaptionML = ENU = 'GST',
                                ENN = 'GST';
                    field("GST Bill-to State Code"; "GST Bill-to State Code")
                    {
                        ApplicationArea = all;
                    }
                    field("GST Ship-to State Code"; "GST Ship-to State Code")
                    {
                        ApplicationArea = all;
                    }
                    field("Location State Code"; "Location State Code")
                    {
                        ApplicationArea = all;
                    }
                    field("Posting No."; "Posting No.")
                    {
                        ApplicationArea = all;
                    }
                    field("Return Receipt No."; "Return Receipt No.")
                    {
                        ApplicationArea = all;
                    }
                    field("Nature of Supply"; "Nature of Supply")
                    {
                        ApplicationArea = all;
                    }
                    field("GST Customer Type"; "GST Customer Type")
                    {
                        ApplicationArea = all;
                    }
                    field("GST Without Payment of Duty"; "GST Without Payment of Duty")
                    {
                        ApplicationArea = all;
                    }
                    field("Invoice Type"; "Invoice Type")
                    {
                        ApplicationArea = all;
                    }
                    field("Bill Of Export No."; "Bill Of Export No.")
                    {
                        ApplicationArea = all;
                    }
                    field("Bill Of Export Date"; "Bill Of Export Date")
                    {
                        ApplicationArea = all;
                    }
                    field("e-Commerce Customer"; "e-Commerce Customer")
                    {
                        ApplicationArea = all;
                    }
                    field("e-Commerce Merchant Id"; "e-Commerce Merchant Id")
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Sys1; 9103)
            {
                SubPageLink = "Table ID" = CONST(36),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part(Sys2; 9080)
            {
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = false;
            }
            part(Sys3; 9081)
            {
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = false;
            }
            part(Sys4; 9082)
            {
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = true;
            }
            part(Sys5; 9084)
            {
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = true;
            }
            part(SYs6; 9087)
            {
                Provider = SalesLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
                Visible = false;
            }
            part(ApprovalFactBox; 9092)
            {
                Visible = false;
            }
            part(IncomingDocAttachFactBox; 193)
            {
                ShowFilter = false;
                Visible = false;
            }
            part(Sys7; 9108)
            {
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(WorkflowStatus; 1528)
            {
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(Sys8; Links)
            {
                Visible = false;
            }
            systempart(Sys9; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Credit Memo")
            {
                CaptionML = ENU = '&Credit Memo',
                            ENN = '&Credit Memo';
                Image = CreditMemo;
                action(Statistics)
                {
                    CaptionML = ENU = 'Statistics',
                                ENN = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category8;
                    ShortCutKey = 'F7';

                    trigger OnAction();
                    begin
                        Salessetup.GET;
                        // CALCFIELDS("Price Inclusive of Taxes"); //PCPL/MIG/NSW Filed not Exist in BC18
                        IF Salessetup."Calc. Inv. Discount" /*AND (NOT "Price Inclusive of Taxes") */THEN BEGIN //PCPL/MIG/NSW Filed not Exist in BC18
                            CalcInvDiscForHeader;
                            COMMIT;
                        END;
                        /* //PCPL/MIG/NSW Filed not Exist in BC18
                        IF "Price Inclusive of Taxes" THEN BEGIN
                          SalesLine.InitStrOrdDetail(Rec);
                          SalesLine.GetSalesPriceExclusiveTaxes(Rec);
                          SalesLine.UpdateSalesLinesPIT(Rec);
                          COMMIT;
                        END;
                        *///PCPL/MIG/NSW Filed not Exist in BC18
                        // IF Structure <> '' THEN BEGIN
                        //   SalesLine.CalculateStructures(Rec);
                        //   SalesLine.AdjustStructureAmounts(Rec);
                        //   SalesLine.UpdateSalesLines(Rec);
                        //   SalesLine.CalculateTCS(Rec);
                        //   COMMIT;
                        // END ELSE BEGIN
                        //   SalesLine.CalculateTCS(Rec);
                        //   COMMIT;
                        // END;
                        // IF GSTManagement.CheckGSTStrucure(Structure) THEN
                        //     GSTManagement.SalesPostValidations(Rec);
                        //PCPL/MIG/NSW Filed not Exist in BC18

                        PAGE.RUNMODAL(PAGE::"Sales Statistics", Rec);
                        SalesCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                action(CreditMemo_CustomerCard)
                {
                    CaptionML = ENU = 'Customer',
                                ENN = 'Customer';
                    Image = EditLines;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                ENN = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category8;
                    RunObject = Page 67;
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData 348 = R;
                    CaptionML = ENU = 'Dimensions',
                                ENN = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category8;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        ShowDocDim;
                        CurrPage.SAVERECORD;
                    end;
                }
                action(Approvals)
                {
                    CaptionML = ENU = 'Approvals',
                                ENN = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category9;

                    trigger OnAction();
                    var
                        ApprovalEntries: Page 658;
                    begin
                        ApprovalEntries.Setfilters(DATABASE::"Sales Header", "Document Type", "No.");
                        ApprovalEntries.RUN;
                    end;
                }
                // action("St&ructure")
                // {
                //     CaptionML = ENU='St&ructure',
                //                 ENN='St&ructure';
                //     Image = Hierarchy;
                //     RunObject = Page 16305;
                //     RunPageLink = Type=CONST(Sale),
                //                   "Document Type"=FIELD("Document Type"),
                //                   "Document No."=FIELD("No."),
                //                   "Structure Code"=FIELD(Structure),
                //                   "Document Line No."=FILTER(0);
                // }
                action("Attached Gate Entry Line")
                {
                    CaptionML = ENU = 'Attached Gate Entry Line',
                                ENN = 'Attached Gate Entry Line';
                    Image = Line;
                    RunObject = Page 18601;
                    RunPageLink = "Entry Type" = CONST(Inward),
                                  "Sales Credit Memo No." = FIELD("No.");
                }
                // action("Detailed &Tax")
                // {
                //     CaptionML = ENU='Detailed &Tax',
                //                 ENN='Detailed &Tax';
                //     Image = TaxDetail;
                //     RunObject = Page 16342;
                //     RunPageLink = "Document Type"=FIELD("Document Type"),
                //                   "Document No."=FIELD("No."),
                //                   "Transaction Type"=CONST(Sale);
                // }
                action("Detailed GST")
                {
                    CaptionML = ENU = 'Detailed GST',
                                ENN = 'Detailed GST';
                    Image = ServiceTax;
                    RunObject = Page 18390;
                    RunPageLink = "Transaction Type" = FILTER(Sales),
                                  "Document Type" = FIELD("Document Type"),
                                  "Document No." = FIELD("No.");
                }
            }
            group("&Line")
            {
                CaptionML = ENU = '&Line',
                            ENN = '&Line';
                Image = Line;
                action(Structure1)
                {
                    CaptionML = ENU = 'Structure',
                                ENN = 'Structure';
                    Image = Hierarchy;

                    trigger OnAction();
                    begin
                        //CurrPage.SalesLines.PAGE.ShowStrOrderDetailsPITForm; *///PCPL/MIG/NSW Filed not Exist in BC18
                    end;
                }
            }
            group("Credit Card")
            {
                CaptionML = ENU = 'Credit Card',
                            ENN = 'Credit Card';
                Image = CreditCardLog;
                // action("Credit Cards Transaction Lo&g Entries")
                // {
                //     CaptionML = ENU='Credit Cards Transaction Lo&g Entries',
                //                 ENN='Credit Cards Transaction Lo&g Entries';
                //     Image = CreditCardLog;
                //     RunObject = Page 829;
                //     RunPageLink = "Document Type"=FIELD("Document Type"),
                //                   "Document No."=FIELD("No."),
                //                   "Customer No."=FIELD("Bill-to Customer No.");
                // }
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
                    Visible = OpenApprovalEntriesExistForCurrUser;

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
                    Visible = OpenApprovalEntriesExistForCurrUser;

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
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Comment)
                {
                    CaptionML = ENU = 'Comments',
                                ENN = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group(Release1)
            {
                CaptionML = ENU = 'Release',
                            ENN = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    CaptionML = ENU = 'Re&lease',
                                ENN = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+F9';
                    ApplicationArea = all;

                    trigger OnAction();
                    var
                        ReleaseSalesDoc: Codeunit 414;
                    begin
                        // rdk230919 -
                        Salessetup.GET;
                        //IF NOT Salessetup."Post Bond SO-SCM" THEN
                        IF (Salessetup."Post Bond SO-SCM") AND (Rec."Location Code" <> 'SNOW BOND') THEN BEGIN
                            //CCIT-JAGA 30/10/2018
                            IF (("Applies-to Doc. No." = '') AND ("Tally Invoice No." = '')) THEN
                                ERROR('Please fill the "Applies-to Doc. No." OR "Tally Invoice No."');
                            // TESTFIELD(Structure); *///PCPL/MIG/NSW Filed not Exist in BC18
                            //CCIT-JAGA 30/10/2018

                            // rdk 10-05-2019
                            SalesLine.RESET;
                            SalesLine.SETRANGE(SalesLine."Document No.", "No.");
                            SalesLine.SETFILTER(SalesLine."No.", '<>%1', '');
                            IF SalesLine.FINDSET THEN
                                REPEAT
                                BEGIN
                                    SalesLine.TESTFIELD("Reason Code");
                                END;
                                UNTIL SalesLine.NEXT = 0;

                            // rdk end
                        END;
                        // rdk230919 +

                        ReleaseSalesDoc.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    CaptionML = ENU = 'Re&open',
                                ENN = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ApplicationArea = all;

                    trigger OnAction();
                    var
                        ReleaseSalesDoc: Codeunit 414;
                    begin
                        ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions',
                            ENN = 'F&unctions';
                Image = "Action";
                action(GetPostedDocumentLinesToReverse)
                {
                    CaptionML = ENU = 'Get Posted Doc&ument Lines to Reverse',
                                ENN = 'Get Posted Doc&ument Lines to Reverse';
                    Ellipsis = true;
                    Image = ReverseLines;
                    Promoted = true;
                    PromotedCategory = Category7;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        //GetPstdDocLinesToRevere; *///PCPL/MIG/NSW Filed not Exist in BC18
                    end;
                }
                // action(CalculateInvoiceDiscount)
                // {
                //     AccessByPermission = TableData 19 = R;
                //     CaptionML = ENU = 'Calculate &Invoice Discount',
                //                 ENN = 'Calculate &Invoice Discount';
                //     Image = CalculateInvoiceDiscount;
                //     Promoted = true;
                //     PromotedCategory = Category7;
                //     ApplicationArea = all;

                //     trigger OnAction();
                //     // begin
                //     //     CALCFIELDS("Price Inclusive of Taxes");
                //     //     IF NOT "Price Inclusive of Taxes" THEN
                //     //         ApproveCalcInvDisc
                //     //     ELSE
                //     //         ERROR(STRSUBSTNO(Text16500, FIELDCAPTION("Price Inclusive of Taxes")));
                //     //     SalesCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                //     // end;
                // }
                separator(Control00525)
                {
                }
                action(ApplyEntries)
                {
                    CaptionML = ENU = 'Apply Entries',
                                ENN = 'Apply Entries';
                    Ellipsis = true;
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Category7;
                    ShortCutKey = 'Shift+F11';
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        // Salessetup.GET;
                        // CALCFIELDS("Price Inclusive of Taxes");
                        // IF Salessetup."Calc. Inv. Discount" AND (NOT "Price Inclusive of Taxes") THEN BEGIN
                        CalcInvDiscForHeader;
                        COMMIT;
                        //END;
                        //IF "Price Inclusive of Taxes" THEN BEGIN
                        // SalesLine.InitStrOrdDetail(Rec);
                        //SalesLine.GetSalesPriceExclusiveTaxes(Rec);
                        //SalesLine.UpdateSalesLinesPIT(Rec);
                        COMMIT;
                        //END;
                        //IF Rec.Structure <> '' THEN BEGIN
                        // SalesLine.CalculateStructures(Rec);
                        // SalesLine.AdjustStructureAmounts(Rec);
                        // SalesLine.UpdateSalesLines(Rec);
                        //SalesLine.CalculateTCS(Rec);
                        COMMIT;
                        //END ELSE BEGIN
                        //SalesLine.CalculateTCS(Rec);
                        //COMMIT;
                        //END;
                        //CODEUNIT.RUN(CODEUNIT::"Sales Header Apply", Rec);
                    end;
                }
                separator(Conytrol8787)
                {
                }
                action("Get St&d. Cust. Sales Codes")
                {
                    CaptionML = ENU = 'Get St&d. Cust. Sales Codes',
                                ENN = 'Get St&d. Cust. Sales Codes';
                    Ellipsis = true;
                    Image = CustomerCode;
                    Promoted = true;
                    PromotedCategory = Category7;

                    trigger OnAction();
                    var
                        StdCustSalesCode: Record 172;
                    begin
                        StdCustSalesCode.InsertSalesLines(Rec);
                    end;
                }
                action("Get Gate Entry Lines")
                {
                    CaptionML = ENU = 'Get Gate Entry Lines',
                                ENN = 'Get Gate Entry Lines';
                    Image = GetLines;

                    trigger OnAction();
                    begin
                        // GetGateEntryLines;
                    end;
                }
                separator(Control5654)
                {
                }
                action(CopyDocument)
                {
                    CaptionML = ENU = 'Copy Document',
                                ENN = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Category7;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        CopySalesDoc.SetSalesHeader(Rec);
                        CopySalesDoc.RUNMODAL;
                        CLEAR(CopySalesDoc);
                        IF GET("Document Type", "No.") THEN;
                    end;
                }
                action("Move Negative Lines")
                {
                    CaptionML = ENU = 'Move Negative Lines',
                                ENN = 'Move Negative Lines';
                    Ellipsis = true;
                    Image = MoveNegativeLines;
                    Promoted = true;
                    PromotedCategory = Category7;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        CLEAR(MoveNegSalesLines);
                        MoveNegSalesLines.SetSalesHeader(Rec);
                        MoveNegSalesLines.RUNMODAL;
                        MoveNegSalesLines.ShowDocument;
                    end;
                }
                group(IncomingDocument)
                {
                    CaptionML = ENU = 'Incoming Document',
                                ENN = 'Incoming Document';
                    Image = Documents;
                    action(IncomingDocCard)
                    {
                        CaptionML = ENU = 'View Incoming Document',
                                    ENN = 'View Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = ViewOrder;
                        ToolTipML =;
                        ApplicationArea = all;

                        trigger OnAction();
                        var
                            IncomingDocument: Record 130;
                        begin
                            IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");
                        end;
                    }
                    action(SelectIncomingDoc)
                    {
                        AccessByPermission = TableData 130 = R;
                        CaptionML = ENU = 'Select Incoming Document',
                                    ENN = 'Select Incoming Document';
                        Image = SelectLineToApply;
                        ToolTipML =;
                        ApplicationArea = all;

                        trigger OnAction();
                        var
                            IncomingDocument: Record 130;
                        begin
                            //     //VALIDATE("Incoming Document Entry No.", IncomingDocument.SelectIncomingDocument("Incoming Document Entry No."));
                        end;
                    }
                    action(IncomingDocAttachFile)
                    {
                        CaptionML = ENU = 'Create Incoming Document from File',
                                    ENN = 'Create Incoming Document from File';
                        Ellipsis = true;
                        Enabled = NOT HasIncomingDocument;
                        Image = Attach;
                        ToolTipML =;
                        ApplicationArea = all;

                        trigger OnAction();
                        var
                            IncomingDocumentAttachment: Record 133;
                        begin
                            IncomingDocumentAttachment.NewAttachmentFromSalesDocument(Rec);
                        end;
                    }
                    action(RemoveIncomingDoc)
                    {
                        CaptionML = ENU = 'Remove Incoming Document',
                                    ENN = 'Remove Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = RemoveLine;
                        ToolTipML =;
                        ApplicationArea = all;

                        trigger OnAction();
                        begin
                            "Incoming Document Entry No." := 0;
                        end;
                    }
                }
            }
            group("Request Approval")
            {
                CaptionML = ENU = 'Request Approval',
                            ENN = 'Request Approval';
                Image = Approval;
                action(SendApprovalRequest)
                {
                    CaptionML = ENU = 'Send A&pproval Request',
                                ENN = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    ApplicationArea = all;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        // IF ApprovalsMgmt.CheckSalesApprovalsWorkflowEnabled(Rec) THEN
                        //   ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    CaptionML = ENU = 'Cancel Approval Re&quest',
                                ENN = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category9;
                    ApplicationArea = all;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit 1535;
                    begin
                        ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                    end;
                }
            }
            group("P&osting")
            {
                CaptionML = ENU = 'P&osting',
                            ENN = 'P&osting';
                Image = Post;
                action(TestReport)
                {
                    CaptionML = ENU = 'Test Report',
                                ENN = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        ReportPrint.PrintSalesHeader(Rec);
                    end;
                }
                action("Remove From Job Queue")
                {
                    CaptionML = ENU = 'Remove From Job Queue',
                                ENN = 'Remove From Job Queue';
                    Image = RemoveLine;
                    Visible = JobQueueVisible;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        CancelBackgroundPosting;
                    end;
                }
                action("Preview Posting")
                {
                    CaptionML = ENU = 'Preview Posting',
                                ENN = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ApplicationArea = all;



                    trigger OnAction();
                    begin
                        //CCIT-JAGA 20/11/2018
                        RecCLE.RESET;
                        RecCLE.SETRANGE(RecCLE."Document No.", "Applies-to Doc. No.");
                        IF RecCLE.FINDFIRST THEN BEGIN
                            // CALCFIELDS("Amount to Customer");
                            RecCLE.CALCFIELDS(Amount);
                            //MESSAGE('%1 ... %2',"Amount to Customer",RecCLE.Amount);
                            //IF "Amount to Customer" > RecCLE.Amount THEN
                            //  ERROR('Sales Credit Note Value : %1 should be less than or equal to Sales Invoice Amount : %2', "Amount to Customer", RecCLE.Amount);
                        END;
                        //CCIT-JAGA 20/11/2018
                        ShowPreview;
                    end;
                }
                separator(Control789)
                {
                }
                action("Calculate Str&ucture Values")
                {
                    CaptionML = ENU = 'Calculate Str&ucture Values',
                                ENN = 'Calculate Str&ucture Values';
                    Image = CalculateHierarchy;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        // CALCFIELDS("Price Inclusive of Taxes");
                        //IF "Price Inclusive of Taxes" THEN BEGIN
                        // SalesLine.InitStrOrdDetail(Rec);
                        // SalesLine.GetSalesPriceExclusiveTaxes(Rec);
                        // SalesLine.UpdateSalesLinesPIT(Rec);
                        //END;
                        // SalesLine.CalculateStructures(Rec);
                        //SalesLine.AdjustStructureAmounts(Rec);
                        // SalesLine.UpdateSalesLines(Rec);
                    end;
                }
                action("Calculate &TCS")
                {
                    CaptionML = ENU = 'Calculate &TCS',
                                ENN = 'Calculate &TCS';
                    Image = CalculateCollectedTax;

                    trigger OnAction();
                    begin
                        //SalesLine.CalculateStructures(Rec);
                        // SalesLine.AdjustStructureAmounts(Rec);
                        //SalesLine.UpdateSalesLines(Rec);
                        // SalesLine.CalculateTCS(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
        // CurrPage.ApprovalFactBox.PAGE.RefreshPage(RECORDID);
    end;

    trigger OnAfterGetRecord();
    begin
        SetControlAppearance;
        //CCIT-JAGA 29/10/2018
        CLEAR(SalesPersonName);
        IF RecSaleaPerson.GET("Salesperson Code") THEN BEGIN
            SalesPersonName := RecSaleaPerson.Name;
        END;
        //CCIT-JAGA 29/10/2018
    end;

    trigger OnDeleteRecord(): Boolean;
    begin
        CurrPage.SAVERECORD;
        EXIT(ConfirmDeletion);
    end;

    trigger OnInit();
    begin
        SetExtDocNoMandatoryCondition;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        CheckCreditMaxBeforeInsert;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Responsibility Center" := UserMgt.GetSalesFilter;
    end;

    trigger OnOpenPage();
    begin
        IF UserMgt.GetSalesFilter <> '' THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Responsibility Center", UserMgt.GetSalesFilter);
            FILTERGROUP(0);
        END;

        SetDocNoVisible;
    end;

    var
        Salessetup: Record 311;
        SalesLine: Record 37;
        ChangeExchangeRate: Page 511;
        CopySalesDoc: Report 292;
        MoveNegSalesLines: Report 6699;
        ReportPrint: Codeunit 228;
        UserMgt: Codeunit 5700;
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
        Text16500: TextConst ENU = 'To calculate invoice discount, check Cal. Inv. Discount on header when Price Inclusive of Tax = Yes.\This option cannot be used to calculate invoice discount when Price Inclusive Tax = Yes.', ENN = 'To calculate invoice discount, check Cal. Inv. Discount on header when Price Inclusive of Tax = Yes.\This option cannot be used to calculate invoice discount when Price Inclusive Tax = Yes.';
        GSTManagement: Codeunit "GST Posting Management";
        [InDataSet]
        JobQueueVisible: Boolean;
        HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        ExternalDocNoMandatory: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        RecSaleaPerson: Record 13;
        SalesPersonName: Text[50];
        RecCLE: Record 21;

    local procedure Post(PostingCodeunitID: Integer);
    begin
        SendToPosting(PostingCodeunitID);
        IF "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting" THEN
            CurrPage.CLOSE;
        CurrPage.UPDATE(FALSE);
    end;

    local procedure ApproveCalcInvDisc();
    begin
        CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure SelltoCustomerNoOnAfterValidat();
    begin
        IF GETFILTER("Sell-to Customer No.") = xRec."Sell-to Customer No." THEN
            IF "Sell-to Customer No." <> xRec."Sell-to Customer No." THEN
                SETRANGE("Sell-to Customer No.");
        CurrPage.UPDATE;
    end;

    local procedure SalespersonCodeOnAfterValidate();
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure BilltoCustomerNoOnAfterValidat();
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension1CodeOnAfterV();
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension2CodeOnAfterV();
    begin
        CurrPage.UPDATE;
    end;

    local procedure PricesIncludingVATOnAfterValid();
    begin
        CurrPage.UPDATE;
    end;

    local procedure SetDocNoVisible();
    var
        DocumentNoVisibility: Codeunit 1400;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::"Credit Memo", "No.");
    end;

    local procedure SetExtDocNoMandatoryCondition();
    var
        SalesReceivablesSetup: Record 311;
    begin
        SalesReceivablesSetup.GET;
        ExternalDocNoMandatory := SalesReceivablesSetup."Ext. Doc. No. Mandatory"
    end;

    procedure ShowPreview();
    var
        SalesPostYesNo: Codeunit 81;
    begin
        SalesPostYesNo.Preview(Rec);
    end;

    local procedure SetControlAppearance();
    var
        ApprovalsMgmt: Codeunit 1535;
    begin
        JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
        HasIncomingDocument := "Incoming Document Entry No." <> 0;
        SetExtDocNoMandatoryCondition;

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
    end;
}

