pageextension 50099 "Acc_Payables_Coord_RC_ext" extends "Acc. Payables Coordinator RC"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778

    layout
    {

        //Unsupported feature: Change Visible on "Control 1900601808". Please convert manually.

    }
    actions
    {

        //Unsupported feature: Change Visible on "Action 1500000". Please convert manually.


        addafter("P&urchase Statistics")
        {
            action("Calculate Depreciation")
            {
                Image = "Report";
                RunObject = Report 5692;
                ApplicationArea = all;
            }
        }
        addafter("Purchase &Credit Memo Nos.")
        {
            action("Chart Of Accounts")
            {
                Caption = 'Chart Of Accounts';
                Image = "Page";
                RunObject = Page 16;
                ApplicationArea = all;
            }
            action("Account Schedules")
            {
                Caption = 'Accounting Shedules';
                RunObject = Page 103;
                ApplicationArea = all;
            }
            action("Analysis by Dimensions")
            {
                Caption = 'Analysis by Dimensions';
                Image = "Page";
                RunObject = Page 556;
                ApplicationArea = all;
            }
            action(Dimensions)
            {
                Caption = 'Dimensions';
                RunObject = Page 536;
                ApplicationArea = all;
            }
            action("Fixed Assets")
            {
                Caption = 'Fixed Assets';
                Image = "Page";
                RunObject = Page 5601;
                ApplicationArea = all;
            }
            action("Bank Account Reconciliation")
            {
                Image = "Page";
                RunObject = Page "Bank Acc. Reconciliation List";
                ApplicationArea = all;
            }
            action("TDS Setup")
            {
                RunObject = Page "TDS Setup";
                ApplicationArea = all;
            }
            action("TDS Entries")
            {
                RunObject = Page "TDS Entries";
                ApplicationArea = all;
            }
            // action("NOD/NOC List")
            // {
            //     Image = "Page";
            //     RunObject = Page "NOD/NOC List";
            // }
        }
        addafter("Purchase Orders")
        {
            action("Purchase Invoices Checking")
            {
                Caption = 'Purchase Invoices Checking';
                RunObject = Page 50057;
                ApplicationArea = all;
            }
        }
        addafter("Payment &Journal")
        {
            action("<Page General Journal Batches>")
            {
                Caption = 'Contra Voucher';
                Image = Journals;
                RunObject = Page "General Journal Batches";
                RunPageView = WHERE("Template Type" = CONST(General),
                                    //"Sub Type"=CONST('Contra Voucher'),
                                    Recurring = CONST(false));
                ApplicationArea = all;
            }
        }
        addafter("Payment &Journal")
        {
            action("Page General Journal Batches")
            {
                Caption = 'Bank Receipt Voucher';
                RunObject = Page "General Journal Batches";
                RunPageView = WHERE("Template Type" = CONST(General),
                                    //Sub Type=CONST(Bank Receipt Voucher),
                                    Recurring = CONST(false),
                                    Name = CONST('VREFUND'));
                ApplicationArea = all;
            }
        }
        addafter("G/L Registers")
        {
            // action("TDS Adjustment Journal")
            // {
            //     CaptionML = ENU = 'TDS Adjustment Journal',
            //                ENN = 'TDS Adjustment Journal';
            //     //         RunObject = Page "Tax Journal Batches";
            //     ApplicationArea = all;
            // }
        }
    }
}

