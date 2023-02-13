pageextension 50102 "Purch_Agent_Role_Center_ext" extends "Purchasing Agent Role Center"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778

    layout
    {

        //Unsupported feature: Change Visible on "Control 1907662708". Please convert manually.

    }
    actions
    {

        addbefore("Purchase &Order")
        {
            group(Purchase)
            {
                Caption = 'Purchase';
                action("Purchase planning Sales Register")
                {
                    Caption = 'Purchase planning Sales Register';
                    Image = "Report";
                    RunObject = Report 50063;
                    ApplicationArea = all;
                }
                action("Purchase GRN Register")
                {
                    Caption = 'Purchase GRN Register';
                    Image = "Report";
                    RunObject = Report 50020;
                    ApplicationArea = all;
                }
                action("Purchase Register Invioce")
                {
                    Caption = 'Purchase Register Invioce';
                    Image = "Report";
                    RunObject = Report 50057;
                    ApplicationArea = all;
                }
                action("Open PO Tracker")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report 50017;
                    ApplicationArea = all;
                }
            }
            group(Inventory)
            {
                Caption = 'Inventory';
                action("Item Month-on-Month")
                {
                    Caption = 'Item Month-on-Month';
                    Image = "Report";
                    RunObject = Report 50087;
                    ApplicationArea = all;
                }
                action("Stock Ageing Report-Excel")
                {
                    Caption = 'Stock Ageing Report-Excel';
                    Image = "Report";
                    RunObject = Report 50023;
                    ApplicationArea = all;
                }
                action("Item Expiry")
                {
                    Caption = 'Item Expiry/Critical SKU';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report 5809;
                    ApplicationArea = all;
                }
                action("Customer Month-on-Month")
                {
                    Caption = 'Customer Month-on-Month';
                    Image = "Report";
                    RunObject = Report 50091;
                    ApplicationArea = all;
                }
                action("Inventory Planning - Branch")
                {
                    Caption = 'Inventory Planning - Branch';
                    Image = "Report";
                    RunObject = Report 50036;
                    ApplicationArea = all;
                }
                action("Inventory Planning- HO")
                {
                    Caption = 'Inventory Planning-HO';
                    Image = "Report";
                    RunObject = Report 50099;
                    Visible = false;
                    ApplicationArea = all;
                }
                action("Inv. Planning HO (Projections)")
                {
                    Image = "Report";
                    RunObject = Report 50098;
                    ApplicationArea = all;
                }
                action("Inventory Planning - HO (New)")
                {
                    Image = "Report";
                    RunObject = Report 50067;
                    ApplicationArea = all;
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                action("Sales Register Invioce&CR-EX1")
                {
                    Caption = 'Sales Register Invioce&CR-EX1';
                    Image = "Report";
                    // RunObject = Report 50058;
                    ApplicationArea = all;
                }
                action("Target Vs Actual Sales ")
                {
                    Image = "Report";
                    RunObject = Page 9376;
                    RunPageView = WHERE(Name = CONST('SALESQTY'));
                }
            }
        }
        addafter("Purchase Journals")
        {
            action(Customers)
            {
                RunObject = Page 22;
                ApplicationArea = all;
            }
        }
        addafter("Standard Cost Worksheets")
        {
            action(Budgets)
            {
                RunObject = Page 9374;
                RunPageView = WHERE(Name = FILTER('SLS2019NEW'));
                ApplicationArea = all;
            }
        }
        addafter("Posted Assembly Orders")
        {
            action("Posted Transfer Shipments")
            {
                Caption = 'Posted Transfer Shipments';
                RunObject = Page "Posted Transfer Shipments";
                ApplicationArea = all;
            }
            action("Posted Transfer Receipts")
            {
                Caption = 'Posted transfer Receipts';
                RunObject = Page "Posted Transfer Receipts";
                ApplicationArea = all;
            }
        }
    }
}

