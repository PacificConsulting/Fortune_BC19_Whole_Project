pageextension 50104 "Acc_Payables_Activities_ext" extends "Acc. Payables Activities"
{
    // version NAVW17.00

    layout
    {

        //Unsupported feature: Change Visible on "Control 7". Please convert manually.

        addbefore("Purchase Return Orders")
        {
            field("Purch.Invoices Not Posted"; "Purch.Invoices Not Posted")
            {
                DrillDownPageID = "Purchase Invoices";
                ApplicationArea = all;
            }
        }
        addafter("Approved Purchase Orders")
        {
            cuegroup("Gen. Journals")
            {
                Caption = 'Gen. Journals';
                field("Bank Payments Not Posted"; "Bank Payments Not Posted")
                {
                    DrillDownPageID = "General Journal Batches";
                    ApplicationArea = all;
                }
                field("Cash Payments Not Posted"; "Cash Payments Not Posted")
                {
                    DrillDownPageID = "General Journal Batches";
                    ApplicationArea = all;
                }
                field("Pending Contra Entries"; "Pending Contra Entries")
                {
                    DrillDownPageID = "General Journal Batches";
                    ApplicationArea = all;
                }
            }
        }
    }
}

