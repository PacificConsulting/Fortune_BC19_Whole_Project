pageextension 50100 "Acc_Receivab_Adm_RC_ext" extends "Acc. Receivables Adm. RC"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778

    actions
    {


        //Unsupported feature: Change Visible on "Action 113". Please convert manually.

        addafter("Customer - Trial Balan&ce")
        {
            action("<Report Customer - Det.trial Bal")
            {
                Caption = 'Customer - Det.trial Bal';
                Image = "Report";
                RunObject = Report "Customer - Detail Trial Bal.";
                ApplicationArea = all;
            }
            action("DSO Report")
            {
                Image = "Report";
                RunObject = Report 50076;
                ApplicationArea = all;
            }
            action("Customer Cr.Limit")
            {
                Image = "Report";
                RunObject = Report 50075;
                ApplicationArea = all;
            }
        }
        addafter(CustomersBalance)
        {
            action(Fin_Customers)
            {
                RunObject = Page 50047;
            }
        }
        addafter("Sales Return Orders")
        {
            action("Sales Credit Memos")
            {
                Caption = 'Sales Credit Memos';
                Image = "Page";
                RunObject = Page "Sales Credit Memos";
                ApplicationArea = all;
            }
        }
        addafter(Items)
        {
            action("<Page Sales Price>")
            {
                Caption = 'Sales Price';
                Image = "Page";
                RunObject = Page 50006;
                ApplicationArea = all;
            }
            action("Bank Account Reconcilations")
            {
                Caption = 'Bank Account Reconcilations';
                Image = "Page";
                RunObject = Page "Bank Acc. Reconciliation List";
                ApplicationArea = all;
            }
        }
        addafter(GeneralJournals)
        {
            action("<Page General Journal Batches>")
            {
                Caption = 'Bank Payment Voucher';
                RunObject = Page "General Journal Batches";
                RunPageView = WHERE("Template Type" = CONST(General),
                                    // "Sub Type"=CONST("Bank Payment Voucher"),
                                    Recurring = CONST(false));
                ApplicationArea = all;
            }
        }
        addafter(GeneralJournals)
        {
            action("Contra Entries")
            {
                Image = Journal;
                RunObject = Page "General Journal Batches";
                ;
                RunPageView = WHERE("Template Type" = CONST(General),
                                    Recurring = CONST(false));
                //Sub Type=CONST(Contra Voucher));
                ApplicationArea = all;
            }
        }
        addafter("Posted Sales Credit Memos")
        {
            action("Posted Purchase Receipts")
            {
                CaptionML = ENU = 'Posted Purchase Receipts',
                            ENN = 'Posted Purchase Receipts';
                RunObject = Page "Posted Purchase Receipts";
                ApplicationArea = all;
            }
        }
        addafter("Issued Reminders")
        {
            action("General ledger entries")
            {
                Caption = 'General ledger entries';
                RunObject = Page "General Ledger Entries";
                ApplicationArea = all;
            }
        }
    }
}

