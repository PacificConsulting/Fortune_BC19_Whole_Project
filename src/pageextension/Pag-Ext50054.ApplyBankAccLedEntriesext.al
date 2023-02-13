pageextension 50054 "Apply_Bank_AccLed_Entries_ext" extends "Apply Bank Acc. Ledger Entries"
{
    // version NAVW19.00.00.45778

    layout
    {
        addafter("Document No.")
        {
            field("Balance Account Name"; "Balance Account Name")
            {
                ApplicationArea = all;
            }
            field("Cheque No."; "Cheque No.")
            {
                ApplicationArea = all;
            }
        }

    }
}

