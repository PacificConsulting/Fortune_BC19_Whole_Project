pageextension 50064 "Unapply_Cust_Entries_ext" extends "Unapply Customer Entries"
{
    // version NAVW19.00.00.45778

    layout
    {
        addafter("Cust. Ledger Entry No.")
        {
            field("Transaction No."; "Transaction No.")
            {
                ApplicationArea = all;
            }
        }
    }
}

