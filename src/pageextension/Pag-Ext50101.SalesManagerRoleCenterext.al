pageextension 50101 "Sales_Manager_Role_Center_ext" extends "Sales Manager Role Center"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778

    layout
    {
        addfirst("Control1900724808")
        {
            part(Page; 9060)
            {
                AccessByPermission = TableData 110 = R;
            }
        }
    }
    actions
    {
        modify("Customer - &Top 10 List")
        {
            CaptionML = ENU = 'Customer - Top 10 List', ENN = 'Customer - &Top 10 List';

            //Unsupported feature: Change Name on "Action 14". Please convert manually.

            Promoted = true;
            PromotedIsBig = true;
            PromotedCategory = Report;
            ApplicationArea = all;
        }




        addbefore("S&ales Statistics")
        {
            action("Sales Register Invioce&CR-EX1")
            {
                Caption = 'Sales Register Invioce and CR (Excel)';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                //RunObject = Report 50058;
                ApplicationArea = all;
            }
            action("Customers Month on Month Excel")
            {
                AccessByPermission = TableData 50034 = RIMD;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 50091;
                ApplicationArea = all;
            }
            action("Purchase Register Invioce")
            {
                RunObject = Report 50057;
                ApplicationArea = all;
            }
            action("Item Month on Month Excel")
            {
                AccessByPermission = TableData 50034 = RIMD;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 50087;
                ApplicationArea = all;
            }
            separator(Control001)
            {
            }
            action("Sales Register (Tally Format)")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 50093;
                ApplicationArea = all;
            }
            action("Customer Aged Receivables")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Aged Accounts Receivable";
                ApplicationArea = all;
            }
            action("Item Expiration - Quantity")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 5809;
                ApplicationArea = all;
            }
            action("Batch-wise Sales Register")
            {
                Image = "Report";
                Promoted = true;
                //RunObject = Report 50064;
                ApplicationArea = all;
            }
            group(control0012)
            {
                Visible = false;
                action("MA Products (Analysis)")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Page "Analysis Report Inventory";
                    RunPageView = WHERE(Name = FILTER('SALESQTY'),
                                        "Analysis Line Template Name" = FILTER('ALLITEMS'),
                                        "Analysis Column Template Name" = FILTER('INV TURN'));
                    ApplicationArea = all;
                }
                action("MA Customers (Analysis)")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Page "Analysis Report Sale";
                    RunPageView = WHERE(Name = FILTER('CUSTMOVE'),
                                        Description = FILTER('Customer MoM'),
                                        "Analysis Line Template Name" = FILTER('CUSTOMERS'),
                                        "Analysis Column Template Name" = FILTER('MNTHONMNTH'));
                    ApplicationArea = all;
                }
                action("MA-Customer(Profitability-DP)")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report 50033;
                    ApplicationArea = all;
                }
                action("MA-Customer(Profitability-DF)")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report 50034;
                    ApplicationArea = all;

                }
                action("MA-Customer")
                {
                    Caption = 'MA-Customer';
                    Image = "Report";
                    RunObject = Report 50089;
                    Visible = false;
                    ApplicationArea = all;
                }
                action("MA-Product")
                {
                    Caption = 'MA-Product';
                    Image = "Report";
                    RunObject = Report 50039;
                    Visible = false;
                    ApplicationArea = all;
                }
            }
            action("Analysis Report Sale")
            {
                Caption = 'Sales Analysis Reports';
                RunObject = Page 9376;
            }
            action("MA Product Analysis")
            {
                RunObject = Page 9377;
                RunPageView = WHERE(Name = FILTER('SALESQTY'),
                                    "Analysis Line Template Name" = FILTER('ALLITEMS'),
                                    "Analysis Column Template Name" = FILTER('INV TURN'));
                ApplicationArea = all;
            }
        }
        addafter(SalesOrdersOpen)
        {
            action(SalesOrder_ShortClosed)
            {
                Caption = 'Short Closed Sales Orders';
                RunObject = Page 50058;
                ApplicationArea = all;
            }
        }
        addafter(SalesInvoices)
        {
            action("Sales Price")
            {
                Caption = 'Sales Price';
                RunObject = Page 50006;
                ApplicationArea = all;
            }
        }
        addafter("Item Disc. Groups")
        {
            group("Posted Documents")
            {
                CaptionML = ENU = 'Posted Documents',
                            ENN = 'Posted Documents';

                Image = FiledPosted;
                ToolTipML = ENU = 'View history for sales, shipments, and inventory.',
                            ENN = 'View history for sales, shipments, and inventory.';

                action("Posted Sales Shipments")
                {
                    CaptionML = ENU = 'Posted Sales Shipments',
                                ENN = 'Posted Sales Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Sales Shipments";
                    ApplicationArea = all;
                }
                action("Posted Sales Invoices")
                {
                    CaptionML = ENU = 'Posted Sales Invoices',
                                ENN = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                    ApplicationArea = all;
                }
                action("Posted Return Receipts")
                {
                    CaptionML = ENU = 'Posted Return Receipts',
                                ENN = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page "Posted Return Receipts";
                    ApplicationArea = all;
                }
                action("Posted Sales Credit Memos")
                {
                    CaptionML = ENU = 'Posted Sales Credit Memos',
                                ENN = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                    ApplicationArea = all;
                }
            }
        }

    }
}

